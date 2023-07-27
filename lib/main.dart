import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebase/splash_screen.dart';
import 'package:get/get.dart';

import 'home_screen_page.dart';


const String firebaseServerKey = 'AAAA7cb38uc:APA91bEh6TZNQhlDkrGBrO9OQa_UA_5WJRE6_YlNXbptVta0Q-IeyLIy68EfQRZ7b7CkVCindgV8szxalP8PKaB6UDWVdNQgk-E9tNxK5g7sOwJo0iBqPAv4GZWPVSlX358IOtkQ5c4M';
const String appNickname = 'ff';
const String packageName = 'com.example.flutterfirebase';

Future<void> backgroundHandler(RemoteMessage message) async {
  String? title = message.notification?.title;
  String? body = message.notification?.body;
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 123,
      channelKey: "call_channel",
      color: Colors.white,
      title: title,
      body: body,
      category: NotificationCategory.Call,
      wakeUpScreen: true,
      fullScreenIntent: true,
      autoDismissible: false,
      backgroundColor: Colors.orange,
    ),
    actionButtons: [
      NotificationActionButton(
        key: "ACCEPT",
        label: "Accept Call",
        color: Colors.green,
        autoDismissible: true,
      ),
      NotificationActionButton(
        key: "REJECT",
        label: "Reject Call",
        color: Colors.red,
        autoDismissible: true,
      ),
    ],
  );
}

void main() async {
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: "call_channel",
        channelName: "Call Channel",
        channelDescription: "Channel of calling",
        defaultColor: Colors.redAccent,
        ledColor: Colors.white,
        importance: NotificationImportance.Max,
        channelShowBadge: true,
        locked: true,
        defaultRingtoneType: DefaultRingtoneType.Ringtone,
      )
    ],
  );
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.subscribeToTopic(packageName);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  Widget build(BuildContext context) {
    _firebaseMessaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received notification: ${message.notification?.title}');
    });
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Liquid Shrink SideMenu',
      home: SplashScreen(),
    );
  }
}

