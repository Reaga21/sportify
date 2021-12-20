import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stats/stats.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:sportify/src/util/dates.dart' as dates;
import 'package:intl/intl.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({Key? key}) : super(key: key);

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  Future<Map<String, dynamic>> readData() async {
    CollectionReference steps = FirebaseFirestore.instance.collection('steps');
    DocumentSnapshot date =
    await steps.doc(FirebaseAuth.instance.currentUser!.uid).get();
    Map<String, dynamic> data1 = date.data() as Map<String, dynamic>;
    Map<String, dynamic> dataSteps = data1['steps'] as Map<String, dynamic>;

    return dataSteps;
  }

  final List<String> days7 = [
    DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(const Duration(days: 6))),
    DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(const Duration(days: 5))),
    DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(const Duration(days: 4))),
    DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(const Duration(days: 3))),
    DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(const Duration(days: 2))),
    DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(const Duration(days: 1))),
    DateFormat('yyyy-MM-dd')
        .format(DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sportify"),
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .primary,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              "Statistics",
              style: TextStyle(
                fontSize: 30,
                color: Theme
                    .of(context)
                    .colorScheme
                    .secondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          FutureBuilder(
              future: readData(),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, dynamic>> dataSteps) {
                if (dataSteps.hasError) {
                  return const Text("A problem has occurred!");
                }
                if (!dataSteps.hasData) {
                  return const CircularProgressIndicator();
                }

                //dataSteps.data!['keyword']; // so kommt man an die Daten ran
                // for(MapEntry entry in dataSteps.data!.entries) {
                // entry.key //DATUM
                //  entry.value //STEP
                // }
                //Map<String, dynamic> realData = dataSteps.data!;
                return
                BarChart(BarChartData(
                  alignment: BarChartAlignment.center,
                  maxY:40000,
                  minY: 0,
                  groupsSpace: 12,
                  barTouchData: BarTouchData(enabled: true),
                ),); //Initialize the chart widget

              }

          )
        ],
      ),
    );

  }
}


class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
