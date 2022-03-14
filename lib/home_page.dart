// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> handleBackground(RemoteMessage remoteMessage) async {
  // TODO: Handle background message
  await Firebase.initializeApp();
  // Sample case update current location
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseMessaging fcm = FirebaseMessaging.instance;
  int balance = 10000;
  initFirebase() async {
    // Get token firebase nya lalu update data ke databse
    String? token = await fcm.getToken();
    fcm.subscribeToTopic("groupUdacoding"); // if using subscribe
    fcm.subscribeToTopic("groupIT"); // if using subscribe

    if (token != null) {
      // update ke database server dengan hit api dari backend
      log("Token Firebase => $token");
    }

    /// Get data from backend / Get push notif from backend
    /// When application is opened
    FirebaseMessaging.onMessage.listen((event) {
      log("Event onMessage => Title: ${event.notification?.title} Body : ${event.notification?.body}");
      handleTopUp(event);
    });

    /// When clicking notif and open the apps
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      log("Event onMessageOpenedApp => Title: ${event.notification?.title} Body : ${event.notification?.body}");
      handleScreen(event);
    });

    // When apps is in backgorund or closed
    // can't to trace
    FirebaseMessaging.onBackgroundMessage(handleBackground);
  }

  void handleScreen(RemoteMessage message) {
    if (message.data['type'] != null && message.data['type'] == 'ORDER') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => OrderScreen()));
    }
    if (message.data['type'] != null && message.data['type'] == 'TOPUP') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => TopupScreen()));
    }
  }

  void handleTopUp(RemoteMessage message) {
    log("Data => ${message.data}");
    if (message.data['balance'] != null) {
      int _totalTopup = int.parse(message.data['balance']);
      setState(() {
        balance = _totalTopup + balance;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Home Page"),
          Text("$balance"),
        ],
      )),
    );
  }
}

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text("Order Screen"),
    ));
  }
}

class TopupScreen extends StatelessWidget {
  const TopupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text("Topup Screen"),
    ));
  }
}
