import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsScreen extends StatefulWidget {
  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  CameraPosition _initialPosition = CameraPosition(target: LatLng(19.28419204919249, -99.1359024219625), zoom: 17);
  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    final TextEditingController _directionController = TextEditingController();
    final FocusNode _directionNode = FocusNode();
    final border = OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
        borderSide: BorderSide.none);

    return Scaffold(
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(32.0, 40.0, 32.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      /*InkWell(
                        focusColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          height: 28.0,
                          width: 28.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.blue
                          ),
                          child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.0),
                        ),
                      ),
                      SizedBox(width: 10.0),*/
                      Text(
                        "Confirmar Dirección",
                        style: TextStyle(color: Colors.blue, fontSize: 28.0, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Text("Tecnológico de Monterrey Campus Ciudad de México",
                    style: TextStyle(color: Color(0xFF36476C), fontSize: 20.0),
                  )
                ],
              ),
            ),
            SizedBox(height: 32.0),
            Container(
              height: 400.0,
              width: double.infinity,
              child: Stack(
                children: [
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: _initialPosition,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: TextField(
                controller: _directionController,
                focusNode: _directionNode,
                style: TextStyle(color: Color(0xFF36476C), fontSize: 20.0),
                decoration: InputDecoration(
                    border: border,
                    disabledBorder: border,
                    enabledBorder: border,
                    filled: true,
                    fillColor: Color(0xFFF5F5F8),
                    focusedBorder: border,
                    hintText: 'Apartamento, Casa',
                    hintStyle: TextStyle(
                        color: Color(0xFF36476C).withOpacity(0.5)),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              width: double.infinity,
              child: ButtonTheme(
                height: 45.0,
                child: FlatButton(
                  child: Text('¡Listo!',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold)),
                  color: Colors.blue,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: Colors.blue, width: 1.5)),
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, '/main', (_) => false),
                ),
              ),
            )
          ],
        ));
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }
}



