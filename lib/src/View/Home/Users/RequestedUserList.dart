import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vutha_admin_app/src/Provider/NewUser/UserProvider.dart';
import 'package:vutha_admin_app/src/View/Home/Users/Widget/RequestedUserCard.dart';

class RequestedUserList extends StatefulWidget {
  @override
  _RequestedUserListState createState() => _RequestedUserListState();
}

class _RequestedUserListState extends State<RequestedUserList> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);

    return AbsorbPointer(
      absorbing: loading,
      child: Stack(
        children: <Widget>[
          StreamBuilder(
            stream: provider.newRequestedUser(),
            builder: (context, snapshot) {
              return snapshot.data != null
                  ? ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, int index) {
                        return RequestedUserListCard(
                          user: snapshot.data[index],
                          loadingCallBack: (v) {
                            setState(() {
                              loading = v;
                            });
                            print(v);
                          },
                        );
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            },
          ),
          loading ? loading_circle() : Container()
        ],
      ),
    );
  }

  loading_circle() {
    return Positioned.fill(
        child: Align(
            alignment: Alignment.center,
            child: Center(
              child: CircularProgressIndicator(),
            )));
  }
}
