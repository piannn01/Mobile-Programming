import 'package:flutter/material.dart';
import 'package:get/get.dart';

//Controller for GetX example
class CounterController extends GetxController {
  var counter = 0.obs;

  void increment() {
    counter++;
  }
}

//Main application
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("State Management Example")),
        body: Column(
          children: [
            StatelessExample(),
            StatefulExample(),
            GetXExample(),
          ],
        ),
      ),
    );
  }
}

//  Stateless Widget Example
class StatelessExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Hello from Stateless Widget!"),
    );
  }
}

class StatefulExample extends StatefulWidget {
  @override
  State<StatefulExample> createState() => _StatefulExampleState();
}

class _StatefulExampleState extends State<StatefulExample> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Counter: $counter'),
        ElevatedButton(
          onPressed: () {
            setState(() {
              counter++;
            });
          },
          child: Text("Increment Stateful"),
        ),
      ],
    );
  }
}

//GetX State management Example
class GetXExample extends StatelessWidget {
  final CounterController c = Get.put(CounterController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => Text('Counter: ${c.counter}')),
        ElevatedButton(
          onPressed: c.increment,
          child: Text("Increment with GetX"),
        ),
      ],
    );
  }
}