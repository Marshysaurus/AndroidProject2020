import 'package:flutter/material.dart';
// Internal imports
import 'package:supercerca/screens/main/cart/cart_screen.dart';
import 'package:supercerca/singletons/cart.dart';
// External imports
import 'package:badges/badges.dart';

class CartIcon extends StatefulWidget {
  CartIcon({@required this.notifyParent});
  final Function() notifyParent;

  @override
  _CartIconState createState() => _CartIconState();
}

class _CartIconState extends State<CartIcon> {
  void refresh() {
    widget.notifyParent();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CartScreen(notifyParent: refresh)));
      },
      child: Badge(
        position: BadgePosition.topRight(top: -16),
        badgeColor: Colors.blue,
        animationType: BadgeAnimationType.fade,
        badgeContent: Text(myCart.orders.length > 9 ? '9' : myCart.orders.length.toString(),
            style: TextStyle(color: Colors.white)),
        child: Icon(
          Icons.shopping_cart,
          color: Colors.blue,
          size: 28.0,
        ),
      ),
    );
  }
}
