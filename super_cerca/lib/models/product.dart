import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  Product({this.id, this.title, this.image, this.price});

  final String id;
  final String title;
  final String image;
  final double price;

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Product(
      id: doc.documentID,
      title: data['title'] ?? 'Bulbasaur uwu',
      image: data['image'] ?? 'https://img.game8.co/3230742/b96cc2a1725020492adae5d560ca851d.png/show',
      price: data['price'] ?? 0.0
    );
  }
}
