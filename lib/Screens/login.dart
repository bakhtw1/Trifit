import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trifit/Screens/home.dart';
import 'package:trifit/Screens/mainScreen.dart';
import 'package:trifit/models/UserModel.dart';
import 'package:trifit/utilities/Styles.dart';
import '../firebase/ApplicationState.dart';
import '../firebase/authentication.dart';

enum LoginState {
  main,
  signin,
  signup,
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  LoginState loginState = LoginState.main;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        toolbarHeight: 30,
        leading: loginState != LoginState.main
            ? IconButton(
                onPressed: () {
                  setState(() {
                    loginState = LoginState.main;
                  });
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 24
                ),
              )
            : const Text(""),
      ),
      backgroundColor: bgColor,
      body: Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(left: 8, right: 8),
            margin: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/trifit.png'),
                  const SizedBox(height: 50),
                  if (loginState == LoginState.main)
                    Column(
                      children: [
                        Container(
                          width: 150,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(trifitColor[900]),
                            ),
                            onPressed: () {
                              setState(() {
                                loginState = LoginState.signin;
                              });
                            },
                            child: const Text(
                              'SIGN IN',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
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
                              setState(() {
                                loginState = LoginState.signup;
                              });
                            },
                            child: const Text(
                              'SIGN UP',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                  else if (loginState == LoginState.signin)
                    const LoginForm()
                  else if (loginState == LoginState.signup)
                    const SignupForm()
                  // const LoginForm()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Create a Form widget.
class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class LoginFormState extends State<LoginForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<LoginFormState>.
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: loginFormColor,
                  ),
              style: const TextStyle(color: Colors.white),
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Invalid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: loginFormColor,
                  ),
              style: const TextStyle(color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text);
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ),
                        );
                      } on FirebaseAuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Container(
                              height: 20,
                              child: Center(
                                child: Text("Failed to sign in: " + authErrorToString(e)),
                              ),
                            ),
                            backgroundColor: trifitColor[900],
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('LOG IN'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  String authErrorToString(FirebaseAuthException e) {
    if (e.code == "user-not-found") {
      return "User not found";
    } else if (e.code == "wrong-password") {
      return "Incorrect password";
    } else {
      return e.code;
    }
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  SignupFormState createState() {
    return SignupFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class SignupFormState extends State<SignupForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<LoginFormState>.
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(
                  hintText: "Name",
                  hintStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: loginFormColor,
                  ),
              style: const TextStyle(color: Colors.white),
              controller: nameController,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: loginFormColor,
                  ),
              style: const TextStyle(color: Colors.white),
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: loginFormColor,
                  ),            style: const TextStyle(color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 6) {
                  return 'Password must be 6 or more characters';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      String? error = await registerAccount(
                          emailController.text,
                          nameController.text,
                          passwordController.text);
      
                      if (error == null) {
                        await createUserEntry(FirebaseAuth.instance.currentUser!.uid, emailController.text, nameController.text);
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Container(
                              height: 20,
                              child: Center(
                                child: Text('Failed to register user: ' + error, style: TextStyle(fontSize: 12)),
                              ),
                            ),
                            backgroundColor: trifitColor[900],
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('REGISTER'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> registerAccount(
      String email, String displayName, String password) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(displayName);
      return null;
    } on FirebaseAuthException catch (e) {
      return authErrorToString(e);
    }
  }
  
  Future<String?> createUserEntry (String uid, String email, String name) async {
    try {
      await FirebaseFirestore.instance
        .collection('users')
        // Using .doc(uid).set lets us define the document to have an ID that is the same as the uid
        // This should make it easier to lookup user data later on
        .doc(uid)
        .set(UserModel(uid, name, email).toJson());
    } catch (e) {
      return e.toString();
    } 
    try {
      await FirebaseFirestore.instance
        .collection('meals')
        .doc(uid)
        .set({"meals": []});
    } catch (e) {
      return e.toString();
    } 
    try {
      await FirebaseFirestore.instance
        .collection('exercise')
        .doc(uid)
        .set({"workouts": []});
    } catch (e) {
      return e.toString();
    } 
    return null;
  }

  String authErrorToString(FirebaseAuthException e) {
    if (e.code == "email-already-in-use") {
      return "Email address already in use.";
    } else if (e.code == "invalid-email") {
      return "Invalid email";
    } else {
      return e.code;
    }
  }
}
