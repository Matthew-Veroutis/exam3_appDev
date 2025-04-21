import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';



class Post {
  String userId;
  String id;
  String title;
  String body;
  
  Post(this.userId, this.id, this.title, this.body);
  @override
  String toString() {
    return "id: $id, Title: $title";
  }
}


Future<List<Post>> _fetchFromApi() async {
  http.Response response = await http.get( Uri.parse("https://jsonplaceholder.typicode.com/posts?_limit=5") );
  List<Post> posts = [];

  if(response.statusCode == 200) {
    List data = jsonDecode(response.body);
     for(int i = 0; i < data.length; i++) {
       var singleData = data[i] as Map<String, dynamic>;
       posts.add(new Post(singleData['userId'].toString(),singleData['id'].toString(),singleData['title'],singleData['body']));
     }
  }
  return posts;
}


Future<List<Post>> _fetchLocaly() async {
  var response = await rootBundle.loadString("assets/json.json");
  print(response);
  List data = await jsonDecode(response);
  print(data);
  List<Post> posts = [];

  for(int i = 0; i < data.length; i++) {
    var singleData = data[i] as Map<String, dynamic>;
    posts.add(new Post(singleData['userId'].toString(),singleData['id'].toString(),singleData['title'],singleData['body']));
  }

  return posts;



}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   // var list = await _fetchFromApi();
   //
  print("zddfhssdfsdfs\n\n\n\nn\n\\nn\\n\n\n\n\n\n");
   var list = await _fetchLocaly();
   for(int i = 0; i < list.length; i++ ) {
     print("\n ${list[i]}");
   }
}