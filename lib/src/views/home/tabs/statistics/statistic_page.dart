import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sportify/src/views/home/tabs/statistics/chart_monthly_average.dart';
import 'package:sportify/src/views/home/tabs/statistics/chart_seven_days.dart';
import 'package:sportify/src/views/home/tabs/statistics/chart_thirty_days.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:sportify/src/util/dates.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({Key? key}) : super(key: key);

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  final controller = PageController(keepPage: true);
  final pages = [
    const ChartSevenDays(),
    const ChartThirtyDays(),
    const ChartMonthlyAverage(),
  ];

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
        child: Column(
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
            Expanded(
              child: PageView.builder(
                itemBuilder: (_, index) {
                  return pages[index % pages.length];
                },
                controller: controller,
                itemCount: pages.length,
              ),
            ),
            SmoothPageIndicator(
              controller: controller,
              onDotClicked: (init) => controller.animateToPage(init,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInQuad),
              count: pages.length,
              effect: JumpingDotEffect(
                dotColor: Theme.of(context).colorScheme.secondaryVariant,
                activeDotColor: Theme.of(context).colorScheme.primary,
                verticalOffset: 20,
                dotHeight: 8,
                dotWidth: 8,
                jumpScale: .7,
              ),
            ),
          ],
        ),
        ),
    );
  }
}

extension DateTimeComparison on DateTime {
  bool isSameYearAndMonth(DateTime other) {
    return ((year == other.year) && (month == other.month));
  }
}
