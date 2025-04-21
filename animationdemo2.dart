import 'package:flutter/material.dart';
import 'dart:math';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: AnimationDemo2()
    );
  }
}

class AnimationDemo2 extends StatefulWidget {
  const AnimationDemo2({super.key});

  @override
  State<AnimationDemo2> createState() => _AnimationDemoState2();
}

//SingleTickerProviderStateMixin is the animation controller that converts the state to animated
class _AnimationDemoState2 extends State<AnimationDemo2> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(seconds: 3),
        vsync: this) ..repeat(reverse: true);
    // .. is cascading operator that continaslty calls the function

    _animation = Tween<double>(begin: 0, end: 300).animate(
      CurvedAnimation(parent: _controller, curve: Curves.bounceOut)
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animation ball movement"),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            // call the transform function to give value to the ball movement
            return Transform.translate(offset: Offset(0,_animation.value),
              child: child,);
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.redAccent,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
