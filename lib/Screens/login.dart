import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trifit/utilities/Styles.dart';
import '../firebase/ApplicationState.dart';
import '../firebase/authentication.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 50),
            margin: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/images/trifit.png'),
                ),
                const SizedBox(height: 30),
                Consumer<ApplicationState>(
                  builder: (context, appState, _) => Authentication(
                    appState: appState,
                    email: appState.email,
                    loginState: appState.loginState,
                    startLoginFlow: appState.startLoginFlow,
                    verifyEmail: appState.verifyEmail,
                    signInWithEmailAndPassword:
                        appState.signInWithEmailAndPassword,
                    cancelRegistration: appState.cancelRegistration,
                    registerAccount: appState.registerAccount,
                    signOut: appState.signOut,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
