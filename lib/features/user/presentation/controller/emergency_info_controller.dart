import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/user/domain/usecases/user_service.dart';

class EmergencyInfoController extends GetxController {
  final UserService userService;
  EmergencyInfoController(this.userService);

  final _isFetchingData = false.obs;
  bool get isFetchingData => _isFetchingData.value;
  set isFetchingData(bool value) => _isFetchingData.value = value;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  final _hasError = false.obs;
  bool get hasError => _hasError.value;
  set hasError(bool value) => _hasError.value = value;

  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  final _descriptionController = TextEditingController();
  TextEditingController get descriptionController => _descriptionController;

  Future<void> fetchEmergencyInfo() async {
    if (isFetchingData) {
      return;
    }

    isFetchingData = true;
    hasError = false;
    try {
      final info = await userService.getEmergencyInformation();
      _descriptionController.text = info;
      isFetchingData = false;
    } catch (error) {
      hasError = true;
      isFetchingData = false;
      return Future.error(error.toString());
    }
  }

  updateDescription() async {
    final isValid = formKey.currentState?.validate() ?? false;

    if (!isValid || isLoading) {
      return;
    }

    isLoading = true;

    try {
      final description = descriptionController.text.trim();
      await userService.updateEmergencyInformation(description);
    } catch (exception) {
      return Future.error(exception.toString());
    }

    isLoading = false;
  }
}
