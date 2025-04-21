import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local API Fetch Demo',
      debugShowCheckedModeBanner: false,
      home: LocalApiScreen(),
    );
  }
}

class LocalApiScreen extends StatefulWidget {
  const LocalApiScreen({super.key});

  @override
  State<LocalApiScreen> createState() => _LocalApiScreenState();
}

class _LocalApiScreenState extends State<LocalApiScreen> {
  Future<List> _fetchLocalJson() async {
    final String response = await rootBundle.loadString('assets/json.json');
    return jsonDecode(response) as List;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Local API Data')),
      body: FutureBuilder<List>(
        future: _fetchLocalJson(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text('Failed to load data'));
          }

          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index] as Map<String, dynamic>;
              return ListTile(
                leading: CircleAvatar(child: Text(item['id'].toString())),
                title: Text(item['title']),
              );
            },
          );
        },
      ),
    );
  }
}
