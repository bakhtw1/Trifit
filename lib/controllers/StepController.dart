import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trifit/models/ExerciseModel.dart';
import '../models/StepModel.dart';
import '../utilities/UtilityFunctions.dart';

class StepController {
  var allSteps = [];

  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> stepSubscription;

  StepController() {
    stepSubscription = FirebaseFirestore.instance
      .collection('exercise')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots()
      .listen((snapshot) {
        var data = snapshot.data();
        if (data != null) {
          allSteps = (data['workouts'] as List<dynamic>).where((i) => i['type'] == 'steps').toList();
        }
    });
  }

  // Fetches step data for the current day and days-1 previous days
  getStepsForPastDays(int days) {
    var filteredSteps = [];
    for (int i = 0; i <= days; i++) {
      filteredSteps.addAll(_getStepsForDay(simpleDate(DateTime.now()).subtract(Duration(days: i))));
    }
    return filteredSteps;
  }

  getActiveCaloriesForDate(DateTime date) {
    return (getStepsForDate(date)*0.04).ceil();
  }

  getStepsForDate(DateTime date) {
    var stepCount = 0.0;
    for (var step in _getStepsForDay(date)) {
      try { stepCount += double.parse(step['workout']['steps']);}
      catch(e) { stepCount += 0; }
    }
    return stepCount;
  }

  _getStepsForDay(DateTime day) {
    return allSteps.where((i) => i["date"] == Timestamp.fromDate(day)).toList();
  }

  addSteps(StepModel toAdd) async {
    var exercise = ExerciseModel("steps", toAdd, toAdd.calories.toDouble(), toAdd.date);
    allSteps.add(toAdd.toJson());
    FirebaseFirestore.instance
      .collection('exercise')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .update({"workouts":FieldValue.arrayUnion([exercise.toJson()])});
  }

}