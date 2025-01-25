import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../controllers/add_tool_controller.dart';
import '../models/add_tool_model.dart';

class ToolView extends StatelessWidget {
  final ToolController toolController = Get.put(ToolController());

  @override
  Widget build(BuildContext context) {
    // Memastikan data alat dimuat setelah halaman dibuka
    toolController.fetchTools();

    return Scaffold(
      appBar: AppBar(
        title: Text('Peminjaman Alat'),
        actions: [
        ],
      ),
      body: Obx(() {
        if (toolController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (toolController.tools.isEmpty) {
          return Center(child: Text('Tidak ada alat yang tersedia.'));
        } else {
          return ListView.builder(
            itemCount: toolController.tools.length,
            itemBuilder: (context, index) {
              ToolModel tool = toolController.tools[index];
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
                      _buildStatusText(tool, userId),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showEditToolDialog(context, tool);
                      } else if (value == 'delete') {
                        _showDeleteConfirmationDialog(context, tool.id);
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
          _showAddToolDialog(context);
        },
        child: Icon(Icons.add),
        tooltip: 'Tambah Alat',
      ),
    );
  }

  // Fungsi untuk menampilkan status alat
  Widget _buildStatusText(ToolModel tool, String? userId) {
    if (tool.isAvailable) {
      return Text(
        'Status: Tersedia',
        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      );
    } else if (tool.bookedBy == userId) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status: Sudah Anda Pinjam',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          Text(
            'Tanggal Peminjaman: ${tool.bookingDate?.toLocal().toString().split(' ')[0] ?? '-'}',
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            'Tanggal Selesai: ${tool.endDate?.toLocal().toString().split(' ')[0] ?? '-'}',
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

  // Fungsi untuk menampilkan dialog tambah alat
  void _showAddToolDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Alat Baru'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nama Alat'),
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
                  toolController.addTool(
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

  // Fungsi untuk menampilkan dialog edit alat
  void _showEditToolDialog(BuildContext context, ToolModel tool) {
    final TextEditingController nameController = TextEditingController(text: tool.name);
    final TextEditingController descriptionController = TextEditingController(text: tool.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Alat'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nama Alat'),
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
                  toolController.editTool(
                    tool.id,
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

  // Fungsi untuk menampilkan dialog konfirmasi hapus alat
  void _showDeleteConfirmationDialog(BuildContext context, String toolId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hapus Alat'),
          content: Text('Apakah Anda yakin ingin menghapus alat ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                toolController.deleteTool(toolId);
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