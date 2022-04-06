import 'package:trifit/models/StepModel.dart';
import '../utilities/UtilityFunctions.dart';

enum Gender {
  male,
  female,
  unspecified
}

class UserModel {
  String uid;
  String name;
  String email;
  // List of uids for followers/following
  List<String> followers = [];
  List<String> following = [];
  DateTime registrationDate = simpleDate(DateTime.now());
  Gender gender = Gender.unspecified;
  String? age;
  String? weight;
  String? heightFeet;
  String? heightInches;

  UserModel(this.uid, this.name, this.email);

  dynamic toJson() => {
    'uid': uid,
    'name': name,
    'email': email,
    'followers': followers,
    'following': following,
    'registrationDate': registrationDate,
    'gender': gender.toString().split('.').last,
    'age': age,
    'weight': weight,
    'heightFeet': heightFeet,
    'heightInches': heightInches,
  };
}