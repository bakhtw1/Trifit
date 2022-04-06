class ExerciseModel {
  late final String type;
  late final DateTime date;
  late final double calories;
  // Workout will be of some exercise type (currently only steps exists)
  // If you make a workout class and intend to use this you need to implement toJson() for the class
  late final dynamic workout;

  ExerciseModel(this.type, this.workout, this.calories, this.date);

  Map<String, dynamic> toJson() {
    return {'type':type, 'workout': workout.toJson(), 'calories': calories, 'date': date};
  }
}