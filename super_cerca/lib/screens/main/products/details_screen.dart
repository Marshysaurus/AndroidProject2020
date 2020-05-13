import 'package:flutter/material.dart';
// Internal imports
import 'package:supercerca/models/product.dart';

class DetailsScreen extends StatefulWidget {
  DetailsScreen({@required this.product});
  final Product product;

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(32.0, 40.0, 32.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.product.title,
                style: TextStyle(
                    color: Color(0xFF36476C),
                    fontFamily: 'Nunito',
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold)),
            Container(
              margin: EdgeInsets.symmetric(vertical: 25.0),
              child: Center(
                  child: Image.network(widget.product.image,
                      height: 150, width: 150)),
            ),
            Text('Precio: \$${widget.product.price} (kg)',
                style: TextStyle(
                    color: Color(0xFF36476C),
                    fontFamily: 'Nunito',
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold)),
            Container(
              margin: EdgeInsets.only(bottom: 4.0),
              child: Text('Notas',
                  style: TextStyle(
                      color: Color(0xFF36476C),
                      fontFamily: 'Nunito',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold)),
            ),
            TextField(
              minLines: 3,
              maxLines: 3,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Colors.black, fontSize: 18.0),
              decoration: InputDecoration(
                fillColor: Color(0xFFF5F5F8),
                filled: true,
                hintText: "Agrega aquí las notas para tu ayudante...",
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
                    textColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: Colors.blue, width: 1.5)),
                    onPressed: () => print('uwu'),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: FlatButton(
                    child: Text('Gramo',
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold)),
                    color: Colors.blue,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: Colors.blue, width: 1.5)),
                    onPressed: () => print('owo'),
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
                    icon: Icon(Icons.remove, color: Colors.blue),
                    onPressed: null,
                  ),
                  SizedBox(width: 32.0),
                  Container(
                    width: 120.0,
                    child: Text(
                      '100gr',
                      style: TextStyle(color: Colors.blue, fontSize: 18.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 32.0),
                  IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: Icon(Icons.add, color: Colors.blue),
                    onPressed: null,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              width: double.infinity,
              child: ButtonTheme(
                height: 45.0,
                child: FlatButton(
                  child: Text('Agregar',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold)),
                  color: Colors.blue,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: Colors.blue, width: 1.5)),
                  onPressed: () => print('owo'),
                ),
              ),
            ),
            SizedBox(height: 15.0),
            Container(
              width: double.infinity,
              child: ButtonTheme(
                height: 45.0,
                child: FlatButton(
                  child: Text('Regresar',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold)),
                  color: Color(0xFFF5F5F8),
                  textColor: Color(0xFF969EB2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
