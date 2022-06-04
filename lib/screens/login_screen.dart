import 'dart:convert';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rowing_app/helpers/api_helper.dart';
import 'package:rowing_app/helpers/constants.dart';
import 'package:rowing_app/components/loader_component.dart';
import 'package:rowing_app/models/models.dart';
import 'package:rowing_app/models/user.dart';
import 'package:rowing_app/screens/home_screen.dart';
import 'package:rowing_app/screens/novedades_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

  String _email = 'GPRIETO';
  //String _email = 'AVASILE';
  //String _email = '';
  //String _email = 'CHIDALGO';
  String _emailError = '';
  bool _emailShowError = false;

  String _password = 'CELESTE';
  //String _password = 'AVA123';
  //String _password = '';
  //String _password = 'CHI123';
  String _passwordError = '';
  bool _passwordShowError = false;

  bool _rememberme = true;
  bool _passwordShow = false;
  bool _showLoader = false;

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff8c8c94),
      body: Stack(
        children: <Widget>[
          Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff242424),
                    Color(0xff8c8c94),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Image.asset(
                    "assets/logo.png",
                    height: 200,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Constants.version,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              )),
          Transform.translate(
            offset: Offset(0, -60),
            child: Center(
              child: SingleChildScrollView(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 15,
                  margin: EdgeInsets.only(
                      left: 20, right: 20, top: 260, bottom: 20),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _showEmail(),
                        _showPassword(),
                        SizedBox(
                          height: 10,
                        ),
                        _showRememberme(),
                        _showButtons(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
          _showLoader
              ? LoaderComponent(
                  text: 'Por favor espere...',
                )
              : Container(),
        ],
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWLOGO ---------------------------
//-----------------------------------------------------------------

  Widget _showLogo() {
    return Image(
      image: AssetImage('assets/logo.png'),
      width: 300,
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWEMAIL --------------------------
//-----------------------------------------------------------------

  Widget _showEmail() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Usuario...',
            labelText: 'Usuario',
            errorText: _emailShowError ? _emailError : null,
            prefixIcon: Icon(Icons.person),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _email = value;
        },
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWPASSWORD -----------------------
//-----------------------------------------------------------------

  Widget _showPassword() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        obscureText: !_passwordShow,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Contraseña...',
            labelText: 'Contraseña',
            errorText: _passwordShowError ? _passwordError : null,
            prefixIcon: Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: _passwordShow
                  ? Icon(Icons.visibility)
                  : Icon(Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _passwordShow = !_passwordShow;
                });
              },
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _password = value;
        },
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWREMEMBERME ---------------------
//-----------------------------------------------------------------

  _showRememberme() {
    return CheckboxListTile(
      title: Text('Recordarme:'),
      value: _rememberme,
      onChanged: (value) {
        setState(() {
          _rememberme = value!;
        });
      },
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWBUTTONS ------------------------
//-----------------------------------------------------------------

  Widget _showButtons() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.login),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Iniciar Sesión'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF781f1e),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () => _login(),
            ),
          ),
        ],
      ),
    );
  }

//*****************************************************************************
//************************** METODO LOGIN *************************************
//*****************************************************************************

  void _login() async {
    FocusScope.of(context).unfocus(); //Oculta el teclado

    setState(() {
      _passwordShow = false;
    });

    if (!validateFields()) {
      return;
    }

    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estes conectado a internet.',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Map<String, dynamic> request = {
      'Email': _email,
      'password': _password,
    };

    var url = Uri.parse('${Constants.apiUrl}/Api/Account/GetUserByEmail');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(request),
    );

    if (response.statusCode >= 400) {
      setState(() {
        _passwordShowError = true;
        _passwordError = 'Email o contraseña incorrectos';
        _showLoader = false;
      });
      return;
    }

    var body = response.body;
    var decodedJson = jsonDecode(body);
    var user = User.fromJson(decodedJson);

    if (user.contrasena.toLowerCase() != _password.toLowerCase()) {
      setState(() {
        _showLoader = false;
        _passwordShowError = true;
        _passwordError = 'Email o contraseña incorrectos';
      });
      return;
    }

    if (user.habilitaAPP != 1) {
      setState(() {
        _showLoader = false;
        _passwordShowError = true;
        _passwordError = 'Usuario no habilitado';
      });
      return;
    }

    if (_rememberme) {
      _storeUser(body);
    }

    setState(() {
      _showLoader = false;
    });

    if (user.codigoCausante != user.login) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(
                    user: user,
                  )));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => NovedadesScreen(
                    user: user,
                  )));
    }
  }

//*****************************************************************************
//************************** METODO VALIDATEFIELDS ****************************
//*****************************************************************************

  bool validateFields() {
    bool isValid = true;

    if (_email.isEmpty) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar tu Usuario';
    } else {
      _emailShowError = false;
    }

    if (_password.isEmpty) {
      isValid = false;
      _passwordShowError = true;
      _passwordError = 'Debes ingresar tu Contraseña';
    } else if (_password.length < 6) {
      isValid = false;
      _passwordShowError = true;
      _passwordError = 'La Contraseña debe tener al menos 6 caracteres';
    } else {
      _passwordShowError = false;
    }

    setState(() {});

    return isValid;
  }

  void _storeUser(String body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRemembered', true);
    await prefs.setString('userBody', body);
    await prefs.setString('date', DateTime.now().toString());
  }
}
