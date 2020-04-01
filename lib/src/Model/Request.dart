import 'package:vutha_admin_app/src/Model/User.dart';

 class RequestList {
  List<Request> requestList;

  RequestList({this.requestList});
}

class Request {
  var phoneNummbe;
  UserLocation userlocation;
  var request_type;

  // User user;

  Request({this.userlocation, this.phoneNummbe, this.request_type});
}

class UserLocation {
  var lat;
  var lan;

  UserLocation({this.lat, this.lan});
}
