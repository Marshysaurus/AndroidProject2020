import 'package:cloud_firestore/cloud_firestore.dart';

class PayCard {
  final String id;
  final String brand;
  final String cardDigits;
  final String stripeID;

  PayCard({this.id, this.brand, this.cardDigits, this.stripeID});

  factory PayCard.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return PayCard(
      id: doc.documentID,
      brand: data['brand'],
      cardDigits: '•••• •••• •••• ' + data['last4'],
      stripeID: data['stripe_id']
    );
  }
}