import 'package:flutter/cupertino.dart';

class TopWaveClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    // This is where we decide what part of our image is going to be visible.
    var path = Path();
    path.lineTo(0.0, size.height / 3);

    //creating first curver near bottom left corner
    var firstControlPoint = new Offset(size.width / 3, size.height);
    var firstEndPoint = new Offset(size.width, size.height);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    //creating second curver near center

    ///move to top right corner
    path.lineTo(size.width, 0.0);

    ///finally close the path by reaching start point from top right corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip

    return true;
  }
}

class BottomClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    // This is where we decide what part of our image is going to be visible.
    var path = Path();

    path.lineTo(0.0, 0.0);

    /* var firstControlPoint = new Offset(size.width +30, size.height-100);
    var firstEndPoint = new Offset(size.width/10, size.height );

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);*/

    path.quadraticBezierTo(
        size.width / 2 + 50, size.height / 7, size.width - 20, size.height);

    path.lineTo(size.width, size.height);

    path.lineTo(0.0, size.height);

    ///finally close the path by reaching start point from top right corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip

    return true;
  }
}