import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/add_room_model.dart';

class PlaceController extends GetxController {
  final places = <PlaceModel>[].obs;
  final isLoading = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch places from Firebase
  void fetchPlaces() async {
    isLoading.value = true;
    try {
      final snapshot = await _firestore.collection('places').get();
      places.assignAll(
        snapshot.docs.map((doc) => PlaceModel.fromMap(doc.id, doc.data())).toList(),
      );
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data tempat');
    } finally {
      isLoading.value = false;
    }
  }

  // Update booking status in Firebase
  void togglePlaceAvailability(String placeId) async {
    try {
      PlaceModel place = places.firstWhere((p) => p.id == placeId);
      await _firestore.collection('places').doc(placeId).update({
        'isAvailable': !place.isAvailable,
      });
      fetchPlaces(); // Refresh data
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengubah status tempat');
    }
  }

  // Book a place
  void bookPlace(String placeId, String userId, DateTime startDate, DateTime endDate) async {
    try {
      await _firestore.collection('places').doc(placeId).update({
        'isAvailable': false,
        'bookedBy': userId,
        'bookingDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      });

      fetchPlaces(); // Refresh data
      Get.snackbar('Sukses', 'Tempat berhasil dipesan!');
    } catch (e) {
      Get.snackbar('Error', 'Gagal memesan tempat: $e');
    }
  }

  // Add a new place to Firebase
  void addPlace(String name, String description) async {
    try {
      final docRef = await _firestore.collection('places').add({
        'name': name,
        'description': description,
        'isAvailable': true, // Default to available
        'bookedBy': null, // No user initially
        'bookingDate': null,
        'endDate': null,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Optional: Add the newly created place to the local list
      places.add(
        PlaceModel(
          id: docRef.id,
          name: name,
          description: description,
          isAvailable: true,
        ),
      );

      Get.snackbar('Sukses', 'Tempat berhasil ditambahkan!');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan tempat: $e');
    }
  }

  // Edit an existing place
  void editPlace(String placeId, String name, String description) async {
    try {
      await _firestore.collection('places').doc(placeId).update({
        'name': name,
        'description': description,
      });

      // Update local data
      int index = places.indexWhere((place) => place.id == placeId);
      if (index != -1) {
        places[index] = places[index].copyWith(name: name, description: description);
      }

      Get.snackbar('Sukses', 'Tempat berhasil diperbarui!');
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui tempat: $e');
    }
  }

  // Delete a place
  void deletePlace(String placeId) async {
    try {
      await _firestore.collection('places').doc(placeId).delete();

      // Remove from local list
      places.removeWhere((place) => place.id == placeId);

      Get.snackbar('Sukses', 'Tempat berhasil dihapus!');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus tempat: $e');
    }
  }
}

