import 'package:alerthub/features/user/domain/usecases/user_service.dart';
import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/user/data/model/account_types.dart';

class UserSignUpController extends GetxController {
  final UserService userService;
  UserSignUpController(this.userService);

  // Reactive variables
  final RxBool _hasUserAgreed = false.obs;
  final RxBool _isHidden = true.obs;
  final RxBool _isLoading = false.obs;

  final Rx<TextEditingController> _emailController =
      TextEditingController().obs;
  final Rx<TextEditingController> _passwordController =
      TextEditingController().obs;
  final Rx<TextEditingController> _retypePasswordController =
      TextEditingController().obs;
  final Rx<FocusNode> _emailFocusNode = FocusNode().obs;
  final Rx<FocusNode> _passwordFocusNode = FocusNode().obs;
  final Rx<FocusNode> _retypePasswordFocusNode = FocusNode().obs;
  final Rx<GlobalKey<FormState>> _formKey = GlobalKey<FormState>().obs;
  final _accountType = Rxn<AccountType>();

  // Getters
  AccountType? get accountType => _accountType.value;
  bool get hasUserAgreed => _hasUserAgreed.value;
  bool get isHidden => _isHidden.value;
  bool get isLoading => _isLoading.value;

  TextEditingController get emailController => _emailController.value;
  TextEditingController get passwordController => _passwordController.value;
  TextEditingController get retypePasswordController =>
      _retypePasswordController.value;

  FocusNode get emailFocusNode => _emailFocusNode.value;
  FocusNode get passwordFocusNode => _passwordFocusNode.value;
  FocusNode get retypePasswordFocusNode => _retypePasswordFocusNode.value;
  GlobalKey<FormState> get formKey => _formKey.value;

  // Setters
  set hasUserAgreed(bool value) => _hasUserAgreed.value = value;
  set isHidden(bool value) => _isHidden.value = value;
  set accountType(AccountType? value) => _accountType.value = value;
  set isLoading(bool value) => _isLoading.value = value;
  set emailController(TextEditingController value) =>
      _emailController.value = value;
  set passwordController(TextEditingController value) =>
      _passwordController.value = value;
  set retypePasswordController(TextEditingController value) =>
      _retypePasswordController.value = value;
  set emailFocusNode(FocusNode value) => _emailFocusNode.value = value;
  set passwordFocusNode(FocusNode value) => _passwordFocusNode.value = value;
  set retypePasswordFocusNode(FocusNode value) =>
      _retypePasswordFocusNode.value = value;
  set formKey(GlobalKey<FormState> value) => _formKey.value = value;

  Future<void> signUpUser() async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return Future.error('Kindly fill all fields.');
    }
    if (isLoading) {
      return Future.error(
          'Kindly wait till the current operation is complete.');
    }

    if (accountType == null) {
      return Future.error('Kindly select your account type to proceed.');
    }
    if (!hasUserAgreed) {
      return Future.error('Kindly agree to the T and C to proceed.');
    }

    formKey.currentState?.save();

    isLoading = true;

    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      await userService.register(
        type: accountType!,
        email: email,
        password: password,
      );
      isLoading = false;
    } catch (exception) {
      isLoading = false;
      return Future.error(exception);
    }
  }
}
