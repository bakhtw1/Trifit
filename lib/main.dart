import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trifit/utilities/firebase_options.dart';
import 'Screens/login.dart';
import 'Screens/mainScreen.dart';
import 'utilities/Styles.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override

  @override
  Widget build(BuildContext context) {
    Future<User>? _calculation;
    try {
        _calculation = Future<User>.delayed(
        Duration(seconds: 0),
        () => FirebaseAuth.instance.currentUser!,
      );
    } catch (e) {
      _calculation = null;
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: MaterialColor(0xFFA545CC, trifitColor)),
      home: FutureBuilder<User>(
        future: _calculation,
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
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
