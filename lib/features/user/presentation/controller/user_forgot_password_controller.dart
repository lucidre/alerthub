import 'package:alerthub/features/user/domain/usecases/user_service.dart';
import 'package:alerthub/common_libs.dart';

class UserForgotPasswordController extends GetxController {
  final UserService userService;
  UserForgotPasswordController(this.userService);

  // Reactive variables
  final RxBool _isHidden = true.obs;
  final RxBool _isLoading = false.obs;
  final Rx<TextEditingController> _emailController =
      TextEditingController().obs;
  final Rx<GlobalKey<FormState>> _formKey = GlobalKey<FormState>().obs;

  // Getters
  bool get isHidden => _isHidden.value;
  bool get isLoading => _isLoading.value;
  TextEditingController get emailController => _emailController.value;
  GlobalKey<FormState> get formKey => _formKey.value;

  // Setters
  set isHidden(bool value) => _isHidden.value = value;
  set isLoading(bool value) => _isLoading.value = value;
  set emailController(TextEditingController value) =>
      _emailController.value = value;
  set formKey(GlobalKey<FormState> value) => _formKey.value = value;

  resetFields() {
    emailController.text = '';
  }

  Future<void> resetForgottenPassword() async {
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
      await userService.forgotPassword(email);
      isLoading = false;
    } catch (exception) {
      isLoading = false;
      return Future.error(exception.toString());
    }
  }
}
