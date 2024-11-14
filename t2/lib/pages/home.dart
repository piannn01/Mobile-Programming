import 'package:flutter/material.dart';

import './product.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PAGE HOME"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductPage(),
              ),
            );
          }, child: Text("NEXT PAGE >>>"),
        ),
      ),
    );
  }
}