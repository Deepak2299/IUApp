import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:IUApp/method/firebase_methods.dart';
import 'package:IUApp/screens/home_screen.dart';
import 'package:IUApp/screens/signin_screen.dart';
import 'package:IUApp/screens/signup_screen.dart';

class CheckLoginScreen extends StatefulWidget {
  @override
  _CheckLoginScreenState createState() => _CheckLoginScreenState();
}

class _CheckLoginScreenState extends State<CheckLoginScreen> {
  FirebaseMethods firebaseMethods = FirebaseMethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: firebaseMethods.getCurrentUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            print("snapshot" + snapshot.data.runtimeType.toString());
            return HomeScreen(
              currentUser: snapshot.data,
            );
          } else {
            return SignInScreen();
          }
        },
      ),
    );
  }
}
