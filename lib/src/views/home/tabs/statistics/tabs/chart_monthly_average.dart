import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportify/src/models/steps_data.dart';
import 'package:sportify/src/views/home/tabs/statistics/statistic_page.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:sportify/src/util/dates.dart';

class ChartMonthlyAverage extends StatelessWidget {
  const ChartMonthlyAverage({Key? key}) : super(key: key);

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
    return FutureBuilder(
        future: readData(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> dataSteps) {
          if (dataSteps.hasError) {
            return const Text("A problem has occurred!");
          }
          if (!dataSteps.hasData) {
            return const CircularProgressIndicator();
          }
          return
            Card(
              child: SfCartesianChart(
                title: ChartTitle(
                    text: 'Monthly (Average)'),
                series: <ChartSeries>[
                  BarSeries<StepsData, dynamic>(
                      color: const Color(0xFFDE6482),
                      dataSource:
                      getChartDataMonthly(dataSteps.data!),
                      xValueMapper: (StepsData data, _) =>
                          monthYear(data.date),
                      yValueMapper: (StepsData data, _) =>
                      data.steps),
                ],
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(
                    edgeLabelPlacement: EdgeLabelPlacement.shift),
                tooltipBehavior: TooltipBehavior(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                    enable: true,
                    // Templating the tooltip
                    builder: (dynamic data,
                        dynamic point,
                        dynamic series,
                        int pointIndex,
                        int seriesIndex) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(200.0),
                        child: Container(
                            color:
                            Theme
                                .of(context)
                                .colorScheme
                                .primary,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                  'Steps (average) : ${(data as StepsData)
                                      .steps}'),
                            )),
                      );
                    }),
              ),
            );
        });
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
            DateTime(DateTime
                .parse(entry.key)
                .year,
                DateTime
                    .parse(entry.key)
                    .month),
            aggregatedSteps ~/ count)); //DATUM
      }
    }
    chartData.sort((a, b) => a.date.compareTo(b.date));
    if (chartData.length > 365) {
      chartData.removeRange(0, chartData.length - 365);
    }
    return chartData;
  }

}
