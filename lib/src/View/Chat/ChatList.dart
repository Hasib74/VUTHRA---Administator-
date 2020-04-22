import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:vutha_admin_app/src/Model/ChatListModel.dart';
import 'package:vutha_admin_app/src/Model/User.dart';
import 'package:vutha_admin_app/src/Utils/Common.dart';
import 'Chat.dart';

class ChatList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream:
              FirebaseDatabase.instance.reference().child(Common.User).onValue,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            } else {
              Map<dynamic, dynamic> _serviceList = snapshot.data.snapshot.value;

              List<User> _userList = new List();

              _serviceList.forEach((key, value) {
                _userList.add(new User(
                  time: value["time"],
                  number: key,
                  name: value["Name"],
                  email: value["Email"],
                ));
              });

              return FutureBuilder(
                future: future_chatList(_userList),
                builder: (context, AsyncSnapshot<List<ChatListModel>> chat) {
                  if (chat.data == null) {
                    return Container();
                  } else {
                    print("length ${chat.data.length}");
                    return ListView.builder(
                        itemCount: chat.data.length,
                        itemBuilder: (context, int index) {
                          print("Namee  ${chat.data[index].name}");

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .push(new MaterialPageRoute(
                                        builder: (context) => Chat(
                                              number: chat.data[index].number,
                                            )));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          spreadRadius: 1,
                                          blurRadius: 1)
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${chat.data[index].name}",
                                        style: TextStyle(
                                            color: Colors.orangeAccent,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2.0,
                                          left: 8,
                                          bottom: 8,
                                          right: 8),
                                      child: Text(
                                        "${chat.data[index].message}",
                                        style: TextStyle(
                                            color: chat.data[index].message ==
                                                    "New conncetion"
                                                ? Colors.black54
                                                : Colors.black,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }
                },
              );
            }
          }),
    );
  }

  Future<List<ChatListModel>> future_chatList(List<User> userList) async {
    List<ChatListModel> _chat_list_model = new List();

    for (int i = 0; i < userList.length; i++) {
      await FirebaseDatabase.instance
          .reference()
          .child(Common.Chat)
          .child(userList[i].number)
          .once()
          .then((value) {
        List<dynamic> chatList = value.value;

        if (chatList == null) {
          _chat_list_model.add(new ChatListModel(
              time: userList[i].time,
              message: 'New conncetion',
              number: userList[i].number,
              name: userList[i].name,
              request: false));
        } else {
          int index = chatList.length - 1;

          print("Chat list  ${chatList[index]["message"]}");
          _chat_list_model.add(new ChatListModel(
              time: chatList[index]["time"],
              message: chatList[index]["message"],
              number: userList[i].number,
              name: userList[i].name,
              request: true));
        }
      });
    }

    print("Length   ${_chat_list_model[0].time}");

    _chat_list_model.sort((a, b) {
      return (a.time)
          .toString()
          .replaceAll(".", "")
          .replaceAll("T", "")
          .compareTo(
              (b.time).toString().replaceAll(".", "").replaceAll("T", ""));
    });

    print("Length 1  ${_chat_list_model.length}");

    _chat_list_model = _chat_list_model.reversed.toList();

    return _chat_list_model;
  }
}
