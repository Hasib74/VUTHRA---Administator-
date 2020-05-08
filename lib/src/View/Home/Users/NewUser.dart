import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:vutha_admin_app/src/Provider/NewUser/UserProvider.dart';
import 'package:vutha_admin_app/src/View/Home/Users/RequestedUserList.dart';
import 'package:vutha_admin_app/src/View/Home/Users/VeryfiedUserList.dart';
import 'package:vutha_admin_app/src/View/Home/Users/Widget/Users.dart';
import 'package:vutha_admin_app/src/View/Home/Users/Widget/Request.dart';

class NewUser extends StatefulWidget {
  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Column(
            children: [TabBar(), UserOrRequestedList()],
          ),
        ),
      ),
    );
  }

  TabBar() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.black45, spreadRadius: 1, blurRadius: 1)
      ]),
      child: Column(
        children: [
          ListTile(
            leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 20,
              ),
            ),
            title: Text(
              "User",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Users(),
                Request(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  UserOrRequestedList() {
    return Expanded(
      child: Consumer<UserProvider>(builder: (context, provider, _) {
        if (provider.tab == "Users") {
          return VeryfiedUserList();
        } else {
          return RequestedUserList();
        }
      }),
    );
  }
}
