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

  // Gets weights for a specific day as an array of json objects
  getWeightsForDay(DateTime date) {
    return allWeights.where((i) => i["date"] == date.toString()).toList();
  }

  // Returns the average weight for a given year and month as a double
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