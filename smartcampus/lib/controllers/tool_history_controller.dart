import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/add_tool_model.dart';

class HistoryToolController extends GetxController {
  var borrowedTools = <ToolModel>[].obs;
  var isLoading = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch history of borrowed tools
  void fetchBorrowedTools(String userId) async {
    isLoading.value = true;
    try {
      final snapshot = await _firestore
          .collection('tools')
          .where('bookedBy', isEqualTo: userId)
          .get();
      borrowedTools.assignAll(
        snapshot.docs.map((doc) => ToolModel.fromMap(doc.id, doc.data())).toList(),
      );
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat history peminjaman alat');
    } finally {
      isLoading.value = false;
    }
  }
}