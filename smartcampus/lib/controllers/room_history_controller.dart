import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/add_room_model.dart';

class HistoryPlaceController extends GetxController {
  var borrowedPlaces = <PlaceModel>[].obs;
  var isLoading = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch history of borrowed places
  void fetchBorrowedPlaces(String userId) async {
    isLoading.value = true;
    try {
      final snapshot = await _firestore
          .collection('places')
          .where('bookedBy', isEqualTo: userId)
          .get();
      borrowedPlaces.assignAll(
        snapshot.docs.map((doc) => PlaceModel.fromMap(doc.id, doc.data())).toList(),
      );
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat history peminjaman tempat');
    } finally {
      isLoading.value = false;
    }
  }
}