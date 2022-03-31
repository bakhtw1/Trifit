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
  MealModel(this.items, this.mealType, this.date);

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
    return {'type':mealType, 'items':jsonItems, 'date': date.toString()};
  }
}