import 'package:supercerca/models/product.dart';

enum Measure {
  piece,
  kg
}

class Order {
  Order({this.product, this.quantity, this.measure, this.notes});

  Product product;
  int quantity;
  Measure measure;
  String notes;

  void productAddRemove(int number) {
    quantity += number;
  }

  double orderPrice(){
    return product.price * quantity;
  }
}