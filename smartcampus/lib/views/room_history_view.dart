import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/room_history_controller.dart';
import '../models/add_room_model.dart';

class HistoryPlaceView extends StatelessWidget {
  final HistoryPlaceController historyPlaceController = Get.put(HistoryPlaceController());

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    // Memastikan history peminjaman tempat dimuat setelah halaman dibuka
    if (userId != null) {
      historyPlaceController.fetchBorrowedPlaces(userId);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('History Peminjaman Tempat'),
      ),
      body: Obx(() {
        if (historyPlaceController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (historyPlaceController.borrowedPlaces.isEmpty) {
          return Center(child: Text('Tidak ada tempat yang pernah dipinjam.'));
        } else {
          return ListView.builder(
            itemCount: historyPlaceController.borrowedPlaces.length,
            itemBuilder: (context, index) {
              PlaceModel place = historyPlaceController.borrowedPlaces[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(place.name),
                  subtitle: Text('Tanggal Peminjaman: ${place.bookingDate?.toLocal().toString().split(' ')[0] ?? '-'}'),
                  trailing: Icon(
                    Icons.history,
                    color: Colors.blue,
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