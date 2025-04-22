import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options :
      FirebaseOptions(apiKey: "AIzaSyAy-MbsSswDwqsA-CNXrMXpWEMKq1ZXyf4",
          appId: "531177743873",
          messagingSenderId: "531177743873",
          projectId: "assignment03-e9559"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homeScreen(),
    );
  }
}

class homeScreen extends StatefulWidget {
  homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assignment 3"),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Text("use drawer to navigate"),
      ),

        drawer: Drawer(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.orange,
                child: Column(
                  children: [
                    SizedBox(height: 30,),
                    ClipOval(
                      child: Image.network(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSvz44t4SeyrSEtAEJQAoBemkpT3bkGDTmMvw&s",
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 25),
                    Text(
                      "Flutter",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              ),
              ListTile(leading: Icon(Icons.person), title: Text("Profile"), trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FirestorePage()));
              },),
              Container(width: double.infinity,height: 1,decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1)),),
              ListTile(leading: Icon(Icons.notifications), title: Text("Notifications"), trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage()));
              },),
              Container(width: double.infinity,height: 1,decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1)),),
              ListTile(leading: Icon(Icons.settings), title: Text("Setting"), trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
              },),
              Container(width: double.infinity,height: 1,decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1)),),
              ListTile(leading: Icon(Icons.lock), title: Text("Log Out"), trailing: Icon(Icons.arrow_right),
              onTap: () {

              },),
            ],
          ),
        ),
    );
  }
}


class FirestorePage extends StatefulWidget {
  FirestorePage({super.key});

  @override
  State<FirestorePage> createState() => _FirestorePageState();
}

class Tasks {
  String title;
  DateTime created;
  Tasks(this.title, this.created);
}

class _FirestorePageState extends State<FirestorePage> {

  Future<QuerySnapshot?> getTasks() async{
    try {
      var tasks =  FirebaseFirestore.instance.collection("tasks").get();
      return tasks;
    } catch (e) {
      print(e);
    }
  }

  insertTasks(String docId, String title) async {
    try {
      await FirebaseFirestore.instance.collection("tasks").doc(docId).set(
          {'created': Timestamp.now(),
          'title' : title});
    } catch (e) {
      print(e);
    }
  }

  updateTasks(String docId, String title) async {
    try {
      await FirebaseFirestore.instance.collection("tasks").doc(docId).update(
          {'title' : title});
    } catch (e) {
      print(e);
    }
  }

  deleteTasks(String docId) async {
    try {
       await FirebaseFirestore.instance.collection("tasks").doc(docId).delete();
    } catch (e) {
      print(e);
    }
  }

  TextEditingController taskController = TextEditingController();
  late Future<QuerySnapshot?> tasks;
  int Highest = 0;

  @override
  void initState() {
    super.initState();
    tasks = getTasks();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cloud Firestore Page"),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [

          Expanded(
            child: FutureBuilder(
              future: tasks,
            builder: (context,snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading.....");
                }

                var data = snapshot.data!.docs;

                return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        if(int.parse(data[index].id) > Highest) {
                          Highest = int.parse(data[index].id);
                        }
                        var singleData = data[index].data() as Map<String, dynamic>;
                        return GestureDetector(child:
                          ListTile(
                          title: Text(singleData['title']),
                          subtitle: Text((singleData['created'] as Timestamp).toDate().toString()),
                          trailing: IconButton(icon: Icon(Icons.delete), onPressed: () {
                            deleteTasks(data[index].id);
                            setState(() {
                              tasks = getTasks();
                            });
                          },),
                          onTap: () {
                            showDialog(context: context, builder: (context) {
                              TextEditingController update = TextEditingController();
                              return AlertDialog(
                                title: Text("Update Title"),
                                content: TextField(controller: update,
                                decoration: InputDecoration(label: Text("New title"),),
                                ),
                                actions: [
                                  ElevatedButton(onPressed: () {
                                    Navigator.pop(context);
                                  }, child: Text("Cancel")),
                                  ElevatedButton(onPressed: () {
                                    if(update.text.isNotEmpty) {
                                      updateTasks(data[index].id, update.text);
                                    }
                                    setState(() {
                                      tasks = getTasks();
                                    });
                                    Navigator.pop(context);
                                  }, child: Text("update")),
                                ],

                              );
                            });
                          },
                              )

                        );
                      },
                );
            })
          ),

          // Bottom task input
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: InputDecoration(
                      label: Text("Task Name")
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white
                  ),
                  onPressed: () {
                    if(taskController.text.isNotEmpty) {
                      insertTasks((++Highest).toString(), taskController.text);
                    }
                    taskController.clear();
                    setState(() {
                      tasks = getTasks();
                    });
                  },
                  child: Text('ADD'),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}


class NotificationPage extends StatefulWidget {
  NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final List<Map<String, dynamic>> books = [
    {
      'title': 'Coffeehouse',
      'mrp': 1500,
      'price': 1,
      'image': 'https://m.media-amazon.com/images/I/71AyA3-hH2L._AC_UF1000,1000_QL80_.jpg',
    },
    {
      'title': 'Taming Jaguar',
      'mrp': 1500,
      'price': 550,
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRp71pknn6patnJp4fS-0LGy5ZfVka600nZRA&s',
    },
    {
      'title': 'Jaguar Development with PowerBuilder 7',
      'mrp': 1500,
      'price': 250,
      'image': 'https://images.manning.com/book/0/e00ed1e-1380-4b2b-a8c8-ccd10296d5b4/barlotta2.jpg',
    },
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredBooks = books
        .where((book) => book['title']
        .toString()
        .toLowerCase()
        .contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Book Store'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search here',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredBooks.length,
              itemBuilder: (context, index) {
                final book = filteredBooks[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                            book['image'],
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                      ),

                        SizedBox(width: 12),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(book['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("50%", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                          Text("OFF", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "M.R.P: \$${book['mrp']}",
                                    style: TextStyle(decoration: TextDecoration.lineThrough),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text("Price: \$${book['price']}", style: TextStyle(color: Colors.red)),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  final player = AudioPlayer();

  void playSound(int soundNumber) {
    player.play(AssetSource('sound$soundNumber.wav'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Xylophone'),
      backgroundColor: Colors.orange,),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: TextButton(
              onPressed: () => playSound(1),
              style: TextButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero,),),
              child: SizedBox.shrink(),
            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: () => playSound(2),
              style: TextButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero,),),
              child: SizedBox.shrink(),
            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: () => playSound(3),
              style: TextButton.styleFrom(backgroundColor: Colors.yellow, shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero,),),
              child: SizedBox.shrink(),
            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: () => playSound(4),
              style: TextButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero,),),
              child: SizedBox.shrink(),
            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: () => playSound(5),
              style: TextButton.styleFrom(backgroundColor: Colors.teal, shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero,),),
              child: SizedBox.shrink(),
            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: () => playSound(6),
              style: TextButton.styleFrom(backgroundColor: Colors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero,),),
              child: SizedBox.shrink(),
            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: () => playSound(7),
              style: TextButton.styleFrom(backgroundColor: Colors.purple, shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero,),),
              child: SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}


