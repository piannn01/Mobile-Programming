import 'package:flutter/material.dart';
import 'package:utsmobpro/pages/create_schedule.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  String _selectedDay = '17'; // Simpan tanggal yang dipilih

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E7FF), // Warna background sesuai tema biru lembut
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0E7FF), // Warna background sesuai tema biru lembut
        title: Text("List Jadwal"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Profile clicked!")),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Header
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nov, 2024',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateSchedule(),
                      ),
                    );
                  },
                  icon: Icon(Icons.add),
                  label: Text("Tugas"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white, // Warna teks diubah menjadi putih
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          // Baris tanggal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDateItem('17', 'Min'),
              _buildDateItem('18', 'Sen'),
              _buildDateItem('19', 'Sel'),
              _buildDateItem('20', 'Rab'),
            ],
          ),
          SizedBox(height: 8), // Spasi antar elemen lebih kecil
          // Daftar Tugas
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daftar Tugas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        children: [
                          _buildTaskCard(
                              'UTS Mobile Programming', '10:00 - 14:00'),
                          SizedBox(height: 8),
                          _buildTaskCard('Ngerjakan Tugas', '18:00'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateItem(String day, String weekday) {
    final bool isSelected = _selectedDay == day;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDay = day;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15), // Spasi proporsional
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Column(
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 4),
            Text(
              weekday,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(String title, String time) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 2,
      child: ListTile(
        leading: Icon(Icons.assignment, color: Colors.purple),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        subtitle: Text(time),
        trailing: Icon(Icons.more_vert, color: Colors.black),
      ),
    );
  }
}
