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

  const InspeccionDuplicarScreen(
      {Key? key, required this.user, required this.vistaInspeccion})
      : super(key: key);

  @override
  State<InspeccionDuplicarScreen> createState() =>
      _InspeccionDuplicarScreenState();
}

class _InspeccionDuplicarScreenState extends State<InspeccionDuplicarScreen> {
//----------------------------------------------------------------
//------------------ Variables -----------------------------------
//----------------------------------------------------------------

  bool _showLoader = false;

  String _codigo = '';
  final String _codigoError = '';
  final bool _codigoShowError = false;

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
          foto: '',
          soloTexto: 0,
          obsApp: '');

  String _nombreSR = '';
  final String _nombreSRError = '';
  final bool _nombreSRShowError = false;
  final TextEditingController _nombreSRController = TextEditingController();

  String _dniSR = '';
  final String _dniSRError = '';
  final bool _dniSRShowError = false;
  final TextEditingController _dniSRController = TextEditingController();

  final String _observacionesError = '';
  final bool _observacionesShowError = false;
  final TextEditingController _observacionesController =
      TextEditingController();

  Position _positionUser = const Position(
      longitude: 0,
      latitude: 0,
      timestamp: null,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);

//----------------------------------------------------------------
//------------------ initState -----------------------------------
//----------------------------------------------------------------

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
        imageFullPath: '',
        image: null,
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
    _getPosition();
    _getInspeccion();
  }

//----------------------------------------------------------------
//------------------ Pantalla ------------------------------------
//----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: const Text('Duplicar Inspección'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _getContent(),
          _showLoader
              ? const LoaderComponent(
                  text: 'Por favor espere...',
                )
              : Container(),
        ],
      ),
    );
  }

//-----------------------------------------------------------------------
//------------------------------ _getContent ----------------------------
//-----------------------------------------------------------------------

  Widget _getContent() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                    'Está por generar una Nueva Inspección a partir de duplicar la siguiente Inspección:',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.normal)),
              ),
              _cardInspeccion(),
              const Padding(
                padding: EdgeInsets.all(10.0),
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
              const SizedBox(
                height: 10,
              ),
              _esContratista ? _showCamposContratista() : _showInfo(),
              const SizedBox(
                height: 10,
              ),
              _showObservaciones(),
              const SizedBox(
                height: 10,
              ),
              _showButton2(),
            ],
          ),
        ),
      ],
    );
  }

//-----------------------------------------------------------
//--------------------- _cardInspeccion ---------------------
//-----------------------------------------------------------

  Widget _cardInspeccion() {
    int largo = 28;
    int fintipotrabajo = widget.vistaInspeccion.tipoTrabajo.length >= largo
        ? largo
        : widget.vistaInspeccion.tipoTrabajo.length;
    int finobra = widget.vistaInspeccion.obra.length >= largo
        ? largo
        : widget.vistaInspeccion.obra.length;
    return Card(
      color: const Color(0xFFC7C7C8),
      shadowColor: Colors.white,
      elevation: 10,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
      child: Container(
        height: 136,
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text("Fecha: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF781f1e),
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                        Row(
                          children: const [
                            Text("Empleado: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF781f1e),
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                        Row(
                          children: const [
                            Text("Cliente: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF781f1e),
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                        Row(
                          children: const [
                            Text("Tipo Trabajo: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF781f1e),
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                        Row(
                          children: const [
                            Text("Obra: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF781f1e),
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                        Row(
                          children: const [
                            Text("Total Preguntas: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF781f1e),
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                        Row(
                          children: const [
                            Text("Respuestas NO: ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF781f1e),
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                        Row(
                          children: const [
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
                                    DateFormat('dd/MM/yyyy').format(
                                        DateTime.parse(
                                            widget.vistaInspeccion.fecha)),
                                    style: const TextStyle(
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
                                    style: const TextStyle(
                                      fontSize: 12,
                                    )),
                              ],
                            ),
                            Row(
                              children: [
                                Text(widget.vistaInspeccion.cliente.toString(),
                                    style: const TextStyle(
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
                                    style: const TextStyle(
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
                                    style: const TextStyle(
                                      fontSize: 12,
                                    )),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                    widget.vistaInspeccion.totalPreguntas
                                        .toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                    )),
                              ],
                            ),
                            Row(
                              children: [
                                Text(widget.vistaInspeccion.totalNo.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                    )),
                              ],
                            ),
                            Row(
                              children: [
                                Text(widget.vistaInspeccion.puntos.toString(),
                                    style: const TextStyle(
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
//-----------------------------------------------------------
//--------------------- _showLegajo -------------------------
//-----------------------------------------------------------

  Widget _showLegajo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          iconColor: const Color(0xFF781f1e),
          prefixIconColor: const Color(0xFF781f1e),
          hoverColor: const Color(0xFF781f1e),
          focusColor: const Color(0xFF781f1e),
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingrese Legajo o Documento del empleado...',
          labelText: 'Legajo o Documento:',
          errorText: _codigoShowError ? _codigoError : null,
          prefixIcon: const Icon(Icons.badge),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF781f1e)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          _codigo = value;
        },
      ),
    );
  }

//-----------------------------------------------------------
//--------------------- _showButton -------------------------
//-----------------------------------------------------------

  Widget _showButton() {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.search),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF781f1e),
                minimumSize: const Size(double.infinity, 50),
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

//-----------------------------------------------------------
//--------------------- _search -----------------------------
//-----------------------------------------------------------

  _search() async {
    FocusScope.of(context).unfocus();
    if (_codigo.isEmpty) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Ingrese un Legajo o Documento.',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
    await _getCausante();
  }

//--------------------------------------------------------------
//--------------------- _getCausante ---------------------------
//--------------------------------------------------------------

  Future<void> _getCausante() async {
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

//------------------------------------------------------------
//--------------------- _showCamposContratista ---------------
//------------------------------------------------------------

  Widget _showCamposContratista() {
    return Column(
      children: [_shownombreSR(), _showdniSR()],
    );
  }

//------------------------------------------------------------
//--------------------- _shownombreSR ------------------------
//------------------------------------------------------------

  Widget _shownombreSR() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextField(
        controller: _nombreSRController,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Ingrese Nombre Contratista...',
            labelText: 'Nombre Contratista:',
            errorText: _nombreSRShowError ? _nombreSRError : null,
            prefixIcon: const Icon(Icons.person),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _nombreSR = value;
          _enabled3 = _dniSR.isNotEmpty && _nombreSR.isNotEmpty;
          setState(() {});
        },
      ),
    );
  }

//------------------------------------------------------------
//--------------------- _showdniSR ---------------------------
//------------------------------------------------------------

  Widget _showdniSR() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextField(
        controller: _dniSRController,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Ingrese DNI Contratista...',
            labelText: 'DNI Contratista:',
            errorText: _dniSRShowError ? _dniSRError : null,
            prefixIcon: const Icon(Icons.assignment_ind),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _dniSR = value;
          _enabled3 = _dniSR.isNotEmpty && _nombreSR.isNotEmpty;
          setState(() {});
        },
        //enabled: _enabled,
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- _showInfo ---------------------------------
//-----------------------------------------------------------------

  Widget _showInfo() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 15,
      margin: const EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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

//------------------------------------------------------------
//--------------------- _showButton2 -------------------------
//------------------------------------------------------------

  Widget _showButton2() {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.search),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Generar cuestionario')
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF781f1e),
                minimumSize: const Size(double.infinity, 50),
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

//-----------------------------------------------------------
//--------------------- _generarCuestionario ----------------
//-----------------------------------------------------------

  _generarCuestionario() async {
    _detallesFormulariosCompleto = [];

    if (_observacionesController.text.length > 199) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message:
              'Las Observaciones tienen ${_observacionesController.text.length} caracteres. No pueden tener más de 199.',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    await _getGruposFormularios(
        widget.vistaInspeccion.idCliente, widget.vistaInspeccion.idTipoTrabajo);

    for (var element in _inspeccionDetalles) {
      String descgpoform = '';
      for (var element2 in _gruposFormularios) {
        if (element2.idgrupoformulario == element.idGrupoFormulario) {
          descgpoform = element2.descripcion;
        }
      }

      detallesFormularioCompleto = DetallesFormularioCompleto(
          idcliente: element.idCliente,
          idgrupoformulario: element.idGrupoFormulario,
          descgrupoformulario: descgpoform,
          detallef: element.detalleF,
          descripcion: element.descripcion,
          ponderacionpuntos: element.ponderacionPuntos,
          cumple: element.cumple,
          foto: element.imageFullPath,
          soloTexto: element.soloTexto!,
          obsApp: element.obsAPP);
      _detallesFormulariosCompleto.add(detallesFormularioCompleto);
    }

    FocusScope.of(context).unfocus();
    String? result = await Navigator.push(
        context,
        MaterialPageRoute(
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
//--------------------- _showObservaciones ------------------------
//-----------------------------------------------------------------

  Widget _showObservaciones() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextField(
        controller: _observacionesController,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Ingrese Observaciones...',
            labelText: 'Observaciones:',
            errorText: _observacionesShowError ? _observacionesError : null,
            prefixIcon: const Icon(Icons.chat),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {},
        //enabled: _enabled,
      ),
    );
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
  }

//-----------------------------------------------------------------
//--------------------- _getInspeccion ----------------------------
//-----------------------------------------------------------------

  Future<void> _getInspeccion() async {
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
            const AlertDialogAction(key: null, label: 'Aceptar'),
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
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    setState(() {
      _inspeccion = response.result;
    });

    _getInspeccionDetalles();
  }

//-----------------------------------------------------------------
//--------------------- _getInspeccionDetalles --------------------
//-----------------------------------------------------------------

  Future<void> _getInspeccionDetalles() async {
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
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response = Response(isSuccess: false);

    response = await ApiHelper.getDetallesInspecciones(
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
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    setState(() {
      _inspeccionDetalles = response.result;
    });

    _getObra();
  }

//-----------------------------------------------------------------
//--------------------- _getObra ----------------------------------
//-----------------------------------------------------------------

  Future<void> _getObra() async {
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
            const AlertDialogAction(key: null, label: 'Aceptar'),
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
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    setState(() {
      _obra = response.result;
    });
  }

//-----------------------------------------------------------------
//--------------------- _getGruposFormularios ---------------------
//-----------------------------------------------------------------

  Future<void> _getGruposFormularios(int cliente, int tipotrabajo) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estés conectado a Internet',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    bandera = false;
    intentos = 0;

    do {
      Response response = Response(isSuccess: false);
      response = await ApiHelper.getGruposFormularios(cliente, tipotrabajo);
      intentos++;
      if (response.isSuccess) {
        bandera = true;
        _gruposFormularios = response.result;
      }
    } while (bandera == false);
    setState(() {});
  }
}
