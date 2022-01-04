import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stats/stats.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:sportify/src/util/dates.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sportify"),
        backgroundColor: Theme.of(context).colorScheme.primary,
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
                color: Theme.of(context).colorScheme.secondary,
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
                //
                //Map<String, dynamic> realData = dataSteps.data!;
                return SfCartesianChart(
                    series: <ChartSeries>[
                      BarSeries<StepsData, dynamic>(
                          dataSource: getChartData(dataSteps.data!),
                          xValueMapper: (StepsData data, _) =>
                              shortDate(data.date),
                          yValueMapper: (StepsData data, _) => data.steps),
                    ],
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(
                        edgeLabelPlacement: EdgeLabelPlacement.shift));
              })
        ],
      ),
    );
  }

  List<StepsData> getChartData(Map<String, dynamic> dataSteps) {
    final List<StepsData> chartData = [];

    for (MapEntry entry in dataSteps.entries) {
      chartData.add(StepsData(
          DateTime.parse(entry.key), entry.value['stepsDay'])); //DATUM
    }
    chartData.sort((a, b) => a.date.compareTo(b.date));
    if (chartData.length > 7) {
      chartData.removeRange(0, chartData.length - 7);
    }
    return chartData;
  }
}

class StepsData {
  StepsData(this.date, this.steps);

  final DateTime date;
  final int steps;
}
