class StepModel {
  late final String steps;
  late final DateTime date;
  int get calories => (double.parse(steps)*0.04).ceil();
  int get _steps => int.parse(steps);

  StepModel(this.steps, this.date);

  Map<String, dynamic> toJson() {
    return {'steps':_steps, 'calories': calories, 'date': date};
  }
}