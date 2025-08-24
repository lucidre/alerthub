import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/user/data/model/contacts/contact.dart';
import 'package:alerthub/features/user/domain/usecases/user_service.dart';

class AddEditEmergencyContactsController extends GetxController {
  final UserService userService;
  AddEditEmergencyContactsController(this.userService);

  final RxBool _isLoading = true.obs;
  final RxBool _isDeleting = true.obs;
  final _nameController = TextEditingController().obs;
  final _phoneNumberController = TextEditingController().obs;
  final _countryController = TextEditingController().obs;
  final _formKey = GlobalKey<FormState>().obs;
  final _oldId = RxnString();

  bool get isLoading => _isLoading.value;
  bool get isDeleting => _isDeleting.value;
  TextEditingController get nameController => _nameController.value;
  TextEditingController get phoneNumberController =>
      _phoneNumberController.value;
  TextEditingController get countryController => _countryController.value;
  GlobalKey<FormState> get formKey => _formKey.value;
  String? get oldId => _oldId.value;

  set isLoading(bool value) => _isLoading.value = value;
  set isDeleting(bool value) => _isDeleting.value = value;
  set oldId(String? value) => _oldId.value = value;
  set nameController(TextEditingController value) =>
      _nameController.value = value;
  set phoneNumberController(TextEditingController value) =>
      _phoneNumberController.value = value;
  set countryController(TextEditingController value) =>
      _countryController.value = value;
  set formKey(GlobalKey<FormState> value) => _formKey.value = value;

  restoreOldContact(Contact contact) {
    nameController.text = contact.fullName ?? '';
    phoneNumberController.text = contact.phoneNumber ?? '';
    countryController.text = contact.country ?? '';
    oldId = contact.id;
  }

  Future<void> saveContact() async {
    final isValid = formKey.currentState?.validate() ?? false;

    if (!isValid || isLoading || isDeleting) {
      return;
    }

    isLoading = true;

    try {
      if (oldId != null) {
        await userService.updateEmergencyContact(
            id: oldId!,
            fullName: nameController.text,
            phoneNumber: phoneNumberController.text,
            country: countryController.text);
      } else {
        await userService.addEmergencyContact(
            fullName: nameController.text,
            phoneNumber: phoneNumberController.text,
            country: countryController.text);
      }

      isLoading = false;
    } catch (exception) {
      isLoading = false;
      return Future.error(exception.toString());
    }
  }

  Future<void> deleteContact() async {
    if (!isLoading || isDeleting) {
      return;
    }

    isDeleting = true;

    try {
      if (oldId != null) {
        await userService.deleteEmergencyContact(oldId!);
      } else {
        throw 'Unable to delete contact';
      }

      isDeleting = false;
    } catch (exception) {
      isDeleting = false;
      return Future.error(exception.toString());
    }
  }
}
