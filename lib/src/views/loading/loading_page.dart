import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sportify/src/models/step_model.dart';
import 'package:sportify/src/views/home/home_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<BuildContext> _setup(BuildContext context) async {
    DocumentSnapshot stepsSnap =
        await FirebaseFirestore.instance.collection('steps').doc(uid).get();
    StepModel stepModel =
        StepModel.fromJson(stepsSnap.data() as Map<String, dynamic>);
    context.read<StepModel>().setStepModel(stepModel);
    return context;
  }

  @override
  Widget build(BuildContext context) {
    _setup(context).then((context) => Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => const HomePage())));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sportiy"),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
