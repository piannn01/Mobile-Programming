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

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bottom Sheet"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isDismissible: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  builder: (context) => SizedBox(
                    height: 300,
                    child: ListView(
                      children: [
                        ListTile(
                          onTap: () => print("KLIK PHOTO"),
                          leading: Icon(Icons.photo),
                          title: Text("Photo"),
                        ),
                        ListTile(
                          onTap: () => print("KLIK MUSIC"),
                          leading: Icon(Icons.music_note_rounded),
                          title: Text("Music"),
                        ),
                        ListTile(
                          onTap: () => print("KLIK VIDEO"),
                          leading: Icon(Icons.video_collection),
                          title: Text("Video"),
                        ),
                        ListTile(
                          onTap: () => print("KLIK SHARE"),
                          leading: Icon(Icons.share),
                          title: Text("Share"),
                        ),
                        ListTile(
                          onTap: () => Navigator.pop(context),
                          leading: Icon(Icons.cancel),
                          title: Text("Cancel"),
                        ),
                      ],
                    ),
                  ),);
              },
              child: Text("SHOW BOTTOM SHEET")),
        ),
      ),
    );
  }
}