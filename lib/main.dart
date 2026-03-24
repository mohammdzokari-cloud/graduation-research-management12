import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("title"), backgroundColor: Colors.blue),
        backgroundColor: const Color.fromARGB(18, 37, 100, 235),
        body: Container(
          child: Text(
            "Mohammed Hassan ",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 40.2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
