class Item {
  late final String name;
  late final int calories;
  Item(this.name, this.calories);

  Map<String, dynamic> toJson() {
    return {'name': name, 'calories': calories};
  }
}

class MealModel {
  late final List<Item> items;
  late final String mealType;
  late final DateTime date;
  int get calories => _calculateCalories();
  MealModel(this.items, this.mealType, this.date);

  _calculateCalories() {
    var calories = 0;
    for (var item in items) {
      calories += item.calories;
    }
    return calories;
  }
  
  @override
  String toString() {
    String mealString = "Meal type: "+mealType + "\nItems: \n";
    mealString += "Date: "+date.toString();
    for (var item in items) {
      mealString = mealString+("Name: "+item.name+" Cals: "+item.calories.toString()+"\n");
    }
    return mealString;
  }

  Map<String, dynamic> toJson() {
    var jsonItems = [];
    for (var item in items) {
      jsonItems.add(item.toJson());
    }
    return {'type':mealType, 'items':jsonItems, 'calories': calories, 'date': date.toString()};
  }
}