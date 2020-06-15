import 'dart:io';
import 'package:flutter/material.dart';
// External imports
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supercerca/models/product.dart';
import 'package:supercerca/screens/main/products/details_screen.dart';
import 'package:supercerca/widgets/product_container.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Product> products;
  CustomSearchDelegate({this.products});

  File pickedImage;
  bool isImageLoaded;
  bool searchByCode = false;
  String code;

  // En teoria, esto lo haria el Mike XD
  final List<Product> recentSearch = [];

  Future selectImage(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    pickedImage = image;
    isImageLoaded = true;
    if (pickedImage != null) decode(context);
  }

  Future decode(BuildContext context) async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    BarcodeDetector barcodeDetector = FirebaseVision.instance.barcodeDetector();
    List barCodes = await barcodeDetector.detectInImage(ourImage);

    List<Product> productsByCode = [];

    for (Barcode readableCode in barCodes) {
      code = readableCode.displayValue;

//      if (code.isEmpty || code == null) {
//      }

      productsByCode.addAll(products.where((product) {
        return product.id == code;
      }).toList());
      code = null;

      if (productsByCode.length == 0) {
        showModalBottomSheet(context: context, builder: (context) => Text('No se detectó ningún código'));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailsScreen(
                    product: productsByCode[0])));
      }
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
      IconButton(
        icon: Icon(Icons.graphic_eq),
        onPressed: () {
          selectImage(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Events displayed which title matches the query
    final List<Product> resultList = query.isEmpty
        ? null
        : products
            .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
            .toList();

    // Show results based on the input
    if (resultList == null) {
      return Center(
        child: Text("Buscando productos",
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
      );
    } else if (resultList.length == 0) {
      return Center(
        child: Text("No hay productos",
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
      );
    } else {
      return GridView.builder(
          padding: EdgeInsets.fromLTRB(32.0, 15.0, 30.0, 0.0),
          physics: BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 3 / 4),
          itemCount: resultList.length,
          itemBuilder: (context, index) {
            return ProductContainer(
              product: resultList[index],
            );
          });
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Lista de productos
    final List<Product> suggestionList = query.isEmpty
        ? recentSearch
        : products
            .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
            .toList();

    // Muestra la lista de productos que coincidan con la search
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) => ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DetailsScreen(product: suggestionList[index])));
          },
          // Highlights the text that matches with the query while
          // displaying the event title
          title: Text(suggestionList[index].title,
              style: TextStyle(color: Colors.black))),
    );
  }
}
