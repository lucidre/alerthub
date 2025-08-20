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

  insertOrUpdateContact(Contact contact) {
    final index = contacts.indexWhere((t) => t.id == contact.id);
    debugPrint("$index");
    if (index == -1) {
      contact.id = UniqueKey().toString();
      _contacts.add(contact);
    } else {
      _contacts[index] = contact;
    }
    _contacts.refresh();
  }

  Future<void> getEmergencyContacts() async {
    isLoading = true;
    hasError = false;
    contacts = [];

    try {
      /*      final contacts = await userService.getEmergencyContacts();
      this.contacts = contacts.data ?? []; */
      hasError = false;
      isLoading = false;
      /*  contacts = [
 Contact( 
  fullName: 'Oti Temitope', 
  phoneNumber: '+2348147486278', 
  email: 'otitemitope6@gmail.com', 

 ), 
        //
      ];  */
    } catch (exception) {
      hasError = true;
      isLoading = false;
      return Future.error(exception.toString());
    }
  }
}
