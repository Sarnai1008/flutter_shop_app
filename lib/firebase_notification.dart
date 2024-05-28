import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseMessage {
  final firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotification() async {
    await firebaseMessaging.requestPermission();
    final FCMtoken = await firebaseMessaging.getAPNSToken();
    debugPrint('token notifition: $FCMtoken');

    FirebaseMessaging.instance.getInitialMessage().then(handleNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(handleNotification);
  }

  void handleNotification(RemoteMessage? msg) {
    if (msg == null) return;

    debugPrint('title: ${msg.notification?.title}');
    debugPrint('body: ${msg.notification?.body}');
  }
}
