import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/services.dart';
import 'package:supercerca/services/auth_service.dart';
import 'package:supercerca/utils/custom_scroll.dart';
import 'package:supercerca/widgets/loading_widget.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Tag para la animation de Flare
  String animation;

  bool loading;

  final AuthService _authService = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  String _emailError;
  String _wrongPasswordError;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    animation = 'idle';
    loading = false;
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _loadWidget();
    return Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                    _buildForm(),
                    loading ? ModalBarrier(
                      color: Colors.black54,
                    ) : SizedBox.shrink(),
                    loading ? LoadingWidget() : SizedBox.shrink()
                  ],
                )),
          ),
        ));
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
          children: <Widget>[
            Container(
              height: 125.0,
              width: 125.0,
              child: Hero(
                tag: 'heartLogo',
                child: FlareActor(
                  'assets/pumping-heart.flr',
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: animation,
                ),
              ),
            ),
            Center(
              child: Hero(
                tag: 'text',
                child: Text("SUPER\nCERCA",
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(fontWeight: FontWeight.w800, height: 1.0)),
              ),
            ),
            SizedBox(height: 32.0),
            Text("Inicio de sesión",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 32.0),
            TextFormField(
              textInputAction: TextInputAction.next,
              onFieldSubmitted: _onEmailSubmitted,
              focusNode: _emailFocus,
              controller: _emailController,
              validator: _validateEmail,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Colors.black, fontSize: 18.0),
              decoration: InputDecoration(
                errorText: _emailError,
                fillColor: Color(0xFFF5F5F8),
                filled: true,
                hintText: "Correo",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 30.0),
            TextFormField(
              focusNode: _passwordFocus,
              controller: _passwordController,
              validator: _validatePassword,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Colors.black, fontSize: 18.0),
              // controller: _contra,
              decoration: InputDecoration(
                errorText: _wrongPasswordError,
                fillColor: Color(0xFFF5F5F8),
                filled: true,
                hintText: "Contraseña",
                labelStyle: TextStyle(color: Colors.white),
                suffixIcon: InkWell(
                  child: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.white,
                  ),
                  onTap: _toggleViewPassword,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              keyboardType: TextInputType.text,
              obscureText: !_isPasswordVisible,
            ),
            SizedBox(height: 50.0),
            ButtonTheme(
              height: 45.0,
              minWidth: double.infinity,
              child: FlatButton(
                color: Color(0xFF0096FF),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    setState(() => loading = true);
                    dynamic result =
                        await _authService.signInWithEmailAndPassword(
                            _emailController.text, _passwordController.text);
                    if (result == null) {
                      setState(() => loading = false);
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                          'El usuario o la contraseña no son correctos.',
                          style: TextStyle(color: Colors.white),
                        ),
                        duration: Duration(seconds: 4),
                        backgroundColor: Colors.red,
                      ));
                    } else {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/main', (_) => false);
                    }
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                // onPressed: _handleSignIn,
                textColor: Colors.white,
                child: Text(
                  'Iniciar sesión',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                    text: "¿No tienes cuenta? ",
                    style: TextStyle(
                        color: Color(0xFF36476C),
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400)),
                TextSpan(
                  text: " Regístrate.",
                  style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Navigator.pushNamed(context, '/register'),
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }

  void _loadWidget() async {
    await Future.delayed(Duration(milliseconds: 10));
    setState(() {
      animation = 'slow-pump';
    });
  }

  String _validateEmail(String email) =>
      EmailValidator.validate(email) ? null : 'Email inválido';

  String _validatePassword(String password) =>
      password.isEmpty ? 'Contraseña inválida' : null;

  void _onEmailSubmitted(String term) {
    _emailFocus.unfocus();
    FocusScope.of(context).requestFocus(_passwordFocus);
  }

  void _toggleViewPassword() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }
}
