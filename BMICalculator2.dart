import 'package:flutter/material.dart';

void main() => runApp(BMICalculatorApp());

class BMICalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BMICalculatorPage(),
    );
  }
}

class BMICalculatorPage extends StatefulWidget {
  const BMICalculatorPage({super.key});

  @override
  State<BMICalculatorPage> createState() => _BMICalculatorPageState();
}

class _BMICalculatorPageState extends State<BMICalculatorPage> {
  int selectedGender = 0;
  Color maleColor = Colors.black26;
  Color femaleColor = Colors.black26;
  Color selectedColor = Colors.black87;
  double currentHeight = 150;
  int currentAge= 20;
  int currentWeight = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BMI Calcualtor"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              SizedBox(width: 10,),
              GestureDetector( onTap: () {
                if(selectedGender == 0 || selectedGender == 2) {
                  setState(() {
                    selectedGender = 1;
                    maleColor = selectedColor;
                    femaleColor = Colors.black26;
                  });
                }
              }, child: Container(child: Icon(Icons.male,size: 50,), color: maleColor ,height: 200, width: 200,),),
              SizedBox(width: 10,),
              GestureDetector( onTap: () {
                if(selectedGender == 0 || selectedGender == 1) {
                  setState(() {
                    selectedGender = 2;
                    femaleColor = selectedColor;
                    maleColor = Colors.black26;
                  });
                }
              }, child: Container(child: Icon(Icons.female,size: 50,), color: femaleColor ,height: 200, width: 200,),),
            ],),
            SizedBox(height: 20,),
            Text("Height: ${currentHeight.toInt().toString()} CM"),
            Slider(
                value: currentHeight,
                min: 100,
                max: 200,
                onChanged: (val) {
                  setState(() {
                    currentHeight = val;
                  });
                }),
            Row( mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Container(child: Column(
              children: [
                Text('Weight'),
                Text(currentWeight.toString()),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [IconButton(onPressed: () {setState(() {
                  currentWeight--;
                });}, icon: Icon(Icons.exposure_minus_1)),
                  IconButton(onPressed: () {setState(() {
                  currentWeight++;
                });}, icon: Icon(Icons.add))],)
              ],
            ), color: Colors.black26 ,height: 200, width: 200,),
            SizedBox(width: 20,),
              Container(color: Colors.black26 ,height: 200, width: 200,),
            ],),

            ElevatedButton(onPressed: () {
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: Text("YOUR BMI IS ${currentHeight/currentWeight}"),
                );
              });
            }, child: Text("Calculate"))
          ],
        ),
      ),
    );
  }
}
