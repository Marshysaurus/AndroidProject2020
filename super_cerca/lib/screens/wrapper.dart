import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../screens/main/main_screen.dart';
import '../screens/authentication/signin_screen.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      return SignInScreen();
    } else {
      return MainScreen();
    }
  }
}
