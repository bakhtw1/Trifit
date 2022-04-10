import 'package:trifit/Screens/feed.dart';

class FeedModel {
  late final String desc;
  late final String img;

  FeedModel(this.desc, this.img);

  @override
  // String toString(){

  //   String feedString = "Meal type: "+mealType + "\nItems: \n";
  //   mealString += "Date: "+date.toString();
  // }

  Map<String, dynamic> toJson() {
    return {'desc': desc, 'img': img};
  }
}
