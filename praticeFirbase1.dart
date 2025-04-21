import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAEt-TxwI8M-ujQhSw9TLu1p8kAawSW5Fo",
      appId: "599972547431",
      messagingSenderId: "599972547431",
      projectId: "exampratice33",
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget content = const FirebaseScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Exam Application")),
      body: Center(child: content),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "This is header of drawer",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            ListTile(
              title: Text("for Firebase Database"),
              onTap: () {
                setState(() {
                  content = const FirebaseScreen();
                  Navigator.pop(context); // Close the drawer
                });
              },
            )
          ],
        ),
      ),
    );
  }
}

class FirebaseScreen extends StatefulWidget {
  const FirebaseScreen({super.key});

  @override
  State<FirebaseScreen> createState() => _FirebaseScreenState();
}

class _FirebaseScreenState extends State<FirebaseScreen> {
  TextEditingController type = TextEditingController();

  Future<List<QueryDocumentSnapshot>> _getAnimals() async {
    var snapshot = await FirebaseFirestore.instance.collection("animals").get();
    return snapshot.docs;
  }

  Future<void> _createAnimal(String type) async {
    await FirebaseFirestore.instance.collection("animals").add({"type": type});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("This is the Firebase screen"),
        SizedBox(height: 25),
        TextField(
          controller: type,
          decoration: InputDecoration(labelText: "Type of Animal"),
        ),
        ElevatedButton(
          onPressed: () {
            if (type.text.isNotEmpty) {
              _createAnimal(type.text);
              setState(() {
                type.clear();
              });
            }
          },
          child: Text("ADD"),
        ),
        SizedBox(height: 25),
        Text("All Animal record below"),
        Expanded(
          child: FutureBuilder<List<QueryDocumentSnapshot>>(
            future: _getAnimals(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No animals found."));
              }

              var data = snapshot.data!;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var animalData = data[index].data() as Map<String, dynamic>;
                  var animalId = data[index].id;
                  return ListTile(
                    title: Text(animalData['type']),
                    subtitle: Text(animalId),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      onPressed: () {
                        showDialog(context: context, builder: (context) {
                          Future<QuerySnapshot> rawData = FirebaseFirestore.instance.collection("animals").doc(animalId).collection("characteristics").get();
                          return AlertDialog(
                            title: Text("See Atributes of animl"),
                            content: Container(height: 500,
                              width: 300,
                              child: FutureBuilder(future: rawData, builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Text("Waiting...");
                                }

                                var data = snapshot.data!.docs;

                                return ListView.builder( itemCount: data.length,
                                  itemBuilder: (context, index) {
                                  var charData = data[index].data() as Map<String, dynamic>;

                                  return ListTile(title:  Text(charData['height']),);
                                },);
                              },),)

                          );
                        },);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}





//characteristics