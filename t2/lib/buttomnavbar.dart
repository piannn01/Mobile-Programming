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
class _HomePageState extends State<HomePage> {
  late int index;
  List showWidget =[
    Center(
      child: Text("Home"),
    ),
    Center(
      child: Text("Cart"),
    ),
    Center(
      child: Text("Profile"),
    ),
  ];

  void initState(){
    index = 0;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Bottom Navigation Bar"),
        ),
        body: showWidget[index],
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.blue,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.black26,
            currentIndex: index,
            onTap: (value){
              setState(() {
                index = value;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: "cart",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "profile",
              ),
            ])
    );
  }
}