import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vutha_admin_app/src/Controller/HomePageController/HomePageController.dart';
import 'package:vutha_admin_app/src/Model/User.dart';
import 'package:vutha_admin_app/src/Provider/NewUser/UserProvider.dart';
import 'package:vutha_admin_app/src/View/Home/Users/Widget/Users.dart';

class UsersCard extends StatelessWidget {
  User user;

  UsersCard({
    this.user,
  });

  HomePageController homePageController = new HomePageController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(4)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                spreadRadius: 0.2,
                blurRadius: 0.2,
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //RichText(text: )

                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Text(
                          "User Name   : ",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          " ${user.name}",
                          style: TextStyle(
                              color: Colors.black38,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Text("User Number   : ",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 17,
                                fontWeight: FontWeight.bold)),
                        Text(" ${user.number}",
                            style: TextStyle(
                                color: Colors.black38,
                                fontWeight: FontWeight.bold,
                                fontSize: 17))
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Text("User DOB   : ",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 17,
                                fontWeight: FontWeight.bold)),
                        Text(" ${user.dob}",
                            style: TextStyle(
                                color: Colors.black38,
                                fontWeight: FontWeight.bold,
                                fontSize: 17))
                      ],
                    ),
                  ),

                  /*  Row(children: [

                    Text("User Name   : "),
                    Text(" ${user.name}")
                  ],),*/
                ],
              ),
              Positioned(top: 0, right: 0, child: _offsetPopup(user))
            ],
          ),
        ),
      ),
    );
  }

  Widget _offsetPopup(User user) {
    return PopupMenuButton<int>(
      onSelected: (value) => {
        if (value == 1) {homePageController.suspendAccount(user.number)}
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text(
            "Suspend Account",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w700),
          ),
        ),
      ],
      icon: Icon(
        Icons.more_vert,
        color: Colors.black,
      ),
      offset: Offset(0, 100),
    );
  }
}
