import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportify/src/models/step_model.dart';
import 'package:sportify/src/views/home/tabs/stepOverview/ranking_list.dart';
import 'package:sportify/src/views/home/tabs/stepOverview/step_box.dart';

class StepOverviewPage extends StatelessWidget {
  const StepOverviewPage({Key? key}) : super(key: key);

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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: createStepBox(
                  context.watch<StepModel>().getTodaySteps().toString(),
                  context),
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    children: [
                      Text(
                        "Hi ${context.read<StepModel>().username}!",
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      const Text("Catch up with your friends")
                    ],
                  ),
                ),
              ],
            ),
            const Expanded(
              flex: 2,
              child: RankingList(),
            )
          ],
        ),
      ),
    );
  }
}
