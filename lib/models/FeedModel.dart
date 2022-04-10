import 'package:trifit/Screens/feed.dart';

class FeedModel {
  late final String desc;
  late final String img;

  FeedModel(this.desc, this.img);

  Map<String, dynamic> toJson() {
    return {'desc': desc, 'img': img};
  }
}
