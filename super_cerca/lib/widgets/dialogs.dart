import 'package:flutter/material.dart';

enum DialogAction { yes, abort }

class Dialogs {
  static Future<DialogAction> yesCancelDialog(
      BuildContext context, String title, String body) async {
    final action = await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title, style: TextStyle(color: Color(0xFF36476C))),
            content: Text(body, style: TextStyle(color: Color(0xFF36476C))),
            actions: <Widget>[
              FlatButton(
                  child: Text("Cancelar", style: TextStyle(color: Color(0xFF36476C))),
                  onPressed: () =>
                      Navigator.of(context).pop(DialogAction.abort)),
              FlatButton(
                  child: Text("Aceptar",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold)),
                  onPressed: () => Navigator.of(context).pop(DialogAction.yes))
            ],
            elevation: 10.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            backgroundColor: Colors.white,
          );
        });
    return (action != null) ? action : DialogAction.abort;
  }
}