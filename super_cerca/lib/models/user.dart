import 'package:flutter/cupertino.dart';
// External imports
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({
    this.uid,
  });

  String uid;
}

class UserData {
  UserData({@required this.uid, this.userName, @required this.userEmail});

  final String uid;
  final String userName;
  final String userEmail;

  factory UserData.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return UserData(
        uid: doc.documentID,
        userName: data['name'] ?? 'Usuario desconocido',
        userEmail: data['email']);
  }
}
