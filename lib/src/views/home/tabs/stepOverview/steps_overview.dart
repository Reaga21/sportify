import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportify/src/models/step_model.dart';
import 'package:sportify/src/views/home/tabs/stepOverview/step_box.dart';

class StepOverviewPage extends StatelessWidget {
  const StepOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return createStepBox(context.watch<StepModel>().getTodaySteps().toString());
  }
}
