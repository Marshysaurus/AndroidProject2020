import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  Future signInWithEmailPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      throw Exception(
          "Los datos introducidos son incorrectos. Intenta de nuevo.");
    }
  }

  // Register on firebase authentication the user and its data in firebase database
  Future registerNewUser(String userName, String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      await DatabaseService(uid: user.uid).updateUserData(userName, email);

      return _userFromFirebaseUser(user);
    } catch (e) {
      throw ("Error desconocido: " + e.toString());
    }
  }

  // Call this function to sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      throw ("Error desconocido: " + e.toString());
    }
  }
}
