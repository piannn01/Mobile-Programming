import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("GetX State Manager")),
        body: CounterPage(),
      ),
    );
  }
}

// Controller untuk mengelola state counter
class CounterController extends GetxController {
  // Variabel reaktif
  var counter = 0.obs;

  // Fungsi untuk menambah counter
  void increment() {
    counter++;
  }
}

// Halaman utama yang menampilkan dan mengontrol counter
class CounterPage extends StatelessWidget {
  // Inisialisasi CounterController dengan Get.put()
  final CounterController counterController = Get.put(CounterController());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Press the button to increase the counter:",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          // Gunakan Obx untuk mengamati perubahan counter
          Obx(() => Text(
            "${counterController.counter}",
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          )),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: counterController.increment,
            child: Text("Increment"),
          ),
        ],
      ),
    );
  }
}