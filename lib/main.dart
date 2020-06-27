import 'package:flutter/material.dart';
import 'package:IUApp/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IUApp',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
