import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/facility_controller.dart';
import '../views/room_booking_view.dart';
import '../views/tool_booking_view.dart';
import '../views/report_view.dart';

class FacilityView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mengambil controller dari GetX
    final BottomNavController bottomNavController = Get.put(BottomNavController());

    // Daftar halaman untuk navigasi
    final List<Widget> _pages = <Widget>[
      RoomBookingView(),
      ItemBookingView(),
      ReportView(),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Peminjaman Fasilitas Kampus')),
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
            BottomNavigationBarItem(
              icon: Icon(Icons.report),
              label: 'Report System',
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