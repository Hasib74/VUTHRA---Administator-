import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:vutha_admin_app/src/Model/User.dart';
import 'package:vutha_admin_app/src/Utils/Common.dart';
import 'package:vutha_admin_app/src/View/Home/Users/Widget/UsersCard.dart';

class VeryfiedUserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseDatabase.instance.reference().child(Common.User).onValue,
      builder: (context, snapshot) {
        List<User> _userList = new List();

        // print("Snapshot data   ${snapshot.data.snapshot.value}");

        if (snapshot.data != null &&
            snapshot != null &&
            snapshot.data.snapshot.value != null) {
          Map<dynamic, dynamic> _users = snapshot.data.snapshot.value;

          _users.forEach((key, value) {
            print("Key   ${key}");
            print("Value  ${value}");

            if (value["master_code"] != null) {
              print("Email   ${value["Email"]}");

              _userList.add(new User(
                  number: key,
                  email: value["Email"],
                  name: value["Name"],
                  dob: value["DOB"]));
            }

            print("User list  ${_userList.length}");
          });

          return ListView.builder(
            itemCount: _userList.length,
            itemBuilder: (context, int index) {
              return UsersCard(
                user: _userList[index],
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
