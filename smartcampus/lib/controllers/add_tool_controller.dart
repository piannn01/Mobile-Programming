import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/add_tool_model.dart';

class ToolController extends GetxController {
  final tools = <ToolModel>[].obs;
  final isLoading = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch tools from Firebase
  void fetchTools() async {
    isLoading.value = true;
    try {
      final snapshot = await _firestore.collection('tools').get();
      tools.assignAll(
        snapshot.docs.map((doc) => ToolModel.fromMap(doc.id, doc.data())).toList(),
      );
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data alat');
    } finally {
      isLoading.value = false;
    }
  }

  // Update booking status in Firebase
  void toggleToolAvailability(String toolId) async {
    try {
      ToolModel tool = tools.firstWhere((p) => p.id == toolId);
      await _firestore.collection('tools').doc(toolId).update({
        'isAvailable': !tool.isAvailable,
      });
      fetchTools(); // Refresh data
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengubah status alat');
    }
  }

  // Book a tool
  void bookTool(String toolId, String userId, DateTime startDate, DateTime endDate) async {
    try {
      await _firestore.collection('tools').doc(toolId).update({
        'isAvailable': false,
        'bookedBy': userId,
        'bookingDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      });

      fetchTools(); // Refresh data
      Get.snackbar('Sukses', 'Alat berhasil dipesan!');
    } catch (e) {
      Get.snackbar('Error', 'Gagal memesan alat: $e');
    }
  }

  // Add a new tool to Firebase
  void addTool(String name, String description) async {
    try {
      final docRef = await _firestore.collection('tools').add({
        'name': name,
        'description': description,
        'isAvailable': true, // Default to available
        'bookedBy': null, // No user initially
        'bookingDate': null,
        'endDate': null,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Optional: Add the newly created tool to the local list
      tools.add(
        ToolModel(
          id: docRef.id,
          name: name,
          description: description,
          isAvailable: true,
        ),
      );

      Get.snackbar('Sukses', 'Alat berhasil ditambahkan!');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan alat: $e');
    }
  }

  // Edit an existing tool
  void editTool(String toolId, String name, String description) async {
    try {
      await _firestore.collection('tools').doc(toolId).update({
        'name': name,
        'description': description,
      });

      // Update local list
      int index = tools.indexWhere((tool) => tool.id == toolId);
      if (index != -1) {
        tools[index] = tools[index].copyWith(
          name: name,
          description: description,
        );
      }

      Get.snackbar('Sukses', 'Alat berhasil diperbarui!');
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui alat: $e');
    }
  }

  // Delete a tool from Firebase
  void deleteTool(String toolId) async {
    try {
      await _firestore.collection('tools').doc(toolId).delete();

      // Remove the tool from the local list
      tools.removeWhere((tool) => tool.id == toolId);

      Get.snackbar('Sukses', 'Alat berhasil dihapus!');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus alat: $e');
    }
  }
}

