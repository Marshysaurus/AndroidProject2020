import 'dart:async';

import 'package:flutter/material.dart';

import '../screens/wrapper.dart';
import '../widgets/loader.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    new Timer(new Duration(milliseconds: 5000), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Wrapper()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Loader()),
    );
  }
}
