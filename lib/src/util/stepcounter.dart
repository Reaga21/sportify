import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pedometer/pedometer.dart';
import 'package:intl/intl.dart';

class StepCounter {
  final Stream<StepCount> _sub = Pedometer.stepCountStream;
  String uid;
  final String _today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final String _yesterday = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().subtract(const Duration(days: 1)));


  Future<DocumentSnapshot> savedSteps () {
    return FirebaseFirestore.instance.collection('steps').doc(uid).get();
  }

  StepCounter(this.uid) {
    //_sub.listen(onStepCount).onError(onStepError);
  }

  onStepCount(StepCount event) {
    // handle count
    print(event.steps);
  }

  onStepError(StepCount error) {
    // handle error
    print(error);

  }
}
