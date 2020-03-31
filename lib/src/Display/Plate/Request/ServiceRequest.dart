import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:vutha_admin_app/src/Display/Plate/Request/Widget/PageDesign.dart';
import 'package:vutha_admin_app/src/Model/Request.dart';
import 'package:vutha_admin_app/src/Model/User.dart';
import 'package:vutha_admin_app/src/Utils/Common.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    swiperControl = new SwiperControl();

    swiperController = new SwiperController();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
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
              Map<dynamic, dynamic> _help_request =
                  snapshot.data.snapshot.value;

              List<Request> _requestList = [];

              _help_request.forEach((key, value) {
                print("Key   ${key}");

                print("Valuee ${value}");

                _requestList.add(new Request(
                  phoneNummbe: key,
                  request_type: value["request_type"],
                  location: new Location(
                      lat: value["location"]["lat"],
                      lan: value["location"]["lan"]),
                ));

                // RequestList(requestList: )
              });

              requestList = new RequestList(requestList: _requestList);

              return Stack(
                children: <Widget>[
                  RequestPageDesign(
                    request: requestList.requestList[page_position],
                  ),
                  Positioned(
                    top: 50,
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
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(0, 10),
                                      blurRadius: 20,
                                      spreadRadius: 10)
                                ]),
                            child:  Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StreamBuilder(
                                  stream: FirebaseDatabase.instance
                                      .reference()
                                      .child(Common.User)
                                      .child(requestList
                                      .requestList[index].phoneNummbe)
                                      .onValue,
                                  builder: (context, snapshot) {
                                    if (snapshot.data == null) {
                                      return Container();
                                    } else {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[

                                          Center(
                                            child: Text(snapshot
                                                .data.snapshot.value["Name"] , style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 20),textAlign: TextAlign.center,),
                                          ),

                                          Center(child: Text("Waiting for  ${requestList.requestList[index].request_type}")),
                                          Padding(padding: EdgeInsets.all(8)),

                                          Divider(color: Colors.black54,height: 2,),


                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text("Email : ${snapshot.data.snapshot.value["Email"]}"),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text("Phone Number : ${requestList.requestList[index].phoneNummbe}"),
                                          ),


                                          Text("Address : ")






                                        ],
                                      );
                                    }
                                  }),
                            )
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }


  getUserLocation() async {//call this async method from whereever you need

    LocationData myLocation;
    String error;
    Location location = new Location();
    try {
      myLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
    }
    currentLocation = myLocation;
    final coordinates = new Coordinates(
        myLocation.latitude, myLocation.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        coordinates);
    var first = addresses.first;
    print(' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    return first;
  }
}
