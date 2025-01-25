import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/report_controller.dart';

class ReportView extends StatelessWidget {
  final ReportController reportController = Get.put(ReportController());
  final TextEditingController messageController = TextEditingController(); // Controller untuk TextField

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: messageController, // Controller untuk mengambil input pesan
              decoration: InputDecoration(
                labelText: 'Pesan Laporan',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              onChanged: (value) {
                // Handle message input if necessary
              },
            ),
            SizedBox(height: 20),
            Obx(() {
              return ElevatedButton(
                onPressed: reportController.isSending.value
                    ? null // Disable the button while sending
                    : () {
                  String message = messageController.text.trim(); // Ambil pesan dari TextField
                  if (message.isNotEmpty) {
                    reportController.sendReport(message); // Kirim laporan
                  } else {
                    Get.snackbar('Error', 'Pesan tidak boleh kosong');
                  }
                },
                child: reportController.isSending.value
                    ? CircularProgressIndicator(color: Colors.white) // Show loading indicator
                    : Text('Kirim Laporan'),
              );
            }),
          ],
        ),
      ),
    );
  }
}