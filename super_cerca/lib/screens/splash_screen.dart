import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flutter/material.dart';

import 'package:flare_flutter/asset_provider.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/services.dart';

import '../utils/animation_controller.dart' as controller;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AssetProvider _assetProvider =
      AssetFlare(bundle: rootBundle, name: 'assets/pumping-heart.flr');
  Widget animation;

  @override
  void initState() {
    animation = FlareActor(
      'assets/pumping-heart.flr',
      alignment: Alignment.center,
      color: Colors.white,
      fit: BoxFit.contain,
      controller: controller.AnimationController('pump', 2),
    );
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => _warmupAnimations().then((_) => _loadData(context)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    var myGroup = AutoSizeGroup();

    return Scaffold(
      backgroundColor: Color(0xFF0096FF),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              height: width / 3,
              width: width / 3,
              child: Hero(
                tag: 'heartLogo',
                child: animation,
              ),
            ),
          ),
          Center(
            child: Hero(
              tag: 'text',
              child: AutoSizeText("SUPER\nCERCA",
                  group: myGroup,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w800, fontSize: 30.0),
                minFontSize: 15.0,
                stepGranularity: 5.0,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _warmupAnimations() async {
    await cachedActor(_assetProvider);
  }

  void _loadData(BuildContext context) async {
    await Future.delayed(Duration(seconds: 2, milliseconds: 30));
    Navigator.pushReplacementNamed(context, '/wrapper');
  }
}
