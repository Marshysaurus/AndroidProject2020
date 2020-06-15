import 'package:flutter/material.dart';

class ReturnButton extends StatelessWidget {
  ReturnButton({this.notifyParent});
  final Function() notifyParent;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: ButtonTheme(
        height: 45.0,
        minWidth: double.infinity,
        child: FlatButton(
          child: Text('Regresar',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          color: Color(0xFFE2E1E1),
          textColor: Color(0xFF787F8F),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          onPressed: () {
            if (notifyParent != null) notifyParent();
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
