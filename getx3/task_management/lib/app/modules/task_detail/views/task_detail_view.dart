import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/task_detail_controller.dart';

class TaskDetailView extends GetView<TaskDetailController> {
  const TaskDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskDetailView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TaskDetailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}