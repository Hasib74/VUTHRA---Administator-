import 'package:geocoder/geocoder.dart';

class Common{

  static var  HelpRequest ="HelpRequest";

  static var User= "User";

  static var Serviceman = "ServiceMan";

  static var Serve ="Serve";

  static var Chat = "Chat";

  static var TOKEN= "Token";


  static Future<String> getUserLocation(lat, lan) async {
    final coordinates = new Coordinates(lat, lan);
    var addresses =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    return '${first.addressLine}   ';
  }

}