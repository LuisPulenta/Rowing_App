import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:rowing_app/components/loader_component.dart';
import 'package:rowing_app/helpers/api_helper.dart';
import 'package:rowing_app/models/models.dart';
import 'package:rowing_app/screens/screens.dart';
import 'package:rowing_app/widgets/widgets.dart';

class InspeccionDuplicarScreen extends StatefulWidget {
  final User user;
  final VistaInspeccion vistaInspeccion;

  InspeccionDuplicarScreen({required this.user, required this.vistaInspeccion});

  @override
  State<InspeccionDuplicarScreen> createState() =>
      _InspeccionDuplicarScreenState();
}

class _InspeccionDuplicarScreenState extends State<InspeccionDuplicarScreen> {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************
  bool _showLoader = false;

  String _codigo = '';
  String _codigoError = '';
  bool _codigoShowError = false;

  bool _enabled1 = false;
  bool _enabled3 = true;
  bool _esContratista = false;

  bool bandera = false;
  int intentos = 0;
  List<GruposFormulario> _gruposFormularios = [];

  late Causante _causante;
  late Inspeccion _inspeccion;
  late Obra _obra;
  late List<InspeccionDetalle> _inspeccionDetalles;

  List<DetallesFormularioCompleto> _detallesFormulariosCompleto = [];

  DetallesFormularioCompleto detallesFormularioCompleto =
      DetallesFormularioCompleto(
          idcliente: 0,
          idgrupoformulario: 0,
          descgrupoformulario: '',
          detallef: '',
          descripcion: '',
          ponderacionpuntos: 0,
          cumple: '',
          foto: '');

  String _nombreSR = '';
  String _nombreSRError = '';
  bool _nombreSRShowError = false;
  TextEditingController _nombreSRController = TextEditingController();

  String _dniSR = '';
  String _dniSRError = '';
  bool _dniSRShowError = false;
  TextEditingController _dniSRController = TextEditingController();

  String _observaciones = '';
  String _observacionesError = '';
  bool _observacionesShowError = false;
  TextEditingController _observacionesController = TextEditingController();

  Position _positionUser = Position(
      longitude: 0,
      latitude: 0,
      timestamp: null,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);

//*****************************************************************************
//************************** INIT STATE ***************************************
//*****************************************************************************

  @override
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
        estado: false,
        razonSocial: '',
        linkFoto: '',
        imageFullPath: '',
        image: null);
    _getPosition();
    _getInspeccion();
  }
//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF484848),
      appBar: AppBar(
        title: Text('Duplicar Inspección'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _getContent(),
          _showLoader
              ? LoaderComponent(
                  text: 'Por favor espere...',
                )
              : Container(),
        ],
      ),
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ METODO GETCONTENT ----------------------------
//-----------------------------------------------------------------------------

  Widget _getContent() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                    'Está por generar una Nueva Inspección a partir de duplicar la siguiente Inspección:',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.normal)),
              ),
              _CardInspeccion(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                    'Seleccione el empleado para el cual se generará la Inspección duplicada:',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.normal)),
              ),
              Row(
                children: [
                  Expanded(flex: 4, child: _showLegajo()),
                  Expanded(flex: 1, child: _showButton()),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              _esContratista ? _showCamposContratista() : _showInfo(),
              SizedBox(
                height: 10,
              ),
              _showObservaciones(),
              SizedBox(
                height: 10,
              ),
              _showButton2(),
            ],
          ),
        ),
      ],
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO CARDINSPECCION ---------------------
//-----------------------------------------------------------------

  Widget _CardInspeccion() {
    int largo = 28;
    int fintipotrabajo = widget.vistaInspeccion.tipoTrabajo.length >= largo
        ? largo
        : widget.vistaInspeccion.tipoTrabajo.length;
    int finobra = widget.vistaInspeccion.obra.length >= largo
        ? largo
        : widget.vistaInspeccion.obra.length;
    return Card(
      color: Color(0xFFC7C7C8),
      shadowColor: Colors.white,
      elevation: 10,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
      child: Container(
        height: 136,
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Fecha: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF781f1e),
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Empleado: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF781f1e),
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Cliente: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF781f1e),
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Tipo Trabajo: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF781f1e),
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Obra: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF781f1e),
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Total Preguntas: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF781f1e),
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Respuestas NO: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF781f1e),
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Total Puntos: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF781f1e),
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                Text(
                                    '${DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.vistaInspeccion.fecha))}',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ))
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                    widget.vistaInspeccion.empleado
                                                .toString()
                                                .trim() ==
                                            'SIN REGISTRAR'
                                        ? widget.vistaInspeccion.nombreSR
                                            .toString()
                                            .trim()
                                        : widget.vistaInspeccion.empleado
                                            .toString()
                                            .trim(),
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                              ],
                            ),
                            Row(
                              children: [
                                Text(widget.vistaInspeccion.cliente.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                    widget.vistaInspeccion.tipoTrabajo
                                        .toString()
                                        .substring(0, fintipotrabajo),
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                    widget.vistaInspeccion.obra
                                        .toString()
                                        .substring(1, finobra),
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                    widget.vistaInspeccion.totalPreguntas
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                              ],
                            ),
                            Row(
                              children: [
                                Text(widget.vistaInspeccion.totalNo.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                              ],
                            ),
                            Row(
                              children: [
                                Text(widget.vistaInspeccion.puntos.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                              ],
                            ),
                          ]),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
    if (_codigo == "000000") {
      _esContratista = true;
      _enabled3 = false;
      _enabled1 = true;
      setState(() {});
      return;
    }

    _esContratista = false;
    _enabled1 = false;
    setState(() {
      _showLoader = true;
    });

    _esContratista = false;
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
        _enabled1 = false;
      });
      return;
    }

    setState(() {
      _showLoader = false;
      _causante = response.result;
      _enabled1 = true;
    });
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOCAMPOSCONTRATISTA ---------------
//-----------------------------------------------------------------

  Widget _showCamposContratista() {
    return Column(
      children: [_shownombreSR(), _showdniSR()],
    );
  }

  Widget _shownombreSR() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextField(
        controller: _nombreSRController,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Ingrese Nombre Contratista...',
            labelText: 'Nombre Contratista:',
            errorText: _nombreSRShowError ? _nombreSRError : null,
            prefixIcon: Icon(Icons.person),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _nombreSR = value;
          _enabled3 = _dniSR.length > 0 && _nombreSR.length > 0;
          setState(() {});
        },

        //enabled: _enabled,
      ),
    );
  }

  Widget _showdniSR() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextField(
        controller: _dniSRController,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Ingrese DNI Contratista...',
            labelText: 'DNI Contratista:',
            errorText: _dniSRShowError ? _dniSRError : null,
            prefixIcon: Icon(Icons.assignment_ind),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _dniSR = value;
          _enabled3 = _dniSR.length > 0 && _nombreSR.length > 0;
          setState(() {});
        },
        //enabled: _enabled,
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
//--------------------- METODO SHOWBUTTON2 -------------------------
//-----------------------------------------------------------------

  Widget _showButton2() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
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
                  Text('Generar cuestionario')
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF781f1e),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: _enabled1 && _enabled3 ? _generarCuestionario : null,
            ),
          ),
        ],
      ),
    );
  }

  //-----------------------------------------------------------------
//--------------------- METODO GENERARCUESTIONARIO ----------------
//-----------------------------------------------------------------

  _generarCuestionario() async {
    _detallesFormulariosCompleto = [];

    await _getGruposFormularios(widget.vistaInspeccion.idCliente,
        widget.vistaInspeccion.idTipoTrabajo as int);

    _inspeccionDetalles.forEach((element) {
      String descgpoform = '';
      _gruposFormularios.forEach((element2) {
        if (element2.idgrupoformulario == element.idGrupoFormulario) {
          descgpoform = element2.descripcion;
        }
        ;
      });

      detallesFormularioCompleto = new DetallesFormularioCompleto(
          idcliente: element.idCliente,
          idgrupoformulario: element.idGrupoFormulario,
          descgrupoformulario: descgpoform,
          detallef: element.detalleF,
          descripcion: element.descripcion,
          ponderacionpuntos: element.ponderacionPuntos,
          cumple: element.cumple,
          foto: element.imageFullPath);
      _detallesFormulariosCompleto.add(detallesFormularioCompleto);
    });

    FocusScope.of(context).unfocus();
    String? result = await Navigator.push(
        context,
        MaterialPageRoute(
//******************************************************************************
//******************************************************************************
//******************************************************************************
//******************************************************************************
//******************************************************************************

            builder: (context) => InspeccionCuestionarioDuplicadoScreen(
                  user: widget.user,
                  causante: _causante,
                  observaciones: _observacionesController.text,
                  obra: _obra,
                  cliente: _inspeccion.idCliente,
                  tipotrabajo: _inspeccion.idTipoTrabajo,
                  esContratista: _esContratista,
                  nombreSR: _nombreSRController.text,
                  dniSR: _dniSRController.text,
                  detallesFormulariosCompleto: _detallesFormulariosCompleto,
                  positionUser: _positionUser,
                )));
    if (result == 'yes') {}
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWOBSERVACIONES ------------------
//-----------------------------------------------------------------

  Widget _showObservaciones() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextField(
        controller: _observacionesController,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Ingrese Observaciones...',
            labelText: 'Observaciones:',
            errorText: _observacionesShowError ? _observacionesError : null,
            prefixIcon: Icon(Icons.chat),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _observaciones = value;
        },
        //enabled: _enabled,
      ),
    );
  }

//*****************************************************************************
//************************** METODO GETPOSITION *******************************
//*****************************************************************************

  Future _getPosition() async {
    bool serviceEnabled;
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
                title: Text('Aviso'),
                content:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Text('El permiso de localización está negado.'),
                  SizedBox(
                    height: 10,
                  ),
                ]),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Ok')),
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
              title: Text('Aviso'),
              content:
                  Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text(
                    'El permiso de localización está negado permanentemente. No se puede requerir este permiso.'),
                SizedBox(
                  height: 10,
                ),
              ]),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Ok')),
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
  }

//*****************************************************************************
//************************** METODO GETINSPECCION *****************************
//*****************************************************************************

  Future<Null> _getInspeccion() async {
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

    Response response = Response(isSuccess: false);

    response =
        await ApiHelper.getInspeccion(widget.vistaInspeccion.idInspeccion);

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

    setState(() {
      _inspeccion = response.result;
    });

    _getInspeccionDetalles();
  }

//*****************************************************************************
//************************** METODO GETINSPECCIONDETALLES *********************
//*****************************************************************************

  Future<Null> _getInspeccionDetalles() async {
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

    Response response = Response(isSuccess: false);

    response = await ApiHelper.GetDetallesInspecciones(
        widget.vistaInspeccion.idInspeccion);

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

    setState(() {
      _inspeccionDetalles = response.result;
    });

    _getObra();
  }

//*****************************************************************************
//************************** METODO GETOBRA *****************************
//*****************************************************************************

  Future<Null> _getObra() async {
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

    Response response = Response(isSuccess: false);

    response = await ApiHelper.getObraInspeccion(_inspeccion.idObra);

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

    setState(() {
      _obra = response.result;
    });
  }

//*****************************************************************************
//************************** METODO GETGRUPOSFORMULARIOS **********************
//*****************************************************************************

  Future<Null> _getGruposFormularios(int cliente, int tipotrabajo) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estés conectado a Internet',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    bandera = false;
    intentos = 0;

    do {
      Response response = Response(isSuccess: false);
      response = await ApiHelper.GetGruposFormularios(cliente, tipotrabajo);
      intentos++;
      if (response.isSuccess) {
        bandera = true;
        _gruposFormularios = response.result;
      }
    } while (bandera == false);
    setState(() {});
    var b = 1;
  }
}
