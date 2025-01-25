import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/report_model.dart';

class ReportController extends GetxController {
  var reports = <ReportModel>[].obs;
  var isLoading = false.obs;
  var isSending = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fungsi untuk mengirim laporan
  void sendReport(String message) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      Get.snackbar('Error', 'Anda harus login terlebih dahulu.');
      return;
    }

    isSending.value = true;
    try {
      await _firestore.collection('reports').add({
        'userId': userId,
        'message': message,
        'status': 'pending', // Status laporan ketika pertama kali dikirim
        'createdAt': FieldValue.serverTimestamp(),
      });
      Get.snackbar('Sukses', 'Laporan berhasil dikirim.');
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengirim laporan: $e');
    } finally {
      isSending.value = false;
    }
  }

  // Fungsi untuk mengambil laporan yang sudah dikirim
  void fetchReports() async {
    isLoading.value = true;
    try {
      final snapshot = await _firestore.collection('reports').get();
      reports.assignAll(
        snapshot.docs.map((doc) => ReportModel.fromMap(doc.id, doc.data())).toList(),
      );
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat laporan.');
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk mengubah status laporan (misalnya, dari 'pending' ke 'resolved')
  void updateReportStatus(String reportId, String status) async {
    try {
      await _firestore.collection('reports').doc(reportId).update({
        'status': status,
      });
      fetchReports(); // Refresh data
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui status laporan.');
    }
  }

  // Delete report
  void deleteReport(String reportId) async {
    try {
      await _firestore.collection('reports').doc(reportId).delete();
      reports.removeWhere((report) => report.id == reportId); // Remove from local list
      Get.snackbar('Sukses', 'Laporan berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus laporan');
    }
  }
}