import 'package:flutter/material.dart';
import 'package:supercerca/widgets/return_button.dart';
import 'package:supercerca/widgets/teammate_row.dart';

class SupportScreen extends StatelessWidget {
  final List<String> students = ['Mike', 'Charlie', 'Alex'];
  final List<String> studentsIDs = ['A01336430', 'A01336319', 'A01337343'];
  final List<String> studentsRol = [
    'Desarrollo Backend',
    'Diseño UI',
    'Desarrollo Frontend'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(32.0, 40.0, 32.0, 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Soporte Técnico',
                  style: TextStyle(
                      color: Color(0xFF36476C),
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 20.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  return TeammateRow(
                      name: students[index],
                      idNumber: studentsIDs[index],
                      rol: studentsRol[index]);
                },
              ),
              Spacer(),
              ReturnButton()
            ],
          ),
        ),
      ),
    );
  }
}
