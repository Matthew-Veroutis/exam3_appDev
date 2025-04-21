import 'package:flutter/material.dart';

import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyTaskPage(),
    );
  }
}

class Task {
  bool done;
  String description;

  Task(this.description, this.done);
}

class MyTaskPage extends StatefulWidget {
  const MyTaskPage({super.key});

  @override
  State<MyTaskPage> createState() => _MyTaskPageState();
}

class _MyTaskPageState extends State<MyTaskPage> {
  List<Task> allTasks = [];

  void _addTaskDialog() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add Task"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Enter task description"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              String desc = controller.text.trim();
              if (desc.isNotEmpty) {
                setState(() {
                  allTasks.add(Task(desc, false));
                });
              }
              Navigator.of(context).pop();
            },
            child: Text("Add"),
          )
        ],
      ),
    );
  }

  int _countDoneTasks() {
    return allTasks.where((task) => task.done).length;
  }

  void _markTaskAsDone(int index) {
    if (!allTasks[index].done) {
      setState(() {
        allTasks[index].done = true;
        allTasks[index].description += " (DONE)";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Manager"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _addTaskDialog,
              child: Text("Add Task"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: allTasks.length,
                itemBuilder: (context, index) {
                  final task = allTasks[index];
                  return ListTile(
                    title: Text(task.description),
                    trailing: ElevatedButton(
                      onPressed: () => _markTaskAsDone(index),
                      child: Text("Mark as Done"),
                    ),
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Tasks done: ${_countDoneTasks()} / ${allTasks.length}",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
