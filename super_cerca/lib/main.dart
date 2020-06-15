import 'package:flutter/material.dart';
// External imports
import 'package:provider/provider.dart';
import 'package:supercerca/models/category.dart';
// Internal imports
import 'package:supercerca/models/user.dart';
import 'package:supercerca/services/auth_service.dart';
import 'package:supercerca/services/database_service.dart';
import 'package:supercerca/utils/myroute_builder.dart';

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
        StreamProvider<User>.value(value: AuthService().user),
        StreamProvider<List<Category>>.value(value: DatabaseService().categories)
      ],
      child: MaterialApp(
        title: 'Super Cerca',
        theme: ThemeData(
            backgroundColor: Colors.white,
            primarySwatch: Colors.blue,
            buttonColor: Colors.blue,
            hintColor: Color.fromRGBO(54, 71, 108, 0.5),
            textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Color(0xFF0096FF),
                decorationColor: Color(0xFF0096FF),
                displayColor: Color(0xFF0096FF),
                fontFamily: 'Nunito'),
            fontFamily: 'Nunito'),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: MyRouteBuilder.handleRoutes,
      ),
    );
  }
}
