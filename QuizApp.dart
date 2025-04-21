import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Question1(0),
    );
  }
}

class Question1 extends StatefulWidget {
  int numRightQuestions;

  Question1(this.numRightQuestions);


  @override
  State<Question1> createState() => _Question1State(this.numRightQuestions);
}

class _Question1State extends State<Question1> {
  int numRightQuestions;

  _Question1State(this.numRightQuestions);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("TEST APPLICATION"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("What is the capital of Candada"),
            ElevatedButton(onPressed: () {
              numRightQuestions++;
              Navigator.push(context, MaterialPageRoute(builder: (context) => Question2(numRightQuestions)));
            }, child: Text("OTTWAA")),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Question2(numRightQuestions)));
            }, child: Text("Montreal")),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Question2(numRightQuestions)));
            }, child: Text("Toronto")),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Question2(numRightQuestions)));
            }, child: Text("Calgary")),
            SizedBox(height: 10,),
          ]
          ,
        ),
      ),
    );
  }
}

class Question2 extends StatefulWidget {
  int numRightQuestions;

  Question2(this.numRightQuestions);


  @override
  State<Question2> createState() => _Question2State(this.numRightQuestions);
}

class _Question2State extends State<Question2> {
  int numRightQuestions;

  _Question2State(this.numRightQuestions);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("TEST APPLICATION"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("What is Prime minister of canada"),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Question3(numRightQuestions)));
            }, child: Text("Justin BIBER")),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Question3(numRightQuestions)));
            }, child: Text("Justin treadeau")),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: () {
              numRightQuestions++;
              Navigator.push(context, MaterialPageRoute(builder: (context) => Question3(numRightQuestions)));
            }, child: Text("Mark Carny")),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Question3(numRightQuestions)));
            }, child: Text("Joe Biden")),
            SizedBox(height: 10,),

          ]
          ,
        ),
      ),
    );
  }
}


class Question3 extends StatefulWidget {
  int numRightQuestions;

  Question3(this.numRightQuestions);


  @override
  State<Question3> createState() => _Question3State(this.numRightQuestions);
}

class _Question3State extends State<Question3> {
  int numRightQuestions;

  _Question3State(this.numRightQuestions);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("TEST APPLICATION"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Is Canada the bigeest country in the world ?"),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Question4(numRightQuestions)));
            }, child: Text("IDK")),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: () {
              numRightQuestions++;
              Navigator.push(context, MaterialPageRoute(builder: (context) => Question4(numRightQuestions)));
            }, child: Text("NO")),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Question4(numRightQuestions)));
            }, child: Text("YES")),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Question4(numRightQuestions)));
            }, child: Text("Maybe")),
            SizedBox(height: 10,),

          ]
          ,
        ),
      ),
    );
  }
}


class Question4 extends StatefulWidget {
  int numRightQuestions;

  Question4(this.numRightQuestions);


  @override
  State<Question4> createState() => _Question4State(this.numRightQuestions);
}

class _Question4State extends State<Question4> {
  int numRightQuestions;

  _Question4State(this.numRightQuestions);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("TEST APPLICATION"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("How many people dose canada have"),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => finalPage(numRightQuestions)));
            }, child: Text("10 Million")),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => finalPage(numRightQuestions)));
            }, child: Text("20 Million")),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => finalPage(numRightQuestions)));
            }, child: Text("30 MIllion")),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: () {
              numRightQuestions++;
              Navigator.push(context, MaterialPageRoute(builder: (context) => finalPage(numRightQuestions)));
            }, child: Text("40 Million")),
            SizedBox(height: 10,),

          ]
          ,
        ),
      ),
    );
  }
}

class finalPage extends StatefulWidget {
  int rightQuestions;
  finalPage(this.rightQuestions);

  @override
  State<finalPage> createState() => _finalPageState(this.rightQuestions);
}

class _finalPageState extends State<finalPage> {
  int rightQuestions;
  _finalPageState(this.rightQuestions);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("TEST APPLICATION"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("You got $rightQuestions Questions Right"),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Question1(0)));
            },
            child: Text("Click here to try again"),),

          ],
        ),
      ),
    );
  }
}




