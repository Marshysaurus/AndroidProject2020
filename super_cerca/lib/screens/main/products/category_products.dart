import 'package:flutter/material.dart';
import 'package:supercerca/screens/main/products/details_screen.dart';
import 'package:supercerca/services/database_service.dart';

class CategoryProducts extends StatefulWidget {
  CategoryProducts({this.categoryID, this.categoryTitle});
  final String categoryID;
  final String categoryTitle;

  @override
  _CategoryProductsState createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchNode = FocusNode();
  final border = OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(5.0),
      ),
      borderSide: BorderSide.none);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(32.0, 40.0, 32.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      style: TextStyle(color: Color(0xFF36476C), fontSize: 20.0),
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
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                widget.categoryTitle,
                style: TextStyle(color: Color(0xFF36476C), fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            StreamBuilder(
              stream: DatabaseService().products(widget.categoryID),
              builder: (BuildContext context, snapshot) {
                if (snapshot.data != null) {
                  return GridView.builder(
                    itemCount: snapshot.data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DetailsScreen(product: snapshot.data[index]))),
                          child: Container(
                            child: Center(child: Image.network(snapshot.data[index].title)),
                          ),
                        );
                      });
                } else {
                  return Container(
                    child: Text('Errores'),
                  );
                }
              },
            ),
          ],
        ),
      )
    );
  }
}
