import '../../bases/screens/index.dart';
import 'login_controller.dart';

class LoginScreen extends BaseWidget<LoginController> {
  LoginScreen({super.key}) : super(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello Ibrahim"),
        actions: [
          IconButton(
            onPressed: () => controller.toProfileScreen(context),
            icon: const Icon(Icons.person),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(label: Text("Username")),
              controller: controller.inputControls.first.controller,
              focusNode: controller.inputControls.first.node,
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(label: Text("Password")),
              controller: controller.inputControls.second.controller,
              focusNode: controller.inputControls.second.node,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => controller.toProductDetailsScreen(context),
              child: const Text(
                "Login",
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 1,
            onPressed: () => controller.focusOnTFWithIndex(0),
            child: const Icon(Icons.person),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 2,
            onPressed: () => controller.focusOnTFWithIndex(1),
            child: const Icon(Icons.password),
          ),
        ],
      ),
    );
  }
}
