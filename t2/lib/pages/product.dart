import 'package:flutter/material.dart';
import './profile.dart';
class ProductPage extends StatelessWidget {
  const ProductPage({Key? key}): super(key: key);
  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        title: Text("PAGE PRODUCT"),
      ),
      body: Center(
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("INI HALAMAN PRODUCT"),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); },
                  child: Text("<<< BACK"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(), ),
                    );
                  },
                  child: Text("NEXT PAGE >>>"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}