import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sportify/src/util/stepcounter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<Map<String, dynamic>> getSteps() async{
    String uid = await FirebaseAuth.instance.currentUser!.getIdToken();
    StepCounter mCounter = StepCounter(uid);
    return (await mCounter.savedSteps()) as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    getSteps();
    return Scaffold(
        appBar: AppBar(
          title: const Text("AppBar"), //title aof appbar
          backgroundColor: Colors.redAccent, //background color of appbar
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: getSteps(),
          builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.hasData) {
              return Text("Hello ${snapshot.data}");
            } else {
              return const CircularProgressIndicator();
            }
          },
        ));
  }
}
