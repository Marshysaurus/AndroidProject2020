import 'package:flutter/material.dart';
import 'package:supercerca/models/product.dart';
import 'package:supercerca/services/database_service.dart';
// Internal imports
import 'package:supercerca/widgets/search_delegate.dart';

class SearchField extends StatefulWidget {
  final void Function() notifyParent;
  SearchField({this.notifyParent});

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final FocusNode _searchNode = FocusNode();
  final border = OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(5.0),
      ),
      borderSide: BorderSide.none);

  List<Product> allProducts = [];

  @override
  Widget build(BuildContext context) {
    DatabaseService().allProducts.then((value) {
      allProducts = [];
      value.data.forEach((product) {
        allProducts.add(Product.fromJSON(product));
      });
    });
    // Pto
    return TextField(
      focusNode: _searchNode,
      onTap: () {
        _searchNode.unfocus();
//        selectImage();
        showSearch(
            context: context,
            delegate: CustomSearchDelegate(products: allProducts, notifyParent: widget.notifyParent));
      },
      style: TextStyle(color: Color(0xFF36476C), fontSize: 20.0),
      decoration: InputDecoration(
          border: border,
          disabledBorder: border,
          enabledBorder: border,
          filled: true,
          fillColor: Color(0xFFE2E1E1),
          focusedBorder: border,
          hintText: 'Buscar',
          hintStyle: TextStyle(color: Color(0xFF36476C).withOpacity(0.5)),
          isDense: true,
          prefixIcon: Icon(Icons.search, color: Color(0xFF36476C))),
    );
  }
}
