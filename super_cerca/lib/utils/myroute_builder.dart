import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// Internal imports
import 'package:supercerca/screens/authentication/signin_screen.dart';
import 'package:supercerca/screens/authentication/register_screen.dart';
import 'package:supercerca/screens/authentication/maps_screen.dart';
import 'package:supercerca/screens/main/main_screen.dart';
import 'package:supercerca/screens/main/payments/all_payments_screen.dart';
import 'package:supercerca/screens/main/payments/new_payment_screen.dart';
import 'package:supercerca/screens/main/products/details_screen.dart';
import 'package:supercerca/screens/main/support/support_screen.dart';
import 'package:supercerca/screens/splash_screen.dart';
import 'package:supercerca/screens/wrapper.dart';

class MyRouteBuilder {
  static Route handleRoutes(settings) {
    Route page;
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        page = MaterialPageRoute(builder: (context) => SplashScreen());
        break;
      case '/wrapper':
        page = MaterialPageRoute(builder: (context) => Wrapper());
        break;
      case '/signin':
        page = PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                SignInScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
            transitionDuration: Duration(milliseconds: 500));
        break;
      case '/register':
        page = PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                RegisterScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
            transitionDuration: Duration(milliseconds: 500));
        break;
      case '/maps':
        page = PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                MapsScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = Offset(0.0, 1.0);
              var end = Offset.zero;
              var tween = Tween(begin: begin, end: end);
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            });
        break;
      case '/main':
        page = PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                MainScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
            transitionDuration: Duration(seconds: 1));
        break;
      case '/details':
        page = MaterialPageRoute(
            builder: (context) => DetailsScreen(product: args));
        break;
      case '/all_payments':
        page = MaterialPageRoute(builder: (context) => AllPaymentsScreen());
        break;
      case '/add_payments':
        page =
            MaterialPageRoute(builder: (context) => NewPaymentMethodScreen());
        break;
      case '/tech_support':
        page = MaterialPageRoute(builder: (context) => SupportScreen());
        break;
    }
    return page;
  }
}
