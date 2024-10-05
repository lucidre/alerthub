import 'package:alerthub/features/user/domain/usecases/user_service.dart';
import 'package:alerthub/common_libs.dart';
import 'package:country_picker/country_picker.dart';

class UserSignUpController extends GetxController {
  final UserService userService;
  UserSignUpController(this.userService);

  // Reactive variables
  final Rxn<Country> _selectedCountry = Rxn<Country>();
  final RxBool _hasUserAgreed = false.obs;
  final RxBool _isHidden = true.obs;
  final RxBool _isLoading = false.obs;
  final Rx<TextEditingController> _fullNameController =
      TextEditingController().obs;
  final Rx<TextEditingController> _phoneNumberController =
      TextEditingController().obs;
  final Rx<TextEditingController> _emailController =
      TextEditingController().obs;
  final Rx<TextEditingController> _passwordController =
      TextEditingController().obs;
  final Rx<TextEditingController> _retypePasswordController =
      TextEditingController().obs;
  final Rx<FocusNode> _phoneNumberFocusNode = FocusNode().obs;
  final Rx<FocusNode> _emailFocusNode = FocusNode().obs;
  final Rx<FocusNode> _passwordFocusNode = FocusNode().obs;
  final Rx<FocusNode> _retypePasswordFocusNode = FocusNode().obs;
  final Rx<GlobalKey<FormState>> _formKey = GlobalKey<FormState>().obs;

  // Getters
  Country? get selectedCountry => _selectedCountry.value;
  bool get hasUserAgreed => _hasUserAgreed.value;
  bool get isHidden => _isHidden.value;
  bool get isLoading => _isLoading.value;
  TextEditingController get fullNameController => _fullNameController.value;
  TextEditingController get phoneNumberController =>
      _phoneNumberController.value;
  TextEditingController get emailController => _emailController.value;
  TextEditingController get passwordController => _passwordController.value;
  TextEditingController get retypePasswordController =>
      _retypePasswordController.value;
  FocusNode get phoneNumberFocusNode => _phoneNumberFocusNode.value;
  FocusNode get emailFocusNode => _emailFocusNode.value;
  FocusNode get passwordFocusNode => _passwordFocusNode.value;
  FocusNode get retypePasswordFocusNode => _retypePasswordFocusNode.value;
  GlobalKey<FormState> get formKey => _formKey.value;

  // Setters
  set selectedCountry(Country? value) => _selectedCountry.value = value;
  set hasUserAgreed(bool value) => _hasUserAgreed.value = value;
  set isHidden(bool value) => _isHidden.value = value;
  set isLoading(bool value) => _isLoading.value = value;
  set fullNameController(TextEditingController value) =>
      _fullNameController.value = value;
  set phoneNumberController(TextEditingController value) =>
      _phoneNumberController.value = value;
  set emailController(TextEditingController value) =>
      _emailController.value = value;
  set passwordController(TextEditingController value) =>
      _passwordController.value = value;
  set retypePasswordController(TextEditingController value) =>
      _retypePasswordController.value = value;
  set phoneNumberFocusNode(FocusNode value) =>
      _phoneNumberFocusNode.value = value;
  set emailFocusNode(FocusNode value) => _emailFocusNode.value = value;
  set passwordFocusNode(FocusNode value) => _passwordFocusNode.value = value;
  set retypePasswordFocusNode(FocusNode value) =>
      _retypePasswordFocusNode.value = value;
  set formKey(GlobalKey<FormState> value) => _formKey.value = value;

  resetFields() {
    phoneNumberController.text = '';
    fullNameController.text = '';
    emailController.text = '';
    passwordController.text = '';
    retypePasswordController.text = '';
    selectedCountry = null;
  }

  Future<void> signUpUser() async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return Future.error('Kindly fill all fields.');
    }
    if (isLoading) {
      return Future.error(
          'Kindly wait till the current operation is complete.');
    }

    if (selectedCountry == null) {
      return Future.error('Kindly select your country to proceed.');
    }
    if (!hasUserAgreed) {
      return Future.error('Kindly agree to the T and C to proceed.');
    }

    formKey.currentState?.save();

    isLoading = true;

    try {
      final fullName = fullNameController.text.trim();
      final email = emailController.text.trim();
      final phoneNumber = phoneNumberController.text.trim();
      final country = selectedCountry?.name ?? '';
      final password = passwordController.text.trim();

      await userService.register(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        country: country,
        password: password,
      );
      isLoading = false;
    } catch (exception) {
      isLoading = false;
      return Future.error(exception);
    }
  }
}
