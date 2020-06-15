import 'package:flutter/material.dart';
// Internal imports
import 'package:supercerca/screens/main/tabs/config_screen.dart';
import 'package:supercerca/screens/main/tabs/halls_screen.dart';
import 'package:supercerca/screens/main/tabs/home_screen.dart';
import 'package:supercerca/singletons/cart.dart';
// External imports
import 'package:permission_handler/permission_handler.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  var permissions = Permission.values.where((Permission permission) {
    return permission != Permission.unknown &&
        permission != Permission.mediaLibrary &&
        permission != Permission.photos &&
        permission != Permission.reminders;
  }).toList();

  final tabs = [
    Center(child: HomeScreen()),
    Center(child: HallsScreen()),
    Center(child: ConfigScreen()),
  ];

  @override
  void initState() {
    super.initState();
    requestPermission(permissions[3]);
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(child: tabs[_currentIndex]),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                  title: Text('Inicio'), icon: Icon(Icons.home)),
              BottomNavigationBarItem(
                  title: Text('Pasillos'), icon: Icon(Icons.loyalty)),
              BottomNavigationBarItem(
                  title: Text('Ajustes'), icon: Icon(Icons.settings))
            ],
            selectedItemColor: Colors.blue,
            unselectedItemColor: Color(0xFF969EB2)),
      ),
    );
  }
}
