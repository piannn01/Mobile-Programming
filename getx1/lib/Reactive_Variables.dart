import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReactiveController extends GetxController {
  var name = "User".obs;

  void changeName(String newName) {
    name.value = newName;
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
        appBar: AppBar(title: Text("Reactive variables Example")),
        body: ReactiveExample(),
      ),
    );
  }
}

class ReactiveExample extends StatelessWidget {
  final ReactiveController rc = Get.put(ReactiveController());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() => Text("Name: ${rc.name}")),
          TextField(
            onChanged: rc.changeName,
            decoration: InputDecoration(labelText: "Enter name"),
          ),
        ],
      ),
    );
  }
}