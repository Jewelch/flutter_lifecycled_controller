import 'package:cg_core_defs/helpers/debugging_printer.dart';
import 'package:flutter/material.dart';

import '../controllers/base_controller.dart';

@immutable
abstract class BaseWidget<T extends BaseController> extends StatefulWidget {
  const BaseWidget(this.controller, {super.key});

  @protected
  final T controller;

  @override
  State<BaseWidget> createState() => _BaseWidgetState();

  @protected
  Widget build(BuildContext context);
}

class _BaseWidgetState extends State<BaseWidget> {
  @override
  @protected
  void initState() {
    widget.controller.initState();
    Debugger.magenta('initState ${widget.controller}');
    super.initState();

    addPostFrameCallback();
  }

  void addPostFrameCallback() => WidgetsBinding.instance.addPostFrameCallback((_) {
        Debugger.magenta('onReady ${widget.controller}');
        widget.controller.onReady();
      });

  @override
  @protected
  void dispose() {
    widget.controller.dispose();
    Debugger.magenta('dispose ${widget.controller}');

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.build(context);
}
