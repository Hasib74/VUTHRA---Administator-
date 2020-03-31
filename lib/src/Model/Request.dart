import 'package:vutha_admin_app/src/Model/User.dart';

class RequestList {
  List<Request> requestList;

  RequestList({this.requestList});
}

class Request {
  var phoneNummbe;
  Location location;
  var request_type;

  // User user;

  Request({this.location, this.phoneNummbe, this.request_type});
}

class Location {
  var lat;
  var lan;

  Location({this.lat, this.lan});
}
