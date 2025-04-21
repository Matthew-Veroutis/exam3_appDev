import 'package:flutter/material.dart';

enum Options {search, upload, copy, exit}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyPopupDemo(),
    );
  }
}

class MyPopupDemo extends StatefulWidget {
  const MyPopupDemo({super.key});

  @override
  State<MyPopupDemo> createState() => _MyPopupDemoState();
}

class _MyPopupDemoState extends State<MyPopupDemo> {
  var _popUpMenuItemIndex = 0;
  Color _ChangeColorAccordingToMenuItem = Colors.red;
  
  //lets customize the app bar as their is an action to be implemented
  var appBarHeight = AppBar().preferredSize.height;
  
  //now build the app bar
  _buildAppBar() {
    return AppBar(
      title: Text('Pop up Menus', style: TextStyle(color: Colors.white, fontSize: 16.0),),
      actions: [
        PopupMenuButton(
            onSelected: (value) {
              _onMenuItemSelected(value as int);
            },
            offset:  Offset(0.0, appBarHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0)
            ),
            itemBuilder: (context) => [
              _buildPopUpMenuItem ('Search',Icons.search, Options.search.index),
              _buildPopUpMenuItem ('Upload',Icons.upload, Options.upload.index),
              _buildPopUpMenuItem ('Copy',Icons.copy, Options.copy.index),
              _buildPopUpMenuItem ('Exit',Icons.exit_to_app, Options.exit.index),
            ])
      ],
    );
  }

  PopupMenuItem _buildPopUpMenuItem (String title, IconData icondata, int position) {
    return PopupMenuItem(
        value: position,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              icondata, color: Colors.black,
            ),
            Text(title),
          ],
        )
    );
  }

  //initiate the method to change color of the chosen item
  _onMenuItemSelected(int value) {
    setState(() {
      _popUpMenuItemIndex = value;
    });
    if(value == Options.search.index) {
      _ChangeColorAccordingToMenuItem = Colors.red;
    } else if(value == Options.upload.index) {
      _ChangeColorAccordingToMenuItem = Colors.limeAccent;
    } else if(value == Options.copy.index) {
      _ChangeColorAccordingToMenuItem = Colors.amber;
    } else {
      _ChangeColorAccordingToMenuItem = Colors.purpleAccent;
    }



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        color: _ChangeColorAccordingToMenuItem,
      ),
    );
  }


}

