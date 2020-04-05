import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: SpinKitChasingDots(
          size: 50.0,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                color: index.isEven ? Color(0xFF0096FF) : Color(0xFF36476C),
                shape: BoxShape.circle
              ),
            );
          },
        ),
      ),
    );
  }
}
