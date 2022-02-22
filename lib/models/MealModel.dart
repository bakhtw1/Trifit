import 'package:flutter/material.dart';

class Item {
  late final String name;
  late final int calories;
  Item(this.name, this.calories);
}

class MealModel {
  late final List<Item> items;
  late final String mealType;
  MealModel(this.items, this.mealType);

  @override
  String toString() {
    // TODO: implement toString
    String mealString = "Meal type: "+mealType + "\nItems: \n";
    for (var item in items) {
      mealString = mealString+("Name: "+item.name+" Cals: "+item.calories.toString()+"\n");
    }
    return mealString;
  }
}