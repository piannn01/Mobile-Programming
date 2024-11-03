import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as myhttp;

void main() {
  runApp(const MyApp());
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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String data = "belum ada data";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HTTP DELETE"),
        actions: [
          IconButton(
            onPressed: () async {
              var response = await myhttp.get(
                  Uri.parse("https://regres.in/api/users/2"));
              Map<String, dynamic> mybody = json.decode(response.body);
              print(mybody);
              setState(() {
                data =
                "Akun : ${mybody['data']['first_name']} ${mybody['data']['last_name']}";
              });
            },
            icon: Icon(Icons.get_app),
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Text(data),
          SizedBox(height: 35),
          ElevatedButton(
            onPressed: () async {
              var response = await myhttp.delete(
                  Uri.parse("https//regres.in/api/users/2"));
              if (response.statusCode == 204) {
                setState(() {
                  data = "Berhasil menghapus data";
                });
              }
            },
            child: Text("DELETE"),
          ),
        ],
      ),
    );
  }
}