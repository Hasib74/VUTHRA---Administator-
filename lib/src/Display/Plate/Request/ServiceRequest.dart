import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:vutha_admin_app/src/Display/Plate/Request/Widget/MapViewPage.dart';
import 'package:vutha_admin_app/src/Model/Request.dart';
import 'package:vutha_admin_app/src/Utils/Common.dart';

import 'package:geocoder/geocoder.dart';

class ServiceRequest extends StatefulWidget {
  @override
  _ServiceRequestState createState() => _ServiceRequestState();
}

class _ServiceRequestState extends State<ServiceRequest> {
  RequestList requestList;

  var page_position = 0;

  SwiperControl swiperControl;

  SwiperController swiperController;

  var width;

  var serviceMan_name;
  var serviceMan_lat;
  var serviceMan_lan;
  var serviceMan_email;
  var serviceMan_phoneNumber;

  var userName;
  var userLat;
  var userLan;
  var userNumber;
  var userEmail;

  bool serviceManWindrow = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    swiperControl = new SwiperControl();

    swiperController = new SwiperController();
  }

  @override
  Widget build(BuildContext context) {
    void moveCursor(index) {
      //print("Super Index  I   ${index}");

      setState(() {
        page_position = index;

        swiperController.move(index, animation: true);
      });
    }

    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
            stream: FirebaseDatabase.instance
                .reference()
                .child(Common.HelpRequest)
                .onValue,
            builder: (context, snapshot) {
              //print("Snapshot  ${snapshot.data.snapshot.value}");

              if (snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              } else {
                StremOperation(snapshot);

                return Stack(
                  children: <Widget>[
                    MapActivity(
                        moveCursor, requestToService, removeServiceManDialog),
                    SwipeArea(context),
                    this.serviceManWindrow ? serviceManDialog() : Container(),
                  ],
                );
              }
            }),
      ),
    );
  }

  void StremOperation(AsyncSnapshot snapshot) {
    Map<dynamic, dynamic> _help_request = snapshot.data.snapshot.value;

    List<Request> _requestList = [];

    _help_request.forEach((key, value) {
      print("Key   ${key}");

      print("Valuee ${value}");

      _requestList.add(new Request(
        phoneNummbe: key,
        request_type: value["request_type"],
        userlocation: new UserLocation(
            lat: value["location"]["lat"], lan: value["location"]["lan"]),
      ));

      // RequestList(requestList: )
    });

    requestList = new RequestList(requestList: _requestList);
  }

  Padding MapActivity(
      void moveCursor(dynamic index),
      void requestToService(
          serviceManName, serviceManNumber, serviceManlat, serviceManlan),
      void removeServiceDialog()) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: MapViewPage(
        request: requestList.requestList[page_position],
        requestList: requestList,
        index: page_position,
        moveCursor: moveCursor,
        requestToServiceMan: requestToService,
        removeSericeManDialog: removeServiceDialog,
      ),
    );
  }

  Positioned SwipeArea(BuildContext context) {
    return Positioned(
      bottom: 10,
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        child: Swiper(
          itemCount: requestList.requestList.length,
          // control: swiperControl,
          controller: swiperController,
          autoplayDisableOnInteraction: false,
          viewportFraction: 0.8,
          scale: 0.9,
          loop: false,
          autoplay: false,
          onIndexChanged: (index) {
            removeServiceManDialog();
            setState(() {
              page_position = index;

              print("position ${page_position}");
            });
          },
          itemBuilder: (context, int index) {
            print("length  ${requestList.requestList.length}");

            return Container(
                height: 200,
                width: width / 1.2,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 0),
                          blurRadius: 1,
                          spreadRadius: 1)
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder(
                      stream: FirebaseDatabase.instance
                          .reference()
                          .child(Common.User)
                          .child(requestList.requestList[index].phoneNummbe)
                          .onValue,
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return Container();
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Text(
                                  snapshot.data.snapshot.value["Name"],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Center(
                                  child: Text(
                                      "Waiting for  ${requestList.requestList[index].request_type}")),
                              Padding(padding: EdgeInsets.all(8)),
                              Divider(
                                color: Colors.black54,
                                height: 2,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                    "Email : ${snapshot.data.snapshot.value["Email"]}"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                    "Phone Number : ${requestList.requestList[index].phoneNummbe}"),
                              ),
                              FutureBuilder(
                                  future: getUserLocation(
                                      requestList
                                          .requestList[index].userlocation.lat,
                                      requestList
                                          .requestList[index].userlocation.lan),
                                  builder: (context, data) {
                                    if (data.data == null) {
                                      return Container();
                                    } else {
                                      return Text("Address : ${data.data} ");
                                    }
                                  })
                            ],
                          );
                        }
                      }),
                ));
          },
        ),
      ),
    );
  }

  getUserLocation(lat, lan) async {
    final coordinates = new Coordinates(lat, lan);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    return '${first.addressLine}   ';
  }

  serviceManDialog() {
    return Positioned(
      top: 20,
      right: 0.0,
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 1.3,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              boxShadow: [
                BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 1)
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Name : ${serviceMan_name}"),
                  Padding(padding: EdgeInsets.all(4)),
                  Text("Number : ${serviceMan_phoneNumber}"),
                  Padding(padding: EdgeInsets.all(4)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Location :"),
                      FutureBuilder(
                          future:
                              getUserLocation(serviceMan_lat, serviceMan_lan),
                          builder: (context, data) {
                            if (data.data == null) {
                              return Container();
                            } else {
                              return Flexible(
                                  child: Text(
                                " ${data.data} ",
                                softWrap: true,
                              ));
                            }
                          }),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){

                        _serveRequest();

                      },

                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 1,
                                  blurRadius: 1)
                            ]),
                        child: Center(
                          child: Text(
                            "   Requested To Serve   ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(0)),
                ],
              ),
            ),
          ),
          Positioned(
              top: 5,
              right: 5,
              child: InkWell(
                  onTap: () {
                    removeServiceManDialog();
                  },
                  child: new Icon(Icons.close)))
        ],
      ),
    );
  }

  requestToService(serviceManName, serviceManNumber, serviceManLat,
      serviceManLan /*, userName, userNumber, userLat, userLan, userGmail*/) {
    print("I am clicked");

    setState(() {
      serviceMan_name = serviceManName;
      serviceMan_phoneNumber = serviceManNumber;

      serviceMan_lan = serviceManLan;

      serviceMan_lat = serviceManLat;

      serviceMan_email = serviceMan_email;



      serviceManWindrow = true;
    });
  }

  void removeServiceManDialog() {
    setState(() {
      this.serviceManWindrow = false;
    });
  }

  void _serveRequest() {


    FirebaseDatabase.instance.reference().child(Common.Serve).child(this.serviceMan_phoneNumber).push().set({


      "userNumber" : this.requestList.requestList[this.page_position].phoneNummbe,
      "requestType" : this.requestList.requestList[this.page_position].request_type,
      "lat" : this.requestList.requestList[this.page_position].userlocation.lat,
      "lan" : this.requestList.requestList[this.page_position].userlocation.lan,



    }).then((value){



      FirebaseDatabase.instance.reference().child(Common.HelpRequest).child(this.requestList.requestList[this.page_position].phoneNummbe).remove().then((value) {


        removeServiceManDialog();

      });


    });

  }
}
