import 'dart:collection';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sportify/src/models/step_model.dart';
import 'package:sportify/src/models/user_model.dart';
import 'package:provider/provider.dart';

class RankingList extends StatelessWidget {
  const RankingList({Key? key, required this.changeTabCallback})
      : super(key: key);
  final void Function(int) changeTabCallback;

  @override
  Widget build(BuildContext context) {
    final UserModel myUser = context.watch<UserModel>();
    return StreamBuilder<Map<String, dynamic>>(
      stream: getFriendsStream(myUser.friends),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            children = <Widget>[
              Center(
                child: ElevatedButton(
                  onPressed: () => changeTabCallback(1),
                  child: const Text('Find Friends'),
                ),
              ),
            ];
          } else {
            children = <Widget>[
              Expanded(
                child: ListView(children: buildList(snapshot.data!)),
              ),
            ];
          }
        } else if (snapshot.hasError) {
          children = <Widget>[Text(snapshot.error.toString())];
        } else {
          children = <Widget>[
            const CircularProgressIndicator(),
          ];
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        );
      },
    );
  }

  List<Widget> buildList(Map<String, dynamic> data) {
    List<Widget> tiles = [];
    Map<String, StepModel> steps = data["steps"] as Map<String, StepModel>;
    Map<String, String> pics = data["pics"] as Map<String, String>;

    LinkedHashMap<dynamic, dynamic> sortedSteps = sortSteps(steps);

    sortedSteps.forEach((uid, steps) {
      String ?pic = pics[uid];
      tiles.add(Card(
        child: ListTile(
          trailing: CircleAvatar(
            backgroundImage: MemoryImage(base64Decode(pic ?? "")),
          ),
          title: Text("${steps.getTodaySteps()} Steps today"),
          subtitle: Text(steps.username),
        ),
      ));
    });
    return tiles;
  }

  LinkedHashMap<dynamic, dynamic> sortSteps(Map<String, StepModel> steps) {
    var sortedKeys = steps.keys.toList(growable: false)
      ..sort((k1, k2) =>
          steps[k1]!.getTodaySteps().compareTo(steps[k2]!.getTodaySteps()));
    LinkedHashMap sortedSteps = LinkedHashMap.fromIterable(sortedKeys.reversed,
        key: (k) => k, value: (k) => steps[k]);
    return sortedSteps;
  }

  Stream<Map<String, dynamic>> getFriendsStream(List<String> uids) async* {
    while (true) {
      final steps = {for (String uid in uids) uid: await getSteps(uid)};
      final pics = {for (String uid in uids) uid: await getPic(uid)};
      yield {"steps": steps, "pics": pics};
      await Future.delayed(const Duration(seconds: 15));
    }
  }

  Future<String> getPic(String uid) async {
    final users = FirebaseFirestore.instance.collection("users");
    final user = await users.doc(uid).get();
    final pic = user.get("pic");
    return pic;
  }

  Future<StepModel> getSteps(String uid) async {
    final steps = FirebaseFirestore.instance.collection('steps');

    StepModel stepModel = StepModel.fromJson(
        (await steps.doc(uid).get()).data() as Map<String, dynamic>);
    return stepModel;
  }
}
