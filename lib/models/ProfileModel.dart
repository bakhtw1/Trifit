class ProfileModel {
  late final String name;
  late final String weight;
  late final String age;
  late final String desiredWeight;
  late final String fitnessStyle;
  late final String height;
  late final String gender;

  ProfileModel(
    this.name,
    this.weight,
    this.age,
    this.desiredWeight,
    this.fitnessStyle,
    this.height,
    this.gender,
  );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'weight': weight,
      'age': age,
      'desiredWeight': desiredWeight,
      'fitnessStyle': fitnessStyle,
      'height': height,
      'gender': gender,
    };
  }
}
