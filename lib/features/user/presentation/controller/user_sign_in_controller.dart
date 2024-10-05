import 'package:alerthub/features/user/domain/usecases/user_service.dart';
import 'package:alerthub/common_libs.dart';

class UserSignInController extends GetxController {
  final UserService userService;
  UserSignInController(this.userService);

  // Reactive variables
  final RxBool _isHidden = true.obs;
  final RxBool _isLoading = false.obs;
  final Rx<TextEditingController> _emailController =
      TextEditingController().obs;
  final Rx<TextEditingController> _passwordController =
      TextEditingController().obs;
  final Rx<FocusNode> _passwordFocusNode = FocusNode().obs;
  final Rx<GlobalKey<FormState>> _formKey = GlobalKey<FormState>().obs;

  // Getters
  bool get isHidden => _isHidden.value;
  bool get isLoading => _isLoading.value;
  TextEditingController get emailController => _emailController.value;
  TextEditingController get passwordController => _passwordController.value;
  FocusNode get passwordFocusNode => _passwordFocusNode.value;
  GlobalKey<FormState> get formKey => _formKey.value;

  // Setters
  set isHidden(bool value) => _isHidden.value = value;
  set isLoading(bool value) => _isLoading.value = value;
  set emailController(TextEditingController value) =>
      _emailController.value = value;
  set passwordController(TextEditingController value) =>
      _passwordController.value = value;
  set passwordFocusNode(FocusNode value) => _passwordFocusNode.value = value;
  set formKey(GlobalKey<FormState> value) => _formKey.value = value;

  resetFields() {
    emailController.text = '';
    passwordController.text = '';
  }

  Future<void> signInUser() async {
    final isValid = formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return Future.error('Kindly fill all fields.');
    }
    if (isLoading) {
      return Future.error(
          'Kindly wait till the current operation is complete.');
    }

    formKey.currentState?.save();

    isLoading = true;

    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      await userService.logIn(email, password);
      isLoading = false;
    } catch (exception) {
      isLoading = false;
      return Future.error(exception.toString());
    }
  }
}
