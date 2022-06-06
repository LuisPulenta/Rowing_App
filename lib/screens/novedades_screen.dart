import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rowing_app/components/loader_component.dart';
import 'package:rowing_app/helpers/api_helper.dart';
import 'package:rowing_app/models/models.dart';
import 'package:rowing_app/screens/screens.dart';
import 'package:rowing_app/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NovedadesScreen extends StatefulWidget {
  final User user;
  const NovedadesScreen({Key? key, required this.user}) : super(key: key);

  @override
  _NovedadesScreenState createState() => _NovedadesScreenState();
}

class _NovedadesScreenState extends State<NovedadesScreen> {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************
  String _codigo = '';
  String _codigoError = '';
  bool _codigoShowError = false;
  bool _enabled = false;
  bool _showLoader = false;

  late Causante _causante;
  List<Novedad> _novedades = [];
  List<Novedad> _novedadesSinLeer = [];

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
      backgroundColor: Color(0xFF484848),
      appBar: AppBar(
        title:
            Text(widget.user.habilitaRRHH == 0 ? "Mis Novedades" : "Novedades"),
        centerTitle: true,
        actions: [
          (widget.user.codigoCausante == widget.user.login)
              ? IconButton(onPressed: _logOut, icon: Icon(Icons.logout))
              : Container()
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 0,
              ),
              _showLogo(),
              SizedBox(
                height: 0,
              ),
              widget.user.habilitaRRHH == 1
                  ? Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 15,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: [
                                Expanded(flex: 4, child: _showLegajo()),
                                Expanded(flex: 1, child: _showButton()),
                              ],
                            ),
                            SizedBox(
                              height: 0,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 5,
              ),
              _showInfo(),
              SizedBox(
                height: 3,
              ),
              _causante.nroCausante != 0
                  ? _novedades.length == 0
                      ? Container()
                      : Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Text('Cant. Novedades: ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                            Text(_novedades.length.toString(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                          ],
                        )
                  : Container(),
              SizedBox(
                height: 5,
              ),
              Expanded(
                child: _causante.nroCausante != 0
                    ? _novedades.length == 0
                        ? _noContent()
                        : _getListView()
                    : Container(),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
          _showLoader
              ? LoaderComponent(
                  text: 'Por favor espere...',
                )
              : Container(),
        ],
      ),
      floatingActionButton: _enabled
          ? FloatingActionButton(
              child: Icon(
                Icons.add,
                size: 38,
              ),
              backgroundColor: Color(0xFF781f1e),
              onPressed: _enabled ? _addNovedad : null,
            )
          : Container(),
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ METODO NOCONTENT -----------------------------
//-----------------------------------------------------------------------------

  Widget _noContent() {
    return Container(
      height: 200,
      width: 300,
      margin: EdgeInsets.all(20),
      child: Center(
        child: Text(
          'Este empleado no tiene novedades en los últimos 30 días.',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white),
        ),
      ),
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ METODO GETLISTVIEW ---------------------------
//-----------------------------------------------------------------------------

  Widget _getListView() {
    return ListView(
      children: _novedades.map((e) {
        return Card(
          color: Colors.white,
          //color: Color(0xFFC7C7C8),
          shadowColor: Colors.white,
          elevation: 10,
          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: InkWell(
            onTap: () {
              // asignacionSelected = e;
              // _goInfoAsignacion(e);
            },
            child: Container(
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text("Tipo Novedad: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF0e4888),
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    Expanded(
                                      child: Text(e.tiponovedad.toString(),
                                          style: TextStyle(
                                            fontSize: 12,
                                          )),
                                    ),
                                    Container(
                                      width: 100,
                                      child: Text("Vista RRHH: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF0e4888),
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    Checkbox(
                                        value: e.vistaRRHH == 1 ? true : false,
                                        checkColor: Color(0xFF781f1e),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.padded,
                                        onChanged: null),
                                  ],
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text("Fecha Novedad: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF0e4888),
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    Expanded(
                                      child: Text(
                                          '${DateFormat('dd/MM/yyyy').format(DateTime.parse(e.fechanovedad.toString()))}',
                                          style: TextStyle(
                                            fontSize: 12,
                                          )),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text("Fecha Inicio: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF0e4888),
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    Expanded(
                                      child: Text(
                                          '${DateFormat('dd/MM/yyyy').format(DateTime.parse(e.fechainicio.toString()))}',
                                          style: TextStyle(
                                            fontSize: 12,
                                          )),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text("Fecha Fin: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF0e4888),
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    Expanded(
                                      child: Text(
                                          '${DateFormat('dd/MM/yyyy').format(DateTime.parse(e.fechafin.toString()))}',
                                          style: TextStyle(
                                            fontSize: 12,
                                          )),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text("Observaciones: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF0e4888),
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.observaciones.toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  height: 1,
                                  color: Colors.black,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text("Estado: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF0e4888),
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.estado.toString(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: e.estado == "Rechazado"
                                                ? Colors.red
                                                : e.estado == "Aprobado"
                                                    ? Colors.green
                                                    : Colors.black,
                                            fontWeight:
                                                e.estado == "Rechazado" ||
                                                        e.estado == "Aprobado"
                                                    ? FontWeight.bold
                                                    : FontWeight.normal),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text("Fecha RRHH: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF0e4888),
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    Expanded(
                                      child: e.fechaEstado != null
                                          ? Text(
                                              '${DateFormat('dd/MM/yyyy').format(DateTime.parse(e.fechaEstado.toString()))}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: e.estado == "Rechazado"
                                                    ? Colors.red
                                                    : e.estado == "Aprobado"
                                                        ? Colors.green
                                                        : Colors.black,
                                              ))
                                          : Text(""),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text("Obs RRHH: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF0e4888),
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.observacionEstado != null
                                            ? e.observacionEstado.toString()
                                            : "",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: e.estado == "Rechazado"
                                              ? Colors.red
                                              : e.estado == "Aprobado"
                                                  ? Colors.green
                                                  : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  height: 1,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    e.confirmaLeido == 1
                                        ? Container(
                                            width: 84,
                                            child: Text("Leído:",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF0e4888),
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          )
                                        : Container(),
                                    e.confirmaLeido == 1
                                        ? Checkbox(
                                            value: e.confirmaLeido == 1
                                                ? true
                                                : false,
                                            checkColor: Color(0xFF781f1e),
                                            materialTapTargetSize:
                                                MaterialTapTargetSize.padded,
                                            onChanged: null)
                                        : Container(),
                                    e.estado != "Pendiente" &&
                                            e.confirmaLeido != 1
                                        ? Container(
                                            width: 100,
                                            height: 40,
                                            color: Colors.red,
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.done),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text("Leído"),
                                                  ],
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color(0xFF781f1e),
                                                  minimumSize: Size(80, 40),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  _novedades.forEach((novedad) {
                                                    if (novedad.idnovedad ==
                                                        e.idnovedad) {
                                                      _grabarNovedad(novedad);
                                                    }
                                                  });
                                                },
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWLOGO ---------------------------
//-----------------------------------------------------------------

  Widget _showLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Image.asset(
          "assets/novedad.png",
          width: 70,
          height: 70,
        ),
        Image.asset(
          "assets/logo.png",
          height: 70,
          width: 200,
        ),
        Transform.rotate(
          angle: 45,
          child: Image.asset(
            "assets/novedad.png",
            width: 70,
            height: 70,
          ),
        ),
      ],
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWLEGAJO -------------------------
//-----------------------------------------------------------------

  Widget _showLegajo() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          iconColor: Color(0xFF781f1e),
          prefixIconColor: Color(0xFF781f1e),
          hoverColor: Color(0xFF781f1e),
          focusColor: Color(0xFF781f1e),
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingrese Legajo o Documento del empleado...',
          labelText: 'Legajo o Documento:',
          errorText: _codigoShowError ? _codigoError : null,
          prefixIcon: Icon(Icons.badge),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF781f1e)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          _codigo = value;
        },
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWBUTTON -------------------------
//-----------------------------------------------------------------

  Widget _showButton() {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF781f1e),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () => _search(),
            ),
          ),
        ],
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWINFO ---------------------------
//-----------------------------------------------------------------

  Widget _showInfo() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 15,
      margin: EdgeInsets.all(5),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomRow(
              icon: Icons.person,
              nombredato: 'Nombre:',
              dato: _causante.nombre,
            ),
            CustomRow(
              icon: Icons.engineering,
              nombredato: 'ENC/Puesto:',
              dato: _causante.encargado,
            ),
            CustomRow(
              icon: Icons.phone,
              nombredato: 'Teléfono:',
              dato: _causante.telefono,
            ),
            CustomRow(
              icon: Icons.badge,
              nombredato: 'Legajo:',
              dato: _causante.codigo,
            ),
            CustomRow(
              icon: Icons.assignment_ind,
              nombredato: 'Documento:',
              dato: _causante.nroSAP,
            ),
          ],
        ),
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SEARCH -----------------------------
//-----------------------------------------------------------------

  _search() async {
    FocusScope.of(context).unfocus();
    if (_codigo.isEmpty) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Ingrese un Legajo o Documento.',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
    await _getCausante();
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
        _enabled = false;
      });
      return;
    }

    setState(() {
      _showLoader = false;
      _causante = response.result;
      _enabled = true;
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
        _enabled = false;
      });
      return;
    }
    setState(() {
      _showLoader = false;
      _novedades = response2.result;
      _enabled = true;
    });

    _novedades.forEach((novedad) {
      if (novedad.estado != "Pendiente" && novedad.confirmaLeido != 1) {
        _novedadesSinLeer.add(novedad);
        ;
      }
    });
  }

//-----------------------------------------------------------------
//--------------------- METODO ADDNOVEDAD -------------------------
//-----------------------------------------------------------------

  void _addNovedad() async {
    if (_novedadesSinLeer.length > 0) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message:
              "No puede agregar nuevas novedades si tiene novedades aprobadas / rechazadas sin leer.",
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    String? result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NovedadAgregarScreen(
                  user: widget.user,
                  causante: _causante,
                )));
    if (result == 'yes') {
      _getNovedades();
    }
  }

//-----------------------------------------------------------------
//--------------------- METODO _logOut ----------------------------
//-----------------------------------------------------------------
  void _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRemembered', false);
    await prefs.setString('userBody', '');
    await prefs.setString('date', '');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

//*****************************************************************************
//************************** GRABAR NOVEDAD ***********************************
//*****************************************************************************

  void _grabarNovedad(Novedad novedad) async {
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
          message: 'Verifica que estés conectado a Internet',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Map<String, dynamic> request = {
      //'nroregistro': _ticket.nroregistro,
      'iDNOVEDAD': novedad.idnovedad,
    };

    Response response = await ApiHelper.put(
      '/api/CausantesNovedades/',
      novedad.idnovedad.toString(),
      request,
    );

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
    if (widget.user.codigoCausante != widget.user.login) {
      Navigator.pop(context, 'yes');
    }
    await _getNovedades();
    _novedadesSinLeer = [];
    _novedades.forEach((novedad) {
      if (novedad.estado != "Pendiente" && novedad.confirmaLeido != 1) {
        _novedadesSinLeer.add(novedad);
        ;
      }
    });
    setState(() {});
  }
}
