import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:vutha_admin_app/src/Utils/CustomDesign.dart';
import 'package:vutha_admin_app/src/View/Chat/ChatList.dart';
import 'package:vutha_admin_app/src/View/Map/ServiceRequest.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';

import 'package:vutha_admin_app/src/View/Map/MapViewPage.dart';

import 'package:vutha_admin_app/src/Controller/NotificationController/NotificationController.dart'
    as notification_controller;
import 'package:vutha_admin_app/src/Routes/Routs.dart' as routes;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /* FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    notification_controller.registerNotification();
    notification_controller.configLocalNotification();
    notification_controller.configureSelectNotificationSubject(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    notification_controller.selectNotificationSubject.close();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Positioned(
                child: ClipPath(
                  clipper: TopWaveClipper(),
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xfffbb448), Color(0xfff7892b)]),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipPath(
                  clipper: BottomClipper(),
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xfffbb448), Color(0xfff7892b)]),
                    ),
                  ),
                ),
              ),
              _cards(),
            ],
          ),
        ),
      ),
    );
  }

  _cards() {
    return Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: <Widget>[
                  _profile(),
                  SizedBox(
                    width: 14,
                  ),
                  _new_user(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: <Widget>[
                  _payment(),
                  SizedBox(
                    width: 14,
                  ),
                  _location(),
                ],
              ),
            ),
            _chat(),
          ],
        ));
  }

  _profile() {
    return Expanded(
      flex: 1,
      child: Stack(
        children: <Widget>[
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, spreadRadius: 1.5, blurRadius: 1.5)
              ],
              color: Colors.white,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.perm_identity,
                    color: Colors.orange,
                    size: 100,
                  ),
                  Text(
                    "Profile",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              top: 25,
              right: 25,
              child: Text(
                "9+",
                style: TextStyle(
                    color: Colors.red.withOpacity(0.5),
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }

  _new_user() {
    return Expanded(
      flex: 1,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 1.5, blurRadius: 1.5)
          ],
          color: Colors.white,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.recent_actors,
                color: Colors.orange,
                size: 100,
              ),
              Text(
                "New User",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _payment() {
    return Expanded(
      flex: 1,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 1.5, blurRadius: 1.5)
          ],
          color: Colors.white,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.payment,
                color: Colors.orange,
                size: 100,
              ),
              Text(
                "Payment",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _location() {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: () {
          routes.normalRoute(context, ServiceRequest());
        },
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, spreadRadius: 1.5, blurRadius: 1.5)
            ],
            color: Colors.white,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  color: Colors.orange,
                  size: 100,
                ),
                Text(
                  "Location",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _chat() {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(new MaterialPageRoute(builder: (context) => ChatList()));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, spreadRadius: 1.5, blurRadius: 1.5)
            ],
            color: Colors.white,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.chat_bubble,
                  color: Colors.orange,
                  size: 100,
                ),
                Text(
                  "Chat",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
