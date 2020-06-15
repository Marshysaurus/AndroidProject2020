import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// Internal imports
import 'package:supercerca/models/category.dart';
import 'package:supercerca/screens/main/products/category_products.dart';
import 'package:supercerca/widgets/cart_icon.dart';
import 'package:supercerca/widgets/search_field.dart';
// External imports
import 'package:provider/provider.dart';

class HallsScreen extends StatefulWidget {
  @override
  _HallsScreenState createState() => _HallsScreenState();
}

class _HallsScreenState extends State<HallsScreen> {

  void refresh() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    List<Category> categories = Provider.of<List<Category>>(context);

    if (categories != null) {
      return Padding(
        padding: EdgeInsets.fromLTRB(32.0, 40.0, 30.0, 0.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(flex: 6, child: SearchField(notifyParent: refresh)),
                Expanded(
                  flex: 1,
                  child: Align(
                      alignment: Alignment.centerRight, child: CartIcon(notifyParent: refresh)),
                )
              ],
            ),
            Expanded(
              child: GridView.builder(
                itemCount: categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 38 / 47),
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoryProducts(
                                categoryID: categories[index].id,
                                categoryTitle: categories[index].title))),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFE2E1E1)),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      padding: EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 12.0),
                      margin: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 10.0, top: 10.0, right: 10.0),
                            child: Text(
                              categories[index].title,
                              style: TextStyle(
                                  color: Color(0xFF36476C),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            child: Center(
                                child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Image.network(categories[index].image),
                            )),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      );
    } else {
      return Center(
        child: Text('Está vacío, ¿ves?'),
      );
    }
  }
}
