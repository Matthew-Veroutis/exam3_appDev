import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

//these extra setting connect manifest to my phone
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AndroidInitializationSettings androidInitializationSettings =
  AndroidInitializationSettings("@mipmap/ic_launcher");

  InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotifactionDemo(),
    );
  }
}

class NotifactionDemo extends StatefulWidget {
  const NotifactionDemo({super.key});

  @override
  State<NotifactionDemo> createState() => _NotifactionDemoState();
}

class _NotifactionDemoState extends State<NotifactionDemo> {

  void showNotifaction() async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            "test_chanel_id",
            "test chanel",
            channelDescription: 'This is just a notification for testing purpose',
          importance: Importance.max,
            priority: Priority.high
        );

    NotificationDetails notificationDetails =
    NotificationDetails(android:  androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
        0, "TEST ME", "you tapped me tp display content", notificationDetails);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Welcome to Notifiactaion"),
            ElevatedButton(onPressed: showNotifaction, child: Text("notify me!!!"))
          ],
        ),
      ),
    );
  }
}
