import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utilities/Styles.dart';
import 'firebase/ApplicationState.dart';
import 'firebase/authentication.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: (context, _) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ApplicationLoginState loginState;
    return MaterialApp(
      title: 'Flutter Demo',
      // theme: ThemeData(primarySwatch: MaterialColor(0xFFA545CC, trifitColor)),
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      home: Consumer<ApplicationState>(
        builder: (context, appState, _) => Authentication(
          appState: appState,
          email: appState.email,
          loginState: appState.loginState,
          startLoginFlow: appState.startLoginFlow,
          verifyEmail: appState.verifyEmail,
          signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
          cancelRegistration: appState.cancelRegistration,
          registerAccount: appState.registerAccount,
          signOut: appState.signOut,
        ),
      ),
    );
  }
}
