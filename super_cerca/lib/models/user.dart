import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;

  User({this.uid});
}

class UserData {
  final String uid;
  final String userName;
  final String email;

  UserData({this.uid, this.userName, this.email});

  factory UserData.fromFirestore(DocumentSnapshot doc){
    Map data = doc.data;

    return UserData(
      uid: doc.documentID,
      userName: data['userName'],
      email: data['email']
    );
  }
}
