import 'dart:async';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rowing_app/helpers/api_helper.dart';
import 'package:rowing_app/models/models.dart';
import 'package:rowing_app/screens/screens.dart';
import 'package:rowing_app/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:battery_plus/battery_plus.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  final int nroConexion;

  const HomeScreen({Key? key, required this.user, required this.nroConexion})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

  final Battery _battery = Battery();
  BatteryState? _batteryState;
  StreamSubscription<BatteryState>? _batteryStateSubscription;

  List<Novedad> _novedadesAux = [];
  List<Novedad> _novedades = [];
  late Causante _causante;
  String _codigo = '';
  int? _nroConexion = 0;

  String direccion = '';

  Position _positionUser = const Position(
      longitude: 0,
      latitude: 0,
      timestamp: null,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);

//*****************************************************************************
//************************** INITSTATE *****************************************
//*****************************************************************************

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
        notasCausantes: '');

    if (widget.user.habilitaRRHH != 1) {
      _codigo = widget.user.codigoCausante;
      _getCausante();
    }

    _battery.batteryState.then(_updateBatteryState);
    _batteryStateSubscription =
        _battery.onBatteryStateChanged.listen(_updateBatteryState);

    guardarHoraLocalizacion();
    handleTimeout(widget.user);
  }

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

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
            Text(
              'Bienvenido/a ${widget.user.fullName}',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ));
  }

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
                      Text(
                        widget.user.fullName,
                        style: (const TextStyle(color: Colors.white)),
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
                      Icons.construction,
                      color: Colors.white,
                    ),
                    tileColor: const Color(0xff8c8c94),
                    title: Text('Obras',
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white)),
                    onTap: () async {
                      guardarLocalizacion();
                      String? result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ObrasScreen(
                            user: widget.user,
                            opcion: 1,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            widget.user.habilitaMedidores == 1
                ? Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: const Icon(
                            Icons.schedule,
                            color: Colors.white,
                          ),
                          tileColor: const Color(0xff8c8c94),
                          title: Text('Medidores',
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white)),
                          onTap: () async {
                            guardarLocalizacion();
                            String? result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MedidoresScreen(
                                  user: widget.user,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : Container(),
            widget.user.habilitaReclamos == 1
                ? Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: const Icon(
                            Icons.border_color,
                            color: Colors.white,
                          ),
                          tileColor: const Color(0xff8c8c94),
                          title: Text('Reclamos',
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white)),
                          onTap: () async {
                            guardarLocalizacion();
                            String? result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReclamosScreen(
                                  user: widget.user,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : Container(),
            widget.user.habilitaSSHH == 1
                ? Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: const Icon(
                            Icons.engineering,
                            color: Colors.white,
                          ),
                          tileColor: const Color(0xff8c8c94),
                          title: Text('Seguridad e Higiene',
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white)),
                          onTap: () async {
                            guardarLocalizacion();
                            String? result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SeguridadScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : Container(),
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
                      guardarLocalizacion();
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
                      guardarLocalizacion();
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
            widget.user.habilitaSSHH == 1
                ? Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: const Icon(
                            Icons.format_list_bulleted,
                            color: Colors.white,
                          ),
                          tileColor: const Color(0xff8c8c94),
                          title: Text('Inspecciones S&H',
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white)),
                          onTap: () async {
                            guardarLocalizacion();
                            String? result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InspeccionesListaScreen(
                                  user: widget.user,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : Container(),
            widget.user.habilitaFlotas.toLowerCase() != "no"
                ? Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: const Icon(
                            Icons.directions_car,
                            color: Colors.white,
                          ),
                          tileColor: const Color(0xff8c8c94),
                          title: Text(
                              widget.user.habilitaFlotas.toLowerCase() ==
                                      "admin"
                                  ? 'Flotas'
                                  : 'Mis Vehículos',
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white)),
                          onTap: () async {
                            guardarLocalizacion();
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FlotaScreen(
                                  user: widget.user,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : Container(),
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
                guardarLocalizacion();
                _logOut();
              },
            ),
          ],
        ),
      ),
    );
  }

//*****************************************************************************
//************************** METODO LOGOUT ************************************
//*****************************************************************************

  void _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRemembered', false);
    await prefs.setString('userBody', '');
    await prefs.setString('date', '');

    //------------ Guarda en WebSesion la fecha y hora de salida ----------
    _nroConexion = prefs.getInt('nroConexion');

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      Response response = await ApiHelper.putWebSesion(_nroConexion!);
    }

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

//-----------------------------------------------------------------
//--------------------- METODO GETCAUSANTE ---------------------------
//-----------------------------------------------------------------

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

//-----------------------------------------------------------------
//--------------------- METODO GETNOVEDADES -----------------------
//-----------------------------------------------------------------

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

//-----------------------------------------------------------------
//--------------------- METODO handleTimeout ----------------------
//-----------------------------------------------------------------

  handleTimeout(User user) async {
    var connectivityResult = Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return;
    }

    await _getPosition();

    _battery.batteryState.then(_updateBatteryState);
    int batnivel = await _battery.batteryLevel;

    if (_positionUser.latitude == 0 || _positionUser.longitude == 0) {
      return;
    }

    Map<String, dynamic> request1 = {
      'IdUsuario': user.idUsuario,
      'UsuarioStr': user.fullName,
      'LATITUD': _positionUser.latitude,
      'LONGITUD': _positionUser.longitude,
      'PIN': "mapinred.ico",
      'PosicionCalle': direccion,
      'Velocidad': 0,
      'Bateria': batnivel,
      'Fecha': DateTime.now().toString(),
      'Modulo': user.modulo,
    };

    ApiHelper.post('/api/UsuariosGeos', request1);

    return;
  }

//-----------------------------------------------------------------
//--------------------- METODO guardarHoraLocalizacion ------------
//-----------------------------------------------------------------

  guardarHoraLocalizacion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('horaLocalizacion', DateTime.now().toString());
    return;
  }

//-----------------------------------------------------------------
//--------------------- METODO guardarLocalizacion ----------------
//-----------------------------------------------------------------

  guardarLocalizacion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String horaLocalizacion = prefs.getString('horaLocalizacion') ?? '';

    if (horaLocalizacion != '') {
      DateTime dateAlmacenada = DateTime.parse(horaLocalizacion);
      if (dateAlmacenada.isBefore(DateTime.now().add(Duration(minutes: -15)))) {
        handleTimeout(widget.user);
        guardarHoraLocalizacion();
      }
    }
    return;
  }

//*****************************************************************************
//************************** METODO GETPOSITION **********************************
//*****************************************************************************

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

      List<Placemark> placemarks = await placemarkFromCoordinates(
          _positionUser.latitude, _positionUser.longitude);
      direccion = placemarks[0].street.toString() +
          " - " +
          placemarks[0].locality.toString() +
          " - " +
          placemarks[0].country.toString();
      ;
    }
  }

//*****************************************************************************
//************************** METODO _updateBatteryState ***********************
//*****************************************************************************
  void _updateBatteryState(BatteryState state) {
    if (_batteryState == state) return;
    setState(() {
      _batteryState = state;
    });
  }
}
