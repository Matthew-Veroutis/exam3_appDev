import 'package:flutter/material.dart';


void main() => runApp(BMICalculatorApp());

class BMICalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      home: BMICalculatorPage(),
    );
  }
}

enum Gender { male, female, other }

class BMICalculatorPage extends StatefulWidget {
  @override
  _BMICalculatorPageState createState() => _BMICalculatorPageState();
}

class _BMICalculatorPageState extends State<BMICalculatorPage> {
  Gender? selectedGender;
  double height = 180;
  int weight = 60;
  int age = 19;

  void calculateBMI() {
    double bmi = weight / ((height / 100) * (height / 100));
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Your BMI"),
        content: Text("Your BMI is ${bmi.toStringAsFixed(1)}"),
        actions: [
          TextButton(
            child: Text("Close"),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  Widget genderCard(Gender gender, IconData icon, String label) {
    bool isSelected = selectedGender == gender;
    return GestureDetector(
      onTap: () => setState(() => selectedGender = gender),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : Color(0xFF1D1E33),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, size: 60),
            SizedBox(height: 10),
            Text(label.toUpperCase()),
          ],
        ),
      ),
    );
  }

  Widget counterBox(String label, int value, VoidCallback onMinus, VoidCallback onPlus) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF1D1E33),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(label, style: TextStyle(color: Colors.white70)),
            Text('$value', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: onMinus, icon: Icon(Icons.remove_circle, size: 30)),
                IconButton(onPressed: onPlus, icon: Icon(Icons.add_circle, size: 30)),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("BMI CALCULATOR"), centerTitle: true),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(child: genderCard(Gender.male, Icons.male, "Male")),
              Expanded(child: genderCard(Gender.female, Icons.female, "Female")),
              Expanded(child: genderCard(Gender.other, Icons.transgender, "Others")),
            ],
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Color(0xFF1D1E33),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text("HEIGHT", style: TextStyle(color: Colors.white70)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(height.toInt().toString(), style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                    SizedBox(width: 5),
                    Text("cm", style: TextStyle(fontSize: 18)),
                  ],
                ),
                Slider(
                  value: height,
                  min: 100,
                  max: 220,
                  //divisions: 120,
                  // activeColor: Colors.blueAccent,
                  onChanged: (val) => setState(() => height = val),
                ),
              ],
            ),
          ),
          Row(
            children: [
              counterBox("WEIGHT (kg)", weight, () => setState(() => weight--), () => setState(() => weight++)),
              counterBox("AGE (years)", age, () => setState(() => age--), () => setState(() => age++)),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: calculateBMI,
            child: Container(
              color: Colors.blueAccent,
              height: 60,
              width: double.infinity,
              alignment: Alignment.center,
              child: Text("CALCULATE", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}