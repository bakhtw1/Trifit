import 'dart:convert';
import 'package:trifit/utilities/FileReadWrite.dart';
import '../models/MealModel.dart';
import '../utilities/UtilityFunctions.dart';

class MealController {
  var allMeals = [];

  // Fetches meal data for the current day and days-1 previous days
  getMealsForPastDays(int days) {
    var filteredMeals = [];
    for (int i = 0; i <= days; i++) {
      filteredMeals.addAll(_getMealsForDay(simpleDate(DateTime.now()).subtract(Duration(days: i))));
    }
    return filteredMeals;
  }

  getMealsForDate(DateTime date) {
    var meals = [];
    for (var meal in allMeals) {
      if (meal["date"] == date.toString()) {
        try { meals = meal["meals"];}
        catch(e) { meals = []; }
      }
    }
    return meals;
  }

  // Fetches all meal data
  loadMeals(DateTime date) async {
    var file = FileReadWrite("mealdata-$date.json");
    var content = await file.read();
    try { allMeals = json.decode(content); } on Exception catch (_) {
      allMeals = [];
    }
  }

  _getMealsForDay(DateTime date) {
    return allMeals.where((i) => i["date"] == date.toString()).toList();
  }

  addMeal(MealModel toAdd, DateTime date) async {
    var mealFile = FileReadWrite("mealdata-$date.json");
    String mealData = await mealFile.read();

    await loadMeals(date);

    allMeals.add(toAdd);
    writeJson("mealdata-$date.json", jsonEncode(allMeals));
  }
}