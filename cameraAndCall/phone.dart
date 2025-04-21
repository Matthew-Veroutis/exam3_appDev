import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyPhoneDemo(),
    );
  }
}

class MyPhoneDemo extends StatefulWidget {
  const MyPhoneDemo({super.key});

  @override
  State<MyPhoneDemo> createState() => _MyPhoneDemoState();
}

class _MyPhoneDemoState extends State<MyPhoneDemo> {

  Future<void> _makePhoneCall(String phoneNumber) async{
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'could not call $phoneUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Get me the access"),
            ElevatedButton(
                onPressed: () {
                  _makePhoneCall("+15146882776"); //+514451254
                },
                child: Text("Call Now"))
          ],
        ),
      ),
    );
  }
}

