import 'package:alerthub/features/hospitals/data/model/hospital/hospital.dart';
import 'package:alerthub/features/user/domain/usecases/user_service.dart';
import 'package:alerthub/common_libs.dart';

class HospitalTabController extends GetxController {
  final UserService userService;
  HospitalTabController(this.userService);

  final RxBool _upcIsLoading = true.obs;
  final RxBool _upcHasError = false.obs;
  final Rxn<Hospital> _upcUserModel = Rxn();

  bool get upcIsLoading => _upcIsLoading.value;
  bool get upcHasError => _upcHasError.value;
  Hospital? get upcUserModel => _upcUserModel.value;

  set upcIsLoading(bool value) => _upcIsLoading.value = value;
  set upcHasError(bool value) => _upcHasError.value = value;

  set upcUserModel(Hospital? profile) => _upcUserModel.value = profile;

  Future<void> getUpcData() async {
    upcIsLoading = true;
    upcHasError = false;
    upcUserModel = null;

    try {
      final user = await userService.getHospital();
      upcUserModel = user.data;
      upcHasError = false;
      upcIsLoading = false;
    } catch (exception) {
      upcHasError = true;
      upcIsLoading = false;
      return Future.error(exception.toString());
    }
  }
}
