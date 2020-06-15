import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supercerca/models/order.dart';
// Internal imports
import 'package:supercerca/models/product.dart';
import 'package:supercerca/singletons/cart.dart';

class ProductRow extends StatefulWidget {
  ProductRow({@required this.product, this.notifyParent});
  final Product product;
  final Function() notifyParent;

  @override
  _ProductRowState createState() => _ProductRowState();
}

class _ProductRowState extends State<ProductRow> {

  @override
  Widget build(BuildContext context) {
    Order order = myCart.orders[widget.product.id];

    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFE2E1E1)),
          borderRadius: BorderRadius.all(Radius.circular(5.0))
      ),
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(widget.product.image, height: 70.0, width: 70.0),
                SizedBox(width: 10.0),
                Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.product.title,
                        style: TextStyle(color: Color(0xFF36476C), fontSize: 18.0, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text('\$${widget.product.price.toStringAsFixed(2)} (kg)',
                          style: TextStyle(color: Color(0xFF36476C), fontSize: 16.0))
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 1.5),
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: order.quantity > 1
                      ? () {
                          setState(() {
                            order.productAddRemove(-1);
                            myCart.orders.update(widget.product.id, (v) => order,
                                ifAbsent: () => order);
                            widget.notifyParent();
                          });
                        }
                      : (order.quantity == 1
                          ? () {
                              setState(() {
                                order.productAddRemove(-1);
                                myCart.orders.remove(widget.product.id);
                                widget.notifyParent();
                              });
                            }
                          : null),
                  child: Icon(Icons.remove, color: Colors.blue, size: 16.0),
                ),
                SizedBox(width: 4.0),
                Container(
                  width: 50.0,
                  child: Text(
                    '${order.quantity}pz',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 4.0),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: order.quantity < 10
                      ? () {
                          setState(() {
                            order.productAddRemove(1);
                            myCart.orders.update(widget.product.id, (v) => order,
                                ifAbsent: () => order);
                            widget.notifyParent();
                          });
                        }
                      : null,
                  child: Icon(Icons.add,
                      color:
                          order.quantity < 10 ? Colors.blue : Colors.transparent,
                      size: 16.0),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
