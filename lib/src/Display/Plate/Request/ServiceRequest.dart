import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:vutha_admin_app/src/Utils/Common.dart';

class ServiceRequest extends StatefulWidget {
  @override
  _ServiceRequestState createState() => _ServiceRequestState();
}

class _ServiceRequestState extends State<ServiceRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: StreamBuilder(

          stream:  FirebaseDatabase.instance.reference().child(Common.HelpRequest).onValue,
          builder:(context, snapshot){


            //print("Snapshot  ${snapshot.data.snapshot.value}");

            if(snapshot.data.snapshot.value == null || snapshot.data == null || snapshot.hasError){

              return Center(child: CircularProgressIndicator());

            }else{


              Map<dynamic,dynamic> _help_request =  snapshot.data.snapshot.value;

              _help_request.forEach((key, value) {


                print("Key   ${key}");


                print("Valuee ${value}");


              });


              return Container();

            }

          }),
      
    );
  }
}

