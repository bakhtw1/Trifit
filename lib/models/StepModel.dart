class StepModel {
  late final String steps;
  late final DateTime date;
  int get calories => (double.parse(steps)*0.04).ceil();

  StepModel(this.steps, this.date);

  Map<String, dynamic> toJson() {
    return {'steps':steps, 'calories': calories, 'date': date};
  }
}