import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AppBar"), //title aof appbar
        backgroundColor: Colors.redAccent, //background color of appbar
      ),
      body: const Center(
        child: Text("Hallo"),
      ),
    );
  }
}
