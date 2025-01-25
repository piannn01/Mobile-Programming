import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/facility_controller.dart';
import '../views/room_history_view.dart';
import '../views/tool_history_view.dart';

class HistoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mengambil controller dari GetX
    final BottomNavController bottomNavController = Get.put(BottomNavController());

    // Daftar halaman untuk navigasi
    final List<Widget> _pages = <Widget>[
      HistoryPlaceView(),
      HistoryToolView(),
    ];

    return Scaffold(
      body: Center(
        // Menampilkan halaman sesuai dengan selectedIndex yang sedang aktif
        child: Obx(() {
          return _pages.elementAt(bottomNavController.selectedIndex.value);
        }),
      ),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.meeting_room),
              label: 'Peminjaman Ruangan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.construction),
              label: 'Peminjaman Alat',
            ),
          ],
          currentIndex: bottomNavController.selectedIndex.value,
          selectedItemColor: Colors.blue,
          onTap: bottomNavController.changeIndex, // Mengganti index saat item di-tap
        );
      }),
    );
  }
}