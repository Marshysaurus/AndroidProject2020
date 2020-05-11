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
      image: data['image'] ?? 'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/c7bca634-434f-4d30-8394-513ca6421852/ddtled9-00590762-4b53-41c9-b9d7-aae6fde7ac8c.png/v1/fit/w_300,h_894,strp/jirachi_by_seviyummy_ddtled9-300w.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOiIsImlzcyI6InVybjphcHA6Iiwib2JqIjpbW3siaGVpZ2h0IjoiPD04OTQiLCJwYXRoIjoiXC9mXC9jN2JjYTYzNC00MzRmLTRkMzAtODM5NC01MTNjYTY0MjE4NTJcL2RkdGxlZDktMDA1OTA3NjItNGI1My00MWM5LWI5ZDctYWFlNmZkZTdhYzhjLnBuZyIsIndpZHRoIjoiPD04MDAifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.wEZ3ntiL874Q50HTMkKejFuopTpfizLV8zQINKahiaA',
      title: data['title'] ?? 'Jirachi',
    );
  }
}
