import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vutha_admin_app/src/Model/Request.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewPage extends StatefulWidget {
  Request request;
  RequestList requestList;
  int index;

  Function moveCursor;

  MapViewPage(
      {this.request, this.requestList, this.index, this.moveCursor, Key key})
      : super(key: key);

  @override
  _MapViewPageState createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapViewPage> {
  Completer<GoogleMapController> _controller = Completer();

  BitmapDescriptor pinLocationIcon;

  Set<Marker> _markers = {};

  var lat, lan;
  var tempIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  loadMarker() {
    setState(() {
      _markers.clear();

      for (int i = 0; i < widget.requestList.requestList.length; i++) {
        print("Super Index  I ${i} & INDEX of  ${widget.index} ");

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
              infoWindow: InfoWindow(
                  title:
                      "Waiting For ${widget.requestList.requestList[i].request_type}",
                  snippet: "${widget.requestList.requestList[i].phoneNummbe}"),
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
              infoWindow: InfoWindow(
                  title:
                      "Waiting For ${widget.requestList.requestList[i].request_type}",
                  snippet: "${widget.requestList.requestList[i].phoneNummbe}"),
              position: new LatLng(
                  widget.requestList.requestList[i].userlocation.lat,
                  widget.requestList.requestList[i].userlocation.lan)));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Super Index   ${widget.index}");

    print(
        "My locatation iss   lat ${widget.request.userlocation.lat} , lan ${widget.request.userlocation.lan} ");

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

    /* BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5), 'Img/marker.png')
        .then((onValue) {
      pinLocationIcon = onValue;
    });*/

    /*_markers.add(new Marker(
      markerId: MarkerId("1"),
      position: new LatLng(
          widget.request.userlocation.lat, widget.request.userlocation.lan),
    ));*/

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
            zoomGesturesEnabled: false,
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
}
