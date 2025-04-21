import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: FirebaseOptions(
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

  _createPerson(String name) {
    FirebaseFirestore.instance.collection("persons").add({
      'name' : name
    });
  }

  _deletePerson(String docId) {
    FirebaseFirestore.instance.collection("persons").doc(docId).delete();
  }

  Future<QuerySnapshot?> _getPerson() async {
    var persons = FirebaseFirestore.instance.collection("persons").get();
    return persons;
  }

  _createCloth(String docId, String type) {
    FirebaseFirestore.instance.collection("persons").doc(docId).collection("clothes").add({
      'type' : type
    });
  }

  Future<QuerySnapshot?> _getCloth(String docId) async {
    var clothes = FirebaseFirestore.instance.collection("persons").doc(docId).collection("clothes").get();
    return clothes;
  }

  late Future<QuerySnapshot?> persons;
  TextEditingController nameEditor = new TextEditingController();

  @override
  void initState() {
    super.initState();
    persons = _getPerson();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("test for firesbase/firestore"),),
      body: Center(
        child: Column(
          children: [
            TextField( controller: nameEditor,
              decoration: InputDecoration(label: Text("Name of person")),
            ),
            ElevatedButton(onPressed: () {
              if(nameEditor.text.isNotEmpty) {
                _createPerson(nameEditor.text);
                setState(() {
                  persons = _getPerson();
                  nameEditor.clear();
                });
              }
            }, child: Text("Add Person")),
            Container(
              width: double.infinity,
              height: 500,
              child: FutureBuilder(
                future: persons,
                builder: (context, snapshot) {

                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  var data = snapshot.data!.docs;

                  return ListView.builder( itemCount: data.length,
                      itemBuilder: (context, index) {
                    var mapData = data[index].data() as Map<String, dynamic>;
                    var personId = data[index].id;
                    return ListTile(
                      subtitle: IconButton(icon: Icon(Icons.delete), onPressed: () {
                        _deletePerson(personId);
                        setState(() {
                          persons = _getPerson();
                        });
                      },),
                      title: Text(mapData['name']),
                      leading: IconButton(icon: Icon(Icons.remove_red_eye), onPressed: () {
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: Text("All clothes"),
                            content: FutureBuilder(
                              future: _getCloth(personId),
                              builder: (context, snapshot) {
                                if(snapshot.connectionState == ConnectionState.waiting) {
                                  return Text("Waiting");
                                }

                                var itemData = snapshot.data!.docs;

                                return Container( height: 300, width: 200, child:
                                  ListView.builder( itemCount: itemData.length,
                                  itemBuilder: (context, index) {
                                  var itemMap = itemData[index].data() as Map<String, dynamic>;
                                  return ListTile(
                                    title: Text(itemMap['type']),
                                  );
                                },)
                                );
                              }
                            ),
                          );
                        });
                      },),
                      trailing: IconButton(icon: Icon(Icons.add), onPressed: () {
                        showDialog(context: context, builder: (context) {
                          TextEditingController type = TextEditingController();

                          return AlertDialog(
                            title: Text("add clothes"),
                            content: TextField(
                              controller: type,decoration: InputDecoration(label: Text("Type of clothes")),
                            ),
                            actions: [
                              ElevatedButton(onPressed: () {
                                if( type.text.isNotEmpty ) {
                                  _createCloth(personId, type.text);
                                  Navigator.pop(context);
                                }
                              }, child: Text("add Clothes"))
                            ],
                          );
                        });
                      },),
                    );
                  });

                },
              ),
            )
          ],
        ),
      ),
    );
  }
}



