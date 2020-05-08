import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vutha_admin_app/src/Provider/NewUser/UserProvider.dart';

class Request extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, service, _) {
        return InkWell(
          onTap: () {
            service.setTab("Requested");
          },
          child: service.tab == "Requested"
              ? Row(
                  children: [
                    Icon(
                      Icons.notifications,
                      size: 20,
                      color: Colors.orange,
                    ),
                    Text(
                      " Requested User ",
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Icon(
                      Icons.notifications,
                      size: 20,
                      color: Colors.black26,
                    ),
                    Text(
                      " Requested User ",
                      style: TextStyle(
                          color: Colors.black26,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
