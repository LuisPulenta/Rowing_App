import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../screens.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
//---------------------------------------------------------------
//----------------------- Variables -----------------------------
//---------------------------------------------------------------

  String imei = '';

  String _email = '';
  String _password = '';

  // String _email = 'gprieto@rowing.com.ar';
  // String _password = '1950Arnaldo';

  // String _email = 'KEYPRESS';
  // String _password = 'KEYROOT';

  // String _email = 'GPRIETO';
  // String _password = 'CELESTE';

  // String _email = 'RODRIGUEZE';
  // String _password = 'ROD951';

  // String _email = '517676';
  // String _password = '94461399';

  // String _email = 'gaos@keypress.com.ar';
  // String _password = 'keyroot';

  // String _email = 'areyes@rowing.com.ar';
  // String _password = 'RW+483482';

  String _emailError = '';
  bool _emailShowError = false;

  String _passwordError = '';
  bool _passwordShowError = false;

  List<Catalogo> _catalogos = [];

  String _platformVersion = 'Unknown',
      _imeiNo = '',
      _modelName = '',
      _manufacturerName = '',
      _deviceName = '',
      _productName = '',
      _cpuType = '',
      _hardware = '';
  var _apiLevel;

  bool _rememberme = true;
  bool _passwordShow = false;
  bool _showLoader = false;

  Position _positionUser = const Position(
      longitude: 0,
      latitude: 0,
      timestamp: null,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);

  Parametro parametro = Parametro(
      id: 0,
      bloqueaactas: 0,
      ipServ: '',
      metros: 0,
      tiempo: 0,
      appBloqueada: 2);

//---------------------------------------------------------------
//----------------------- initState -----------------------------
//---------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _getParametro();
  }

  @override
  void dispose() {
    super.dispose();
  }

//---------------------------------------------------------------
//----------------------- Pantalla ------------------------------
//---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff8c8c94),
      body: Stack(
        children: <Widget>[
          Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 0),
              decoration: const BoxDecoration(
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
                    'assets/logo.png',
                    height: 200,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Constants.version,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              )),
          Transform.translate(
            offset: const Offset(0, -60),
            child: parametro.appBloqueada == 0
                ? Center(
                    child: SingleChildScrollView(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 15,
                        margin: const EdgeInsets.only(
                            left: 20, right: 20, top: 260, bottom: 20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 35, vertical: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _showEmail(),
                              _showPassword(),
                              const SizedBox(
                                height: 10,
                              ),
                              _showRememberme(),
                              _showButtons(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : parametro.appBloqueada == 1
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('App bloqueada temporalmente.',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            Text('Por favor reintente en unos minutos.',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    : Container(),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
          _showLoader
              ? const LoaderComponent(
                  text: 'Por favor espere...',
                )
              : Container(),
        ],
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- _showEmail --------------------------------
//-----------------------------------------------------------------

  Widget _showEmail() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Usuario...',
            labelText: 'Usuario',
            errorText: _emailShowError ? _emailError : null,
            prefixIcon: const Icon(Icons.person),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _email = value;
        },
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- _showPassword -----------------------------
//-----------------------------------------------------------------

  Widget _showPassword() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        obscureText: !_passwordShow,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Contraseña...',
            labelText: 'Contraseña',
            errorText: _passwordShowError ? _passwordError : null,
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: _passwordShow
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
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
//--------------------- _showRememberme ---------------------------
//-----------------------------------------------------------------

  _showRememberme() {
    return CheckboxListTile(
      title: const Text('Recordarme:'),
      value: _rememberme,
      activeColor: const Color(0xFF781f1e),
      onChanged: (value) {
        setState(() {
          _rememberme = value!;
        });
      },
    );
  }

//-----------------------------------------------------------------
//--------------------- _showButtons ------------------------------
//-----------------------------------------------------------------

  Widget _showButtons() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.login),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Iniciar Sesión'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF781f1e),
                minimumSize: const Size(double.infinity, 50),
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

//-----------------------------------------------------------------
//--------------------- _login ------------------------------------
//-----------------------------------------------------------------

  void _login() async {
    FocusScope.of(context).unfocus(); //Oculta el teclado

    setState(() {
      _passwordShow = false;
      _showLoader = true;
    });

    //---------- Valida campos -------------
    if (!validateFields()) {
      setState(() {
        _showLoader = false;
      });
      return;
    }

    //---------- Valida si hay Internet -------------
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });

      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: const Text('Error'),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Text('Verifica que estes conectado a internet.'),
                    SizedBox(
                      height: 10,
                    ),
                  ]),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Aceptar')),
              ],
            );
          });
      return;
    }

    //---------- Login si el Usuario ES un Email -------------
    if (_email.contains('@')) {
      //---------- CreateToken -------------
      Map<String, dynamic> request = {
        'userName': _email,
        'password': _password,
      };
      var url = Uri.parse('${Constants.apiUrl}/api/Account/CreateToken');
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
          _showLoader = false;
          _passwordShowError = true;
          _passwordError = 'Email o contraseña incorrectos';
        });
        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', _email);

      //---------- user2 -------------
      var body = response.body;
      var decodedJson = jsonDecode(body);
      var token = Token.fromJson(decodedJson);

      Map<String, dynamic> request2 = {
        'Email': _email,
      };
      url = Uri.parse('${Constants.apiUrl}/Api/Account/GetUserByEmail2');
      var response2 = await http.post(
        url,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          'authorization': 'bearer ${token.token}',
        },
        body: jsonEncode(request2),
      );

      var body2 = response2.body;
      var decodedJson2 = jsonDecode(body2);
      var user2 = User2.fromJson(decodedJson2);

      //-------------- Actualiza fecha LastLogin ---------------------
      url = Uri.parse('${Constants.apiUrl}/Api/Account/UpdateLoginDate');
      await http.put(
        url,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          'authorization': 'bearer ${token.token}',
        },
        body: jsonEncode(user2.email),
      );

      //---------- user3 -------------
      var user3 = User(
          idUsuario: 0,
          codigoCausante: '000000',
          login: '',
          contrasena: '',
          nombre: '',
          apellido: '',
          autorWOM: 0,
          estado: 0,
          habilitaAPP: 0,
          habilitaFotos: 0,
          habilitaReclamos: 0,
          habilitaSSHH: 0,
          habilitaRRHH: 0,
          modulo: '',
          habilitaMedidores: 0,
          habilitaFlotas: '',
          reHabilitaUsuarios: 0,
          codigogrupo: '',
          codigocausante: '',
          fullName: '',
          fechaCaduca: 0,
          intentosInvDiario: 0,
          opeAutorizo: 0,
          habilitaNuevoSuministro: 0,
          habilitaVeredas: 0,
          habilitaJuicios: 0,
          habilitaPresentismo: 0,
          habilitaSeguimientoUsuarios: 0,
          habilitaVerObrasCerradas: 0,
          habilitaElementosCalle: 0,
          habilitaCertificacion: 0,
          conceptomov: 0,
          conceptomova: 0,
          limitarGrupo: 0,
          rubro: 0,
          firmaUsuario: '',
          firmaUsuarioImageFullPath: '',
          appIMEI: '');

      if (user2.userType == 1) {
        Map<String, dynamic> request3 = {
          'Email': user2.codigo,
          'password': user2.document,
        };

        var url3 = Uri.parse('${Constants.apiUrl}/Api/Account/GetUserByEmail');
        var response3 = await http.post(
          url3,
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
          body: jsonEncode(request3),
        );

        if (response.statusCode >= 400) {
          setState(() {
            _passwordShowError = true;
            _passwordError = 'Email o contraseña incorrectos';
            _showLoader = false;
          });
          return;
        }

        var body3 = response3.body;
        var decodedJson3 = jsonDecode(body3);
        user3 = User.fromJson(decodedJson3);

        if (user3.habilitaAPP != 1) {
          setState(() {
            _showLoader = false;
            _passwordShowError = true;
            _passwordError = 'Usuario no habilitado';
          });
          return;
        }
      }

//--------------- Control del IMEI ---------------------------
      if (user3.appIMEI != null && user3.appIMEI!.isNotEmpty) {
        if (user3.appIMEI != imei) {
          setState(() {
            _showLoader = false;
          });
          await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: const Text('Aviso'),
                  content:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    Text(
                        'Este celular tiene el IMEI $imei, el cual no coincide con el IMEI que tiene registrado su Usuario.'),
                    const SizedBox(
                      height: 10,
                    ),
                  ]),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Ok')),
                  ],
                );
              });
          return;
        }
      }
      setState(() {
        _showLoader = false;
      });
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home3Screen(
              token: token, user2: user2, user: user3, password: _password),
        ),
      );
      return;
    }

    //---------- Login si el Usuario NO ES un email -------------

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

//--------------- Control del IMEI ---------------------------
    if (user.appIMEI != null && user.appIMEI!.isNotEmpty) {
      if (user.appIMEI != imei) {
        setState(() {
          _showLoader = false;
        });
        await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: const Text('Aviso'),
                content:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Text(
                      'Este celular tiene el IMEI $imei, el cual no coincide con el IMEI que tiene registrado su Usuario.'),
                  const SizedBox(
                    height: 10,
                  ),
                ]),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Ok')),
                ],
              );
            });
        return;
      }
    }

    if (_rememberme) {
      _storeUser(body);
    }

    // Agregar registro a  websesion

    Random r = Random();
    int resultado = r.nextInt((99999999 - 10000000) + 1) + 10000000;
    double hora = (DateTime.now().hour * 3600 +
            DateTime.now().minute * 60 +
            DateTime.now().second +
            DateTime.now().millisecond * 0.001) *
        100;

    WebSesion webSesion = WebSesion(
        nroConexion: resultado,
        usuario: user.idUsuario.toString(),
        iP: _imeiNo,
        loginDate: DateTime.now().toString(),
        loginTime: hora.round(),
        modulo: 'App-${user.codigoCausante}',
        logoutDate: '',
        logoutTime: 0,
        conectAverage: 0,
        id_ws: 0,
        versionsistema: Constants.version);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('nroConexion', resultado);

    // Si hay internet subir al servidor websesion

    connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      await _postWebSesion(webSesion);
    }

    //Guarda ubicación del Usuario en Tabla UsuariosGeos

    _getCatalogos(user.modulo);

    if (user.codigoCausante != user.login) {
      setState(() {
        _showLoader = false;
      });
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            user: user,
            nroConexion: webSesion.nroConexion,
            imei: imei,
          ),
        ),
      );
      return;
    } else {
      setState(() {
        _showLoader = false;
      });
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home2Screen(
            user: user,
            nroConexion: webSesion.nroConexion,
          ),
        ),
      );
      return;
    }
  }

//-----------------------------------------------------------------
//--------------------- validateFields ----------------------------
//-----------------------------------------------------------------

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

//-----------------------------------------------------------------
//--------------------- _postWebSesion ----------------------------
//-----------------------------------------------------------------

  Future<void> _postWebSesion(WebSesion webSesion) async {
    Map<String, dynamic> requestWebSesion = {
      'nroConexion': webSesion.nroConexion,
      'usuario': webSesion.usuario,
      'iP': webSesion.iP,
      'loginDate': webSesion.loginDate,
      'loginTime': webSesion.loginTime,
      'modulo': webSesion.modulo,
      'logoutDate': webSesion.logoutDate,
      'logoutTime': webSesion.logoutTime,
      'conectAverage': webSesion.conectAverage,
      'id_ws': webSesion.id_ws,
      'versionsistema': webSesion.versionsistema,
    };

    Response response =
        await ApiHelper.post('/api/WebSesions/', requestWebSesion);
  }

//-----------------------------------------------------------------
//--------------------- initPlatformState -------------------------
//-----------------------------------------------------------------

  Future<void> initPlatformState() async {
    late String platformVersion,
        imeiNo = '',
        modelName = '',
        manufacturer = '',
        deviceName = '',
        productName = '',
        cpuType = '',
        hardware = '';
    var apiLevel;
    // Platform messages may fail,
    // so we use a try/catch PlatformException.

    var status = await Permission.phone.status;

    if (status.isDenied) {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: const Text('Aviso'),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Text(
                        'La App necesita que habilite el Permiso de acceso al teléfono para registrar el IMEI del celular con que se loguea.'),
                    SizedBox(
                      height: 10,
                    ),
                  ]),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Ok')),
              ],
            );
          });
      openAppSettings();
      //exit(0);
    }

    try {
      platformVersion = await DeviceInformation.platformVersion;
      imeiNo = await DeviceInformation.deviceIMEINumber;
      imei = imeiNo;
      modelName = await DeviceInformation.deviceModel;
      manufacturer = await DeviceInformation.deviceManufacturer;
      apiLevel = await DeviceInformation.apiLevel;
      deviceName = await DeviceInformation.deviceName;
      productName = await DeviceInformation.productName;
      cpuType = await DeviceInformation.cpuName;
      hardware = await DeviceInformation.hardware;
    } on PlatformException catch (e) {
      platformVersion = '${e.message}';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _platformVersion = 'Running on :$platformVersion';
    _imeiNo = imeiNo;
    _modelName = modelName;
    _manufacturerName = manufacturer;
    _apiLevel = apiLevel;
    _deviceName = deviceName;
    _productName = productName;
    _cpuType = cpuType;
    _hardware = hardware;

    setState(() {});
  }

//-----------------------------------------------------------------
//--------------------- _getPosition ------------------------------
//-----------------------------------------------------------------

  Future _getPosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: const Text('Aviso'),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Text('El permiso de localización está negado.'),
                      SizedBox(
                        height: 10,
                      ),
                    ]),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Ok')),
                ],
              );
            });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: const Text('Aviso'),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Text(
                        'El permiso de localización está negado permanentemente. No se puede requerir este permiso.'),
                    SizedBox(
                      height: 10,
                    ),
                  ]),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Ok')),
              ],
            );
          });
      return;
    }

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      _positionUser = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    }

    setState(() {
      _showLoader = false;
    });
  }

//-----------------------------------------------------------------
//--------------------- _getCatalogos -----------------------------
//-----------------------------------------------------------------

  Future<void> _getCatalogos(String modulo) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      showMyDialog(
          'Error', 'Verifica que estés conectado a Internet', 'Aceptar');
    }

    Response response = Response(isSuccess: false);

    response = await ApiHelper.getCatalogosSuministros(modulo);

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    _catalogos = response.result;

    DBSuministroscatalogos.deleteall();
    for (var catalogo in _catalogos) {
      DBSuministroscatalogos.insertSuministrocatalogos(catalogo);
    }
  }

//-----------------------------------------------------------------
//--------------------- _getParametro -----------------------------
//-----------------------------------------------------------------

  Future<void> _getParametro() async {
    _showLoader = true;
    var url = Uri.parse('${Constants.apiUrl}/Api/UsuariosGeos/GetParametro');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      return;
    }

    parametro = Parametro.fromJson(jsonDecode(response.body));

    _getPosition();
  }
}
