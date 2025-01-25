import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/tool_history_controller.dart';
import '../models/add_tool_model.dart';

class HistoryToolView extends StatelessWidget {
  final HistoryToolController historyToolController = Get.put(HistoryToolController());

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    // Memastikan history peminjaman alat dimuat setelah halaman dibuka
    if (userId != null) {
      historyToolController.fetchBorrowedTools(userId);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('History Peminjaman Alat'),
      ),
      body: Obx(() {
        if (historyToolController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (historyToolController.borrowedTools.isEmpty) {
          return Center(child: Text('Tidak ada alat yang pernah dipinjam.'));
        } else {
          return ListView.builder(
            itemCount: historyToolController.borrowedTools.length,
            itemBuilder: (context, index) {
              ToolModel tool = historyToolController.borrowedTools[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(tool.name),
                  subtitle: Text('Tanggal Peminjaman: ${tool.bookingDate?.toLocal().toString().split(' ')[0] ?? '-'}'),
                  trailing: Icon(
                    Icons.history,
                    color: Colors.blue,
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}