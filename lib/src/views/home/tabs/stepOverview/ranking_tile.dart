import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sportify/src/models/step_model.dart';

class RankingTile extends StatefulWidget {
  final String uid;
  final String pic;
  final String name;

  const RankingTile(
      {Key? key, required this.uid, required this.name, required this.pic})
      : super(key: key);

  @override
  _RankingTileState createState() => _RankingTileState();
}

class _RankingTileState extends State<RankingTile> {
  late StepModel steps;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        trailing: CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: MemoryImage(base64Decode(widget.pic)),
        ),
        title: getStepMonitor(),
        subtitle: Text(widget.name),
      ),
    );
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getStepsStream() {
    return FirebaseFirestore.instance
        .collection("steps")
        .doc(widget.uid)
        .snapshots();
  }

  Widget getStepMonitor() {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: getStepsStream(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          } else {
            final data = snapshot.data!.data();
            final steps = StepModel.fromJson(data!);
            return Text("${steps.getTodaySteps()} Steps today");
          }
        });
  }
}
