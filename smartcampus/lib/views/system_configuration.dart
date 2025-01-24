import 'package:flutter/material.dart';
import 'package:get/get.dart';

// save
class SystemConfigurationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('System Configuration'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pengaturan Sistem',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildConfigOption('Backup Data', Icons.backup, () {
              Get.snackbar('Backup Data', 'Fitur ini sedang dalam pengembangan.');
            }),
            _buildConfigOption('Reset Password Semua Pengguna', Icons.lock_reset, () {
              Get.snackbar('Reset Password', 'Fitur ini sedang dalam pengembangan.');
            }),
            _buildConfigOption('Pengaturan Notifikasi', Icons.notifications, () {
              Get.snackbar('Pengaturan Notifikasi', 'Fitur ini sedang dalam pengembangan.');
            }),
            _buildConfigOption('Update Sistem', Icons.system_update, () {
              Get.snackbar('Update Sistem', 'Fitur ini sedang dalam pengembangan.');
            }),
            _buildConfigOption('Log Monitoring', Icons.note_add_outlined, () {
              Get.snackbar('Log Monitoring', 'Fitur ini sedang dalam pengembangan.');
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigOption(String title, IconData icon, void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: Icon(icon, color: Colors.blue),
            ),
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
