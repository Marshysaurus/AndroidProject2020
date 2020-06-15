import 'package:flutter/material.dart';
import 'package:supercerca/screens/main/payments/complete_purchase_screen.dart';
// Internal imports
import 'package:supercerca/singletons/cart.dart';
import 'package:supercerca/widgets/product_row.dart';
import 'package:supercerca/widgets/return_button.dart';

class CartScreen extends StatefulWidget {
  CartScreen({this.notifyParent});
  final Function() notifyParent;

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void refresh() {
    setState(() {
      widget.notifyParent();
    });
  }

  Widget proceedButton() {
    return ButtonTheme(
      height: 45.0,
      minWidth: double.infinity,
      child: FlatButton(
        child: Text('Proceder al pago',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        color: Colors.blue,
        textColor: Colors.white,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(
                color: myCart.orders.isNotEmpty ? Colors.blue : Colors.grey,
                width: 1.5)),
        onPressed: myCart.orders.isNotEmpty
            ? () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CompletePurchaseScreen()));
              }
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text('Carrito',
                  style: TextStyle(
                      color: Colors.blue,
                      fontFamily: 'Nunito',
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 20.0),
              Expanded(
                child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemCount: myCart.orders.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(height: 10.0),
                    itemBuilder: (BuildContext context, int index) {
                      return ProductRow(
                          product:
                              myCart.orders.values.elementAt(index).product,
                          notifyParent: refresh);
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Subtotal:',
                    style: TextStyle(
                        color: Color(0xFF36476C),
                        fontSize: 28.0,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '\$${myCart.totalPrice().toStringAsFixed(2)}',
                    style: TextStyle(
                        color: Color(0xFF36476C),
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(height: 15.0),
              proceedButton(),
              SizedBox(height: 15.0),
              ReturnButton(notifyParent: refresh)
            ],
          ),
        ),
      ),
    );
  }
}
