class ServiceMan {
  var Name;
  var Number;
  var Email;
  var ServiceType;
  ServiceManLocation serviceManLocation;

  ServiceMan(
      {this.serviceManLocation,
      this.Email,
      this.Number,
      this.ServiceType,
      this.Name});
}

class ServiceManLocation {
  var lat;

  var lan;

  ServiceManLocation({this.lat, this.lan});
}
