import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../views/detail_page_dosen.dart'; // Import halaman detail

class TugasDosenView extends StatelessWidget {
  final List<Color> cardColors = [
    Colors.orangeAccent,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.redAccent,
    Colors.tealAccent,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tugas Dosen'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tugas').orderBy('createdAt').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan'));
          }

          final tugasDocs = snapshot.data?.docs ?? [];

          if (tugasDocs.isEmpty) {
            return Center(child: Text('Belum ada tugas yang ditambahkan.'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: tugasDocs.length,
            itemBuilder: (context, index) {
              final tugas = tugasDocs[index];
              final color = cardColors[index % cardColors.length];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        mataKuliah: tugas['mataKuliah'] ?? 'Tidak diketahui',
                        kelas: tugas['kelas'] ?? 'Tidak diketahui',
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                  color: color,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    title: Text(
                      tugas['mataKuliah'] ?? 'Tidak diketahui',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    subtitle: Text(
                      'Kelas: ${tugas['kelas'] ?? 'Tidak diketahui'}',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddClassDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showAddClassDialog(BuildContext context) {
    final TextEditingController mataKuliahController = TextEditingController();
    final TextEditingController kelasController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Kelas Baru'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: mataKuliahController,
                decoration: InputDecoration(labelText: 'Mata Kuliah'),
              ),
              TextField(
                controller: kelasController,
                decoration: InputDecoration(labelText: 'Kelas'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final mataKuliah = mataKuliahController.text.trim();
                final kelas = kelasController.text.trim();

                if (mataKuliah.isNotEmpty && kelas.isNotEmpty) {
                  await FirebaseFirestore.instance.collection('tugas').add({
                    'mataKuliah': mataKuliah,
                    'kelas': kelas,
                    'createdAt': Timestamp.now(),
                  });
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
}
