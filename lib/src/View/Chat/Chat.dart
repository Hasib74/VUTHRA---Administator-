import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:vutha_admin_app/src/Model/ChatModel.dart';
import 'package:vutha_admin_app/src/Utils/Common.dart';

class Chat extends StatefulWidget {
  final number;

  Chat({this.number});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  double size;

  var text;

  var chat_edit_text_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
//    print("Number is  ${number}");

    size = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: <Widget>[
          ChatBody(),
          TextFiledAndSendButton(context)
        ],
      ),
    );
  }

  Expanded ChatBody() {
    return Expanded(
          child: StreamBuilder(
              stream: FirebaseDatabase.instance
                  .reference()
                  .child(Common.Chat)
                  .child(widget.number)
                  .onValue,
              builder: (context, snapshot) {
                if (snapshot.data == null || snapshot.data.snapshot.value == null ) {

                  return Center(
                    child: Text("Empty"),
                  );

                } else {


                  List<ChatModel> _chat_list = new List();

                  List<dynamic> step1 = snapshot.data.snapshot.value;

                  step1.forEach((element) {
                    if (element != null) {
                      _chat_list.add(new ChatModel(
                          type: element["type"],
                          message: element["message"]));
                    }
                  });

                  _chat_list = _chat_list.reversed.toList();

                  return ListView.builder(
                    itemCount: _chat_list.length,
                    reverse: true,
                    itemBuilder: (context, int index) {
                      if (_chat_list[index].type == "admin") {
                        return AdminMessage(_chat_list, index);
                      } else {
                        return UserMessage(_chat_list, index);
                      }
                    },
                  );

                }
              }),
        );
  }

  Padding UserMessage(List<ChatModel> _chat_list, int index) {
    return Padding(
                        padding: EdgeInsets.only(
                            right: size / 2, top: 3, bottom: 3, left: 3),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Text(
                              _chat_list[index].message,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
  }

  Padding AdminMessage(List<ChatModel> _chat_list, int index) {
    return Padding(
                        padding: EdgeInsets.only(
                            left: size / 2, top: 3, bottom: 3, right: 3),
                        child: Container(
                          alignment: Alignment.centerRight,
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Text(
                              _chat_list[index].message,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
  }

  Padding TextFiledAndSendButton(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Container(
                      child: TextField(
                          onChanged: (v) {
                            setState(() {
                              text = v;
                            });
                          },
                          controller: chat_edit_text_controller,
                          maxLines: null,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: Color(0xfff3f3f4),
                              filled: true)),
                    ),
                  )),
                  text != null
                      ? InkWell(
                          onTap: () => send_message(),
                          child: Icon(
                            Icons.send,
                            color: Colors.orange,
                            size: 30,
                          ),
                        )
                      : InkWell(
                          //  onTap: ()=>send_message(),

                          child: Icon(
                            Icons.send,
                            color: Colors.black54,
                            size: 30,
                          ),
                        )
                ],
              ),
            ),
          ),
        );
  }

  send_message() {
    if (chat_edit_text_controller.value.text.isNotEmpty) {
      FirebaseDatabase.instance
          .reference()
          .child(Common.Chat)
          .child(widget.number)
          .once()
          .then((value) {
        if (value.value == null) {
          FirebaseDatabase.instance
              .reference()
              .child(Common.Chat)
              .child(widget.number)
              .child("1")
              .set({
            "message": chat_edit_text_controller.value.text,
            "type": "admin"
          }).then((value) => chat_edit_text_controller.text = "");
        } else {
          FirebaseDatabase.instance
              .reference()
              .child(Common.Chat)
              .child(widget.number)
              .child("${value.value.length + 1}")
              .set({
            "message": chat_edit_text_controller.value.text,
            "type": "admin"
          }).then((value) => chat_edit_text_controller.text = "");
        }
      });
    }
  }
}
