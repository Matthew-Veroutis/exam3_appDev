import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

Future<List?> _fetchFromApi() async{
  http.Response response = await http.get(
    Uri.parse("https://jsonplaceholder.typicode.com/posts?_limit=3")
  );

  if( response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return data;
  }
}
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: FutureBuilder(
          future: _fetchFromApi(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return Text("loading...");
            }

            var list = snapshot.data;

            return ListView.builder(
            itemCount: list!.length,
            itemBuilder: (context, index) {
              var map = list[index] as Map<dynamic, dynamic>;
              return ListTile(
                title: Text(map["id"].toString()),
                subtitle: Text(map["title"].toString()),
              );
            },);
          },
        )
        
      ),
    );
  }
}

