import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';
import 'screens/splash_screen.dart';
import 'services/auth_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(value: AuthService().user)
      ],
      child: MaterialApp(
          title: 'Super Cerca',
          theme: ThemeData(
            backgroundColor: Colors.white,
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          home: SplashScreen()),
    );
  }
}
