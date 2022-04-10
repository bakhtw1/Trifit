import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/ChallengeModel.dart';
import '../utilities/UtilityFunctions.dart';

class ChallengeController {
  var allChallenges = [];
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> challengeSubscription;

  ChallengeController() {
      challengeSubscription = FirebaseFirestore.instance
      .collection('challenges')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots()
      .listen((snapshot) {
        var data = snapshot.data();
        if (data != null) {
          allChallenges = data['challenges'];
        }
    });
  }

  addChallenge(ChallengeModel toAdd, DateTime date) async {
    FirebaseFirestore.instance
      .collection('challenges')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .update({
        "challenges": FieldValue.arrayUnion([toAdd.toJson()])
      });
  }

  getAllChallenges() {
    return allChallenges;
  }

}