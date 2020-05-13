import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supercerca/models/category.dart';
import 'package:supercerca/screens/main/products/category_products.dart';

class HallsScreen extends StatefulWidget {
  @override
  _HallsScreenState createState() => _HallsScreenState();
}

class _HallsScreenState extends State<HallsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchNode = FocusNode();
  final border = OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(5.0),
      ),
      borderSide: BorderSide.none);

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<List<Category>>(context);

    if (categories != null) {
      return Padding(
        padding: EdgeInsets.fromLTRB(32.0, 40.0, 32.0, 0.0),
        child: Column(
          children: [
            Container(
              height: 60.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 6,
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchNode,
                      textAlignVertical: TextAlignVertical.bottom,
                      style:
                          TextStyle(color: Color(0xFF36476C), fontSize: 20.0),
                      decoration: InputDecoration(
                          border: border,
                          disabledBorder: border,
                          enabledBorder: border,
                          filled: true,
                          fillColor: Color(0xFFF5F5F8),
                          focusedBorder: border,
                          hintText: 'Buscar',
                          hintStyle: TextStyle(
                              color: Color(0xFF36476C).withOpacity(0.5)),
                          prefixIcon:
                              Icon(Icons.search, color: Color(0xFF36476C))),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.shopping_cart,
                            color: Colors.blue, size: 28.0)),
                  )
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0)
                    ),
                    child: Stack(
                      children: [
                        // Un poco de hardcodeo por las fotos con fondo blanco
                        Positioned.fill(child: Container(color: Colors.white)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
                              child: Text(categories[index].title,
                                style: TextStyle(color: Color(0xFF36476C), fontSize: 16.0, fontWeight: FontWeight.bold),
                                maxLines: 2,
                              ),
                            ),
                            Expanded(
                              child: Center(child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Image.network(categories[index].image),
                              )),
                            )
                          ],
                        ),
                        Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CategoryProducts(
                                              categoryID: categories[index].id, categoryTitle: categories[index].title)))
                              ),
                            ))
                      ],
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
