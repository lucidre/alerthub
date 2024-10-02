import 'package:get/get.dart';

class BottomBarController extends GetxController {
  final RxInt _index = 0.obs;
  int get index => _index.value;
  RxInt get indexRx => _index;

  setIndex(index) => _index(index);
  goToProfile() => setIndex(2);
}
