import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:vutha_admin_app/src/Utils/Common.dart';
import 'Chat.dart';

class ChatList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream:
              FirebaseDatabase.instance.reference().child(Common.Serve).onValue,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            } else {
              List<String> _user_number_list = new List();

              Map<dynamic, dynamic> _serviceList = snapshot.data.snapshot.value;

              _serviceList.forEach((key, value) {
                Map<dynamic, dynamic> _list = value;

                _list.forEach((key, value) {
                  print("Keyyy  ${key}");
                  print("Valuee   ${value}");

                  _user_number_list.add(value["userNumber"]);
                });
              });

              return ListView.builder(
                  itemCount: _user_number_list.length,
                  itemBuilder: (context, int index) {
                    return FutureBuilder(
                      future: FirebaseDatabase.instance
                          .reference()
                          .child(Common.User)
                          .child(_user_number_list[index])
                          .once(),
                      builder: (context, AsyncSnapshot<dynamic> data) {
                        if (data.data != null) {
                          print("dattaaa   ${data.data.value["Name"]}");

                          return new InkWell(

                            onTap: (){

                              Navigator.of(context).push(new MaterialPageRoute(builder: (context)=>Chat(number:_user_number_list[index],)));

                            },

                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: new Text(
                                        "${data.data.value["Name"]}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: new Text(
                                        "${_user_number_list[index]}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          );
                        }
                      },
                    );
                  });
            }
          }),
    );
  }
}
