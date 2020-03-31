import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vutha_admin_app/src/Model/Request.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RequestPageDesign extends StatelessWidget {
  Request request;

  RequestPageDesign({this.request, Key key}) : super(key: key);

  Completer<GoogleMapController> _controller = Completer();

  BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(request.location.lat, request.location.lan),
      zoom: 14.4746,
      tilt: 0.0,
      bearing: 0.0// 2
    );

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5), 'Img/marker.png')
        .then((onValue) {
      pinLocationIcon = onValue;
    });

    _markers.add(new Marker(
      markerId: MarkerId("1"),

      position: new LatLng(request.location.lat, request.location.lan),
    ));

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
}
