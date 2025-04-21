import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Question1Page(score: 0));
  }
}

class Question1Page extends StatefulWidget {
  final int score;
  Question1Page({required this.score});

  @override
  _Question1PageState createState() => _Question1PageState();
}

class _Question1PageState extends State<Question1Page> {
  int? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Question 1")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("What is the capital of Canada?", style: TextStyle(fontSize: 18)),
            RadioListTile(
              title: Text("Toronto"),
              value: 0,
              groupValue: selectedOption,
              onChanged: (val) => setState(() => selectedOption = val),
            ),
            RadioListTile(
              title: Text("Ottawa"),
              value: 1,
              groupValue: selectedOption,
              onChanged: (val) => setState(() => selectedOption = val),
            ),
            RadioListTile(
              title: Text("Vancouver"),
              value: 2,
              groupValue: selectedOption,
              onChanged: (val) => setState(() => selectedOption = val),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: selectedOption != null
                  ? () {
                int updatedScore = selectedOption == 1 ? widget.score + 1 : widget.score;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Question2Page(score: updatedScore),
                  ),
                );
              }
                  : null,
              child: Text("Next"),
            )
          ],
        ),
      ),
    );
  }
}

class Question2Page extends StatefulWidget {
  final int score;
  Question2Page({required this.score});

  @override
  _Question2PageState createState() => _Question2PageState();
}

class _Question2PageState extends State<Question2Page> {
  int? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Question 2")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Which language is used in Flutter?", style: TextStyle(fontSize: 18)),
            RadioListTile(
              title: Text("Java"),
              value: 0,
              groupValue: selectedOption,
              onChanged: (val) => setState(() => selectedOption = val),
            ),
            RadioListTile(
              title: Text("Dart"),
              value: 1,
              groupValue: selectedOption,
              onChanged: (val) => setState(() => selectedOption = val),
            ),
            RadioListTile(
              title: Text("Kotlin"),
              value: 2,
              groupValue: selectedOption,
              onChanged: (val) => setState(() => selectedOption = val),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: selectedOption != null
                  ? () {
                int updatedScore = selectedOption == 1 ? widget.score + 1 : widget.score;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultPage(score: updatedScore),
                  ),
                );
              }
                  : null,
              child: Text("Finish"),
            )
          ],
        ),
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final int score;
  ResultPage({required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Score")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "You got $score out of 2 correct!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Question1Page(score: 0)),
                      (route) => false,
                );
              },
              child: Text("Retry Quiz"),
            ),
          ],
        ),
      ),
    );
  }
}