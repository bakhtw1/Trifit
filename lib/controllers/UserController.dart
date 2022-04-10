import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/ProfileModel.dart';

class UserController {
  var user;
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>
      userSubscription;

  UserController() {
    userSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen(
      (snapshot) {
        user = snapshot.data();
      },
    );
  }

  getUser() {
    var cleanedUser = {};
    user.forEach((k, v) {
      if (v == null) {
        cleanedUser[k] = '';
      } else {
        cleanedUser[k] = v;
      }
    });
    return cleanedUser;
  }

  updateUser(ProfileModel toUpdate) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(toUpdate.toJson());
  }
}
