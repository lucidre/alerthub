import 'package:alerthub/features/hospitals/data/model/hospital/hospital.dart';
import 'package:alerthub/features/hospitals/domain/usecases/hospital_service.dart';
import 'package:get/get.dart';

class HospitalDetailsController extends GetxController {
  final HospitalService hospitalService;

  HospitalDetailsController(this.hospitalService);
  final RxBool _isLoading = true.obs;
  final RxBool _hasError = false.obs;
  final Rxn<Hospital> _hospital = Rxn<Hospital>();

  // Getters
  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value; 
  
  Hospital? get hospital => _hospital.value;

  // Setters
  set isLoading(bool value) => _isLoading.value = value;
  set hasError(bool value) => _hasError.value = value;
  set hospital(Hospital? value) => _hospital.value = value;

  getData(String hospitalId) async {
    isLoading = true;
    hasError = false;

    try {
      final data = await hospitalService.getHospital(hospitalId);
      hospital = data.data; 
      hasError = false;
      isLoading = false;
    } catch (exception) {
      hasError = true;
      isLoading = false;
      return Future.error(exception.toString());
    }
  }
}
