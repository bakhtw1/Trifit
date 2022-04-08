import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trifit/controllers/StepController.dart';
import 'package:trifit/models/MealModel.dart';
import 'package:trifit/icons/scale_icon_icons.dart';
import '../controllers/WeightController.dart';
import '../models/StepModel.dart';
import '../models/WeightModel.dart';
import '../utilities/Styles.dart';
import '../components/dropdown.dart';
import '../components/expandableFab.dart';
import '../controllers/MealController.dart';
import 'package:intl/intl.dart';
import '../utilities/UtilityFunctions.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  final String pageTitle = "Home";
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Need to call load while initializing the screen
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await load();
    });
  }

  List selectedMealData = [];
  List<Widget> mealCards = [];
  List<MealModel> mealModels = [];
  bool isLoading = true;
  DateTime selectedDate = simpleDate(DateTime.now());
  bool isDecrementDateButtonDisabled = false;
  bool isIncrementDateButtonDisabled = true;
  List steps = [];
  var stepController = StepController();
  var mealController = MealController();
  var weightController = WeightController();
  @override
  Widget build(BuildContext context) {
    /*
      Using this streambuilder allows the page to wait until it has all of the necessary data
      fetched and ready to go before
    */
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('meals')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          selectedMealData = mealController.getMealsForDay(selectedDate);
          mealCards = [];
          for (var meal in selectedMealData) {
            mealCards.add(mealCard(meal));
          }
          return Scaffold(
            body: Stack(
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back_ios),
                                onPressed: isDecrementDateButtonDisabled
                                    ? null
                                    : () {
                                        incrementSelectedDate(-1);
                                      },
                              ),
                              selectedDateLabel(),
                              IconButton(
                                icon: Icon(Icons.arrow_forward_ios),
                                onPressed: isIncrementDateButtonDisabled
                                    ? null
                                    : () {
                                        incrementSelectedDate(1);
                                      },
                              )
                            ],
                          )),

                      // Calorie summary card
                      isLoading
                          ? SizedBox(height: 0)
                          : calorieSummary(
                              selectedMealData), // Calorie summary if data has been fetched, loading state if not
                      Expanded(
                          child: ListView(
                        shrinkWrap: true,
                        children: isLoading
                            ? [SizedBox(height: 0)]
                            : [
                                ...mealCards,
                                SizedBox(height: 140)
                              ], // Populate with meal cards if data has been fetched, loading state if not, and add a sizedbox to the end for whitespace
                      )),
                    ]),
              ],
            ),
            floatingActionButton: ExpandableFab(
              distance: 80.0,
              children: [
                ActionButton(
                  onPressed: () => showStepEntryDialog(() => {
                        setState(() {
                          load();
                        })
                      }),
                  icon: const Icon(Icons.directions_walk_outlined),
                ),
                ActionButton(
                  onPressed: () => showWeightEntryDialog(() => {
                        setState(() {
                          load();
                        })
                      }),
                  // icon: const Icon(CustomIcons.scale, size: 24),
                  icon: const Icon(ScaleIcon.scale, size: 24),
                ),
                ActionButton(
                  onPressed: () => showMealEntryDialog(() => {
                        setState(() {
                          load();
                        })
                      }),
                  icon: const Icon(Icons.restaurant),
                )
              ],
            ),
          );
        });
  }

  void showMealEntryDialog(reload) {
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
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Enter a meal'),
            insetPadding: EdgeInsets.zero,
            content: Container(
              width: MediaQuery.of(context).size.width * 0.8,
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
                                    onValueSelected: (String value) {
                                      mealTypeDropdownValue = value;
                                    },
                                    dropdownOptions: [
                                      "Snack",
                                      "Breakfast",
                                      "Lunch",
                                      "Dinner"
                                    ],
                                    placeholderText: "Meal Type",
                                    flex: 3,
                                  )),
                                  SizedBox(width: 20),
                                  DropdownMenu(
                                    onValueSelected: (String value) {
                                      setState(() {
                                        numberOfItems = int.parse(value);
                                        // Add rows to the end of the list if the new number is greater than the previous number
                                        if (numberOfItems > itemRows.length) {
                                          int numberOfNewRows =
                                              numberOfItems - itemRows.length;
                                          for (int i = 0;
                                              i < numberOfNewRows;
                                              i++) {
                                            var newItemController =
                                                TextEditingController();
                                            var newCalorieController =
                                                TextEditingController();
                                            itemControllers
                                                .add(newItemController);
                                            calorieControllers
                                                .add(newCalorieController);
                                            itemRows.add(newItemRow(
                                                newItemController,
                                                newCalorieController));
                                          }
                                        }
                                        // Remove rows from the end of the list if the new number is less than the current number of items
                                        else if (numberOfItems <
                                            itemRows.length) {
                                          int numberOfItemsToRemove =
                                              itemRows.length - numberOfItems;
                                          for (int i = 0;
                                              i < numberOfItemsToRemove;
                                              i++) {
                                            itemRows.removeLast();
                                            itemControllers.removeLast();
                                            calorieControllers.removeLast();
                                          }
                                        }
                                      });
                                    },
                                    dropdownOptions: [
                                      "1",
                                      "2",
                                      "3",
                                      "4",
                                      "5",
                                      "6"
                                    ],
                                    placeholderText: " ",
                                    // This sets 1 to be the default selected item
                                    isDefaultValueFirstItem: numberOfItems == 1,
                                  ),
                                  SizedBox(width: 10),
                                  Text("Items")
                                ],
                              )),
                          SizedBox(height: 20),
                          ...itemRows,
                          SizedBox(height: 20),
                        ],
                      ))),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    var meal = makeMealModel(mealTypeDropdownValue,
                        itemControllers, calorieControllers);
                    await mealController.addMeal(meal, selectedDate);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Successfully added meal'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    reload();
                    Navigator.pop(context);
                  }
                },
                child: Text('Add'),
              ),
            ],
          );
        });
      },
    );
  }

  void showStepEntryDialog(reload) {
    final _formKey = GlobalKey<FormState>();

    TextEditingController stepTextController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Add steps'),
            insetPadding: EdgeInsets.zero,
            content: Container(
              width: 200,
              child: SingleChildScrollView(
                  child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: stepTextController,
                              decoration: InputDecoration(hintText: "Steps"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                if (num.tryParse(value) == null) {
                                  return 'Must be number';
                                }
                                return null;
                              },
                            ),
                          )
                        ],
                      ))),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await stepController.addSteps(
                        StepModel(stepTextController.text, selectedDate));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Successfully added steps'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    reload();
                    Navigator.pop(context);
                  }
                },
                child: Text('Add'),
              ),
            ],
          );
        });
      },
    );
  }

  void showWeightEntryDialog(reload) {
    final _formKey = GlobalKey<FormState>();

    TextEditingController weightTextController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Update weight'),
            insetPadding: EdgeInsets.zero,
            content: Container(
              width: 200,
              child: SingleChildScrollView(
                  child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: weightTextController,
                              decoration:
                                  InputDecoration(hintText: "Weight (lbs)"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                if (num.tryParse(value) == null) {
                                  return 'Must be number';
                                }
                                return null;
                              },
                            ),
                          )
                        ],
                      ))),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await weightController.addWeight(
                        WeightModel(weightTextController.text, selectedDate));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Successfully updated weight'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    reload();
                    Navigator.pop(context);
                  }
                },
                child: Text('Update'),
              ),
            ],
          );
        });
      },
    );
  }

  MealModel makeMealModel(
      String mealType,
      List<TextEditingController> itemControllers,
      List<TextEditingController> calorieControllers) {
    List<Item> items = [];
    for (int i = 0; i < itemControllers.length; i++) {
      items.add(
          Item(itemControllers[i].text, int.parse(calorieControllers[i].text)));
    }
    var mealModel = MealModel(items, mealType, selectedDate);
    return mealModel;
  }

  Row newItemRow(TextEditingController itemController,
      TextEditingController calorieController) {
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
            )),
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
        )),
      ],
    );
  }

  Widget calorieSummary(List meals) {
    int calsFromFood =
        isLoading ? 0 : mealController.calorieIntakeForDate(selectedDate);
    // Active walking calories can very loosely be calculated as 0.04 * number of steps
    int calsFromExercise =
        isLoading ? 0 : (stepController.getActiveCaloriesForDate(selectedDate));
    String netCals = (calsFromFood - calsFromExercise).toString();

    return Container(
        height: 140,
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SizedBox.expand(
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Calories", style: TextStyle(fontSize: 26)),
                      Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(children: [
                                Text(calsFromFood.toString(),
                                    style: homeCardTitleTextStyle),
                                Text("Food")
                              ]),
                              Column(children: [
                                Text(calsFromExercise.toString(),
                                    style: homeCardTitleTextStyle),
                                Text("Exercise")
                              ]),
                              Column(children: [
                                Text(netCals, style: homeCardTitleTextStyle),
                                Text("Net")
                              ]),
                            ],
                          ))
                    ],
                  ))),
        ));
  }

  mealCard(Map<String, dynamic> meal) {
    List<Widget> items = [];
    for (var item in meal["items"] as List) {
      items.add(Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            children: [
              Text(item["name"], style: cardBodyTextStyle),
              Spacer(),
              Text(item["calories"].toString() + " cals",
                  style: cardBodyTextStyle),
            ],
          )));
    }
    return Container(
        // This manages to maintain proper heights without using expanded
        height: 140 + (items.length - 2) * 26,
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SizedBox.expand(
              child: Padding(
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(meal["type"] as String,
                          style: homeCardTitleTextStyle),
                      SizedBox(height: 10),
                      Column(children: items)
                    ],
                  ))),
        ));
  }

  load() async {
    isLoading = true;

    setState(() {
      selectedMealData = mealController.allMeals
          .where((i) => DateTime.parse(i["date"]) == selectedDate)
          .toList();
      isLoading = false;
    });
  }

  incrementSelectedDate(int addsub) {
    setState(() {
      selectedDate = addsub == 1
          ? selectedDate.add(Duration(days: 1))
          : selectedDate.subtract(Duration(days: 1));
      if (selectedDate.difference(DateTime.now()).inDays == -6) {
        isDecrementDateButtonDisabled = true;
      } else if (selectedDate == simpleDate(DateTime.now())) {
        isIncrementDateButtonDisabled = true;
      } else {
        isDecrementDateButtonDisabled = false;
        isIncrementDateButtonDisabled = false;
      }
    });
    load();
  }

  selectedDateLabel() {
    Text label;
    if (selectedDate == simpleDate(DateTime.now())) {
      label = Text("Today", style: homeCardTitleTextStyle);
    } else if (selectedDate ==
        simpleDate(DateTime.now().subtract(Duration(days: 1)))) {
      label = Text("Yesterday", style: homeCardTitleTextStyle);
    } else {
      label = Text(
          "${DateFormat.MMMM().format(selectedDate)} ${selectedDate.day}",
          style: homeCardTitleTextStyle);
    }
    return (Container(width: 200, child: Center(child: label)));
  }
}
