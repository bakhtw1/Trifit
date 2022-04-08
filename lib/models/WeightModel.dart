class WeightModel {
  late final String weight;
  late final DateTime date;
  double get _weight => double.parse(weight);

  WeightModel(this.weight, this.date);

  Map<String, dynamic> toJson() {
    return {'weight':_weight, 'date': date};
  }
}