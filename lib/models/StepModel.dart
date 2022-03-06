class StepModel {
  late final String steps;
  late final DateTime date;

  StepModel(this.steps, this.date);

  Map<String, dynamic> toJson() {
    return {'steps':steps, 'date': date.toString()};
  }
}