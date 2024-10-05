import 'package:alerthub/features/user/data/model/user_data/user.dart';
import 'package:alerthub/features/user/domain/usecases/user_service.dart';
import 'package:alerthub/common_libs.dart';
import 'package:country_picker/country_picker.dart';
import 'package:image_picker/image_picker.dart';

class UserEditProfileController extends GetxController {
  final UserService userService;
  UserEditProfileController(this.userService);

  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final phoneNumberFocusNode = FocusNode();

  final formKey = GlobalKey<FormState>();

  final _imagePicker = ImagePicker();

  // Reactive variables
  final Rxn<Country> _selectedCountry = Rxn<Country>();
  final RxBool _isFetching = true.obs;
  final RxBool _isLoading = false.obs;
  final RxBool _hasError = false.obs;
  final Rxn<String> _imagePath = Rxn<String>();
  final RxBool _isImageFromFile = true.obs;
  final Rxn<User> _model = Rxn<User>();

  // Getters
  Country? get selectedCountry => _selectedCountry.value;
  bool get isFetching => _isFetching.value;
  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;
  String? get imagePath => _imagePath.value;
  bool get isImageFromFile => _isImageFromFile.value;
  ImagePicker get imagePicker => _imagePicker;
  User? get model => _model.value;

  // Setters
  set selectedCountry(Country? value) => _selectedCountry.value = value;
  set isFetching(bool value) => _isFetching.value = value;
  set isLoading(bool value) => _isLoading.value = value;
  set hasError(bool value) => _hasError.value = value;
  set imagePath(String? value) => _imagePath.value = value;
  set isImageFromFile(bool value) => _isImageFromFile.value = value;
  set model(User? value) => _model.value = value;

  getData() async {
    isFetching = true;
    hasError = false;

    try {
      final data = await userService.getUser();

      model = data.data;
      emailController.text = model?.email ?? '';
      fullNameController.text = model?.fullName ?? '';
      phoneNumberController.text = model?.phoneNumber ?? '';

      if (model?.imageUrl != null) {
        imagePath = model?.imageUrl;
        isImageFromFile = false;
      }

      final country = CountryService().getAll().firstWhereOrNull(
        (element) {
          return element.name == model?.country;
        },
      );
      if (country != null) {
        selectedCountry = country;
      }
    } catch (exception) {
      hasError = true;
    }

    isFetching = false;
  }

  Future<void> updateUserData() async {
    final isValid = formKey.currentState?.validate() ?? false;

       if (!isValid) {
      return Future.error('Kindly fill all fields.');
    }
    if (isLoading) {
      return Future.error('Kindly wait till the current operation is complete.');
    }

    if (selectedCountry == null) {
      return Future.error('Kindly select your country');
    }

    formKey.currentState?.save();

    final email = emailController.text.trim();
    final fullName = fullNameController.text.trim();
    final phoneNumber = phoneNumberController.text.trim();
    final country = selectedCountry?.name;
    String? imageUrl;

    isLoading = true;

    try {
      if (imagePath != null) {
        if (isImageFromFile) {
          imageUrl = await userService.uploadProfilePicture(imagePath!);
        } else {
          imageUrl = imagePath;
        }
      }
      await userService.updateUser(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        country: country,
        imageUrl: imageUrl,
      );
      Get.find<UserProfileController>().getUser();
      isLoading = false;
    } catch (exception) {
      isLoading = false;
      return Future.error(exception.toString());
    }
  }

  selectImage() async {
    try {
      XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        imagePath = file.path;
        isImageFromFile = true;
      }
    } catch (exception) {
      return Future.error(exception);
    }
  }
}
