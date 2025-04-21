import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyCameraDemo(),
    );
  }
}

class MyCameraDemo extends StatefulWidget {
  const MyCameraDemo({super.key});

  @override
  State<MyCameraDemo> createState() => _MyCameraDemoState();
}

class _MyCameraDemoState extends State<MyCameraDemo> {
  
  //create a file instance to store the pic that is taken by the camera
  File? cameraFile;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  
  Future<void> selectFromCamera() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? pickedFile = await imagePicker.
    pickImage(source: ImageSource.camera);
    if(pickedFile != null) {
      setState(() {
        cameraFile = File(pickedFile.path);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: selectFromCamera, 
                child: Text("Select Image")),
            SizedBox(height: 10,),
            SizedBox(
              height: 200,
              width: 300,
              child: cameraFile == null 
              ? Center(child: Text("NO PICTURE IS STORED"),)
              : Image.file(cameraFile!)
            )
          ],
        ),
      ),
    );
  }
}

