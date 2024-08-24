import '../../bases/controllers/index.dart';
import 'data/login_remote_datasource.dart';

class LoginController extends BaseController {
  late final LoginService _service;
  final inputControls = InputControl.generate(2);

  @override
  void initState() {
    _service = LoginService();
    super.initState();
  }

  @override
  void onReady() {
    _service.loginWithCredentials(
      username: 'ibrahim2',
      password: "ibraPwd",
    );
    super.onReady();
  }

  void focusOnTFWithIndex(int index) => inputControls[index].node.requestFocus();

  void toProductDetailsScreen(BuildContext context) => context.go(RouteNames.productDetails);

  void toProfileScreen(BuildContext context) => context.go(RouteNames.profileScreen);

  @override
  void dispose() {
    inputControls.disposeAll();
    super.dispose();
  }
}
