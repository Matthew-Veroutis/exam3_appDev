import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    home: MyDateTimePicker()
    );
  }
}

class MyDateTimePicker extends StatefulWidget {
  const MyDateTimePicker({super.key});

  @override
  State<MyDateTimePicker> createState() => _MyDateTimePickerState();
}

class _MyDateTimePickerState extends State<MyDateTimePicker> {
  DateTime currentDate = DateTime.now();

  Future<void> _selectedDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
        initialDate: currentDate,
        context: context, firstDate: DateTime(2010), lastDate: DateTime(2030));
    if(pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column (
          children: [
            Text(currentDate.toString()),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: () => _selectedDate(context), child: Text("Choose Date"))
          ],
        ),
      ),
    );
  }
}

