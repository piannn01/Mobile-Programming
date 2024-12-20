import 'package:get/get.dart';

import '../controllers/task_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskController>(
          () => TaskController(),
    );
  }
}