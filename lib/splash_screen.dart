import 'package:flutter/material.dart';
import 'package:IUApp/check_login_screen.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => CheckLoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.blue,
              Colors.deepPurple,
              Colors.deepPurpleAccent
            ])),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Shimmer.fromColors(
                  baseColor: Colors.white,
                  highlightColor: Colors.deepPurpleAccent,
                  enabled: true,
                  child: Text('IUApp',
                      style: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.white))),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
