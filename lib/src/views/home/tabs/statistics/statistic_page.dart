import 'package:flutter/material.dart';

class StatisticPage extends StatelessWidget {
  const StatisticPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text("Sportify"),
    backgroundColor: Theme.of(context).colorScheme.primary,
    ),
    body: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Padding(
    padding: const EdgeInsets.symmetric(vertical: 20.0),
    child: Text(
    "Statistics",
    style: TextStyle(
    fontSize: 30,
    color: Theme.of(context).colorScheme.secondary,
    ),
    textAlign: TextAlign.center,
    ),
    ),
    ],
    )
    );
  }
}
