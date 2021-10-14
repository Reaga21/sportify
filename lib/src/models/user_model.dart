import 'package:json_annotation/json_annotation.dart';
import 'package:sportify/src/util/dates.dart' as dates;

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  Map<String, Map<String, int>> steps;
  String currentTimestamp;

  @JsonKey(ignore: true)
  DateTime? lastStepEvent;

  UserModel(this.steps, this.currentTimestamp);

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
  void updateTodaySteps(int stepsFromPedometer, DateTime timeStamp) {
    // get last Timestamp from Step Event if null first run
    DateTime checkpoint =
        lastStepEvent ?? timeStamp.subtract(const Duration(days: 1));
    //only update when timestamp is newer
    if (timeStamp.isAfter(checkpoint)) {
      currentTimestamp = dates.nowFormated();
      lastStepEvent = timeStamp;
      int newSteps = calcNewSteps(stepsFromPedometer);
      commitTodaySteps(newSteps, stepsFromPedometer);
    }
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

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
