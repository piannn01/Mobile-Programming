import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/report_controller.dart';
import '../models/report_model.dart';

class StaffReportView extends StatelessWidget {
  final ReportController reportController = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    reportController.fetchReports(); // Mengambil laporan yang masuk

    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Masuk'),
      ),
      body: Obx(() {
        if (reportController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (reportController.reports.isEmpty) {
          return Center(child: Text('Tidak ada laporan masuk.'));
        } else {
          return ListView.builder(
            itemCount: reportController.reports.length,
            itemBuilder: (context, index) {
              ReportModel report = reportController.reports[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(report.message),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status: ${report.status}'),
                      SizedBox(height: 5),
                      Text('Pengirim: ${report.userId}'),
                      Text('Tanggal: ${report.createdAt.toLocal().toString().split(' ')[0]}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tombol untuk menyelesaikan laporan
                      if (report.status == 'pending')
                        IconButton(
                          icon: Icon(Icons.check_circle),
                          onPressed: () {
                            reportController.updateReportStatus(report.id, 'resolved');
                          },
                        ),
                      // Tombol untuk menghapus laporan
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Konfirmasi sebelum menghapus laporan
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Konfirmasi'),
                                content: Text('Apakah Anda yakin ingin menghapus laporan ini?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context), // Menutup dialog
                                    child: Text('Batal'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      reportController.deleteReport(report.id);
                                      Navigator.pop(context); // Menutup dialog setelah dihapus
                                    },
                                    child: Text('Hapus'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
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