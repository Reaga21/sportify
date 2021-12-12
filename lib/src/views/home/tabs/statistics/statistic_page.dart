import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stats/stats.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

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

  final List<_SalesData> data = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 34),
    _SalesData('Apr', 32),
    _SalesData('May', 40)
  ];

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
                return const Text("Ein Problem ist aufgetreten");
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
              return //Initialize the chart widget
                  SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                // Chart title
                title: ChartTitle(text: 'Half yearly sales analysis'),
                // Enable legend
                legend: Legend(isVisible: true),
                // Enable tooltip
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries<_SalesData, String>>[
                  LineSeries<_SalesData, String>(
                    dataSource: data,  // keine Forschleifen verwendbar -- entsprechende Funktionalitäten in einer Funktion auslagern
                    xValueMapper: (_SalesData sales, _) => sales.year,
                    yValueMapper: (_SalesData sales, _) => sales.sales,
                    name: 'Sales',
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],
              );
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              //Initialize the spark charts widget
              child: SfSparkLineChart.custom(
                //Enable the trackball
                trackball: const SparkChartTrackball(
                    activationMode: SparkChartActivationMode.tap),
                //Enable marker
                marker: const SparkChartMarker(
                    displayMode: SparkChartMarkerDisplayMode.all),
                //Enable data label
                labelDisplayMode: SparkChartLabelDisplayMode.all,
                xValueMapper: (int index) => data[index].year,
                yValueMapper: (int index) => data[index].sales,
                dataCount: 5,
              ),
            ),
          ),
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
