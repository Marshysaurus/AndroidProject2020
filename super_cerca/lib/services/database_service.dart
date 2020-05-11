// External imports
import 'package:cloud_firestore/cloud_firestore.dart';
// Internal imports
import 'package:supercerca/models/category.dart';
import 'package:supercerca/models/product.dart';
import 'package:supercerca/models/user.dart';

class DatabaseService {
  DatabaseService({this.uid});

  final String uid;

  // Referencia a las colecciones en Firestore
  final CollectionReference usersCollection =
      Firestore.instance.collection('users');
  final CollectionReference categoriesCollection =
      Firestore.instance.collection('categories');

  // Stream para capturar la info de un usuario de Firestore
  Stream<UserData> get userData {
    return usersCollection
        .document(uid)
        .snapshots()
        .map((doc) => UserData.fromFirestore(doc));
  }

  Stream<List<Category>> get categories {
    return categoriesCollection.snapshots().map((list) =>
        list.documents.map((doc) => Category.fromFirestore(doc)).toList());
  }

  Stream<List<Product>> products(String categoryID) {
    return categoriesCollection
    .document(categoryID).collection('products')
        .snapshots()
        .map((list) =>
            list.documents.map((doc) => Product.fromFirestore(doc)).toList());
  }

  // Se llama tanto para cuando se hace registro como para actualizar datos post-registro
  Future<void> updateUserData(String name, String email) async {
    return await usersCollection
        .document(uid)
        .setData({'name': name, 'email': email});
  }
}
