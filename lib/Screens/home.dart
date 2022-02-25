import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trifit/models/MealModel.dart';
import '../assets/Styles.dart' as tfStyle;
import '../assets/SampleData.dart' as SampleData;
import '../components/dropdown.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  final String pageTitle = "Home";
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List mealData = SampleData.sampleHomeData[0]["MealEntriesData"];
  List<Widget> mealSummaries = [];
  @override
  Widget build(BuildContext context) {
    for (var meal in mealData) {
      mealSummaries.add(mealSummary(meal));
    }
    // This is so that there's white space at the bottom of the list so the last items are easily viewable. 140 is the default height of a card
    mealSummaries.add(SizedBox(height: 140));
    return  Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              calorieSummary(mealData),
              Expanded(child:ListView(
                shrinkWrap: true,
                children: mealSummaries
                )
              ),
            ],
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              backgroundColor: tfStyle.trifitColor[700],
              onPressed: () {
                showMealEntryDialog();
              },
              tooltip: 'Add a new entry',
              child: const Icon(Icons.add),
            ),
          )
        ],
    );
  }

  void showMealEntryDialog() {
    String error = "";
    String mealTypeDropdownValue = "";
    int numberOfItems = 1;
    final _formKey = GlobalKey<FormState>();

    List<TextEditingController> itemControllers = [TextEditingController()];
    List<TextEditingController> calorieControllers = [TextEditingController()];

    List<Widget> itemRows = [
      newItemRow(itemControllers[0], calorieControllers[0])
    ];

    showDialog(
      context: context,
      builder: (context) {
      return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text('Enter a meal'),
          insetPadding: EdgeInsets.zero,
          content: Container(
              width: MediaQuery.of(context).size.width*0.8,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft, 
                        child: Row(
                          children: [
                            Container(
                              child: DropdownMenu(
                                onValueSelected: (String value) { mealTypeDropdownValue = value; },
                                dropdownOptions: ["Snack", "Breakfast", "Lunch", "Dinner"],
                                placeholderText: "Meal Type",
                                flex: 3,
                              )
                            ),
                            SizedBox(width: 20),
                            DropdownMenu(
                              onValueSelected: (String value) { 
                                setState(() {
                                  numberOfItems = int.parse(value);
                                  // Add rows to the end of the list if the new number is greater than the previous number
                                  if (numberOfItems > itemRows.length) {
                                    int numberOfNewRows = numberOfItems - itemRows.length;
                                    for (int i = 0; i < numberOfNewRows; i++) {
                                      var newItemController = TextEditingController();
                                      var newCalorieController = TextEditingController();
                                      itemControllers.add(newItemController);
                                      calorieControllers.add(newCalorieController);
                                      itemRows.add(newItemRow(newItemController, newCalorieController));
                                    }
                                  } 
                                  // Remove rows from the end of the list if the new number is less than the current number of items
                                  else if (numberOfItems < itemRows.length) {
                                    int numberOfItemsToRemove = itemRows.length - numberOfItems;
                                    for (int i = 0; i < numberOfItemsToRemove; i++) {
                                      itemRows.removeLast();
                                      itemControllers.removeLast();
                                      calorieControllers.removeLast();
                                    }
                                  }
                                });
                              },
                              dropdownOptions: ["1", "2", "3", "4", "5", "6"],
                              placeholderText: " ",
                              // This sets 1 to be the default selected item
                              isDefaultValueFirstItem: numberOfItems == 1,
                            ),
                            SizedBox(width: 10),
                            Text("Items")
                          ],
                        )
                      ),
                      SizedBox(height: 20),
                      ...itemRows,
                      SizedBox(height: 20),
                      Align(alignment: Alignment.topLeft, child: Text(error, style: tfStyle.errorTextStyle)),
                    ],
                  )
                )
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Successfully added meal'), backgroundColor: Colors.green,),
                  );
                  Navigator.pop(context);
                  makeMealModel(mealTypeDropdownValue, itemControllers, calorieControllers);
                }
              },
              child: Text('Add'),
            ),
          ],
        );});
      },
    );
  }

  MealModel makeMealModel(String mealType, List<TextEditingController> itemControllers, List<TextEditingController> calorieControllers) {
    List<Item> items = [];
    for (int i = 0; i < itemControllers.length; i++) {
      items.add(Item(itemControllers[i].text, int.parse(calorieControllers[i].text)));
    }
    var mealModel = MealModel(items, mealType);
    print(mealModel.mealType);
    for (var item in mealModel.items) {
      print(item.name + " " + item.calories.toString() + "\n");
    }
    return mealModel;
  }

  Row newItemRow(TextEditingController itemController, TextEditingController calorieController) {
    return Row(
      children: [ 
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: itemController,
            decoration: InputDecoration(hintText: "Item"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }
              return null;
            },
          )
        ),
        SizedBox(width: 20),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: calorieController,
              decoration: InputDecoration(hintText: "Calories"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                if (num.tryParse(value) == null) {
                  return 'Must be number';
                }
                return null;
              },
            )
        ),
      ],
    );
  }

  int calculateCaloriesFromFood() {
    int cals = 0;
    List meals = SampleData.sampleHomeData[0]["MealEntriesData"];
    for (var meal in meals) {
      for (var item in meal["items"]) {
        cals += item["calories"] as int;
      }
    }
    return cals;
  }

  Widget calorieSummary(List meals) {
    List sampleHomeData = SampleData.sampleHomeData;
    /*
    Eventually these will all be computed properties or fetched, but for now it'll be dummy data
    */
    int calsFromFood = calculateCaloriesFromFood();
    int calsFromExercise = sampleHomeData[0]["SummaryCardData"]["CaloriesFromExercise"];
    String netCals = (calsFromFood - calsFromExercise).toString();

    return Container(
      height: 140,
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: SizedBox.expand(
        child: Card (
          color: Color(0xFFEEEEEE),
          child: Padding(padding: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Calories", style: TextStyle(fontSize: 26)),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(children: [Text(calsFromFood.toString(), style: tfStyle.homeCardTitleTextStyle), Text("Food")]),
                      Column(children: [Text(calsFromExercise.toString(), style: tfStyle.homeCardTitleTextStyle), Text("Exercise")]),
                      Column(children: [Text(netCals, style: tfStyle.homeCardTitleTextStyle) ,Text("Net")]),
                    ],
                  )
                )
              ],
            )
          )
        )
      )
    );
  }

  Widget mealSummary(LinkedHashMap<String, Object> meal) {
    List<Widget> items = [];
    for (var item in meal["items"] as List) {
      items.add(
        Padding(
        padding: EdgeInsets.only(top: 5, bottom: 5),
        child: Row(
          children: [
            Text(item["name"]),
            Spacer(),
            Text(item["calories"].toString())
          ],
        )
        )
      );
    }
    return Container(
      // This manages to maintain proper heights without using expanded
      height: 140 + (items.length - 2)*26,
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: SizedBox.expand(
        child: Card (
          color: Color(0xFFEEEEEE),
          shape: RoundedRectangleBorder(
           // side: BorderSide(color: tfStyle.trifitColor[900]!, width: 2),
            borderRadius: BorderRadius.circular(5)
          ),
          child: Padding(padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(meal["type"] as String, style: tfStyle.homeCardTitleTextStyle),
                  SizedBox(height: 10),
                  Column(children: items)
                ],
              
            )
          )
        )
      )
    );
  }
}