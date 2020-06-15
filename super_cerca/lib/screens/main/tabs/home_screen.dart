import 'package:flutter/material.dart';
// External imports
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supercerca/models/category.dart';
import 'package:supercerca/widgets/product_container.dart';
import 'package:transparent_image/transparent_image.dart';
// Internal imports
import 'package:supercerca/models/product.dart';
import 'package:supercerca/models/user.dart';
import 'package:supercerca/services/database_service.dart';
import 'package:supercerca/widgets/cart_icon.dart';
import 'package:supercerca/widgets/loading_widget.dart';
import 'package:supercerca/widgets/search_field.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void refresh() {
    setState(() {});
  }

  Widget _buildCarouselShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Container(
        height: (MediaQuery.of(context).size.width) * (2 / 3),
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    List<Category> categories = Provider.of<List<Category>>(context);

    return StreamBuilder<Object>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            UserData userData = snapshot.data;

            return ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(32.0, 40.0, 30.0, 0.0),
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
                                      fontSize: 28.0,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: userData.userName.contains(" ")
                                      ? userData.userName.substring(
                                          0, userData.userName.indexOf(" "))
                                      : userData.userName,
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontFamily: 'Nunito',
                                      fontSize: 28.0,
                                      fontWeight: FontWeight.bold))
                            ]),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: CartIcon(notifyParent: refresh)),
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
                  child: SearchField(notifyParent: refresh),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text('Populares',
                      style: TextStyle(
                          color: Color(0xFF36476C),
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 10.0),
                StreamBuilder<QuerySnapshot>(
                    stream:
                        Firestore.instance.collection('carousel').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return _buildCarouselShimmer(context);
                      }

                      if (snapshot.data.documents.isEmpty) {
                        return SizedBox.shrink();
                      }

                      Widget _carouselItemBuilder(
                          BuildContext context, int index) {
                        return Stack(
                          children: <Widget>[
                            Center(
                              child: SpinKitChasingDots(color: Colors.blue),
                            ),
                            Container(
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: snapshot
                                    .data.documents[index].data['image'],
                                fit: BoxFit.fill,
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                              ),
                            )
                          ],
                        );
                      }

                      return CarouselSlider.builder(
                        itemBuilder: _carouselItemBuilder,
                        itemCount: snapshot.data.documents.length,
                        options: CarouselOptions(
                            autoPlay: true,
                            enlargeCenterPage: true,
                            pauseAutoPlayOnTouch: true,
                            aspectRatio: 2.0),
                      );
                    }),
                SizedBox(height: 20.0),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text('Las promociones de hoy',
                        style: TextStyle(
                            color: Color(0xFF36476C),
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold))),
                SizedBox(height: 10.0),
                Container(
                  height: 480,
                  child: StreamBuilder<List<Product>>(
                      stream: DatabaseService().products(categories
                          .where((element) => element.id == 'promotions')
                          .first
                          .id),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return Container();

                        List<Product> products = snapshot.data;

                        return GridView.builder(
                          itemCount: products.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, childAspectRatio: 7 / 5),
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return ProductContainer(product: products[index], notifyParent: refresh);
                          },
                        );
                      }),
                ),
              ],
            );
          } else {
            return LoadingWidget();
          }
        });
  }
}
