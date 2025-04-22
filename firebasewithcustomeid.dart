import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';



import 'dart:convert';
import 'dart:io';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseOptions(
      apiKey: "AIzaSyBSzLYGs0iZE_rOV9nhBDnarV9Ismx3cgc",
      appId: "756022570023",
      messagingSenderId: "756022570023",
      projectId: "practice5-51f54")
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomeScreen(),
    );
  }
}

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}


class _MyHomeScreenState extends State<MyHomeScreen> {
  final Stream<QuerySnapshot> users = FirebaseFirestore.instance.collection("users").snapshots();


  _CreateUser(String name) async {
    try {
      // Get all documents in 'users' collection to determine the next user number
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("users").get();

      int userNumber = snapshot.docs.length + 1;
      String userId = "user$userNumber";

      // Check if userId already exists (to avoid overwriting)
      DocumentSnapshot existingUser = await FirebaseFirestore.instance.collection("users").doc(userId).get();
      if (existingUser.exists) {
        // If the ID exists, keep incrementing until you find an unused one
        while (existingUser.exists) {
          userNumber++;
          userId = "user$userNumber";
          existingUser = await FirebaseFirestore.instance.collection("users").doc(userId).get();
        }
      }

      // Create the user document with custom ID
      await FirebaseFirestore.instance.collection("users").doc(userId).set({
        'Name': name,
      });
    } catch (e) {
      print("Error creating user: $e");
    }
  }

  _CreateItem(String docId, String itemName) async {
    try {
      await FirebaseFirestore.instance.collection("users").doc(docId).collection("items").add({
        'ItemName' : itemName
      });
    } catch (e) {
      print(e);
    }
  }

  _DeleteItem(String docIdUser,String docIdItem) async {
    try {
      await FirebaseFirestore.instance.collection("users").doc(docIdUser).collection("items").doc(docIdItem).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<QuerySnapshot?> _GetItems(String docId) async {
    try {
      QuerySnapshot<Map<String,dynamic>> items = await FirebaseFirestore.instance.collection("users").doc(docId).collection("items").get();
      return items;
    } catch (e) {
      print(e);
    }
    return null;
  }

  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("App to add users and items"),
            TextField(controller: nameController, decoration: InputDecoration(label: Text("Name of User")),),
            ElevatedButton(onPressed: () {
              _CreateUser(nameController.text);
            }, child: Text("Add User")),

            Text("ALl Users Below"),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: users,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('STill Loading');
                  }

                  var docs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      var data = docs[index].data() as Map<String, dynamic>;
                      String docId = docs[index].id;
                      return ListTile(
                        title: Text(data['Name'] ?? 'Unnamed'),
                        trailing: ElevatedButton(
                          onPressed: () {
                            TextEditingController itemController = TextEditingController();

                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Add Item For this User"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: itemController,
                                        decoration: InputDecoration(labelText: "Item Name"),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        String itemName = itemController.text.trim();
                                        if (itemName.isNotEmpty) {
                                          _CreateItem(docId, itemName);
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: Text("Add Item"),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Cancel"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }, child: Text("Add items for person"),
                        ),
                        leading: ElevatedButton(onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("ALL items of a given user"),
                                content: FutureBuilder(
                                  future: _GetItems(docId),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return SizedBox(
                                        height: 100,
                                        child: Center(child: CircularProgressIndicator()),
                                      );
                                    }

                                    if (snapshot.hasError) {
                                      return Text("Error loading items");
                                    }

                                    if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
                                      return Text("No items found.");
                                    }

                                    final items = snapshot.data!.docs;

                                    return Container(
                                      height: 200,
                                      width: double.maxFinite,
                                      child: ListView.builder(
                                        itemCount: items.length,
                                        itemBuilder: (context, index) {
                                          final item = items[index].data() as Map<String, dynamic>;
                                          return ListTile(
                                            title: Text(item['ItemName'] ?? 'Unnamed Item'),
                                            trailing: ElevatedButton(onPressed: () {
                                              _DeleteItem(docId, items[index].id);
                                              Navigator.pop(context);
                                            }, child: Text("DELETE ITEM"), ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Close"),
                                  ),
                                ],
                              );
                            },
                          );


                        }, child: Text("See Items"),),

                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}