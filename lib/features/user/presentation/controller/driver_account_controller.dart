import 'dart:io';
import 'package:alerthub/features/hospitals/data/model/hospital/driver.dart';
import 'package:alerthub/features/hospitals/domain/usecases/hospital_service.dart';
import 'package:alerthub/common_libs.dart';
import 'package:image_picker/image_picker.dart';

class DriverAccountSetupController extends GetxController {
  final HospitalService service;
  DriverAccountSetupController(this.service);

  final RxBool _isLoading = false.obs;
  final RxBool _isDeleting = false.obs;

  final Rx<TextEditingController> _nameController = TextEditingController().obs;
  final Rx<TextEditingController> _emailController =
      TextEditingController().obs;

  final Rx<TextEditingController> _passwordController =
      TextEditingController().obs;
  final Rx<TextEditingController> _contactController =
      TextEditingController().obs;

  final Rx<GlobalKey<FormState>> _formKey = GlobalKey<FormState>().obs;
  GlobalKey<FormState> get formKey => _formKey.value;

  final Rxn<File> _profileImage = Rxn<File>();

  bool get isLoading => _isLoading.value;
  bool get isDeleting => _isDeleting.value;
  File? get profileImage => _profileImage.value;
  TextEditingController get nameController => _nameController.value;

  TextEditingController get emailController => _emailController.value;

  TextEditingController get passwordController => _passwordController.value;
  TextEditingController get contactController => _contactController.value;

  set isLoading(bool value) => _isLoading.value = value;
  set isDeleting(bool value) => _isDeleting.value = value;

  set profileImage(File? value) => _profileImage.value = value;
  set nameController(TextEditingController value) =>
      _nameController.value = value;
  set emailController(TextEditingController value) =>
      _emailController.value = value;
  set passwordController(TextEditingController value) =>
      _passwordController.value = value;
  set contactController(TextEditingController value) =>
      _contactController.value = value;

  set formKey(GlobalKey<FormState> value) => _formKey.value = value;

  setUpDriver(Driver driver) {
    //TODO MAKE PROFILE IMAGE PASSABLE.
    nameController.text = driver.fullName ?? '';
    emailController.text = driver.email ?? '';
    passwordController.text = driver.password ?? '';
    contactController.text = driver.contact ?? '';
  }

  Future<void> updateDriver(Driver? driver) async {
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

    formKey.currentState?.save();

    isLoading = true;

    try {
      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final contact = contactController.text.trim();
      final img = await service.uploadDriverImage(profileImage?.path ?? '');

      if (driver == null) {
        await service.createDriver(
          fullName: name,
          email: email,
          password: password,
          contact: contact,
          image: img,
        );
      } else {
        await service.editDriver(
          id: driver.id ?? '',
          fullName: name,
          email: email,
          password: password,
          contact: contact,
          image: img,
          location: driver.location ?? '',
          lat: driver.lat ?? -1,
          lng: driver.lng ?? -1,
        );
      }
      isLoading = false;
    } catch (exception) {
      isLoading = false;
      return Future.error(exception);
    }
  }

  deleteDriver(Driver driver) async {
    isDeleting = true;
    try {
      await service.deleteDriver(driver.id ?? '');
    } catch (exception) {
      return Future.error(exception.toString());
    }
    isDeleting = false;
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
