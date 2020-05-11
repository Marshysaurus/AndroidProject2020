import 'dart:async';

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
    return Scaffold(
      backgroundColor: Color(0xFF0096FF),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
              height: 150.0,
              width: 150.0,
              child: Hero(
                tag: 'heartLogo',
                child: animation,
              ),
            ),
          ),
          Center(
            child: Hero(
              tag: 'text',
              child: Text("SUPER\nCERCA",
                  style: Theme.of(context).textTheme.headline5.copyWith(
                      fontWeight: FontWeight.w800, color: Colors.white)),
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
