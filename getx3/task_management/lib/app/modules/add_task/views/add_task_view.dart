import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../home/controllers/task_controller.dart';
import '../../../data/models/task_model.dart';

class AddTaskView extends StatelessWidget {
  final TaskController controller = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    // Ambil task dari argumen jika tersedia
    final task = Get.arguments as TaskModel?;
    final titleController = TextEditingController(text: task?.title ?? '');
    final descriptionController = TextEditingController(text: task?.description ?? '');

    return Scaffold(
      appBar: AppBar(
        title: Text(task == null ? 'Add Task' : 'Edit Task'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Task Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  if (task == null) {
                    // Tambah task baru
                    controller.addTask(
                      titleController.text,
                      description: descriptionController.text,
                    );
                  } else {
                    // Update task yang sudah ada
                    controller.updateTask(
                      task.copyWith(
                        title: titleController.text,
                        description: descriptionController.text,
                      ),
                    );
                  }
                  Get.back(); // Kembali ke HomeView
                } else {
                  Get.snackbar(
                    'Error',
                    'Task title cannot be empty',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              child: Text(task == null ? 'Add Task' : 'Update Task'),
            ),
          ],
        ),
      ),
    );
  }
}