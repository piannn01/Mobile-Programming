import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:smartcampus/controllers/add_tool_controller.dart';
import '../controllers/tool_booking_controller.dart';
import '../models/tool_booking_model.dart';

class ItemBookingView extends StatelessWidget {
  final ItemController itemController = Get.put(ItemController());

  @override
  Widget build(BuildContext context) {
    // Memastikan data tempat dimuat setelah halaman dibuka
    itemController.fetchTools();

    return Scaffold(
      body: Obx(() {
        if (itemController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (itemController.tools.isEmpty) {
          return Center(child: Text('Tidak ada alat yang tersedia.'));
        } else {
          return ListView.builder(
            itemCount: itemController.tools.length,
            itemBuilder: (context, index) {
              ItemModel tool = itemController.tools[index];
              String? userId = FirebaseAuth.instance.currentUser?.uid;

              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(tool.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tool.description),
                      SizedBox(height: 5),
                      tool.isAvailable
                          ? Text(
                        'Alat tersedia',
                        style: TextStyle(color: Colors.green),
                      )
                          : tool.bookedBy == userId
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booked by You',
                            style: TextStyle(color: Colors.blue),
                          ),
                          Text(
                            'Tanggal Booking: ${tool.bookingDate?.toLocal().toString().split(' ')[0] ?? '-'}',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            'Tanggal Selesai: ${tool.endDate?.toLocal().toString().split(' ')[0] ?? '-'}',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      )
                          :  Text('Already Booked', style: TextStyle(color: Colors.red),),
                    ],
                  ),
                  trailing: tool.isAvailable
                      ? ElevatedButton(
                    onPressed: () {
                      _showBookingDialog(context, tool.id);
                    },
                    child: Text('Book'),
                  )
                      : tool.bookedBy == userId
                      ? ElevatedButton(
                    onPressed: () {
                      itemController.cancelBooking(tool.id);
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

  void _showBookingDialog(BuildContext context, String toolId) {
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
                  itemController.bookTools(
                    toolId,
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