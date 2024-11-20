import 'package:flutter/material.dart';
import 'schedule_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeContent(),
    SchedulePage(),
    NotificationsPage(),
    SearchPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E7FF), // Warna background sesuai tema biru lembut
      appBar: _currentIndex == 1 // Cek jika halaman SchedulePage aktif
          ? PreferredSize(
        preferredSize: Size.fromHeight(0), // Tinggi AppBar 0
        child: SizedBox.shrink(), // Widget kosong
      )
          : AppBar(
        backgroundColor: const Color(0xFFE0E7FF), // Warna background sesuai tema biru lembut
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Sidebar menu clicked!")),
            );
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
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}

// Konten untuk Tab Home
class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            "Halo, Viannn!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            "Semoga harimu menyenangkan!\nHIMASI??? NGGEH!!!",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Mengatur posisi ke kiri
            children: [
              Wrap(
                spacing: 10, // Jarak horizontal antar Chip
                runSpacing: 10, // Jarak vertikal jika Chip berpindah baris
                children: [
                  ActionChip(
                    label: Text("Tugasku ↓"),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Tugasku clicked!")),
                      );
                    },
                  ),
                  ActionChip(
                    label: Text("Projek"),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Projek clicked!")),
                      );
                    },
                  ),
                  ActionChip(
                    label: Text("Catatan"),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Catatan clicked!")),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 20),

          // Geser Cards
          SizedBox(
            height: 250, // Tinggi untuk menampilkan kartu sepenuhnya
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.6), // Tampilan sebagian kartu berikutnya
              itemCount: 3,
              itemBuilder: (context, index) {
                final cardData = [
                  {
                    "title": "Mobile Programming",
                    "subtitle": "UTS",
                    "clock": "10.00",
                    "date": "17 Oktober 2024",
                    "color": Colors.blueAccent,
                    "icon": Icons.code,
                  },
                  {
                    "title": "Pulau Dewata",
                    "subtitle": "Jalan-jalan",
                    "clock": "06.00",
                    "date": "24 Oktober 2024",
                    "color": Colors.yellow,
                    "icon": Icons.beach_access,
                  },
                  {
                    "title": "Kerja Kelompok",
                    "subtitle": "Progress",
                    "clock": "08.00",
                    "date": "7 hari yang lalu",
                    "color": Colors.red,
                    "icon": Icons.group,
                  },
                ];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _buildCard(
                    title: cardData[index]["title"] as String,
                    subtitle: cardData[index]["subtitle"] as String,
                    clock: cardData[index]["clock"] as String,
                    date: cardData[index]["date"] as String,
                    color: cardData[index]["color"] as Color,
                    icon: cardData[index]["icon"] as IconData,
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 20),
          Text(
            "Progress",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: Icon(Icons.task_rounded, color: Colors.green),
              title: Text("UTS Studi Islam"),
              subtitle: Text("2 hari yang lalu"),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Selected: $value")),
                  );
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(value: "Edit", child: Text("Edit")),
                  PopupMenuItem(value: "Delete", child: Text("Delete")),
                ],
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.close, color: Colors.red),
              title: Text("Checkout 11.11"),
              subtitle: Text("6 hari yang lalu"),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Selected: $value")),
                  );
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(value: "Edit", child: Text("Edit")),
                  PopupMenuItem(value: "Delete", child: Text("Delete")),
                ],
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.close, color: Colors.red),
              title: Text("Kerja Kelompok"),
              subtitle: Text("3 hari yang lalu"),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Selected: $value")),
                  );
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(value: "Edit", child: Text("Edit")),
                  PopupMenuItem(value: "Delete", child: Text("Delete")),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildCard({
  required String title,
  required String subtitle,
  required String clock,
  required String date,
  required Color color,
  required IconData icon,
}) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    elevation: 4, // Tambahkan shadow untuk efek 3D
    color: color,
    margin: EdgeInsets.symmetric(horizontal: 10),
    child: Container(
      width: 50, // Lebar tetap
      height: 100, // Tinggi lebih panjang
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 40, color: Colors.white),
          SizedBox(height: 10),
          Text(
            subtitle,
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            clock,
            style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Text(
            date,
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    ),
  );
}

// Konten untuk Tab Notifikasi
class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Halaman Notifikasi", style: TextStyle(fontSize: 18)),
    );
  }
}

// Konten untuk Tab Pencarian
class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Halaman Pencarian", style: TextStyle(fontSize: 18)),
    );
  }
}
