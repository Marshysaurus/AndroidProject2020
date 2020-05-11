import 'package:flutter/material.dart';
// External imports
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:supercerca/models/product.dart';
// Internal imports
import 'package:supercerca/models/user.dart';
import 'package:supercerca/screens/main/products/details_screen.dart';
import 'package:supercerca/services/database_service.dart';
import 'package:supercerca/widgets/loading_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  int _current = 0;
  final List<String> imgList = ['red', 'green', 'blue'];

  List<Product> products;

  @override
  void initState() {
    super.initState();
    products = [
      Product(id: 'ID 1', title: 'Cabbage boi', price: 20.00, image: 'https://img.game8.co/3230742/b96cc2a1725020492adae5d560ca851d.png/show'),
      Product(id: 'ID 2', title: 'Lechuguita', price: 20.00, image: 'https://img.game8.co/3230742/b96cc2a1725020492adae5d560ca851d.png/show'),
      Product(id: 'ID 3', title: 'Cebolla', price: 20.00, image: 'https://img.game8.co/3230742/b96cc2a1725020492adae5d560ca851d.png/show'),
      Product(id: 'ID 4', title: 'Producto 4', price: 20.00, image: 'https://img.game8.co/3230742/b96cc2a1725020492adae5d560ca851d.png/show'),
      Product(id: 'ID 5', title: 'Producto 5', price: 20.00, image: 'https://img.game8.co/3230742/b96cc2a1725020492adae5d560ca851d.png/show'),
      Product(id: 'ID 6', title: 'Producto 6', price: 20.00, image: 'https://img.game8.co/3230742/b96cc2a1725020492adae5d560ca851d.png/show'),
      Product(id: 'ID 7', title: 'Producto 7', price: 20.00, image: 'https://img.game8.co/3230742/b96cc2a1725020492adae5d560ca851d.png/show'),
      Product(id: 'ID 8', title: 'Producto 8', price: 20.00, image: 'https://img.game8.co/3230742/b96cc2a1725020492adae5d560ca851d.png/show'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    final TextEditingController _searchController = TextEditingController();
    final FocusNode _searchNode = FocusNode();
    final border = OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
        borderSide: BorderSide.none);

    return StreamBuilder<Object>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            UserData userData = snapshot.data;
            return ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(32.0, 40.0, 32.0, 0.0),
                  child: Container(
                    height: 60.0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 6,
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "Hola, ",
                                  style: TextStyle(
                                      color: Color(0xFF36476C),
                                      fontFamily: 'Nunito',
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: userData.userName.contains(" ")
                                      ? userData.userName.substring(
                                          0, userData.userName.indexOf(" "))
                                      : userData.userName,
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontFamily: 'Nunito',
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold))
                            ]),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.shopping_cart,
                                color: Colors.blue,
                                size: 28.0,
                              )),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  transform: Matrix4.translationValues(0.0, -16.0, 0.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "¿Qué necesitas hoy?",
                      style: TextStyle(
                          color: Color(0xFF36476C),
                          fontFamily: 'Nunito',
                          fontSize: 18.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchNode,
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
                SizedBox(height: 20.0),
                CarouselSlider(
                  items: [
                    Container(color: Colors.red),
                    Container(color: Colors.green),
                    Container(color: Colors.blue)
                  ],
                  options: CarouselOptions(
                      autoPlay: false,
                      enlargeCenterPage: true,
                      aspectRatio: 2.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imgList.map((url) {
                    int index = imgList.indexOf(url);
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == index
                            ? Color.fromRGBO(0, 0, 0, 0.9)
                            : Color.fromRGBO(0, 0, 0, 0.4),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 40.0),
                Container(
                  height: 100,
                  child: GridView.builder(
                    itemCount: products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                    ),
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailsScreen(product: products[index]))),
                        child: Center(
                          child: Text(products[index].title),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  height: 100,
                  child: GridView.builder(
                    itemCount: products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                    ),
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      // TODO: Poner items desde firestore con ML para productos recomendados
                      return InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailsScreen(product: products[index]))),
                        child: Center(
                          child: Text(products[index].title),
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          } else {
            return LoadingWidget();
          }
        });
  }
}
