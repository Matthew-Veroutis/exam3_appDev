import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: SplashScreenDemo()
    );
  }
}

class SplashScreenDemo extends StatefulWidget {
  const SplashScreenDemo({super.key});

  @override
  State<SplashScreenDemo> createState() => _SplashScreenDemoState();
}

class _SplashScreenDemoState extends State<SplashScreenDemo> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => HomePage()))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //this child will create a default flutter logo
      child: FlutterLogo(size: MediaQuery.of(context).size.height,),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("HEYY MATTHEWWW"),
      ),
    );
  }
}
