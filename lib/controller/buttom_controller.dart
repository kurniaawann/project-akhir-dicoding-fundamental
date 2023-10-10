import 'package:get/get.dart';

class ButtomController extends GetxController {
  var currentIndex = 0.obs;

  void changeCurrentIndex(int newIndex) {
    currentIndex.value = newIndex;
  }
}
