import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';
import '../../modules/add_task/views/add_task_view.dart';

class HomeView extends GetView<TaskController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management'),
        centerTitle: true,
        actions: [
          Obx(() => Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                '${controller.completedTask}/${controller.totalTasks}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ))
        ],
      ),
      body: Obx(() {
        if (controller.tasks.isEmpty) {
          return const Center(
            child: Text(
              'No tasks available. Add some tasks!',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.tasks.length,
          itemBuilder: (context, index) {
            final task = controller.tasks[index];
            return ListTile(
              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              subtitle: Text(task.description),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Checkbox untuk status selesai
                  Checkbox(
                    value: task.isCompleted,
                    onChanged: (_) => controller.toggleTaskStatus(task.id),
                  ),
                  // Icon untuk edit task
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      // Navigasi ke halaman edit dengan argumen task
                      Get.to(() => AddTaskView(), arguments: task);
                    },
                  ),
                  // Icon untuk hapus task
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => controller.deleteTask(task.id),
                  ),
                ],
              ),
              onTap: () => Get.toNamed('/task-detail', arguments: task),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Get.to(() => AddTaskView()), // Panggil AddTaskView
      ),
    );
  }
}