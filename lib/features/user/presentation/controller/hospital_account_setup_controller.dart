import 'dart:io';
import 'package:alerthub/features/user/domain/usecases/user_service.dart';
import 'package:alerthub/common_libs.dart';
import 'package:country_picker/country_picker.dart';
import 'package:image_picker/image_picker.dart';

class HospitalAccoutSetupController extends GetxController {
  final UserService userService;
  HospitalAccoutSetupController(this.userService);

  // Reactive variables
  final Rxn<Country> _selectedCountry = Rxn<Country>();
  final RxBool _isLoading = false.obs;
  final Rxn<double> _lat = Rxn<double>();
  final Rxn<double> _lng = Rxn<double>();
  final Rx<TextEditingController> _hospitalNameController =
      TextEditingController().obs;
  final Rx<TextEditingController> _addressController =
      TextEditingController().obs;
  final Rx<TextEditingController> _descriptionController =
      TextEditingController().obs;
  final Rx<TextEditingController> _helplineController =
      TextEditingController().obs;
  final Rx<FocusNode> _helplineFocusNode = FocusNode().obs;
  final Rx<FocusNode> _descriptionFocusNode = FocusNode().obs;
  final Rx<GlobalKey<FormState>> _formKey = GlobalKey<FormState>().obs;
  final Rxn<File> _profileImage = Rxn<File>();

  // Getters
  double? get lat => _lat.value;
  double? get lng => _lng.value;
  Country? get selectedCountry => _selectedCountry.value;
  bool get isLoading => _isLoading.value;
  File? get profileImage => _profileImage.value;
  TextEditingController get hospitalNameController =>
      _hospitalNameController.value;
  TextEditingController get descriptionController =>
      _descriptionController.value;
  TextEditingController get addressController => _addressController.value;
  TextEditingController get helplineController => _helplineController.value;
  FocusNode get helplineFocusNode => _helplineFocusNode.value;
  FocusNode get descriptionFocusNode => _descriptionFocusNode.value;

  GlobalKey<FormState> get formKey => _formKey.value;

  // Setters
  set selectedCountry(Country? value) => _selectedCountry.value = value;
  set isLoading(bool value) => _isLoading.value = value;
  set lat(double? value) => _lat.value = value;
  set lng(double? value) => _lng.value = value;
  set profileImage(File? value) => _profileImage.value = value;
  set hospitalNameController(TextEditingController value) =>
      _hospitalNameController.value = value;
  set descriptionController(TextEditingController value) =>
      _descriptionController.value = value;
  set helplineController(TextEditingController value) =>
      _helplineController.value = value;
  set addressController(TextEditingController value) =>
      _addressController.value = value;
  set helplineFocusNode(FocusNode value) => _helplineFocusNode.value = value;
  set descriptionFocusNode(FocusNode value) =>
      _descriptionFocusNode.value = value;
  set formKey(GlobalKey<FormState> value) => _formKey.value = value;

  locationUpdate(double? lat, double? lng) {
    this.lat = lat;
    this.lng = lng;
  }

  Future<void> signUpHospital(String email) async {
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
      throw 'Kindly select your country to proceed.'; 
    }

    formKey.currentState?.save();

    isLoading = true;

    try {
      final hospitalName = hospitalNameController.text.trim();
      final helpline = helplineController.text.trim();
      final country = selectedCountry?.name ?? '';
      final description = descriptionController.text.trim();
      final location = addressController.text.trim();
      final img =
          await userService.uploadProfilePicture(profileImage?.path ?? '');

      await userService.updateHealthCenter(
        hospitalName: hospitalName,
        email: email,
        helpline: helpline,
        description: description,
        country: country,
        imageUrl: img,
        latitude: lat ?? -1,
        longitude: lng ?? -1,
        location: location,
        drivers: [],
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
