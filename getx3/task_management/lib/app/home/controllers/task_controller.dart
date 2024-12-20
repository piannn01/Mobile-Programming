import 'package:get/get.dart';
import '../../data/models/task_model.dart';

class TaskController extends GetxController {
  // Array untuk menyimpan daftar task
  final tasks = <TaskModel>[].obs;

  // Getter untuk jumlah total task
  int get totalTasks => tasks.length;

  // Getter untuk jumlah task yang selesai
  int get completedTask => tasks.where((task) => task.isCompleted).length;

  // Method untuk menambah task baru
  void addTask(String title, {String description = ''}) {
    final newTask = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
    );
    tasks.add(newTask); // Tambahkan task baru ke array
  }

  // Method untuk mengedit task
  void updateTask(TaskModel updatedTask) {
    final index = tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask;
    }
  }

  // Method untuk menghapus task berdasarkan ID
  void deleteTask(String taskId) {
    tasks.removeWhere((task) => task.id == taskId);
  }

  // Method untuk toggle status task selesai/tidak
  void toggleTaskStatus(String taskId) {
    final index = tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      tasks[index] =
          tasks[index].copyWith(isCompleted: !tasks[index].isCompleted);
    }
  }
}