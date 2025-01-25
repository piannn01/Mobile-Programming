import 'package:get/get.dart';

class BottomNavController extends GetxController {
  // RxInt untuk membuat index yang dapat di-observe
  var selectedIndex = 0.obs;

  // Method untuk mengganti index
  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}