import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Screens/login.dart';
import 'Screens/mainScreen.dart';
import 'utilities/Styles.dart';
import 'firebase/ApplicationState.dart';
import 'firebase/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Future<User>? _calculation = Future<User>.delayed(
    Duration(seconds: 2),
    () => FirebaseAuth.instance.currentUser!,
  );
  // Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<User>(
        future: _calculation,
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          print(snapshot.hasData);
          if (snapshot.hasData) {
            return const MainScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
