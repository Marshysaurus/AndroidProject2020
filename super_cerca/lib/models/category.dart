import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supercerca/models/product.dart';

class Category {
  Category({this.id, this.image, this.title});

  final String id;
  final String image;
  final String title;

  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Category(
      id: doc.documentID,
      image: data['image'],
      title: data['title']
    );
  }
}
