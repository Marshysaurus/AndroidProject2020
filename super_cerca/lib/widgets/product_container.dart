import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// Internal imports
import 'package:supercerca/models/order.dart';
import 'package:supercerca/models/product.dart';
import 'package:supercerca/screens/main/products/details_screen.dart';
import 'package:supercerca/singletons/cart.dart';

class ProductContainer extends StatefulWidget {
  ProductContainer({@required this.product, this.notifyParent});
  final Product product;
  final Function() notifyParent;

  @override
  _ProductContainerState createState() => _ProductContainerState();
}

class _ProductContainerState extends State<ProductContainer> {
  Order order;

  void refresh() {
    setState(() {});
  }

  Widget addButton() {
    return ButtonTheme(
      minWidth: double.infinity,
      height: 28.0,
      child: FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Text('Agregar', style: TextStyle(fontSize: 18.0)),
        color: Colors.blue,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
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

  Widget quantityRow() {
    return Container(
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
          SizedBox(width: 8.0),
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
          SizedBox(width: 8.0),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: order.quantity < 10
                ? () {
                    setState(() {
                      order.productAddRemove(1);
                      myCart.orders.update(widget.product.id, (v) => order,
                          ifAbsent: () => order);
                    });
                  }
                : null,
            child: Icon(Icons.add,
                color: order.quantity < 10 ? Colors.blue : Colors.transparent,
                size: 16.0),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (!myCart.orders.containsKey(widget.product.id))
      order =
          Order(product: widget.product, quantity: 0, measure: Measure.piece);
  }

  @override
  Widget build(BuildContext context) {
    if (myCart.orders.containsKey(widget.product.id))
      order = myCart.orders[widget.product.id];

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailsScreen(
                  product: widget.product, notifyParent: widget.notifyParent))),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFE2E1E1)),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        padding: EdgeInsets.fromLTRB(14.0, 4.0, 14.0, 12.0),
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(widget.product.image,
                  height: 80.0, width: 80.0),
            ),
            Text('\$${widget.product.price.toStringAsFixed(2)}',
                style: TextStyle(
                    color: Color(0xFF36476C),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold)),
            Text('${widget.product.title}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Color(0xFF36476C), fontSize: 18.0)),
            Spacer(),
            (myCart.orders.containsKey(widget.product.id))
                ? quantityRow()
                : addButton(),
          ],
        ),
      ),
    );
  }
}
