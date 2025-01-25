import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/tool_booking_model.dart';

class ItemController extends GetxController {
  final tools = <ItemModel>[].obs;
  final isLoading = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all tools from Firebase
  void fetchTools() async {
    isLoading.value = true;
    try {
      final snapshot = await _firestore.collection('tools').get();
      tools.assignAll(snapshot.docs.map((doc) {
        return ItemModel.fromMap(doc.id, doc.data());
      }).toList());
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data tempat');
    } finally {
      isLoading.value = false;
    }
  }

  // Book a tool
  void bookTools(String toolId, String userId, DateTime bookingDate, DateTime endDate) async {
    try {
      await _firestore.collection('tools').doc(toolId).update({
        'isAvailable': false,
        'bookedBy': userId,
        'bookingDate': bookingDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      });
      fetchTools(); // Refresh data
    } catch (e) {
      Get.snackbar('Error', 'Gagal mem-booking tempat');
    }
  }

  // Cancel a booking
  void cancelBooking(String toolId) async {
    try {
      await _firestore.collection('tools').doc(toolId).update({
        'isAvailable': true,
        'bookedBy': null,
        'bookingDate': null,
        'endDate': null,
      });
      fetchTools(); // Refresh data
    } catch (e) {
      Get.snackbar('Error', 'Gagal membatalkan booking');
    }
  }
}
