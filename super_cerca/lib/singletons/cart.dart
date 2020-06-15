import 'dart:collection';
import 'package:flutter/material.dart';
// Internal imports
import 'package:supercerca/models/order.dart';

class Cart with ChangeNotifier{
  LinkedHashMap orders = LinkedHashMap();

  static final Cart _cart = Cart._internal();

  Cart._internal();

  factory Cart() {
    return _cart;
  }

  double totalPrice() {
    double total = 0.0;
    for(Order order in orders.values) {
      total += order.orderPrice();
    }

    return total;
  }

  List<String> stringify() {
    List<String> titles = [];
    for (int i = 0; i < orders.length; i++)
      titles.add(orders[i].product.title);
    return titles;
  }

  int get ordersLen => orders.length;
}

final myCart = Cart();