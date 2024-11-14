import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';

void main () {
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

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Avatar Glow"),
      ),
      body: Center(
        child: AvatarGlow(
          glowColor: Colors.blueAccent,
          duration: Duration(milliseconds: 500),
          child: Material(
            // Replace this child with your own
            elevation: 8.0,
            shape: CircleBorder(),
            child: CircleAvatar(
              backgroundColor: Colors.grey[100],
              backgroundImage: NetworkImage("https://picsum.photos/200"),
              radius: 75.0,
            ),
          ),
        ),
      ),
    );
  }
}