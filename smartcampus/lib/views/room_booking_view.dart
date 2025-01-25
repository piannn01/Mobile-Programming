import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../controllers/room_booking_controller.dart';
import '../models/room_booking_model.dart';

class RoomBookingView extends StatelessWidget {
  final PlaceController placeController = Get.put(PlaceController());

  @override
  Widget build(BuildContext context) {
    // Memastikan data tempat dimuat setelah halaman dibuka
    placeController.fetchPlaces();

    return Scaffold(
      body: Obx(() {
        if (placeController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (placeController.places.isEmpty) {
          return Center(child: Text('Tidak ada tempat yang tersedia.'));
        } else {
          return ListView.builder(
            itemCount: placeController.places.length,
            itemBuilder: (context, index) {
              RoomModel place = placeController.places[index];
              String? userId = FirebaseAuth.instance.currentUser?.uid;

              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(place.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(place.description),
                      SizedBox(height: 5),
                      place.isAvailable
                          ? Text(
                        'Tempat tersedia',
                        style: TextStyle(color: Colors.green),
                      )
                          : place.bookedBy == userId
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booked by You',
                            style: TextStyle(color: Colors.blue),
                          ),
                          Text(
                            'Tanggal Booking: ${place.bookingDate?.toLocal().toString().split(' ')[0] ?? '-'}',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            'Tanggal Selesai: ${place.endDate?.toLocal().toString().split(' ')[0] ?? '-'}',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      )
                          :  Text('Already Booked', style: TextStyle(color: Colors.red),),
                    ],
                  ),
                  trailing: place.isAvailable
                      ? ElevatedButton(
                    onPressed: () {
                      _showBookingDialog(context, place.id);
                    },
                    child: Text('Book'),
                  )
                      : place.bookedBy == userId
                      ? ElevatedButton(
                    onPressed: () {
                      placeController.cancelBooking(place.id);
                    },
                    child: Text('Cancel Booking'),
                  )
                      : ElevatedButton(
                    onPressed: () {},
                    child: Text('Already Booked', style: TextStyle(color: Colors.red),),
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }

  void _showBookingDialog(BuildContext context, String placeId) {
    DateTime? selectedBookingDate;
    DateTime? selectedEndDate;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Booking Tempat'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () async {
                  selectedBookingDate = await _selectDate(context);
                  if (selectedBookingDate != null) {
                    print('Tanggal booking: ${selectedBookingDate.toString()}');
                  }
                },
                child: Text(
                  selectedBookingDate == null
                      ? 'Pilih Tanggal Booking'
                      : 'Booking Date: ${selectedBookingDate?.toLocal().toString().split(' ')[0]}',
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (selectedBookingDate != null) {
                    selectedEndDate = await _selectDate(context);
                    if (selectedEndDate != null && selectedEndDate!.isAfter(selectedBookingDate!)) {
                      print('Tanggal selesai booking: ${selectedEndDate.toString()}');
                    }
                  }
                },
                child: Text(
                  selectedEndDate == null
                      ? 'Pilih Tanggal Selesai'
                      : 'End Date: ${selectedEndDate?.toLocal().toString().split(' ')[0]}',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (selectedBookingDate != null && selectedEndDate != null) {
                  final userId = FirebaseAuth.instance.currentUser?.uid ?? 'UnknownUser'; // Mendapatkan ID pengguna yang sedang login
                  placeController.bookPlace(
                    placeId,
                    userId,
                    selectedBookingDate!,
                    selectedEndDate!,
                  );
                  Navigator.pop(context);
                }
              },
              child: Text('Book'),
            ),
          ],
        );
      },
    );
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    DateTime today = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: DateTime(today.year + 1),
    );
    return pickedDate;
  }
}
