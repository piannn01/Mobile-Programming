import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../controllers/add_room_controller.dart';
import '../models/add_room_model.dart';

class PlaceView extends StatelessWidget {
  final PlaceController placeController = Get.put(PlaceController());

  @override
  Widget build(BuildContext context) {
    // Memastikan data tempat dimuat setelah halaman dibuka
    placeController.fetchPlaces();

    return Scaffold(
      appBar: AppBar(
        title: Text('Peminjaman Tempat'),
      ),
      body: Obx(() {
        if (placeController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (placeController.places.isEmpty) {
          return Center(child: Text('Tidak ada tempat yang tersedia.'));
        } else {
          return ListView.builder(
            itemCount: placeController.places.length,
            itemBuilder: (context, index) {
              PlaceModel place = placeController.places[index];
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
                      _buildStatusText(place, userId),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showEditPlaceDialog(context, place);
                      } else if (value == 'delete') {
                        _showDeleteConfirmationDialog(context, place.id);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Hapus'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPlaceDialog(context);
        },
        child: Icon(Icons.add),
        tooltip: 'Tambah Tempat',
      ),
    );
  }

  Widget _buildStatusText(PlaceModel place, String? userId) {
    if (place.isAvailable) {
      return Text(
        'Status: Tersedia',
        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      );
    } else if (place.bookedBy == userId) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status: Sudah Anda Pinjam',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          Text(
            'Tanggal Peminjaman: ${place.bookingDate?.toLocal().toString().split(' ')[0] ?? '-'}',
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            'Tanggal Selesai: ${place.endDate?.toLocal().toString().split(' ')[0] ?? '-'}',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      );
    } else {
      return Text(
        'Status: Sudah Dipinjam',
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      );
    }
  }

  void _showAddPlaceDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Tempat Baru'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nama Tempat'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Deskripsi'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty) {
                  placeController.addPlace(
                    nameController.text,
                    descriptionController.text,
                  );
                  Navigator.pop(context);
                }
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showEditPlaceDialog(BuildContext context, PlaceModel place) {
    final TextEditingController nameController =
    TextEditingController(text: place.name);
    final TextEditingController descriptionController =
    TextEditingController(text: place.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Tempat'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nama Tempat'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Deskripsi'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty) {
                  placeController.editPlace(
                    place.id,
                    nameController.text,
                    descriptionController.text,
                  );
                  Navigator.pop(context);
                }
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String placeId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hapus Tempat'),
          content: Text('Apakah Anda yakin ingin menghapus tempat ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                placeController.deletePlace(placeId);
                Navigator.pop(context);
              },
              child: Text('Hapus'),
        style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        ),
            ),
          ],
        );
      },
    );
  }
}