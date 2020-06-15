import 'package:flutter/material.dart';
// Internal imports
import 'package:supercerca/services/database_service.dart';
import 'package:supercerca/widgets/cart_icon.dart';
import 'package:supercerca/widgets/product_container.dart';
import 'package:supercerca/widgets/return_button.dart';
import 'package:supercerca/widgets/search_field.dart';

class CategoryProducts extends StatefulWidget {
  CategoryProducts({this.categoryID, this.categoryTitle, this.notifyParent});
  final String categoryID;
  final String categoryTitle;
  final void Function() notifyParent;

  @override
  _CategoryProductsState createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {

  void refresh() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 6,
                          child: SearchField(notifyParent: refresh),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: CartIcon(notifyParent: refresh)),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text(
                        widget.categoryTitle,
                        style: TextStyle(
                            color: Color(0xFF36476C),
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    StreamBuilder(
                      stream: DatabaseService().products(widget.categoryID),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.data != null) {
                          return GridView.builder(
                              itemCount: snapshot.data.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, childAspectRatio: 3 / 4),
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return ProductContainer(
                                  product: snapshot.data[index],
                                  notifyParent: refresh,
                                );
                              });
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 60.0)
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 20.0),
              child: ReturnButton(notifyParent: widget.notifyParent),
            )
          ],
        ),
      ),
    );
  }
}
