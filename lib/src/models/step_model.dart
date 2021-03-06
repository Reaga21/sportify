import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sportify/src/util/dates.dart' as dates;

part 'step_model.g.dart';

@JsonSerializable()
class StepModel extends ChangeNotifier {
  Map<String, Map<String, int>> steps;
  String lastUpdate;
  String username;

  StepModel(this.steps, this.lastUpdate, this.username);

  int getTodaySteps() {
    return steps[dates.today()]?['stepsDay'] ?? 0;
  }

  /// returns the latest absolute amount of steps
  int getLatestStepsAbs() {
    return steps[dates.today()]?['stepsAbs'] ??
        steps[dates.yesterday()]?['stepsAbs'] ??
        0;
  }

  /// updates with the new Steps
  void updateTodaySteps(int stepsFromPedometer) {
    lastUpdate = dates.nowFormated();
    int newSteps = calcNewSteps(stepsFromPedometer);
    commitTodaySteps(newSteps, stepsFromPedometer);
    notifyListeners();
  }

  /// calcs the new Steps from [stepsFromPedometer]
  int calcNewSteps(int stepsFromPedometer) {
    int savedSteps = getLatestStepsAbs();
    int newSteps = 0;
    if (savedSteps == 0) {
      // first record => zero new steps
      newSteps = 0;
    } else if (savedSteps < stepsFromPedometer) {
      newSteps = stepsFromPedometer - savedSteps;
    } else if (savedSteps > stepsFromPedometer) {
      // sensor sometimes takes a step back, just continue
      if (10 < (savedSteps - stepsFromPedometer)) {
        newSteps = 0;
      } else {
        // phone did restart and reset the pedometer
        // newSteps are equal to steps from pedometer
        newSteps = stepsFromPedometer;
      }
    }
    return newSteps;
  }

  /// commits the new Steps to Map
  void commitTodaySteps(int newSteps, int totalSteps) {
    // check if an entries exits for today and update
    if (steps[dates.today()] != null) {
      steps[dates.today()]!
        ..update('stepsDay', (oldSteps) => oldSteps + newSteps)
        ..update('stepsAbs', (_) => totalSteps);
    } else {
      // no entry yet, create a fresh one
      steps[dates.today()] = {
        'stepsDay': newSteps,
        'stepsAbs': totalSteps,
      };
    }
  }

  setStepModel(StepModel? newModel) {
    if (newModel != null) {
      steps = newModel.steps;
      lastUpdate = newModel.lastUpdate;
      username = newModel.username;
    }
    notifyListeners();
  }

  factory StepModel.fromJson(Map<String, dynamic> json) =>
      _$StepModelFromJson(json);

  Map<String, dynamic> toJson() => _$StepModelToJson(this);
}
