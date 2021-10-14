import 'package:sportify/src/models/user_model.dart';
import 'package:sportify/src/util/dates.dart';
import 'dart:convert';

import 'package:test/test.dart';

final String jsonStringToday = '''{
    "steps": {
      "${today()}": {
        "stepsDay": 400,
        "stepsAbs": 1400
      },
      "${yesterday()}": {
        "stepsDay": 200,
        "stepsAbs": 1000
      }
    }
}''';

final String jsonStringYesterday = '''{
    "steps": {
      "${yesterday()}": {
        "stepsDay": 200,
        "stepsAbs": 1000
      }
    }
}''';

const String jsonStringFirst = '''{
    "steps": {
    }
}''';

final Map<String, dynamic> jsonToday = jsonDecode(jsonStringToday);
final Map<String, dynamic> jsonYesterday = jsonDecode(jsonStringYesterday);
final Map<String, dynamic> jsonZero = jsonDecode(jsonStringFirst);

void main() {
  UserModel userToday = UserModel.fromJson(jsonToday);
  UserModel userYesterday = UserModel.fromJson(jsonYesterday);
  UserModel userZero = UserModel.fromJson(jsonZero);

  test("Get the latest amount of absolute Steps", () {
    assert(userToday.getLatestStepsAbs() == 1400);
    assert(userYesterday.getLatestStepsAbs() == 1000);
    assert(userZero.getLatestStepsAbs() == 0);
  });

  test("Get today's steps", () {
    assert(userToday.getTodaySteps() == 400);
    assert(userYesterday.getTodaySteps() == 0);
    assert(userZero.getTodaySteps() == 0);
  });

  test("Calculates the new Steps", () {
    assert(userToday.calcNewSteps(2000) == 600);
    assert(userYesterday.calcNewSteps(2000) == 1000);
    assert(userZero.calcNewSteps(2000) == 0);
  });

  test("Go through full update routine", () {
    userToday.updateTodaySteps(2000, DateTime.now());
    userYesterday.updateTodaySteps(2000, DateTime.now());
    userZero.updateTodaySteps(2000, DateTime.now());

    assert(userZero.getTodaySteps() == 0);
    assert(userToday.getTodaySteps() == 1000);
    assert(userYesterday.getTodaySteps() == 1000);

    userToday.updateTodaySteps(3000, DateTime.now());
    userYesterday.updateTodaySteps(3000, DateTime.now());
    userZero.updateTodaySteps(3000, DateTime.now());

    assert(userZero.getTodaySteps() == 1000);
    assert(userToday.getTodaySteps() == 2000);
    assert(userYesterday.getTodaySteps() == 2000);
  });
}
