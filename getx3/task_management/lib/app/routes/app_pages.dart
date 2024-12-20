import 'package:get/get.dart';

import '../modules/add_task/bindings/add_task_binding.dart';
import '../modules/add_task/views/add_task_view.dart';
import '../home/bindings/home_binding.dart';
import '../home/views/home_view.dart';
import '../modules/task_detail/bindings/task_detail_binding.dart';
import '../modules/task_detail/views/task_detail_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.TASK_DETAIL,
      page: () => const TaskDetailView(),
      binding: TaskDetailBinding(),
    ),
    GetPage(
      name: _Paths.ADD_TASK,
      page: () => AddTaskView(),
      binding: AddTaskBinding(),
    ),
  ];
}