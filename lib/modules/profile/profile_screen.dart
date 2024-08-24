import '../../bases/screens/index.dart';
import 'profile_controller.dart';

class ProfileScreen extends BaseWidget<ProfileController> {
  ProfileScreen({super.key}) : super(ProfileController());

  @override
  Widget build(BuildContext context) {
    const double containerSide = 50;
    return Scaffold(
      appBar: AppBar(
        title: Text("$ProfileScreen"),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: controller.animationController,
          builder: (context, child) => Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..rotateY(controller.animation.value),
            child: Container(
              width: containerSide,
              height: containerSide,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
