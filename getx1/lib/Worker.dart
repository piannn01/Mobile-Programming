import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controller untuk mendemonstrasikan penggunaan Workers
class WorkerController extends GetxController {
  // Variabel reaktif yang akan kita monitor
  var count = 0.obs;

  @override
  void onInit() {
    // memanggil worker setiap kali saat count berubah
    ever(count, (_) => print("ever: Count changed to $count"));

    //Memanggil worker hanya satu kali saat count berubah untuk pertama kalinya
    once(count, (_) => print("once: Count changed to $count"));

    //Memanggil worker setiap 2 detik, hanya jika ada perubahan pada count
    interval(count, (_) => print("interval: Count changed to $count"), time: Duration(seconds: 2));

    super.onInit();
  }

  //Fungsi untuk menambah nilai count
  void increment() {
    count++;
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Workers Example")),
        body: WorkerExample(),
      ),
    );
  }
}

class WorkerExample extends StatelessWidget {
  // Menginisialisasi Controller menggunakan GetX
  final WorkerController wc = Get.put(WorkerController());
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() => Text("Count: ${wc.count}", style: TextStyle(fontSize: 24))),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: wc.increment,
            child: Text("increment"),
          ),
        ],
      ),
    );
  }
}