import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vutha_admin_app/src/Provider/NewUser/UserProvider.dart';

class Users extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, service, child) {
        return InkWell(
          onTap: () {
            service.setTab("Users");
          },
          child: Row(
            children: [
              //Icon(Icons.playlist_add_check,size: 20,),
              service.tab == "Users"
                  ? Icon(
                      Icons.supervised_user_circle,
                      color: Colors.orange,
                    )
                  : Icon(
                      Icons.supervised_user_circle,
                      color: Colors.black26,
                    ),
              service.tab == "Users"
                  ? Text(
                      " Varifyed Users",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : Text(
                      " Varifyed Users",
                      style: TextStyle(
                          color: Colors.black26,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    )
            ],
          ),
        );
      },
    );
  }
}
