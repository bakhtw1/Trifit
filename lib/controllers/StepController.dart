import 'dart:convert';
import 'package:trifit/utilities/FileReadWrite.dart';
import '../models/StepModel.dart';
import '../utilities/UtilityFunctions.dart';

class StepController {
  var file = FileReadWrite("steps.json");
  var allSteps = [];

  // Fetches step data for the current day and days-1 previous days
  getStepsForPastDays(int days) {
    print(allSteps);
    var filteredSteps = [];
    for (int i = 0; i <= days; i++) {
      filteredSteps.addAll(_getStepsForDay(simpleDate(DateTime.now()).subtract(Duration(days: i))));
    }
    return filteredSteps;
  }

  getStepsForDate(DateTime date) {
    var stepCount = 0.0;
    for (var step in allSteps) {
      if (step["date"] == date.toString()) {
        try { stepCount = double.parse(step["steps"]);}
        catch(e) { stepCount = 0; }
      }
    }
    return stepCount;
  }

  // Fetches all step data
  loadSteps() async {
    var content = await file.read();
    try { allSteps = json.decode(content); } on Exception catch (_) {
      allSteps = [];
    }
  }

  _getStepsForDay(DateTime day) {
    return allSteps.where((i) => i["date"] == day.toString()).toList();
  }

  addSteps(String toAdd, DateTime date) async {
    var stepFile = FileReadWrite("steps.json");
    String stepData = await stepFile.read();
    bool dateHasSteps = false;
    var jsonResult;

    try { jsonResult = json.decode(stepData); } on Exception catch (_) {
      jsonResult = [];
    }
    allSteps = jsonResult;

    print(allSteps);
    for (var step in allSteps) {
      if (step["date"] == date.toString()) {
        step["steps"] = (int.parse(step["steps"])+int.parse(toAdd)).toString();
        dateHasSteps = true;
        break;
      }
    }
    if (!dateHasSteps) {
      allSteps.add(StepModel(toAdd, date).toJson());
    }
    writeJson("steps.json", jsonEncode(allSteps));
  }
}