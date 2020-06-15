import 'package:flutter/material.dart';
import 'package:supercerca/services/auth_service.dart';
import 'package:supercerca/singletons/cart.dart';
import 'package:supercerca/utils/custom_scroll.dart';
import 'package:supercerca/widgets/dialogs.dart';

class ConfigScreen extends StatefulWidget {
  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  final _authService = AuthService();
  final List<String> settings = [
    'Métodos de Pago',
    'Revisar métodos de pago',
    'Ayuda',
    'Soporte Técnico'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 50.0),
          padding: EdgeInsets.only(left: 32.0),
          child: Text('Ajustes',
              style: TextStyle(
                  color: Color(0xFF36476C),
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold)),
        ),
        ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView.builder(
            padding: EdgeInsets.only(left: 32.0),
            shrinkWrap: true,
            itemCount: settings.length,
            itemBuilder: (BuildContext context, index) {
              return Column(
                children: [
                  index == 0 || index == 2
                      ? Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(top: 20.0),
                          height: 40.0,
                          child: Text(
                            settings[index],
                            style: TextStyle(
                                color: Color(0xFF36476C),
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : InkWell(
                          onTap: index == 1
                              ? () {
                                  Navigator.of(context)
                                      .pushNamed('/all_payments');
                                }
                              : (index == 3
                                  ? () {
                                      Navigator.of(context)
                                          .pushNamed('/tech_support');
                                    }
                                  : null),
                          child: Container(
                              alignment: Alignment.centerLeft,
                              height: 50.0,
                              child: Text(
                                settings[index],
                                style: TextStyle(
                                    color: Color(0xFF36476C), fontSize: 22.0),
                              )),
                        ),
                  Divider()
                ],
              );
            },
          ),
        ),
        Spacer(),
        Container(
          alignment: Alignment.centerLeft,
          height: 60,
          padding: EdgeInsets.only(left: 32.0),
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () async {
              final action = await Dialogs.yesCancelDialog(
                  context, "Cerrar sesión", "¿Estás seguro de cerrar sesión?");
              if (action == DialogAction.yes) {
                myCart.orders.clear();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/signin', (_) => false);
                await _authService.signOut();
              }
            },
            child: Text(
              "Cerrar Sesión",
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Color(0xFF36476C),
                  fontFamily: 'Nunito',
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }
}
