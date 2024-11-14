import 'package:flutter/material.dart';
void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}
class HomePage extends StatefulWidget{
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController tabC = TabController(length: 4, vsync: this);

  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Whatsapp"),
        centerTitle: false,
        bottom: TabBar(
          controller: tabC,
          tabs: [
            Tab(
              icon: Icon(Icons.camera_alt),
            ),
            Tab(
              text: "Chat",
            ),
            Tab(
              text: "Status",
            ),
            Tab(
              text: "Call",
            ),
          ],
        ),
      ),
      body: TabBarView(
          controller: tabC,
          children: [
            Center(
              child: Text("Camera"),
            ),
            Center(
              child: Text("Chats"),
            ),
            Center(
              child: Text("Status"),
            ),
            Center(
              child: Text("Calls"),
            ),
          ]),
    );
  }
}