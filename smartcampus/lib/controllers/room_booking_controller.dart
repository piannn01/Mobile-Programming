import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/room_booking_model.dart';

class PlaceController extends GetxController {
  final places = <RoomModel>[].obs;
  final isLoading = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all places from Firebase
  void fetchPlaces() async {
    isLoading.value = true;
    try {
      final snapshot = await _firestore.collection('places').get();
      places.assignAll(snapshot.docs.map((doc) {
        return RoomModel.fromMap(doc.id, doc.data());
      }).toList());
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data tempat');
    } finally {
      isLoading.value = false;
    }
  }

  // Book a place
  void bookPlace(String placeId, String userId, DateTime bookingDate, DateTime endDate) async {
    try {
      await _firestore.collection('places').doc(placeId).update({
        'isAvailable': false,
        'bookedBy': userId,
        'bookingDate': bookingDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      });
      fetchPlaces(); // Refresh data
    } catch (e) {
      Get.snackbar('Error', 'Gagal mem-booking tempat');
    }
  }

  // Cancel a booking
  void cancelBooking(String placeId) async {
    try {
      await _firestore.collection('places').doc(placeId).update({
        'isAvailable': true,
        'bookedBy': null,
        'bookingDate': null,
        'endDate': null,
      });
      fetchPlaces(); // Refresh data
    } catch (e) {
      Get.snackbar('Error', 'Gagal membatalkan booking');
    }
  }

  Future<void> sendBookingVerification(String placeId, DateTime startDate, DateTime endDate) async {
    try {
      isLoading.value = true;

      // Example of adding the verification request to Firestore (can be customized)
      CollectionReference verificationRequests = FirebaseFirestore.instance.collection('booking_verifications');

      await verificationRequests.add({
        'description': "Booking for Room A needs verification",
        'placeId': placeId,
        'startDate': startDate,
        'endDate': endDate,
        'status': 'pending', // You can later update this status based on staff review
        'createdAt': Timestamp.now(),
      });

      // Optionally, you can notify staff or send a push notification
      // Here you can integrate Firebase Cloud Messaging or any other notification system
      // FirebaseMessaging.instance.sendToStaff(...);

      Get.snackbar('Verifikasi Terkirim', 'Permintaan verifikasi booking telah dikirim kepada staff.',
          snackPosition: SnackPosition.BOTTOM);

    } catch (e) {
      print('Error sending booking verification: $e');
      Get.snackbar('Gagal', 'Terjadi kesalahan saat mengirim verifikasi booking.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
