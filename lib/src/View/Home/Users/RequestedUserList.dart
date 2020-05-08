import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vutha_admin_app/src/Provider/NewUser/UserProvider.dart';
import 'package:vutha_admin_app/src/View/Home/Users/Widget/RequestedUserCard.dart';

class RequestedUserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);

    return StreamBuilder(
      stream: provider.newRequestedUser(),
      builder: (context, snapshot) {
        return snapshot.data != null
            ? ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, int index) {
                  return RequestedUserListCard(snapshot.data[index]);
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
