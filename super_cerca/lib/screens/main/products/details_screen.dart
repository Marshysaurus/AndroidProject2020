import 'package:flutter/material.dart';
// Internal imports
import 'package:supercerca/models/product.dart';
import 'package:supercerca/models/order.dart';
import 'package:supercerca/singletons/cart.dart';
import 'package:supercerca/widgets/return_button.dart';

class DetailsScreen extends StatefulWidget {
  DetailsScreen({@required this.product, this.notifyParent});
  final Product product;
  final Function() notifyParent;

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  TextEditingController _controller;
  Order order;

  void refresh() {
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    if (myCart.orders.containsKey(widget.product.id))
      order = myCart.orders[widget.product.id];
    else
      order =
          Order(product: widget.product, quantity: 0, measure: Measure.piece);
    _controller = TextEditingController(text: order.notes);
  }

  @override
  Widget build(BuildContext context) {
    Widget addButton() {
      return ButtonTheme(
        height: 45.0,
        child: FlatButton(
          child: Text('Agregar',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          color: Colors.blue,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
              side: BorderSide(color: Colors.blue, width: 1.5)),
          onPressed: () {
            setState(() {
              order.productAddRemove(1);
              myCart.orders.putIfAbsent(widget.product.id, () => order);
              widget.notifyParent();
            });
          },
        ),
      );
    }

    Widget removeButton() {
      return ButtonTheme(
        height: 45.0,
        child: FlatButton(
          child: Text('Quitar del carrito',
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold)),
          color: Colors.white,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
              side: BorderSide(color: Colors.red, width: 1.5)),
          onPressed: () {
            setState(() {
              myCart.orders.remove(widget.product.id);
              order.quantity = 0;
              widget.notifyParent();
            });
          },
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(32.0, 40.0, 32.0, 20.0),
          children: [
            Text(widget.product.title,
                style: TextStyle(
                    color: Color(0xFF36476C),
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 25.0),
              child: Center(
                  child: Image.network(widget.product.image,
                      height: 125, width: 125)),
            ),
            Text(
                'Precio: \$${widget.product.price.toStringAsFixed(2)}',
                style: TextStyle(
                    color: Color(0xFF36476C),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold)),
            Container(
              margin: EdgeInsets.only(bottom: 4.0),
              child: Text('Notas',
                  style: TextStyle(
                      color: Color(0xFF36476C),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold)),
            ),
            TextField(
              controller: _controller,
              onChanged: (text) => order.notes = text,
              minLines: 4,
              maxLines: 4,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Colors.black, fontSize: 20.0),
              decoration: InputDecoration(
                fillColor: Color(0xFFE2E1E1),
                filled: true,
                hintText: "Agrega aquí las notas para tu ayudante...",
                hintStyle: TextStyle(color: Color(0xFF969EB2)),
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: FlatButton(
                    child: Text('Pieza',
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold)),
                    color: order.measure == Measure.piece
                        ? Colors.blue
                        : Colors.white,
                    textColor: order.measure == Measure.piece
                        ? Colors.white
                        : Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: Colors.blue, width: 1.5)),
                    onPressed: () {
                      setState(() {
                        order.measure = Measure.piece;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: FlatButton(
                    child: Text('Gramo',
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold)),
                    color: order.measure == Measure.kg
                        ? Colors.blue
                        : Colors.white,
                    textColor: order.measure == Measure.kg
                        ? Colors.white
                        : Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: Colors.blue, width: 1.5)),
                    onPressed: () {
                      setState(() {
                        order.measure = Measure.kg;
                      });
                    },
                  ),
                )
              ],
            ),
            SizedBox(height: 10.0),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 1.5),
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: Icon(Icons.remove,
                          color: order.quantity > 0
                              ? Colors.blue
                              : Colors.transparent),
                      onPressed: order.quantity > 0
                          ? () {
                              setState(() {
                                order.productAddRemove(-1);
                                if (order.quantity == 0)
                                  myCart.orders.remove(widget.product.id);
                                else
                                  myCart.orders.update(
                                      widget.product.id, (v) => order,
                                      ifAbsent: () => order);
                                widget.notifyParent();
                              });
                            }
                          : null),
                  SizedBox(width: 32.0),
                  Container(
                    width: 120.0,
                    child: Text(
                      '${order.quantity}pz',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 32.0),
                  IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: Icon(Icons.add,
                        color: order.quantity < 10
                            ? Colors.blue
                            : Colors.transparent),
                    onPressed: order.quantity < 10
                        ? () {
                            setState(() {
                              order.productAddRemove(1);
                              myCart.orders.update(
                                  widget.product.id, (v) => order,
                                  ifAbsent: () => order);
                              widget.notifyParent();
                            });
                          }
                        : null,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              width: double.infinity,
              child: order.quantity > 0 ? removeButton() : addButton(),
            ),
            SizedBox(height: 10.0),
            ReturnButton(notifyParent: refresh)
          ],
        ),
      ),
    );
  }
}
