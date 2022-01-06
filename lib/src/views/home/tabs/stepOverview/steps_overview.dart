import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportify/src/models/step_model.dart';
import 'package:sportify/src/views/home/tabs/stepOverview/ranking_list.dart';
import 'package:sportify/src/views/home/tabs/stepOverview/step_box.dart';

class StepOverviewPage extends StatelessWidget {
  const StepOverviewPage({Key? key, required this.changeTabCallback})
      : super(key: key);
  final void Function(int) changeTabCallback;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sportify"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const StepBox(),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi ${context.read<StepModel>().username}!",
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      Text("Catch up with your friends", style: Theme.of(context).textTheme.headline4,)
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: RankingList(
                changeTabCallback: changeTabCallback,
              ),
            )
          ],
        ),
      ),
    );
  }
}
