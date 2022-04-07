import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/WeightModel.dart';
import '../utilities/UtilityFunctions.dart';

class WeightController {
  var allWeights = [];
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> weightSubscription;

  WeightController() {
      weightSubscription = FirebaseFirestore.instance
      .collection('weights')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots()
      .listen((snapshot) {
        var data = snapshot.data();
        if (data != null) {
          allWeights = data['weights'];
        }
    });
  }

  // Fetches weight data for the current day and days-1 previous days
  getWeightsForPastDays(int days) {
    var filteredWeights = [];
    for (int i = 0; i <= days; i++) {
      filteredWeights.addAll(getWeightsForDay(simpleDate(DateTime.now()).subtract(Duration(days: i))));
    }
    return filteredWeights;
  }

  getWeightsForDay(DateTime date) {
    return allWeights.where((i) => i["date"] == date.toString()).toList();
  }

  getAverageWeightForMonth(int year, int month) {
    double totalWeight = 0;
    int numWeights = 0;
    for (var weight in allWeights) {
      var date = dateFromTimestamp(weight["date"]);
      if (date.year == year && date.month == month) {
        totalWeight += (weight["weight"]);
        numWeights++;
      } else {
      }
    }
    if (numWeights == 0) {
      // Could do some backtracking to get weights for previous months if there's no data
      // but would need to discuss how far back to look because looking back until you find data 
      // could go back forever
      return 0;
    }
    return totalWeight/numWeights;
  }

  addWeight(WeightModel toAdd) async {
    FirebaseFirestore.instance
      .collection('weights')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .update({
        "weights": FieldValue.arrayUnion([toAdd.toJson()])
      });
  }
}