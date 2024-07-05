import 'dart:async';
import 'dart:convert';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:rowing_app/models/models.dart';
import 'package:rowing_app/screens/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:rowing_app/helpers/helpers.dart';

class Home2Screen extends StatefulWidget {
  final User user;
  final int nroConexion;

  const Home2Screen({Key? key, required this.user, required this.nroConexion})
      : super(key: key);

  @override
  _Home2ScreenState createState() => _Home2ScreenState();
}

class _Home2ScreenState extends State<Home2Screen> {
//------------------------------------------------------------------------
//-------------------------- Variables -----------------------------------
//------------------------------------------------------------------------

  List<Novedad> _novedadesAux = [];
  List<Novedad> _novedades = [];
  late Causante _causante;
  String _codigo = '';
  int? _nroConexion = 0;

//------------------------------------------------------------------------
//-------------------------- initState -----------------------------------
//------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();

    _causante = Causante(
        nroCausante: 0,
        codigo: '',
        nombre: '',
        encargado: '',
        telefono: '',
        grupo: '',
        nroSAP: '',
        estado: false,
        razonSocial: '',
        linkFoto: '',
        image: null,
        imageFullPath: '',
        direccion: '',
        numero: 0,
        telefonoContacto1: '',
        telefonoContacto2: '',
        telefonoContacto3: '',
        fecha: '',
        notasCausantes: '',
        ciudad: '',
        provincia: '',
        codigoSupervisorObras: 0,
        zonaTrabajo: '',
        nombreActividad: '',
        notas: '',
        presentismo: '',
        perteneceCuadrilla: '',
        firma: null,
        firmaDigitalAPP: '',
        firmaFullPath: '');

    if (widget.user.habilitaRRHH != 1) {
      _codigo = widget.user.codigoCausante;
      _getCausante();
    }
  }

//------------------------------------------------------------------------
//-------------------------- Pantalla ------------------------------------
//------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rowing App'),
        centerTitle: true,
      ),
      body: _getBody(),
      drawer: _getMenu(),
    );
  }

//------------------------------------------------------------------------
//-------------------------- _getBody ------------------------------------
//------------------------------------------------------------------------

  Widget _getBody() {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 60),
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
              "assets/logo.png",
              height: 200,
            ),
            const Text(
              'Bienvenido/a',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              widget.user.apellido!.replaceAll("  ", ""),
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ));
  }

//------------------------------------------------------------------------
//-------------------------- _getMenu ------------------------------------
//------------------------------------------------------------------------

  Widget _getMenu() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff8c8c94),
              Color(0xff8c8c94),
            ],
          ),
        ),
        child: ListView(
          children: <Widget>[
            DrawerHeader(
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
                  const SizedBox(
                    height: 20,
                  ),
                  const Image(
                    image: AssetImage('assets/logo.png'),
                    width: 200,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      const Text(
                        "Usuario: ",
                        style: (TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Text(
                          widget.user.apellido.toString(),
                          style: (const TextStyle(color: Colors.white)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.white,
              height: 1,
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    leading: const Icon(
                      Icons.warning,
                      color: Colors.white,
                    ),
                    tileColor: const Color(0xff8c8c94),
                    title: Text(
                        widget.user.habilitaSSHH == 1
                            ? 'Siniestros'
                            : 'Mis Siniestros',
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white)),
                    onTap: () async {
                      String? result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SiniestrosScreen(
                            user: widget.user,
                          ),
                        ),
                      );
                      if (result != 'zzz') {
                        if (widget.user.habilitaRRHH != 1) {
                          _getCausante();
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    leading: const Icon(
                      Icons.newspaper,
                      color: Colors.white,
                    ),
                    tileColor: const Color(0xff8c8c94),
                    title: Text(
                        widget.user.habilitaRRHH == 1
                            ? 'Novedades RRHH'
                            : 'Mis Novedades RRHH',
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white)),
                    onTap: () async {
                      String? result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NovedadesScreen(
                            user: widget.user,
                          ),
                        ),
                      );
                      if (result != 'zzz') {
                        if (widget.user.habilitaRRHH != 1) {
                          _getCausante();
                        }
                      }
                    },
                  ),
                ),
                _novedades.isNotEmpty
                    ? SizedBox(
                        height: 30,
                        width: 30,
                        child: CircleAvatar(
                          child: Text(_novedades.length.toString()),
                          backgroundColor: Colors.red,
                        ),
                      )
                    : Container(),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ExpansionTile(
                    collapsedIconColor: Colors.white,
                    iconColor: Colors.white,
                    leading: const Icon(
                      Icons.list_alt,
                      color: Colors.white,
                    ),
                    title: const Text("Recibos",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: ListTile(
                          leading: const Icon(
                            Icons.fact_check,
                            color: Colors.white,
                          ),
                          tileColor: const Color(0xff8c8c94),
                          title: const Text('Mis Recibos',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReciboScreen(
                                  user: widget.user,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: ListTile(
                          leading: const Icon(
                            Icons.draw_outlined,
                            color: Colors.white,
                          ),
                          tileColor: const Color(0xff8c8c94),
                          title: const Text('Mi Firma',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CausanteFirmaScreen(
                                  user: widget.user,
                                ),
                              ),
                            );
                            await _getUsuario();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.white,
              height: 1,
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              tileColor: const Color(0xff8c8c94),
              title: const Text('Cerrar Sesión',
                  style: TextStyle(fontSize: 15, color: Colors.white)),
              onTap: () {
                _logOut();
              },
            ),
          ],
        ),
      ),
    );
  }

//------------------------------------------------------------------------
//-------------------------- _logOut -------------------------------------
//------------------------------------------------------------------------

  void _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRemembered', false);
    await prefs.setString('userBody', '');
    await prefs.setString('date', '');

    //------------ Guarda en WebSesion la fecha y hora de salida ----------
    _nroConexion = prefs.getInt('nroConexion');

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      await ApiHelper.putWebSesion(_nroConexion!);
    }

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

//------------------------------------------------------------------------
//-------------------------- _getCausante --------------------------------
//------------------------------------------------------------------------

  Future<void> _getCausante() async {
    setState(() {});

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {});
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estes conectado a internet.',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response = await ApiHelper.getCausante(_codigo);

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: "Legajo o Documento no válido",
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);

      setState(() {});
      return;
    }

    setState(() {
      _causante = response.result;
    });

    await _getNovedades();
  }

//------------------------------------------------------------------------
//-------------------------- _getNovedades -------------------------------
//------------------------------------------------------------------------

  Future<void> _getNovedades() async {
    setState(() {});

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {});
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estes conectado a internet.',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response2 = await ApiHelper.getNovedades(
        _causante.grupo, _causante.codigo.toString());

    if (!response2.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: "Legajo o Documento no válido",
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);

      setState(() {});
      return;
    }

    _novedades = [];
    _novedadesAux = response2.result;
    for (var novedad in _novedadesAux) {
      if (novedad.estado != "Pendiente" && novedad.confirmaLeido != 1) {
        _novedades.add(novedad);
      }
    }
    setState(() {});
  }

//------------------------------------------------------------------
//------------------------------ _getUsuario --------------------------
//------------------------------------------------------------------

  Future<void> _getUsuario() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {});
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estes conectado a internet.',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Map<String, dynamic> request = {
      'Email': widget.user.codigoCausante,
      'password': widget.user.contrasena,
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

    var body = response.body;
    var decodedJson = jsonDecode(body);
    var user = User.fromJson(decodedJson);

    widget.user.firmaUsuario = user.firmaUsuario;
    widget.user.firmaUsuarioImageFullPath = user.firmaUsuarioImageFullPath;

    setState(() {});
  }
}
