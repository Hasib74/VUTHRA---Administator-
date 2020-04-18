import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:vutha_admin_app/src/Display/Plate/Chat/ChatList.dart';
import 'package:vutha_admin_app/src/Display/Plate/Request/ServiceRequest.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';

import 'package:vutha_admin_app/src/Display/Plate/Request/Widget/MapViewPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var number = "+27012345678";

  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    registerNotification();
    configLocalNotification();

    _configureSelectNotificationSubject();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    selectNotificationSubject.close();
  }

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    tokenUpdate();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');

      showNotification(message['data']);

      //onSelectNotification(message["data"]["click_action"]);

      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');

      showNotification(message['data']);

      // onSelectNotification(message["data"]["click_action"]);

      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');

      showNotification(message['data']);

      // onSelectNotification(message["data"]["click_action"]);

      return;
    });
  }

  void tokenUpdate() {
    firebaseMessaging.getToken().then((token) {
      print('token: $token');

      FirebaseDatabase.instance
          .reference()
          .child("Token")
          .child("Admin")
          //.child(number)
          .set({"token": token}).then((_) {
        print("Token Update");
      }).catchError((err) => print(err));
    }).catchError((err) {
      print(err);
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_logo');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (value) {
     // print("Valueeeeeeeeeeeeeeeeeeeeeeeeee   ${value}");

      selectNotificationSubject.add(value);
    });
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.monu.vutha_admin_app'
          : 'com.monu.vutha_admin_app',
      'Admin App',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        new Random().nextInt(20),
        message['title'].toString(),
        message['body'].toString(),
        platformChannelSpecifics,
        payload: json.encode(message));
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((payload) async {



      print(
          "Poyload =========================================================   ${json.decode(payload)["click_action".toString()]}");




      onSelectNotification(json.decode(payload)["click_action"].toString());
    });
  }

  Future<void> onSelectNotification(String payload) async {
    if (payload == "newRequest") {
      await Navigator.of(context)
          .push(new MaterialPageRoute(builder: (context) => ServiceRequest()));
    }
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
          Navigator.of(context).push(
              new MaterialPageRoute(builder: (context) => ServiceRequest()));
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
          height: 200,
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

class TopWaveClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    // This is where we decide what part of our image is going to be visible.
    var path = Path();
    path.lineTo(0.0, size.height / 3);

    //creating first curver near bottom left corner
    var firstControlPoint = new Offset(size.width / 3, size.height);
    var firstEndPoint = new Offset(size.width, size.height);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    //creating second curver near center

    ///move to top right corner
    path.lineTo(size.width, 0.0);

    ///finally close the path by reaching start point from top right corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip

    return true;
  }
}

class BottomClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    // This is where we decide what part of our image is going to be visible.
    var path = Path();

    path.lineTo(0.0, 0.0);

    /* var firstControlPoint = new Offset(size.width +30, size.height-100);
    var firstEndPoint = new Offset(size.width/10, size.height );

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);*/

    path.quadraticBezierTo(
        size.width / 2 + 50, size.height / 7, size.width - 20, size.height);

    path.lineTo(size.width, size.height);

    path.lineTo(0.0, size.height);

    ///finally close the path by reaching start point from top right corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip

    return true;
  }
}
