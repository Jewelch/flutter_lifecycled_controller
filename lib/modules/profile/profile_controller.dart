import 'dart:math' show pi;

import '../../bases/controllers/controller_mixins.dart';
import '../../bases/controllers/index.dart';

class ProfileController extends BaseController with BaseSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    animation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(animationController);

    super.initState();
  }

  @override
  void onReady() {
    super.onReady();
    animationController.repeat();
  }

  void playWithKids() {}

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
