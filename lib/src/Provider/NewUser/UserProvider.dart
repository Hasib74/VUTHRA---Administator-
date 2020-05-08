import 'dart:io';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:vutha_admin_app/src/Model/User.dart';
import 'package:vutha_admin_app/src/Utils/Common.dart';
import 'package:sms/sms.dart';

//import 'package:flutter_sms/flutter_sms.dart';

class UserProvider extends ChangeNotifier {
  List<User> _user_request_list;

  List<User> get userRequestList => _user_request_list;

  List<User> _user_panding_list;

  List<User> get userPandingList => _user_panding_list;

  var _tab;

  get tab => _tab;

  UserProvider() {
    print("Povider");

    _tab = "Users";

    newRequestedUser().listen((event) {
      //_user_request_list.clear();

      _user_request_list = event;

      notifyListeners();
    });

    pandingUser().listen((value) {
      _user_panding_list = value;

      notifyListeners();
    });
  }

  void setTab(tab) {
    _tab = tab;

    notifyListeners();
  }

  Stream<List<User>> newRequestedUser() {
    return Stream<List<User>>.fromFuture(getFutureNewUser());
  }

  Future<List<User>> getFutureNewUser() async {
    List<User> _userList = new List();

    await FirebaseDatabase.instance
        .reference()
        .child(Common.User)
        .once()
        .then((value) {
      Map<dynamic, dynamic> _users = value.value;

      _users.forEach((key, value) {
        print("Key   ${key}");
        print("Value  ${value}");

        if (value["genarated_code"] == null) {
          print("Email   ${value["Email"]}");

          _userList.add(new User(
              number: key,
              email: value["Email"],
              name: value["Name"],
              dob: value["DOB"]));
        }
      });
    });

    return _userList;
  }

  Stream<List<User>> pandingUser() {
    List<User> _userList = new List();

    FirebaseDatabase.instance
        .reference()
        .child(Common.User)
        .once()
        .then((value) {
      Map<dynamic, dynamic> _users = value.value;

      _users.forEach((key, value) {
        print("Key   ${key}");
        print("Value  ${value}");

        if (value["genarated_code"] != null) {
          print("Email   ${value["Email"]}");

          _userList.add(new User(
              number: key,
              email: value["Email"],
              name: value["Name"],
              dob: value["DOB"]));
        }
      });
    });

    return Stream<List<User>>.periodic(
        new Duration(milliseconds: 300), (List) => _userList);
  }

  Future<bool> accept(number) async {
    bool status = false;

    String code = RandomDigits.getInteger(6).toString();

    SmsSender sender = new SmsSender();

    sender
        .sendSms(new SmsMessage(number, ' Master Code : ${code}'))
        .then((value) async {
      print("SMS VALUE  ${value.body}");

      if (value.isRead) {
        status = true;
        await FirebaseDatabase.instance
            .reference()
            .child(Common.User)
            .child(number)
            .update({
          "genarated_code": code,
        });
      } else {
        status = false;
      }
    }).catchError((err) {
      status = false;
    });

    return status;
  }
}

class RandomDigits {
  static const MaxNumericDigits = 17;
  static final _random = Random();

  static int getInteger(int digitCount) {
    if (digitCount > MaxNumericDigits || digitCount < 1)
      throw new RangeError.range(0, 1, MaxNumericDigits, "Digit Count");
    var digit = _random.nextInt(9) + 1; // first digit must not be a zero
    int n = digit;

    for (var i = 0; i < digitCount - 1; i++) {
      digit = _random.nextInt(10);
      n *= 10;
      n += digit;
    }
    return n;
  }

  static String getString(int digitCount) {
    String s = "";
    for (var i = 0; i < digitCount; i++) {
      s += _random.nextInt(10).toString();
    }
    return s;
  }
}
