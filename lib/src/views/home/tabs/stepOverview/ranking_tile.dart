import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sportify/src/models/step_model.dart';
import 'package:sportify/src/models/user_model.dart';

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
        trailing: getPic(),
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

  Stream<String> getPicStream() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uid)
        .snapshots()
        .map((data) {
      final user = UserModel.fromJson(data.data()!);
      return user.pic;
    });
  }

  Widget getPic() {
    return StreamBuilder<String>(
        stream: getPicStream(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasError) {
            return CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: MemoryImage(base64Decode(widget.pic)));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: MemoryImage(base64Decode(widget.pic)));
          } else {
            final newPic = snapshot.data!;
            return CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: MemoryImage(base64Decode(newPic)));
          }
        });
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
