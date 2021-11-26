import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sportify/src/models/step_model.dart';
import 'package:sportify/src/models/user_model.dart';
import 'package:provider/provider.dart';

class RankingList extends StatelessWidget {
  const RankingList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserModel myUser = context.watch<UserModel>();
    return FutureBuilder<Map<String, StepModel>>(
      future: getFriends(myUser.friends),
      builder: (BuildContext context,
          AsyncSnapshot<Map<String, StepModel>> snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          children = buildList(snapshot.data!);
        }
        else if(snapshot.hasError){
          children = <Widget>[
            Text(snapshot.error.toString())
          ];
        }
        else {
          children = <Widget>[

            const CircularProgressIndicator(),
          ];
        }
        return Column(
            children: children,
        );
      },
    );
  }

  List<Widget> buildList(Map<String, StepModel> steps) {
    List<Widget> tiles = [];
    steps.forEach((uid, steps) {
      tiles.add(Card(
        child: ListTile(
          title: Text(steps.getTodaySteps().toString()),
          subtitle: Text(uid),
        ),
      ));
    });
    return tiles;
  }

  Future<Map<String, StepModel>> getFriends(List<String> uids) async {
    var result = {for (String uid in uids) uid: await getSteps(uid)};
    return result;
  }

  Future<StepModel> getSteps(String uid) async {
    final CollectionReference steps =
    FirebaseFirestore.instance.collection('steps');
    StepModel stepModel = StepModel.fromJson(
        (await steps.doc(uid).get()).data() as Map<String, dynamic>);
    return stepModel;
  }
}