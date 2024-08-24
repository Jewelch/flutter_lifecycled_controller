// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'base_controller.dart';

export 'package:flutter/scheduler.dart';

/// Used like `SingleTickerProviderMixin` but only with Get Controllers.
/// Simplifies AnimationController creation inside BaseController.
///
/// Example:
///```
///class SplashController extends BaseController with BaseSingleTickerProviderStateMixin {
///  AnimationController controller;
///
///  @override
///  void initState() {
///    final duration = const Duration(seconds: 2);
///    controller =
///        AnimationController.unbounded(duration: duration, vsync: this);
///    controller.repeat();
///    controller.addListener(() =>
///        print("Animation Controller value: ${controller.value}"));
///  }
///  ...
/// ```
mixin BaseSingleTickerProviderStateMixin on BaseController implements TickerProvider {
  Ticker? _ticker;

  @override
  Ticker createTicker(TickerCallback onTick) {
    assert(() {
      if (_ticker == null) return true;
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('$runtimeType is a BaseSingleTickerProviderStateMixin but multiple tickers were created.'),
        ErrorDescription('A BaseSingleTickerProviderStateMixin can only be used as a TickerProvider once.'),
        ErrorHint(
          'If a State is used for multiple AnimationController objects, or if it is passed to other '
          'objects and those objects might use it more than one time in total, then instead of '
          'mixing in a BaseSingleTickerProviderStateMixin, use a regular GetTickerProviderStateMixin.',
        ),
      ]);
    }());
    _ticker = Ticker(onTick, debugLabel: kDebugMode ? 'created by $this' : null);
    // We assume that this is called from initState, build, or some sort of
    // event handler, and that thus TickerMode.of(context) would return true. We
    // can't actually check that here because if we're in initState then we're
    // not allowed to do inheritance checks yet.
    return _ticker!;
  }

  void didChangeDependencies(BuildContext context) {
    if (_ticker != null) _ticker!.muted = !TickerMode.of(context);
  }

  @override
  void dispose() {
    assert(() {
      if (_ticker == null || !_ticker!.isActive) return true;
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('$this was disposed with an active Ticker.'),
        ErrorDescription(
          '$runtimeType created a Ticker via its BaseSingleTickerProviderStateMixin, but at the time '
          'dispose() was called on the mixin, that Ticker was still active. The Ticker must '
          'be disposed before calling super.dispose().',
        ),
        ErrorHint(
          'Tickers used by AnimationControllers '
          'should be disposed by calling dispose() on the AnimationController itself. '
          'Otherwise, the ticker will leak.',
        ),
        _ticker!.describeForError('The offending ticker was'),
      ]);
    }());
    super.dispose();
  }
}

/// Used like `TickerProviderMixin` but only with Get Controllers.
/// Simplifies multiple AnimationController creation inside BaseController.
///
/// Example:
///```
///class SplashController extends BaseController with BaseTickerProviderStateMixin {
///  AnimationController first_controller;
///  AnimationController second_controller;
///
///  @override
///  void initState() {
///    final duration = const Duration(seconds: 2);
///    first_controller =
///        AnimationController.unbounded(duration: duration, vsync: this);
///    second_controller =
///        AnimationController.unbounded(duration: duration, vsync: this);
///    first_controller.repeat();
///    first_controller.addListener(() =>
///        print("Animation Controller value: ${first_controller.value}"));
///    second_controller.addListener(() =>
///        print("Animation Controller value: ${second_controller.value}"));
///  }
///  ...
/// ```
mixin BaseTickerProviderStateMixin on BaseController implements TickerProvider {
  Set<Ticker>? _tickers;

  @override
  Ticker createTicker(TickerCallback onTick) {
    _tickers ??= <_WidgetTicker>{};
    final result = _WidgetTicker(onTick, this, debugLabel: kDebugMode ? 'created by ${describeIdentity(this)}' : null);
    _tickers!.add(result);
    return result;
  }

  void _removeTicker(_WidgetTicker ticker) {
    assert(_tickers != null);
    assert(_tickers!.contains(ticker));
    _tickers!.remove(ticker);
  }

  void didChangeDependencies(BuildContext context) {
    final muted = !TickerMode.of(context);
    if (_tickers != null) {
      for (final ticker in _tickers!) {
        ticker.muted = muted;
      }
    }
  }

  @override
  void dispose() {
    assert(() {
      if (_tickers != null) {
        for (final ticker in _tickers!) {
          if (ticker.isActive) {
            throw FlutterError.fromParts(<DiagnosticsNode>[
              ErrorSummary('$this was disposed with an active Ticker.'),
              ErrorDescription(
                '$runtimeType created a Ticker via its GetTickerProviderStateMixin, but at the time '
                'dispose() was called on the mixin, that Ticker was still active. All Tickers must '
                'be disposed before calling super.dispose().',
              ),
              ErrorHint(
                'Tickers used by AnimationControllers '
                'should be disposed by calling dispose() on the AnimationController itself. '
                'Otherwise, the ticker will leak.',
              ),
              ticker.describeForError('The offending ticker was'),
            ]);
          }
        }
      }
      return true;
    }());
    super.dispose();
  }
}

class _WidgetTicker extends Ticker {
  _WidgetTicker(super.onTick, this._creator, {super.debugLabel});

  final BaseTickerProviderStateMixin _creator;

  @override
  void dispose() {
    _creator._removeTicker(this);
    super.dispose();
  }
}
