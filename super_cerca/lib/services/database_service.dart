// External imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:supercerca/models/paycard.dart';
// Internal imports
import 'package:supercerca/models/category.dart';
import 'package:supercerca/models/product.dart';
import 'package:supercerca/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // Function para jalar la info de todos los productos en firestore
  final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
    functionName: 'getAllProducts',
  );

  // Referencia a las colecciones en Firestore
  final CollectionReference usersCollection =
      Firestore.instance.collection('users');
  final CollectionReference categoriesCollection =
      Firestore.instance.collection('categories');
  final CollectionReference carouselCollection =
      Firestore.instance.collection('carousel');
  final CollectionReference allProductsCollection =
      Firestore.instance.collection('products');

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
        .document(categoryID)
        .collection('products')
        .snapshots()
        .map((list) =>
            list.documents.map((doc) => Product.fromFirestore(doc)).toList());
  }

  // Future que regresa todos los productos dentro de la base de datos
  Future get allProducts async {
    dynamic resp = await callable.call();
    return resp;
  }

  Stream<List<PayCard>> get usersCards {
    return usersCollection.document(uid).collection('methods').snapshots().map(
        (list) =>
            list.documents.map((doc) => PayCard.fromFirestore(doc)).toList());
  }

  // Se llama tanto para cuando se hace registro como para actualizar datos post-registro
  Future<void> updateUserData(String name, String email) async {
    return await usersCollection
        .document(uid)
        .setData({'name': name, 'email': email});
  }
}
