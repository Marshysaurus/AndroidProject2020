import 'package:flutter/material.dart';

class TeammateRow extends StatelessWidget {
  final String name;
  final String idNumber;
  final String rol;

  TeammateRow(
      {@required this.name, @required this.idNumber, @required this.rol});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: Image.asset('assets/students/$name.jpg', fit: BoxFit.cover, width: 60.0, height: 60.0,),
          ),
          SizedBox(width: 15.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name + ' ' + idNumber,
                  style: TextStyle(
                      color: Color(0xFF36476C),
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold)),
              Text(rol, style: TextStyle(color: Color(0xFF36476C), fontSize: 22.0)),
            ],
          )
        ],
      ),
    );
  }
}
