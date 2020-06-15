import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:supercerca/models/paycard.dart';
import 'package:supercerca/models/user.dart';
import 'package:supercerca/services/database_service.dart';
import 'package:supercerca/widgets/return_button.dart';

class AllPaymentsScreen extends StatefulWidget {
  @override
  _AllPaymentsScreenState createState() => _AllPaymentsScreenState();
}

class _AllPaymentsScreenState extends State<AllPaymentsScreen> {
  final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
    functionName: 'deletePaymentMethod',
  );

  String svgName;

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(32.0, 40.0, 32.0, 20.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Métodos de Pago',
                    style: TextStyle(
                        color: Color(0xFF36476C),
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 30.0),
              StreamBuilder(
                  stream: DatabaseService(uid: user.uid).usersCards,
                  builder: (BuildContext context, snapshot) {
//                    if (!snapshot.hasError) print('Errores');
                    if (!snapshot.hasData) return Container();

                    List<PayCard> cards = snapshot.data;

                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cards.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == cards.length) {
                          svgName = 'assets/svg_images/money.svg';
                          return ListTile(
                            leading: SvgPicture.asset(svgName),
                            title: Text('Efectivo'),
                          );
                        }

                        switch (cards[index].brand) {
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

                        return ListTile(
                          leading: SvgPicture.asset(svgName, height: 24.0),
                          title: Text(cards[index].cardDigits,
                              style: TextStyle(
                                  color: Color(0xFF36476C), fontSize: 18.0)),
                          trailing: InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        elevation: 5.0,
                                        title: Text('Cancelar tarjeta',
                                            style: TextStyle(
                                                color: Color(0xFF36476C),
                                                fontSize: 28.0,
                                                fontWeight: FontWeight.bold)),
                                        content: Text(
                                            '¿Estás seguro de querer remover este método de pago?',
                                            style: TextStyle(
                                                color: Color(0xFF36476C),
                                                fontSize: 18.0)),
                                        actions: [
                                          FlatButton(
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Cancelar',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 16.0)),
                                          ),
                                          FlatButton(
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            onPressed: () async {
                                              await callable
                                                  .call(<String, dynamic>{
                                                'id': '${cards[index].id}',
                                                'uid': '${user.uid}'
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Aceptar',
                                                style:
                                                    TextStyle(fontSize: 16.0)),
                                          )
                                        ],
                                      );
                                    });
                              },
                              child: Text('Eliminar',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline))),
                        );
                      },
                    );
                  }),
              Spacer(),
              Container(
                width: double.infinity,
                child: ButtonTheme(
                  height: 45.0,
                  child: FlatButton(
                    child: Text('Agregar',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)),
                    color: Colors.blue,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: Colors.blue, width: 1.5)),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/add_payments');
                    },
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              ReturnButton(notifyParent: refresh)
            ],
          ),
        ),
      ),
    );
  }
}
