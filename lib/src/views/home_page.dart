import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportify/src/models/user_model.dart';
import 'package:sportify/src/util/stepcounter.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<DocumentSnapshot> getSteps() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    StepCounter mCounter = StepCounter(uid);
    return mCounter.savedSteps();
  }

  @override
  Widget build(BuildContext context) {
    getSteps();
    return Scaffold(
        appBar: AppBar(
          title: const Text("AppBar"), //title aof appbar
          backgroundColor: Colors.redAccent, //background color of appbar
        ),
        body: Center(
          child: FutureBuilder<DocumentSnapshot>(
            future: getSteps(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("Something went wrong");
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return const Text("Document does not exist");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                UserModel user = UserModel.fromJson(
                    snapshot.data!.data() as Map<String, dynamic>);
                return Text("Steps: ${user.getTodaySteps()}");
              }

              return const CircularProgressIndicator();
            },
          ),
        ));
  }
}
