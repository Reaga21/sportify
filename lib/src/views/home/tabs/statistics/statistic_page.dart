import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:sportify/src/util/dates.dart';

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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
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
                    return Column(
                      children: [
                        Card(
                          child: SfCartesianChart(
                            title: ChartTitle(text: 'Overview Steps (Seven Days)'),
                            series: <ChartSeries>[
                              BarSeries<StepsData, dynamic>(color: Color(0xFFDE6482),
                                  dataSource: getChartDataSeven(dataSteps.data!),
                                  xValueMapper: (StepsData data, _) =>
                                      shortDate(data.date),
                                  yValueMapper: (StepsData data, _) =>
                                      data.steps),
                            ],
                            primaryXAxis: CategoryAxis(),
                            primaryYAxis: NumericAxis(
                                edgeLabelPlacement: EdgeLabelPlacement.shift),
                            tooltipBehavior: TooltipBehavior(
                              color: Theme.of(context).colorScheme.primary,
                                enable: true,
                                // Templating the tooltip
                                builder: (dynamic data, dynamic point, dynamic series,
                                    int pointIndex, int seriesIndex) {
                                  return ClipRRect(borderRadius: BorderRadius.circular(200.0),
                                    child: Container(color: Theme.of(context).colorScheme.primary,

                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                              'Steps : ${(data as StepsData).steps}'
                                          ),
                                        )
                                    ),
                                  );
                                }
                            ),
                          ),
                        ),
                        Card(
                          child: SfCartesianChart(
                            title: ChartTitle(text: 'Overview Steps (Thirty Days)'),
                    series: <ChartSeries>[
                    BarSeries<StepsData, dynamic>(color: Color(0xFFDE6482),
                    dataSource: getChartDataThirty(dataSteps.data!),
                    xValueMapper: (StepsData data, _) =>
                    shortDate(data.date),
                    yValueMapper: (StepsData data, _) =>
                    data.steps),
                    ],
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(
                    edgeLabelPlacement: EdgeLabelPlacement.shift),
                    tooltipBehavior: TooltipBehavior(
                    color: Theme.of(context).colorScheme.primary,
                    enable: true,
                    // Templating the tooltip
                    builder: (dynamic data, dynamic point, dynamic series,
                    int pointIndex, int seriesIndex) {
                    return ClipRRect(borderRadius: BorderRadius.circular(200.0),
                    child: Container(color: Theme.of(context).colorScheme.primary,

                    child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                    'Steps : ${(data as StepsData).steps}'
                    ),
                    )
                    ),
                    );
                    }
                    ),
                          ),
                        ),
                        Card(
                          child: SfCartesianChart(
                            title: ChartTitle(text: 'Monthly Overview Steps (Average)'),
                            series: <ChartSeries>[
                              BarSeries<StepsData, dynamic>(color: Color(0xFFDE6482),
                                  dataSource: getChartDataMonthly(dataSteps.data!),
                                  xValueMapper: (StepsData data, _) =>
                                      shortDate(data.date),
                                  yValueMapper: (StepsData data, _) =>
                                  data.steps),
                            ],
                            primaryXAxis: CategoryAxis(),
                            primaryYAxis: NumericAxis(
                                edgeLabelPlacement: EdgeLabelPlacement.shift),
                            tooltipBehavior: TooltipBehavior(
                                color: Theme.of(context).colorScheme.primary,
                                enable: true,
                                // Templating the tooltip
                                builder: (dynamic data, dynamic point, dynamic series,
                                    int pointIndex, int seriesIndex) {
                                  return ClipRRect(borderRadius: BorderRadius.circular(200.0),
                                    child: Container(color: Theme.of(context).colorScheme.primary,

                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                              'Steps (average) : ${(data as StepsData).steps}'
                                          ),
                                        )
                                    ),
                                  );
                                }
                            ),
                          ),
                        ),
                      ],
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }

  List<StepsData> getChartDataSeven(Map<String, dynamic> dataSteps) {
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

  List<StepsData> getChartDataThirty(Map<String, dynamic> dataSteps) {
    final List<StepsData> chartData = [];

    for (MapEntry entry in dataSteps.entries) {
      chartData.add(StepsData(
          DateTime.parse(entry.key), entry.value['stepsDay'])); //DATUM
    }
    chartData.sort((a, b) => a.date.compareTo(b.date));
    if (chartData.length > 30) {
      chartData.removeRange(0, chartData.length - 30);
    }
    return chartData;
  }

  List<StepsData> getChartDataMonthly(Map<String, dynamic> dataSteps) {
    final List<StepsData> chartData = [];
    int aggregatedSteps = 0;
    int count = 0;

    for (MapEntry entry in dataSteps.entries) {
      if (DateTime.parse(entry.key).isSameYearAndMonth(
          DateTime.parse(entry.key).add(const Duration(days: 1)))) {
        aggregatedSteps += int.parse(entry.value['stepsDay']!.toString());
        ++count;
        chartData.add(StepsData(
            DateTime(DateTime.parse(entry.key).year,
                DateTime.parse(entry.key).month),
            aggregatedSteps ~/ count)); //DATUM
      }
    }
    chartData.sort((a, b) => a.date.compareTo(b.date));
    if (chartData.length > 30) {
      chartData.removeRange(0, chartData.length - 30);
    }
    return chartData;
  }
// gruppieren der Daten nach Jahr  und dann nach Monat

// Datetime hat month property und year property
// groupierte Liste erstellen

}

class StepsData {
  StepsData(this.date, this.steps);

  final DateTime date;
  final int steps;
}

extension DateTimeComparison on DateTime {
  bool isSameYearAndMonth(DateTime other) {
    return ((year == other.year) && (month == other.month));
  }
}
