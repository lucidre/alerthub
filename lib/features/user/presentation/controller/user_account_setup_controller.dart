import 'dart:io';
import 'package:alerthub/features/user/domain/usecases/user_service.dart';
import 'package:alerthub/common_libs.dart';
import 'package:country_picker/country_picker.dart';
import 'package:image_picker/image_picker.dart';

class UserAccoutSetupController extends GetxController {
  final UserService userService;
  UserAccoutSetupController(this.userService);

  // Reactive variables
  final Rxn<Country> _selectedCountry = Rxn<Country>();
  final RxBool _isLoading = false.obs;

  final Rx<TextEditingController> _fullNameController =
      TextEditingController().obs;
  final Rx<TextEditingController> _phoneNumberController =
      TextEditingController().obs;
  final Rx<FocusNode> _phoneNumberFocusNode = FocusNode().obs;
  final Rx<GlobalKey<FormState>> _formKey = GlobalKey<FormState>().obs;
  final Rxn<File> _profileImage = Rxn<File>();

  // Getters
  Country? get selectedCountry => _selectedCountry.value;
  bool get isLoading => _isLoading.value;
  File? get profileImage => _profileImage.value;
  TextEditingController get fullNameController => _fullNameController.value;
  TextEditingController get phoneNumberController =>
      _phoneNumberController.value;
  FocusNode get phoneNumberFocusNode => _phoneNumberFocusNode.value;

  GlobalKey<FormState> get formKey => _formKey.value;

  // Setters
  set selectedCountry(Country? value) => _selectedCountry.value = value;
  set isLoading(bool value) => _isLoading.value = value;
  set profileImage(File? value) => _profileImage.value = value;
  set fullNameController(TextEditingController value) =>
      _fullNameController.value = value;
  set phoneNumberController(TextEditingController value) =>
      _phoneNumberController.value = value;
  set phoneNumberFocusNode(FocusNode value) =>
      _phoneNumberFocusNode.value = value;
  set formKey(GlobalKey<FormState> value) => _formKey.value = value;

  Future<void> signUpUser(String email) async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return Future.error('Kindly fill all fields.');
    }

    if (isLoading) {
      return Future.error(
          'Kindly wait till the current operation is complete.');
    }

    if (profileImage == null) {
      throw 'Please select a profile image';
    }

    if (selectedCountry == null) {
      return Future.error('Kindly select your country to proceed.');
    }

    formKey.currentState?.save();

    isLoading = true;

    try {
      final fullName = fullNameController.text.trim();
      final phoneNumber = phoneNumberController.text.trim();
      final country = selectedCountry?.name ?? '';
      final profileImage =
          await userService.uploadProfilePicture(this.profileImage?.path ?? '');

      await userService.updateUser(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        country: country,
        imageUrl: profileImage,
      );
      isLoading = false;
    } catch (exception) {
      isLoading = false;
      return Future.error(exception);
    }
  }

  selectImage() async {
    try {
      final imagePicker = ImagePicker();
      const source = ImageSource.gallery;
      final file = await imagePicker.pickImage(source: source);
      if (file != null) {
        profileImage = File(file.path);
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }
}
