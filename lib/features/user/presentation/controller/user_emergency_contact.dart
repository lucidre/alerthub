import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/user/data/model/contacts/contact.dart';
import 'package:alerthub/features/user/domain/usecases/user_service.dart';

class UserEmergencyContactsController extends GetxController {
  final UserService userService;
  UserEmergencyContactsController(this.userService);

  final RxBool _isLoading = true.obs;
  final RxBool _hasError = false.obs;
  final RxList<Contact> _contacts = <Contact>[].obs;

  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;
  List<Contact> get contacts => _contacts;

  set isLoading(bool value) => _isLoading.value = value;
  set hasError(bool value) => _hasError.value = value;
  set contacts(List<Contact> value) => _contacts.value = value;

  void deleteContact(Contact? contact) {
    if (contact != null) {
      _contacts.removeWhere((t) => t.id == contact.id);
    }
  }

  Future<void> getEmergencyContacts() async {
    isLoading = true;
    hasError = false;
    contacts.clear();

    try {
      final contacts = await userService.getEmergencyContact();
      this.contacts = contacts.data ?? [];
      hasError = false;
      isLoading = false;
    } catch (exception) {
      hasError = true;
      isLoading = false;
      return Future.error(exception.toString());
    }
  }
}
