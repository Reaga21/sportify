import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportify/src/models/steps_data.dart';
import 'package:sportify/src/views/home/tabs/statistics/statistic_page.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:sportify/src/util/dates.dart';

class ChartSevenDays extends StatelessWidget {
  const ChartSevenDays({Key? key}) : super(key: key);

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
                  title: ChartTitle(text: 'Overview Steps (Seven Days)'),
                  series: <ChartSeries>[
                    BarSeries<StepsData, dynamic>(
                        color: Color(0xFFDE6482),
                        dataSource: getChartDataSeven(dataSteps.data!),
                        xValueMapper: (StepsData data, _) =>
                            shortDate(data.date),
                        yValueMapper: (StepsData data, _) => data.steps),
                  ],
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis:
                      NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
                  tooltipBehavior: TooltipBehavior(
                      color: Theme.of(context).colorScheme.primary,
                      enable: true,
                      // Templating the tooltip
                      builder: (dynamic data, dynamic point, dynamic series,
                          int pointIndex, int seriesIndex) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(200.0),
                          child: Container(
                              color: Theme.of(context).colorScheme.primary,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                    'Steps : ${(data as StepsData).steps}'),
                              )),
                        );
                      }),
                ),
              );
        });
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

}
