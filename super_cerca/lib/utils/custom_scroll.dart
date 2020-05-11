import 'package:flutter/cupertino.dart';

// Comportamiento definido para eliminar el clamp scrolling con brillo
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}