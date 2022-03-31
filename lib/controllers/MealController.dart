import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/MealModel.dart';
import '../utilities/UtilityFunctions.dart';

class MealController {
  var allMeals = [];
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> mealSubscription;

  MealController() {
      mealSubscription = FirebaseFirestore.instance
      .collection('users')
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
      filteredMeals.addAll(getMealsForDay(simpleDate(DateTime.now()).subtract(Duration(days: i))));
    }
    return filteredMeals;
  }

  getMealsForDate(DateTime date) {
    var meals = [];
    for (var meal in allMeals) {
      if (meal["date"] == date.toString()) {
        try { meals = meal;}
        catch(e) { meals = []; }
      }
    }
    return meals;
  }

  getMealsForDay(DateTime date) {
    return allMeals.where((i) => i["date"] == date.toString()).toList();
  }

  addMeal(MealModel toAdd, DateTime date) async {
    allMeals.add(toAdd.toJson());

    FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .update({"meals":allMeals});
    List<Map<String, dynamic>> items = [];
    for (var item in toAdd.items)
      items.add(item.toJson());
    FirebaseFirestore.instance
      .collection('meals')
      .add({
        "date":allMeals,
        "items": items,
        "uid": FirebaseAuth.instance.currentUser!.uid
      });
  }

  int calorieIntakeForDate(DateTime date) {
    var selectedMealData = allMeals
      .where((i) => DateTime.parse(i["date"]) == date)
      .toList();
    int cals = 0;
    for (var meal in selectedMealData) {
      for (var item in meal["items"]) {
        cals += item["calories"] as int;
      }
    }
    return cals;
  }
}