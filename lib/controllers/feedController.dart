import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trifit/models/FeedModel.dart';
import '../models/MealModel.dart';
import '../utilities/UtilityFunctions.dart';

class FeedController {
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>
      feedSubscription;
  var allFeeds = [];

  FeedController() {
    feedSubscription = FirebaseFirestore.instance
        .collection('feeds')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((snapshot) {
      var data = snapshot.data();
      if (data != null) {
        allFeeds = data['feeds'];
      }
    });
  }

  getAllFeeds() async {
    allFeeds = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('feeds').get();
    // Get data from docs and convert map to List
    List<dynamic> mapped = querySnapshot.docs.map((doc) => doc.data()).toList();
    for (var list in mapped) {
      if (list["feeds"] != null) {
        allFeeds.addAll(list["feeds"]);
      }
    }
    return allFeeds;
  }

  addFeed(FeedModel toAdd) async {
    FirebaseFirestore.instance
        .collection('feeds')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "feeds": FieldValue.arrayUnion([toAdd.toJson()])
    });
  }

  getFeed() {
    var feelist = [];
    for (int i = 0; i < allFeeds.length; i++) {
      feelist = allFeeds[i].desc;
    }
    return feelist;
  }
}
