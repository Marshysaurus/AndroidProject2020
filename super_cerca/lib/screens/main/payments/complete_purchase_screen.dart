import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:supercerca/models/paycard.dart';
import 'package:supercerca/models/user.dart';
import 'package:supercerca/services/database_service.dart';
// Internal imports
import 'package:supercerca/singletons/cart.dart';
import 'package:supercerca/widgets/return_button.dart';

class CompletePurchaseScreen extends StatefulWidget {
  @override
  _CompletePurchaseScreenState createState() => _CompletePurchaseScreenState();
}

class _CompletePurchaseScreenState extends State<CompletePurchaseScreen> {
  final double subtotal = myCart.totalPrice();
  final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
    functionName: 'payWithMethod',
  );
  User user;
  PayCard card;
  int totalPayment;
  bool loading = false;

  void refresh() {
    setState(() {});
  }

  callFunction() {
    setState(() {
      loading = true;
    });
    Future.delayed(Duration(seconds: 1), () async {
      await callable.call(<String, dynamic>{
        'payment_method_id': card.stripeID,
        'currency': 'mxn',
        'amount': totalPayment,
        'uid': user.uid,
        'products': myCart.orders.values.toList().map((order) {
          return {
            'product_id': order.product.id,
            'product_name': order.product.title,
            'quantity': order.quantity,
            'notes': order.notes
          };
        }).toList()
      }).then((value) {
        setState(() {
          loading = false;
        });
        if (value.data['status'] == 'succeeded') {
          showDialog(
            barrierDismissible: false,
              context: context,
              builder: (context) => AlertDialog(
                  title: Text('¡Tu compra ha sido exitosa!'),
                  actions: [FlatButton(child: Text('Aceptar'),
                  onPressed: () {
                    myCart.orders.clear();
                    Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
                  },
                  )]));
        }
      }).catchError((error) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: Text('Ocurrió un problema con la compra...'),
                actions: [FlatButton(child: Text('Regresar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )]));
      });
    });
  }

  Widget completeButton() {
    return ButtonTheme(
      height: 45.0,
      minWidth: double.infinity,
      child: FlatButton(
        child: Text('Completar pedido',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        color: Colors.blue,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(color: Colors.blue, width: 1.5)),
        onPressed: callFunction,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double sendingCost = subtotal * 0.07;
    double total = subtotal + sendingCost;
    totalPayment = (total * 100).round();

    user = Provider.of<User>(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Confirmación',
                      style: TextStyle(
                          color: Colors.blue,
                          fontFamily: 'Nunito',
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 20.0),
                  Text('Dirección de envío',
                      style: TextStyle(
                          fontSize: 24.0,
                          color: Color(0xFF36476C),
                          fontWeight: FontWeight.w700)),
                  Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 30.0),
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Colors.grey.withOpacity(0.2)),
                          bottom: BorderSide(color: Colors.grey.withOpacity(0.2))),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 15.0, right: 10.0),
                              child: Icon(Icons.location_on)),
                          Text('Paseo del Cantil #51',
                              style: TextStyle(
                                  fontSize: 22.0, color: Color(0xFF36476C))),
                          Spacer(),
                          Text('Cambiar',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 18.0)),
                        ],
                      ),
                    ),
                  ),
                  Text('Método de Pago',
                      style: TextStyle(
                          fontSize: 24.0,
                          color: Color(0xFF36476C),
                          fontWeight: FontWeight.w700)),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Colors.grey.withOpacity(0.2)),
                          bottom: BorderSide(color: Colors.grey.withOpacity(0.2))),
                    ),
                    child: StreamBuilder(
                        stream: DatabaseService(uid: user.uid).usersCards,
                        builder: (context, snapshot) {
                          String svgName;
                          if (snapshot.hasData) {
                            switch (snapshot.data[0].brand) {
                              case 'mastercard':
                                svgName = 'assets/svg_images/mastercard.svg';
                                break;
                              case 'visa':
                                svgName = 'assets/svg_images/visa.svg';
                                break;
                              default:
                                svgName = 'assets/svg_images/amex.svg';
                                break;
                            }

                            card = snapshot.data[0];

                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              child: Row(
                                children: [
                                  Container(
                                      margin:
                                      EdgeInsets.only(left: 15.0, right: 10.0),
                                      child:
                                      SvgPicture.asset(svgName, height: 24.0)),
                                  Text(snapshot.data[0].cardDigits,
                                      style: TextStyle(
                                          color: Color(0xFF36476C),
                                          fontSize: 18.0)),
                                  Spacer(),
                                  InkWell(
                                      onTap: () {},
                                      child: Text('Cambiar',
                                          style: TextStyle(
                                              decoration: TextDecoration.underline,
                                              fontSize: 18.0))),
                                ],
                              ),
                            );
                          }
                          return Container();
                        }),
                  ),
                  Text(
                      '* No se realizará ningun cobro hasta que recibas tus productos.',
                      style: TextStyle(color: Color(0xFF969EB2), fontSize: 18.0)),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Subtotal:',
                        style: TextStyle(color: Color(0xFF36476C), fontSize: 24.0),
                      ),
                      Text(
                        '\$${subtotal.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Color(0xFF36476C),
                          fontSize: 24.0,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Costo de envío:',
                        style: TextStyle(color: Color(0xFF36476C), fontSize: 24.0),
                      ),
                      Text(
                        '\$${sendingCost.toStringAsFixed(2)}',
                        style: TextStyle(color: Color(0xFF36476C), fontSize: 24.0),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Total:',
                        style: TextStyle(color: Color(0xFF36476C), fontSize: 28.0),
                      ),
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Color(0xFF36476C),
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(height: 15.0),
                  completeButton(),
                  SizedBox(height: 15.0),
                  ReturnButton(notifyParent: refresh),
                ],
              ),
            ),
            loading ? ModalBarrier(dismissible: false, color: Colors.black.withOpacity(0.3)) : Container(),
            loading ? Center(child: SpinKitFoldingCube(
              color: Colors.blue,
            )) : Container()
          ],
        )
      ),
    );
  }
}
