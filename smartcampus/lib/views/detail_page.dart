import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailPage extends StatefulWidget {
  final String mataKuliah;
  final String kelas;

  DetailPage({required this.mataKuliah, required this.kelas});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _selectedIndex = 0; // Untuk mengatur tab yang aktif

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          // Header
          Stack(
            children: [
              Container(
                height: 200,
                color: Colors.blueAccent,
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      child: Text(
                        widget.mataKuliah.substring(0, 1).toUpperCase(),
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.mataKuliah,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Kelas: ${widget.kelas}',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: _selectedIndex == 0
                ? _buildStreamContent()
                : _selectedIndex == 1
                ? _buildClassworkContent()
                : _buildPeopleContent(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Stream'),
          BottomNavigationBarItem(icon: Icon(Icons.work_outline), label: 'Classwork'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'People'),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      /*floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
        onPressed: () {
          // Add your upload task logic here if needed
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.upload_file),
      )
          : null,*/  // FAB will only be visible on the "Classwork" tab
    );
  }

  // Menampilkan Materials di Stream
  Widget _buildStreamContent() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('materials')
          .where('mataKuliah', isEqualTo: widget.mataKuliah)
          .where('kelas', isEqualTo: widget.kelas)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Terjadi kesalahan.'));
        }

        final materials = snapshot.data?.docs ?? [];
        if (materials.isEmpty) {
          return Center(child: Text('Belum ada materi.'));
        }

        return ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: materials.length,
          itemBuilder: (context, index) {
            final material = materials[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: Icon(Icons.description_outlined, color: Colors.blueAccent),
                title: Text(material['namaMateri'] ?? 'Tidak diketahui'),
                subtitle: Text(material['deskripsi'] ?? 'Tidak ada deskripsi'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MaterialDetailPage(
                        namaMateri: material['namaMateri'],
                        deskripsi: material['deskripsi'],
                        fileUrl: material['fileUrl'],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  // Menampilkan Assignments di Classwork
  Widget _buildClassworkContent() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('assignments')
          .where('mataKuliah', isEqualTo: widget.mataKuliah)
          .where('kelas', isEqualTo: widget.kelas)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Terjadi kesalahan.'));
        }

        final assignments = snapshot.data?.docs ?? [];
        if (assignments.isEmpty) {
          return Center(child: Text('Belum ada tugas.'));
        }

        return ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: assignments.length,
          itemBuilder: (context, index) {
            final assignment = assignments[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: Icon(Icons.assignment_outlined, color: Colors.blueAccent),
                title: Text(assignment['namaTugas'] ?? 'Tidak diketahui'),
                subtitle: Text(assignment['deskripsi'] ?? 'Tidak ada deskripsi'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AssignmentDetailPage(
                        namaTugas: assignment['namaTugas'],
                        deskripsi: assignment['deskripsi'],
                        deadline: (assignment['deadline'] as Timestamp).toDate(),
                        fileUrl: assignment['fileUrl'],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  // Konten tab People
  Widget _buildPeopleContent() {
    return Center(
      child: Text(
        'People Content',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

class MaterialDetailPage extends StatelessWidget {
  final String namaMateri;
  final String deskripsi;
  final String? fileUrl;

  MaterialDetailPage({
    required this.namaMateri,
    required this.deskripsi,
    this.fileUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Materi'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.description_outlined, size: 32, color: Colors.blueAccent),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          namaMateri,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Konten Detail
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSectionTitle('Deskripsi'),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      deskripsi.isNotEmpty ? deskripsi : 'Tidak ada deskripsi.',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                  SizedBox(height: 16),
                  if (fileUrl != null && fileUrl!.isNotEmpty) ...[
                    _buildSectionTitle('File Materi'),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          // Tambahkan logika untuk membuka URL file
                        },
                        child: Text(
                          fileUrl!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueAccent,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blueAccent,
      ),
    );
  }
}

class AssignmentDetailPage extends StatelessWidget {
  final String namaTugas;
  final String deskripsi;
  final DateTime deadline;
  final String? fileUrl;

  AssignmentDetailPage({
    required this.namaTugas,
    required this.deskripsi,
    required this.deadline,
    this.fileUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Tugas'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.assignment_outlined, size: 32, color: Colors.blueAccent),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          namaTugas,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Deadline: ${_formatDate(deadline)}',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Konten Detail
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSectionTitle('Deskripsi'),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      deskripsi.isNotEmpty ? deskripsi : 'Tidak ada deskripsi.',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                  SizedBox(height: 16),
                  if (fileUrl != null && fileUrl!.isNotEmpty) ...[
                    _buildSectionTitle('File Tugas'),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          // Tambahkan logika untuk membuka URL file
                        },
                        child: Text(
                          fileUrl!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueAccent,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Transform.translate(
        offset: Offset(-10, -150), // Move FAB slightly up
        child: FloatingActionButton(
          onPressed: () {
            // Implement upload or any other action for the assignment here
          },
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.upload_file),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blueAccent,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}, ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
