import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sportify/src/models/step_model.dart';
import 'package:sportify/src/util/dates.dart' as dates;
import 'package:sportify/src/views/home/tabs/stepOverview/step_box.dart';

void main() {
  testWidgets('MyWidget has a title and massage', (WidgetTester tester) async {
    const initSteps = 1000;
    const nextSteps = 1500;
    final mySteps = StepModel({
      dates.today(): {
        "stepsAbs": initSteps,
        "stepsDay": initSteps,
      }
    }, dates.nowFormated(), "Tester");

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => mySteps
          )
        ],
        child: const MaterialApp(home: StepBox()),
      ),
    );
    Finder stepFinder = find.text(initSteps.toString());
    expect(stepFinder, findsOneWidget);

    mySteps.updateTodaySteps(nextSteps);
    await Future.microtask(tester.pump);
    stepFinder = find.text(nextSteps.toString());
    expect(stepFinder, findsOneWidget);

  });
}
