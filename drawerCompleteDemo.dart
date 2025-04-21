import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options:
  FirebaseOptions(
      apiKey: "AIzaSyAEt-TxwI8M-ujQhSw9TLu1p8kAawSW5Fo",
      appId: "599972547431",
      messagingSenderId: "599972547431",
      projectId: "exampratice33"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  Color homeTextColor = Colors.orange;
  //bmi
  double currentWeight = 50;
  double currentHeight = 150;
  String currentBMI = "UnKnown";

  //firebase
  late Future<QuerySnapshot> rooms;
  TextEditingController itemName = TextEditingController();

  @override
  void initState() {
    super.initState();
    rooms = _getRoomsFromFirebase();
  }

  Future<List> _ListFetchLocally() async {
    var response = await rootBundle.loadString("assets/json.json");
    var list = jsonDecode(response);
    return list as List;
  }


  Future<List> _ListFetchAPI() async {
    var response = await http.get(
      Uri.parse("https://jsonplaceholder.typicode.com/posts?_limit=4")
    );
    var list = jsonDecode(response.body);
    return list as List;
  }

  Map<String, dynamic> _convertListItemToMap(item) {
    return item as Map<String, dynamic>;
  }

  Future<QuerySnapshot> _getRoomsFromFirebase() {
    return FirebaseFirestore.instance.collection("rooms").get();
  }

  Future<QuerySnapshot> _getItemsFromFirebase(String id) {
    return FirebaseFirestore.instance.collection("rooms").doc(id).collection("items").get();
  }

  _addRoomsFromFirebase(String name) {
    FirebaseFirestore.instance.collection("rooms").add(
      {"name" : name }
    );
  }

  _addItemsFromFirebase(String id, String name) async {
    FirebaseFirestore.instance.collection('rooms').doc(id).collection("items").add(
        {'name' : name }
    );
  }


  _BuildBody(int index) {

    List buildBodyList = [
      Column(
        children: [
          DropdownMenu(
              dropdownMenuEntries: [
                DropdownMenuEntry(
                    value: 1, label: "Orange Color",
                ),
                DropdownMenuEntry(
                  value: 2, label: "Gray Color",
                ),
                DropdownMenuEntry(
                  value: 3, label: "purple Color",
                ),
                DropdownMenuEntry(
                  value: 4, label: "lime Color",
                ),
              ],
            onSelected: (index) {
                setState(() {
                  if (index == 1) {
                    homeTextColor = Colors.orange;
                  } else if (index == 2) {
                    homeTextColor = Colors.grey;
                  } else if (index == 3) {
                    homeTextColor = Colors.purple;
                  } else if (index == 4) {
                    homeTextColor = Colors.lime;
                  }
                });

            },
          ),
          Text("This is the home screen Use drawer to navigate", style: TextStyle(color: homeTextColor),),
        ],
      ),

      Column(
        children: [
          ElevatedButton(onPressed: () {
            setState(() {

            });
          }, child: Text("Reload")),
          Text("This is the Firebase database"),
          TextField(controller: itemName,
          decoration: InputDecoration(label: Text("Enter Item Name")),),
          ElevatedButton(onPressed: () {
            if(itemName.text.isNotEmpty) {
              _addRoomsFromFirebase(itemName.text);
              setState(() {
                rooms = _getRoomsFromFirebase();
                itemName.clear();
              });
            }
          }, child: Text("Add to firbase")),
          SizedBox(height: 20,),
          Expanded(child: FutureBuilder(
            future: rooms,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return Text("Waiting...");
            }

            var data = snapshot.data!.docs;
            
            return ListView.builder(
              itemCount: data.length,
                itemBuilder: (context, index) {
                  var mapData = data[index].data() as Map<String, dynamic>;
                  var roomId = data[index].id;
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26, width: 1)
                    ),
                    width: double.infinity,
                    height: 300,
                    child: Column(
                      children: [
                        ElevatedButton(onPressed: () {
                          showDialog(context: context, builder: (context) {
                            TextEditingController name = TextEditingController();
                            return AlertDialog(
                              title: Text("Add Items with Name:"),
                              content: TextField(controller: name,),
                              actions: [
                                ElevatedButton(onPressed: () {
                                  if(name.text.isNotEmpty) {
                                    _addItemsFromFirebase(roomId, name.text);
                                    setState(() {
                                      rooms = _getRoomsFromFirebase();
                                    });
                                    Navigator.pop(context);
                                  }
                                }, child: Text("Add Item"))
                              ],
                            );
                          });
                        } , child: Text("Add item to room")),
                        Text("name of room: ${mapData['name']}"),
                        Text("Id of room: $roomId"),
                        Text("All Items Below:"),
                        Expanded( child:  FutureBuilder(future: _getItemsFromFirebase(roomId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text("Waiting...");
                              }
                              var data = snapshot.data!.docs;

                              return ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  var mapData = data[index].data() as Map<
                                      String,
                                      dynamic>;

                                  return ListTile(title: Text(
                                      "Name of Item: ${mapData['name']}"),
                                    subtitle: Text(
                                        "Id of item: ${data[index].id}"),);
                                },
                              );
                            }
                        ),
                        ),
                        ElevatedButton(onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ItemScreen(roomId),));
                        }, child: Text("See Items on another Page"))
                      ],
                    ),
                  );
                },);
          },)),
          Text('END')
        ],
      ),

      Column(
        children: [
          Text("This is the API fetch"),
          Expanded(child: FutureBuilder(
            future: _ListFetchAPI(),
            builder: (context, snapshot) {
              var data = snapshot.data;
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Waiting ....");
              }

              if (snapshot.data!.isEmpty) {
                return Text("Its empty");
              }

              return ListView.builder(
                itemCount: data!.length,
                itemBuilder: (context, index) {
                  var mapData = _convertListItemToMap(data[index]);

                  return ListTile(
                    title: Text(mapData['title']),
                    subtitle: Text(mapData['id'].toString()),
                  );
                },);
            },
          ))
        ],
      ),

      Column(
        children: [
          Text("This is the Local Fetch"),
          Expanded(child: FutureBuilder(
            future: _ListFetchLocally(),
            builder: (context, snapshot) {
              var data = snapshot.data;
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Waiting ....");
              }

              if (snapshot.data!.isEmpty) {
                return Text("Its empty");
              }

              return ListView.builder(
                  itemCount: data!.length,
                  itemBuilder: (context, index) {
                    var mapData = _convertListItemToMap(data[index]);

                    return ListTile(
                      title: Text(mapData['title']),
                      subtitle: Text(mapData['id'].toString()),
                    );
                  },);
            },
          ))
        ],
      ),

      Column(
        children: [
          Text("This is the BMI Calculator"),
          SizedBox(height: 20,),
          Text("Use Slider for Weight:"),
          Text("Wight: ${currentWeight.toInt()} KG"),
          Slider(
            min: 30,
            max: 120,
            activeColor: Colors.red,
            value: currentWeight,
            onChanged: (value) {
              setState(() {
                currentWeight = value;
              });
          },),
          SizedBox(height: 20,),
          Text("Use Slider for Height:"),
          Text("Wight: ${currentHeight.toInt()} CM"),
          Slider(
            min: 100,
            max: 250,
            activeColor: Colors.black,
            value: currentHeight,
            onChanged: (value) {
              setState(() {
                currentHeight = value;
              });
            },),
          ElevatedButton(onPressed: () {
            setState(() {
              currentBMI = (currentHeight/currentWeight).toInt().toString();
            });
          }, child: Text("Click here to calculate new BMI")),
          Text("Current BMI is ${currentBMI}")
        ],
      ),
    ];

    return buildBodyList[index];
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Test Application"),),
      body: Center(
        child: _BuildBody(selectedIndex),
      ),

      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader( decoration: BoxDecoration(color: Colors.greenAccent),
                child: Container(
                  width: double.infinity,
                  child: Text("Header of drawer"),
                )),
            ListTile(title: Text("Homeeee"),
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                });
                Navigator.pop(context);
              },),
            ListTile(title: Text("for Firebase"),
            onTap: () {
              setState(() {
                selectedIndex = 1;
              });
              Navigator.pop(context);
            },),
            ListTile(title: Text("Fetch from API"),
              onTap: () {
                setState(() {
                  selectedIndex = 2;
                });
                Navigator.pop(context);
              },),
            ListTile(title: Text("Fetch Locally"),
              onTap: () {
                setState(() {
                  selectedIndex = 3;
                });
                Navigator.pop(context);
              },),
            ListTile(title: Text("BMI calculator"),
              onTap: () {
                setState(() {
                  selectedIndex = 4;
                });
                Navigator.pop(context);
              },),
          ],
        ),
      ),
    );
  }
}


class ItemScreen extends StatefulWidget {
  String id;
  ItemScreen(this.id);

  @override
  State<ItemScreen> createState() => _ItemScreenState(this.id);
}

class _ItemScreenState extends State<ItemScreen> {
  String id;
  late Future<QuerySnapshot> items;
  _ItemScreenState(this.id);

  @override
  void initState() {
    super.initState();
    items = FirebaseFirestore.instance.collection("rooms").doc(id).collection("items").get();
  }

  _updateItemName(String name, String ItemId) {
    FirebaseFirestore.instance.collection("rooms").doc(id).collection("items").doc(ItemId).update(
      {'name': name }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: items,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==  ConnectionState.waiting) {
            return Text("Waiting");
          }

          var data = snapshot.data!.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
            var mapData = data[index].data() as Map<String, dynamic>;

            return ListTile(title: Text(mapData['name'],),
            trailing: ElevatedButton(child: Text("Edit"), onPressed: () {
              showDialog(context: context, builder: (context) {
                TextEditingController nameEdditor = TextEditingController(text: mapData['name']);

                return AlertDialog(title: Text("Enter new Name"),
                content: TextField(controller: nameEdditor,),
                actions: [
                  ElevatedButton(onPressed: () {
                    if(nameEdditor.text.isNotEmpty) {
                      _updateItemName(nameEdditor.text, data[index].id);
                      setState(() {
                        items = FirebaseFirestore.instance.collection("rooms").doc(id).collection("items").get();
                      });
                      Navigator.pop(context);
                    }
                  }, child: Text("Update"))
                ],);
              });
            },),);
          },);
        },
      ),
    );
  }
}

