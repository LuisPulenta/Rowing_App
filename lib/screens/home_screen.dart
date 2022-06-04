import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:rowing_app/helpers/api_helper.dart';
import 'package:rowing_app/models/models.dart';
import 'package:rowing_app/screens/screens.dart';
import 'package:rowing_app/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

  bool _showLoader = false;
  List<Novedad> _novedadesAux = [];
  List<Novedad> _novedades = [];
  late Causante _causante;
  String _codigo = '';

//*****************************************************************************
//************************** INITSTATE *****************************************
//*****************************************************************************

  void initState() {
    super.initState();

    _causante = new Causante(
        nroCausante: 0,
        codigo: '',
        nombre: '',
        encargado: '',
        telefono: '',
        grupo: '',
        nroSAP: '',
        estado: false);

    if (widget.user.habilitaRRHH != 1) {
      _codigo = widget.user.codigoCausante;
      _getCausante();
    }
  }

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rowing App'),
      ),
      body: _getBody(),
      drawer: _getMenu(),
    );
  }

  Widget _getBody() {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 60),
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
            Text(
              'Bienvenido/a ${widget.user.fullName}',
              style: TextStyle(
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
        decoration: BoxDecoration(
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
                  SizedBox(
                    height: 20,
                  ),
                  Image(
                    image: AssetImage('assets/logo.png'),
                    width: 200,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Text(
                        "Usuario: ",
                        style: (TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      Text(
                        widget.user.fullName,
                        style: (TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.white,
              height: 1,
            ),
            MenuTile(
                icon: Icons.construction,
                menuitem: 'Obras',
                screen: ObrasScreen(
                  user: widget.user,
                  opcion: 1,
                )),
            widget.user.habilitaMedidores == 1
                ? MenuTile(
                    icon: Icons.schedule,
                    menuitem: 'Medidores',
                    screen: MedidoresScreen(
                      user: widget.user,
                    ))
                : Container(),
            widget.user.habilitaReclamos == 1
                ? MenuTile(
                    icon: Icons.border_color,
                    menuitem: 'Reclamos',
                    screen: ReclamosScreen(
                      user: widget.user,
                    ))
                : Container(),
            widget.user.habilitaSSHH == 1
                ? MenuTile(
                    icon: Icons.engineering,
                    menuitem: 'Seguridad e Higiene',
                    screen: SeguridadScreen())
                : Container(),
            Row(
              children: [
                Expanded(
                  child: MenuTile(
                      icon: Icons.newspaper,
                      menuitem: widget.user.habilitaRRHH == 1
                          ? 'Novedades'
                          : 'Mis Novedades',
                      screen: NovedadesScreen(
                        user: widget.user,
                      )),
                ),
                _novedades.length > 0
                    ? Container(
                        height: 30,
                        width: 30,
                        child: CircleAvatar(
                          child: Text(_novedades.length.toString()),
                          backgroundColor: Colors.red,
                        ),
                      )
                    : Container(),
                SizedBox(
                  width: 10,
                )
              ],
            ),
            widget.user.habilitaSSHH == 1
                ? MenuTile(
                    icon: Icons.format_list_bulleted,
                    menuitem: 'Inspecciones',
                    screen: InspeccionesListaScreen(
                      user: widget.user,
                    ))
                : Container(),
            widget.user.habilitaFlotas.toLowerCase() != "no"
                ? MenuTile(
                    icon: Icons.directions_car,
                    menuitem: 'Flotas',
                    screen: FlotaScreen(
                      user: widget.user,
                    ))
                : Container(),
            Divider(
              color: Colors.white,
              height: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              tileColor: Color(0xff8c8c94),
              title: Text('Cerrar Sesión',
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

  void _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRemembered', false);
    await prefs.setString('userBody', '');
    await prefs.setString('date', '');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

//-----------------------------------------------------------------
//--------------------- METODO GETCAUSANTE ---------------------------
//-----------------------------------------------------------------

  Future<Null> _getCausante() async {
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

    Response response = await ApiHelper.getCausante(_codigo);

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: "Legajo o Documento no válido",
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);

      setState(() {
        _showLoader = false;
      });
      return;
    }

    setState(() {
      _showLoader = false;
      _causante = response.result;
    });

    await _getNovedades();
  }

//-----------------------------------------------------------------
//--------------------- METODO GETNOVEDADES -----------------------
//-----------------------------------------------------------------

  Future<Null> _getNovedades() async {
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

    Response response2 = await ApiHelper.GetNovedades(
        _causante.grupo, _causante.codigo.toString());

    if (!response2.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: "Legajo o Documento no válido",
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);

      setState(() {
        _showLoader = false;
      });
      return;
    }

    _novedadesAux = response2.result;
    _novedadesAux.forEach((novedad) {
      if (novedad.estado != "Pendiente" && novedad.confirmaLeido != 1) {
        _novedades.add(novedad);
        ;
      }
    });
    setState(() {});
  }
}
