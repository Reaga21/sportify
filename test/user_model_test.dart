import 'package:sportify/src/models/user_model.dart';
import 'dart:convert';

import 'package:test/test.dart';

const String jsonStringToday = '''{
    "steps": {
      "2021-10-08": {
        "stepsDay": 400,
        "stepsAbs": 1400
      },
      "2021-10-07": {
        "stepsDay": 200,
        "stepsAbs": 1000
      }
    }
}''';

const String jsonStringYesterday = '''{
    "steps": {
      "2021-10-07": {
        "stepsDay": 200,
        "stepsAbs": 1000
      }
    }
}''';

final Map<String, dynamic> jsonToday = jsonDecode(jsonStringToday);
final Map<String, dynamic> jsonYesterday = jsonDecode(jsonStringYesterday);

void main() {
  UserModel userToday = UserModel.fromJson(jsonToday);
  UserModel userYesterday = UserModel.fromJson(jsonYesterday);

  test("Get the latest amount of absolute Steps", () {
    assert(userToday.getLatestStepsAbs() == 1400);
    assert(userYesterday.getLatestStepsAbs() == 1000);
  });

  test("Get today's steps", () {
    assert(userToday.getTodaySteps() == 400);
    assert(userYesterday.getTodaySteps() == 0);
  });

  test("Calculates the new Steps", () {
    assert(userToday.calcNewSteps(2000) == 600);
    assert(userYesterday.calcNewSteps(2000) == 1000);
  });

  test("Calculates the new Steps", () {
    userToday.updateTodaySteps(2000);
    userYesterday.updateTodaySteps(2000);


    assert(userToday.getTodaySteps() == 1000);
    assert(userYesterday.getTodaySteps() == 1000);
  });
}
