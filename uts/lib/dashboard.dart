import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E9F5), // Warna latar
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6E9F5),
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.account_circle, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Halo, Vian!",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4.0),
              const Text(
                "Semoga harimu menyenangkan!",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  // Panggil buildTabButton dengan showArrow: true untuk "Tugasku"
                  buildTabButton("Tugasku", true, showArrow: true),
                  const SizedBox(width: 8.0),
                  buildTabButton("Projek", false),
                  const SizedBox(width: 8.0),
                  buildTabButton("Catatan", false),
                ],
              ),
              const SizedBox(height: 16.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    buildTaskCard(
                      title: "Mobile Programming",
                      time: "10.00",
                      date: "17 Oktober 2024",
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 12.0),
                    buildTaskCard(
                      title: "Pulau Dewata",
                      time: "06.00",
                      date: "24 Oktober 2024",
                      color: Colors.purple,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),
              const Text(
                "Progress",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  buildProgressItem(
                    icon: Icons.check_circle,
                    iconColor: Colors.green,
                    title: "UTS Studi Islam",
                    time: "2 hari yang lalu",
                  ),
                  buildProgressItem(
                    icon: Icons.cancel,
                    iconColor: Colors.red,
                    title: "Checkout 11.11",
                    time: "6 hari yang lalu",
                  ),
                  buildProgressItem(
                    icon: Icons.cancel,
                    iconColor: Colors.red,
                    title: "Kerja Kelompok",
                    time: "7 hari yang lalu",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget buildTabButton(String title, bool isSelected, {bool showArrow = false}) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.white : Colors.transparent,
        foregroundColor: isSelected ? Colors.black : Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: isSelected ? 2.0 : 0.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title),
          if (showArrow) ...[
            const SizedBox(width: 4.0),
            const Icon(Icons.arrow_drop_down, size: 20.0),
          ],
        ],
      ),
    );
  }

  Widget buildTaskCard({
    required String title,
    required String time,
    required String date,
    required Color color,
  }) {
    return Container(
      width: 150.0,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.calendar_today, color: Colors.white),
          const SizedBox(height: 16.0),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            time,
            style: const TextStyle(color: Colors.white, fontSize: 14.0),
          ),
          const SizedBox(height: 8.0),
          Text(
            date,
            style: const TextStyle(color: Colors.white, fontSize: 12.0),
          ),
        ],
      ),
    );
  }

  Widget buildProgressItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  time,
                  style: const TextStyle(color: Colors.grey, fontSize: 12.0),
                ),
              ],
            ),
          ),
          const Icon(Icons.more_vert, color: Colors.grey),
        ],
      ),
    );
  }
}
