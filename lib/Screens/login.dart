import 'package:flutter/material.dart';
import 'package:trifit/utilities/Styles.dart';
import '../firebase/ApplicationState.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key, required this.appState}) : super(key: key);
  ApplicationState appState;

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
                Container(
                  width: 150,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(trifitColor[900]),
                    ),
                    onPressed: () {
                      appState.startLoginFlow();
                    },
                    child: const Text(
                      'Login / Sign Up',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
