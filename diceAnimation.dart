import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DiceAnimation()
    );
  }
}

class DiceAnimation extends StatefulWidget {
  const DiceAnimation({super.key});

  @override
  State<DiceAnimation> createState() => _DiceAnimationState();
}

class _DiceAnimationState extends State<DiceAnimation> {
int leftNumber = 1;
int rightNumber = 1;

void setDice() {
  setState(() {
    leftNumber = Random().nextInt(6) +1;
    rightNumber = Random().nextInt(6) +1;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Row(
          children: [
            TextButton(onPressed:  setDice, child: Image.asset('assets/dice$leftNumber.png')),
            TextButton(onPressed: setDice, child: Image.asset('assets/dice$rightNumber.png')),
          ],
        ),
      ),

    );
  }
}
