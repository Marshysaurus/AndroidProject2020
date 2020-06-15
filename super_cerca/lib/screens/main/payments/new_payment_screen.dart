import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// External imports
import 'package:stripe_payment/stripe_payment.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:supercerca/models/user.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:supercerca/utils/custom_scroll.dart';
import 'package:supercerca/widgets/return_button.dart';

class NewPaymentMethodScreen extends StatefulWidget {
  @override
  _NewPaymentMethodScreenState createState() => _NewPaymentMethodScreenState();
}

class _NewPaymentMethodScreenState extends State<NewPaymentMethodScreen> {
  User user;
  final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
    functionName: 'addPaymentMethod',
  );
  // addPaymentMethod

  CreditCard testCard;
  PaymentMethod _paymentMethod;

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  refresh() {
    setState(() {});
  }

  callFunction() {
    Future.delayed(Duration(seconds: 2), () async {
      await callable.call(<String, dynamic>{
        'uid': '${user.uid}',
        'id': '${_paymentMethod.id}',
      });
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              elevation: 5.0,
              title: Text('Método de pago añadido con éxito',
                  style: TextStyle(
                      color: Color(0xFF36476C),
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold)),
              actions: [
                FlatButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text('Aceptar',
                      style:
                      TextStyle(fontSize: 16.0)),
                )
              ],
            );
          });
    });
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  @override
  void initState() {
    StripePayment.setOptions(StripeOptions(
        publishableKey:
            "pk_test_51Gtf49Ltfl1EdMnHumxsIzBSUIlVLQyJ5XqokzjHXXFyV3ffnvrK30BhpJUXOXtb7XpFcFYhBMrheIXapZr4uWp200IOOg3QXq",
        merchantId: "Test",
        androidPayMode: 'test'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    return Scaffold(
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView(
            padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20.0),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Nuevo Método de Pago',
                    style: TextStyle(
                        color: Colors.blue,
                        fontFamily: 'Nunito',
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold)),
              ),
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                cardBgColor: Color(0xFF5F5AB7),
              ),
              CreditCardForm(
                onCreditCardModelChange: onCreditCardModelChange,
              ),
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
                    onPressed: () async {
                      if (cardHolderName.isNotEmpty &&
                          cardNumber.replaceAll(' ', '').length == 16 &&
                          expiryDate.length == 5 &&
                          (cvvCode.length == 3 || cvvCode.length == 4)) {
                        testCard = CreditCard(
                          name: cardHolderName,
                          number: cardNumber.replaceAll(' ', ''),
                          expMonth: int.parse(expiryDate.substring(0, 2)),
                          expYear: int.parse(expiryDate.substring(3)),
                          cvc: cvvCode,
                        );
                      }

                      if (testCard != null) {
                        StripePayment.createPaymentMethod(
                                PaymentMethodRequest(card: testCard))
                            .then((paymentMethod) {
                          setState(() {
                            _paymentMethod = paymentMethod;
                          });
                        }).catchError((error) {});
                        callFunction();
                      }
                    },
                  ),
                ),
              ),
              ReturnButton(notifyParent: refresh)
            ],
          ),
        ),
      ),
    );
  }
}
