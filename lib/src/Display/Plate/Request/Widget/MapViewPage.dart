import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vutha_admin_app/src/Model/Request.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vutha_admin_app/src/Model/ServiceMan.dart';
import 'package:vutha_admin_app/src/Utils/Common.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapViewPage extends StatefulWidget {
  Request request;
  RequestList requestList;
  int index;

  Function moveCursor;

  Function requestToServiceMan;

  Function removeSericeManDialog;

  MapViewPage(
      {this.request,
      this.requestList,
      this.index,
      this.moveCursor,
      this.removeSericeManDialog,
      this.requestToServiceMan,
      Key key})
      : super(key: key);

  @override
  _MapViewPageState createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapViewPage> {
  Completer<GoogleMapController> _controller = Completer();

  BitmapDescriptor pinLocationIcon;

  Set<Marker> _markers = {};
  Set<Marker> _home_assist_markers = {};
  Set<Marker> _security_markers = {};
  Set<Marker> _ambulance_markers = {};
  Set<Marker> _rode_side_markers = {};

  var lat, lan;
  var tempIndex = 0;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  loadServiceMan() {
    setState(() {
      _security_markers.clear();
      _home_assist_markers.clear();
    });

    loadServiceManMarker().then((value) {
      for (int i = 0; i < value.length; i++) {
        //setState(() {

        if (value[i].ServiceType == "Home Assist") {
          print("LoadSeviceMan  ${value[i].Number}");

          setState(() {
            _home_assist_markers.add(new Marker(
                //  consumeTapEvents: true,

                onTap: () {
                  widget.requestToServiceMan(
                    value[i].Name,
                    value[i].Number,
                    value[i].serviceManLocation.lat,
                    value[i].serviceManLocation.lan,
                  );
                },
                markerId: MarkerId("ha${i}"),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueYellow),
                position: new LatLng(value[i].serviceManLocation.lat,
                    value[i].serviceManLocation.lan)));
          });
        } else if (value[i].ServiceType == "Security") {
          setState(() {
            _security_markers.add(new Marker(
                consumeTapEvents: true,
                onTap: () {
                  widget.requestToServiceMan(
                    value[i].Name,
                    value[i].Number,
                    value[i].serviceManLocation.lat,
                    value[i].serviceManLocation.lan,
                  );
                },
                markerId: MarkerId("s${i}"),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueYellow),
                position: new LatLng(value[i].serviceManLocation.lat,
                    value[i].serviceManLocation.lan)));
          });
        } else if (value[i].ServiceType == "Ambulance") {
          _ambulance_markers.add(new Marker(
              onTap: () {
                widget.requestToServiceMan(
                  value[i].Name,
                  value[i].Number,
                  value[i].serviceManLocation.lat,
                  value[i].serviceManLocation.lan,
                );
              },
              consumeTapEvents: true,
              markerId: MarkerId("amb${i}"),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueYellow),
              position: new LatLng(value[i].serviceManLocation.lat,
                  value[i].serviceManLocation.lan)));
        } else {
          _rode_side_markers.add(new Marker(
              consumeTapEvents: true,
              markerId: MarkerId("rs${i}"),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueYellow),
              position: new LatLng(value[i].serviceManLocation.lat,
                  value[i].serviceManLocation.lan)));
        }

        if (widget.requestList.requestList[widget.index].request_type
            .toString()
            .contains("Home Assist")) {
          print("Security icons adds Type ....  Assist");

          setState(() {
            _security_markers.forEach((element) {
              setState(() {
                _markers.remove(element);
              });
            });

            _ambulance_markers.forEach((element) {
              setState(() {
                _markers.remove(element);
              });
            });

            _rode_side_markers.forEach((element) {
              setState(() {
                _markers.remove(element);
              });
            });

            _home_assist_markers.forEach((element) {
              if (element != null) {
                _markers.add(element);
              }
            });
          });
        } else if (widget.requestList.requestList[widget.index].request_type
            .toString()
            .contains("Security")) {
          print("Security icons adds Type ....  Security");

          _markers.forEach((element) {
            print("Security icons adds  marker  ${element.markerId}");
          });

          _security_markers.forEach((element) {
            setState(() {
              if (element != null) {
                print("Security icons adds  == ${_security_markers.length}");
                _markers.add(element);
              }
            });
          });

          _ambulance_markers.forEach((element) {
            setState(() {
              _markers.remove(element);
            });
          });

          _rode_side_markers.forEach((element) {
            setState(() {
              _markers.remove(element);
            });
          });

          _home_assist_markers.forEach((element) {
            setState(() {
              _markers.remove(element);
            });
          });
        } else if (widget.requestList.requestList[widget.index].request_type
            .toString()
            .contains("Ambulance")) {
          _security_markers.forEach((element) {
            setState(() {
              _markers.remove(element);
            });
          });

          _ambulance_markers.forEach((element) {
            if (element.markerId == null) {
              _markers.add(element);
            }
          });

          _rode_side_markers.forEach((element) {
            setState(() {
              _markers.remove(element);
            });
          });

          _home_assist_markers.forEach((element) {
            setState(() {
              _markers.remove(element);
            });
          });
        } else if (widget.requestList.requestList[widget.index].request_type
            .toString()
            .contains("Rode Side")) {
          _security_markers.forEach((element) {
            setState(() {
              _markers.remove(element);
            });
          });

          _ambulance_markers.forEach((element) {
            setState(() {
              _markers.remove(element);
            });
          });

          _rode_side_markers.forEach((element) {
            if (element.markerId == null) {
              _markers.add(element);
            }
          });

          _home_assist_markers.forEach((element) {
            setState(() {
              _markers.remove(element);
            });
          });
        }
      }
    });
  }

  loadMarker() {
    setState(() {
      _markers.clear();
    });
    for (int i = 0; i < widget.requestList.requestList.length; i++) {
      if (tempIndex == i) {
        _markers.add(new Marker(
            onTap: () {
              setState(() {
                tempIndex = i;

                widget.moveCursor(i);

                loadMarker();
              });
            },
            markerId: MarkerId(i.toString()),
            position: new LatLng(
                widget.requestList.requestList[i].userlocation.lat,
                widget.requestList.requestList[i].userlocation.lan)));
      } else {
        _markers.add(new Marker(
            onTap: () {
              setState(() {
                tempIndex = i;

                widget.moveCursor(i);
                loadMarker();
              });
            },
            markerId: MarkerId(i.toString()),
            icon: BitmapDescriptor.defaultMarkerWithHue(17),
            position: new LatLng(
                widget.requestList.requestList[i].userlocation.lat,
                widget.requestList.requestList[i].userlocation.lan)));
      }
    }

    loadServiceMan();
  }

  @override
  Widget build(BuildContext context) {




    print("Request List   ${widget.requestList}");
    if (lat != widget.request.userlocation.lat &&
        lan != widget.request.userlocation.lan) {
      movecamera(
          widget.request.userlocation.lat, widget.request.userlocation.lan);

      setState(() {
        tempIndex = widget.index;

        loadMarker();
      });
    }

    setState(() {
      lat = widget.request.userlocation.lat;

      lan = widget.request.userlocation.lan;
    });

    CameraPosition _kGooglePlex = CameraPosition(
        target: LatLng(
            widget.request.userlocation.lat, widget.request.userlocation.lan),
        zoom: 15.4746,
        tilt: 0.0,
        bearing: 0.0 // 2
        );

    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            indoorViewEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: _markers,
            myLocationEnabled: true,
            scrollGesturesEnabled: true,
            mapType: MapType.terrain,
            //  zoomGesturesEnabled: true,
            padding: EdgeInsets.only(top: 50),
            //  minMaxZoomPreference: MinMaxZoomPreference(10.0, 30.0),
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
            zoomGesturesEnabled: true,
          )
        ],
      ),
    );
  }

  void movecamera(lat, lan) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(
            lat,
            lan,
          ),
          zoom: 15)),
    );
  }

  Future<List<ServiceMan>> loadServiceManMarker() async {
    List<ServiceMan> _list_service_man = new List();

    await FirebaseDatabase.instance
        .reference()
        .child("ServiceMan")
        .once()
        .then((value) {
      Map<dynamic, dynamic> _service_man = value.value;

      _service_man.forEach((key, value) {
        print("Key  ${key}");

        print("Value  ${value}");

        _list_service_man.add(new ServiceMan(
            Name: value["Name"],
            Email: value["Email"],
            Number: key,
            ServiceType: value["ServiceType"],
            serviceManLocation: new ServiceManLocation(
                lat: value["location"]["lat"], lan: value["location"]["lan"])));
      });
    });

    return _list_service_man;
  }
}
