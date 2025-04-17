import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/app/dream.dart';
import 'package:dream/model/dreams.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationHandler {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final NotificationHandler _singleton = NotificationHandler._internal();
  factory NotificationHandler() {
    return _singleton;
  }

  NotificationHandler._internal();

  BuildContext? myContext;
  initializeFcmNotification(BuildContext context) async {
    myContext = context;
    var initializationSettingAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettings = InitializationSettings(
      android: initializationSettingAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
    User? _currentUser = await FirebaseAuth.instance.currentUser;
    String? _token = await _fcm.getToken();
    if (_currentUser != null) {
      if (_token != null) {
        await FirebaseFirestore.instance
            .doc("tokens/" + _currentUser.uid)
            .set({"token": _token});
      }

      // Token yenilenirse tekrar kaydet
      _fcm.onTokenRefresh.listen((newToken) async {
        await FirebaseFirestore.instance
            .doc("tokens/" + _currentUser.uid)
            .set({"token": newToken});
      });
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      showNotification(message);

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  static void showNotification(RemoteMessage message) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        '1234', 'Rüyanız Cevaplandı',
        channelDescription: 'Görmek için tıklayınız',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
        message.notification?.body, platformChannelSpecifics,
        payload: jsonEncode(message.data));
  }

  Future<void> onDidReceiveNotificationResponse(
      NotificationResponse response) async {
    String? payload = response.payload;
    if (payload != null) {
      debugPrint("notification payload: $payload");
      Map<String, dynamic> responseNotification = jsonDecode(payload);
      String email = responseNotification["email"];
      String userID = responseNotification["usersID"];
      String content = responseNotification["content"];
      String userName = responseNotification["userName"];
      String request = responseNotification['request'];
      String dreamID = responseNotification['dreamID'];

      Dreams notifDream = Dreams(
        email: email,
        usersID: userID,
        content: content,
        userName: userName,
        request: request,
        dreamID: dreamID,
        point: 0,
      );

      Navigator.of(myContext!, rootNavigator: false).push(
        MaterialPageRoute(
          builder: ((context) => Dream(
                oneDream: notifDream,
              )),
        ),
      );
    }
  }

  Future onSelectNotification(String? payload) async {
    if (payload != null) {
      debugPrint("notification payload" + payload);
      Map<String, dynamic> responseNotification = await jsonDecode(payload);
      String email = responseNotification["email"];
      String userID = responseNotification["usersID"];
      String content = responseNotification["content"];
      String userName = responseNotification["userName"];
      String request = responseNotification['request'];
      String dreamID = responseNotification['dreamID'];
      Dreams notifDream = Dreams(
          email: email,
          usersID: userID,
          content: content,
          userName: userName,
          request: request,
          dreamID: dreamID,
          point: 0);
      Navigator.of(myContext!, rootNavigator: false).push(
        MaterialPageRoute(
          builder: ((context) => Dream(
                oneDream: notifDream,
              )),
        ),
      );
    }
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {}
}
