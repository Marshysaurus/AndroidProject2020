import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference usersCollection =
      Firestore.instance.collection('users');

  Future<void> updateUserData(String userName, String email) async {
    return await usersCollection.document(uid).setData({
      'userName': userName,
      'email': email
    });
  }

  Stream<UserData> get userData {
    return usersCollection
        .document(uid)
        .snapshots()
        .map((doc) => UserData.fromFirestore(doc));
  }
}
