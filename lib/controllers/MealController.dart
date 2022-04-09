import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/MealModel.dart';
import '../utilities/UtilityFunctions.dart';

class MealController {
  var allMeals = [];
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>
      mealSubscription;

  MealController() {
    mealSubscription = FirebaseFirestore.instance
        .collection('meals')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((snapshot) {
      var data = snapshot.data();
      if (data != null) {
        allMeals = data['meals'];
      }
    });
  }

  // Fetches meal data for the current day and days-1 previous days
  getMealsForPastDays(int days) {
    var filteredMeals = [];
    for (int i = 0; i <= days; i++) {
      filteredMeals.addAll(getMealsForDay(
          simpleDate(DateTime.now()).subtract(Duration(days: i))));
    }
    return filteredMeals;
  }

  // Returns a json array of objects equivalent to the 'MealModel' class
  getMealsForDay(DateTime date) {
    return allMeals.where((i) => i["date"] == date.toString()).toList();
  }

  addMeal(MealModel toAdd, DateTime date) async {
    FirebaseFirestore.instance
        .collection('meals')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "meals": FieldValue.arrayUnion([toAdd.toJson()])
    });
  }

  // Returns the total calorie intake from meals on a given date as an int
  int calorieIntakeForDate(DateTime date) {
    var selectedMealData =
        allMeals.where((i) => DateTime.parse(i["date"]) == date).toList();

    int cals = 0;
    for (var meal in selectedMealData) {
      cals += meal["calories"] as int;
    }

    return cals;
  }
}
