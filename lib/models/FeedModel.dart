import 'package:trifit/Screens/feed.dart';

class FeedModel {
  late final String profileImageURL;
  late final String name;
  late final String desc;
  late final String img;
  late final DateTime date;

  FeedModel(this.name, this.desc, this.img, this.profileImageURL, this.date);

  @override
  // String toString(){

  //   String feedString = "Meal type: "+mealType + "\nItems: \n";
  //   mealString += "Date: "+date.toString();
  // }

  Map<String, dynamic> toJson() {
    return {
      'desc': desc,
      'img': img,
      'name': name,
      'profileImageUrl': profileImageURL,
      'date': date
    };
  }
}
