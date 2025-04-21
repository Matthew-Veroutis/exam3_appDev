import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentIndex = 0;

  final screens = [
    Center(child: Text("This is Home")),
    Center(child: Text("This is Add Screen")),
    Center(child: Text("This is Remove Screen")),
    Center(child: Text("This is Edit Screen")),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
              backgroundColor: Colors.blueGrey
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: "Add",
                backgroundColor: Colors.blueGrey
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.remove),
              label: "Remove",
                backgroundColor: Colors.blueGrey

            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit),
              label: "Edit",
                backgroundColor: Colors.blueGrey

            ),
          ],
        ),
      ),
    );
  }
}
