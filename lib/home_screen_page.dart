import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebase/add_users.dart';
import 'package:flutterfirebase/home_controller.dart';
import 'package:flutterfirebase/main.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  var controller = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String? title = message.notification?.title;
      String? body = message.notification?.body;
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
      // AwesomeNotifications().actionStream.listen((event) {
      //   if (event.buttonKeyPressed == "REJECT") {
      //     print("Call Rejected");
      //   } else if (event.buttonKeyPressed == "ACCEPT") {
      //     print("Call Accepted");
      //   } else {
      //     print("Clicked on notification");
      //   }
      // }
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(()=>AddUsers());
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Push Notification',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(onPressed: (){ controller.logout();}, icon: Icon(Icons.logout))
                ],
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: bodyController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Body',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  sendPushNotification();
                },
                child: Text('Send Notification'),
              ),
              SizedBox(height: 16.0),
              StreamBuilder<QuerySnapshot>(
                stream: controller.fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error fetching data.'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final data = snapshot.data?.docs ?? [];

                  return Flexible(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final userData = data[index].data() as Map<String, dynamic>?;
                        if (userData != null) {
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(userData['img'] ?? Image.asset('assets/logo')),
                            ),
                            title: Text(userData['name'] ?? 'Name not available'),
                            subtitle: Text(userData['email'] ?? 'Email not available'),
                          );
                        } else {
                          return ListTile(
                            title: Text('User data not available'),
                          );
                        }
                      },


                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> sendPushNotification() async {
    String title = titleController.text;
    String body = bodyController.text;
    try {
      http.Response response = await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=$firebaseServerKey',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            'condition': "'$appNickname' in topics || '$packageName' in topics",
          },
        ),
      );
      response;

      // Show SnackBar and clear text fields
      _scaffoldKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text('Notification send successfully!'),
        ),
      );
      titleController.clear();
      bodyController.clear();
    } catch (e) {
      e;
    }
  }
}
