import 'package:flutter/material.dart';
import 'package:supercerca/services/auth_service.dart';
import 'package:supercerca/utils/custom_scroll.dart';
import 'package:supercerca/widgets/dialogs.dart';

class ConfigScreen extends StatefulWidget {
  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  final _authService = AuthService();
  final List<String> settings = [
    'General',
    'Perfil',
    'Direcciones',
    'Pedidos Anteriores',
    'Métodos de Pago',
    'Revisar métodos de pago',
    'Ayuda',
    'Soporte Técnico'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ScrollConfiguration(
            behavior: MyBehavior(),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: settings.length,
              itemBuilder: (BuildContext context, index) {
                return Column(
                  children: [
                    index == 0 || index == 4 || index == 6
                        ? Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 20.0),
                            padding: EdgeInsets.only(left: 32.0),
                            height: 40.0,
                            child: Text(
                              settings[index],
                              style: TextStyle(
                                  color: Color(0xFF36476C),
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        : Container(
                            alignment: Alignment.centerLeft,
                            height: 50.0,
                            padding: EdgeInsets.only(left: 32.0),
                            child: Text(
                              settings[index],
                              style: TextStyle(
                                  color: Color(0xFF36476C), fontSize: 22.0),
                            )),
                    Divider()
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 40.0),
          Container(
            alignment: Alignment.centerLeft,
            height: 60,
            padding: EdgeInsets.only(left: 32.0),
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () async {
                final action = await Dialogs.yesCancelDialog(context,
                    "Cerrar sesión", "¿Estás seguro de cerrar sesión?");
                if (action == DialogAction.yes) {
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
      ),
    );
  }
}
