import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vutha_admin_app/src/Model/User.dart';
import 'package:vutha_admin_app/src/Provider/NewUser/UserProvider.dart';
import 'package:vutha_admin_app/src/View/Home/Users/Widget/Users.dart';

class RequestedUserListCard extends StatelessWidget {
  User user;

  RequestedUserListCard(this.user);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(4)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black45,
                  spreadRadius: 0.4,
                  blurRadius: 0.7,
                  offset: Offset(0.0, 2.0))
            ]),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
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

              Divider(
                height: 2,
                color: Colors.black45,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      provider.accept(user.number,user.email).then((value) {


                        print("Email ==>  accept  ${value}");

                        if (value) {
                          return;
                        } else {
                          displayDialog(context);
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Text(
                        "Accept",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 30,
                    color: Colors.black26,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Text(
                      "Decline",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void displayDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text("Failed To Accept"),
        content: new Text("Check your mobile balance"),
        actions: [
          CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              isDefaultAction: true,
              child: new Text("Close"))
        ],
      ),
    );
  }
}
