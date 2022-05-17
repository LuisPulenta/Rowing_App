import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rowing_app/helpers/api_helper.dart';
import 'package:rowing_app/models/models.dart';
import 'package:rowing_app/screens/inspeccion_cuestionario_screen.dart';
import 'package:rowing_app/screens/screens.dart';
import 'package:rowing_app/widgets/widgets.dart';

class InspeccionesScreen extends StatefulWidget {
  final User user;
  InspeccionesScreen({required this.user});

  @override
  _InspeccionesScreenState createState() => _InspeccionesScreenState();
}

class _InspeccionesScreenState extends State<InspeccionesScreen> {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************
  String _codigo = '';
  String _codigoError = '';
  bool _codigoShowError = false;
  bool _enabled1 = false;
  bool _enabled2 = false;
  bool _enabled3 = true;
  bool _showLoader = false;
  bool _esContratista = false;
  late Causante _causante;
  bool bandera = false;
  int intentos = 0;
  List<Cliente> _clientes = [];

  int _cliente = 0;
  String _clienteError = '';
  bool _clienteShowError = false;
  TextEditingController _clienteController = TextEditingController();

  int _tipoTrabajoSelected = 0;
  String _tipoTrabajoError = '';
  bool _tipoTrabajoShowError = false;
  List<TiposTrabajo> _tipoTrabajos = [];

  List<GruposFormulario> _gruposFormularios = [];
  List<DetallesFormulario> _detallesFormularios = [];
  List<DetallesFormulario> _detallesFormulariosAux = [];
  List<DetallesFormularioCompleto> _detallesFormulariosCompleto = [];
  DetallesFormularioCompleto detallesFormularioCompleto =
      DetallesFormularioCompleto(
          idcliente: 0,
          idgrupoformulario: 0,
          descgrupoformulario: '',
          detallef: '',
          descripcion: '',
          ponderacionpuntos: 0,
          cumple: '');

  Position _positionUser = Position(
      longitude: 0,
      latitude: 0,
      timestamp: null,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);

  String _observaciones = '';
  String _observacionesError = '';
  bool _observacionesShowError = false;
  TextEditingController _observacionesController = TextEditingController();

  String _nombreSR = '';
  String _nombreSRError = '';
  bool _nombreSRShowError = false;
  TextEditingController _nombreSRController = TextEditingController();

  String _dniSR = '';
  String _dniSRError = '';
  bool _dniSRShowError = false;
  TextEditingController _dniSRController = TextEditingController();

  Obra obra = Obra(
      nroObra: 0,
      nombreObra: '',
      elempep: '',
      observaciones: '',
      finalizada: 0,
      supervisore: '',
      codigoEstado: '',
      modulo: '',
      grupoAlmacen: '',
      obrasDocumentos: []);

//*****************************************************************************
//************************** INIT STATE ***************************************
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
    _getPosition();
    _loadData();
  }

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 191, 191),
      appBar: AppBar(
        title: Text('Nueva Inspección'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 15,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
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
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                _esContratista ? _showCamposContratista() : _showInfo(),
                SizedBox(
                  height: 10,
                ),
                _showObra(),
                _showObservaciones(),
                _showClientes(),
                _showTiposTrabajos(),
                SizedBox(
                  height: 10,
                ),
                _showButton2(),
              ],
            ),
          )
        ],
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
              onPressed: _enabled1 && _enabled2 && _enabled3 && obra.nroObra > 0
                  ? _generarCuestionario
                  : null,
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
//--------------------- METODO SHOCAMPOSCONTRATISTA ---------------
//-----------------------------------------------------------------

  Widget _showCamposContratista() {
    return Column(
      children: [_shownombreSR(), _showdniSR()],
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

//*****************************************************************************
//************************** METODO LOADDATA **********************************
//*****************************************************************************

  void _loadData() async {
    await _getClientes();
  }

//*****************************************************************************
//************************** METODO GETCLIENTES *******************************
//*****************************************************************************

  Future<Null> _getClientes() async {
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
      response = await ApiHelper.GetClientes();
      intentos++;
      if (response.isSuccess) {
        bandera = true;
        _clientes = response.result;
      }
    } while (bandera == false);
    setState(() {});
  }

//-----------------------------------------------------------------------------
//------------------------------ SHOWCLIENTES----------------------------------
//-----------------------------------------------------------------------------

  Widget _showClientes() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 5),
            child: _clientes.length == 0
                ? Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Cargando Clientes...'),
                    ],
                  )
                : DropdownButtonFormField(
                    value: _cliente,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Elija un Cliente...',
                      labelText: 'Cliente',
                      errorText: _clienteShowError ? _clienteError : null,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    items: _getComboClientes(),
                    onChanged: (value) {
                      _cliente = value as int;
                      _tipoTrabajoSelected = 0;
                      _getTiposTrabajos();
                    },
                  ),
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<int>> _getComboClientes() {
    List<DropdownMenuItem<int>> list = [];
    list.add(DropdownMenuItem(
      child: Text('Elija un Cliente...'),
      value: 0,
    ));

    _clientes.forEach((cliente) {
      list.add(DropdownMenuItem(
        child: Text(cliente.nombre.toString()),
        value: cliente.nrocliente,
      ));
    });

    return list;
  }

//*****************************************************************************
//************************** METODO GETTIPOSTRABAJOS *******************************
//*****************************************************************************

  Future<Null> _getTiposTrabajos() async {
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
      response = await ApiHelper.GetTiposTrabajos(_cliente);
      intentos++;
      if (response.isSuccess) {
        bandera = true;
        _tipoTrabajos = response.result;
      }
    } while (bandera == false);
    setState(() {});
  }

//-----------------------------------------------------------------------------
//------------------------------ SHOWTIPOSTRABAJOS-----------------------------
//-----------------------------------------------------------------------------

  Widget _showTiposTrabajos() {
    return Container(
      padding: EdgeInsets.all(10),
      child: _tipoTrabajos.length == 0
          ? Text('')
          : DropdownButtonFormField(
              items: _getComboTiposTrabajos(),
              value: _tipoTrabajoSelected,
              onChanged: (option) {
                _tipoTrabajoSelected = option as int;
                if (_tipoTrabajoSelected > 0) {
                  _enabled2 = true;
                }
                _gruposFormularios = [];
                _getGruposFormularios();

                setState(() {});
              },
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Seleccione un Tipo de Trabajo...',
                labelText: 'Tipo de Trabajo',
                errorText: _tipoTrabajoShowError ? _tipoTrabajoError : null,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              )),
    );
  }

  List<DropdownMenuItem<int>> _getComboTiposTrabajos() {
    List<DropdownMenuItem<int>> list = [];
    list.add(DropdownMenuItem(
      child: Text('Seleccione un Tipo de Trabajo...'),
      value: 0,
    ));

    _tipoTrabajos.forEach((tipoTrabajo) {
      list.add(DropdownMenuItem(
        child: Text(tipoTrabajo.descripcion),
        value: tipoTrabajo.idtipotrabajo,
      ));
    });

    return list;
  }

//*****************************************************************************
//************************** METODO GETGRUPOSFORMULARIOS **********************
//*****************************************************************************

  Future<Null> _getGruposFormularios() async {
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
      response =
          await ApiHelper.GetGruposFormularios(_cliente, _tipoTrabajoSelected);
      intentos++;
      if (response.isSuccess) {
        bandera = true;
        _gruposFormularios = response.result;
      }
    } while (bandera == false);
    setState(() {});
    _getDetallesFormularios();
    _detallesFormulariosAux = _detallesFormularios;
    var b;
  }

//*****************************************************************************
//************************** METODO GETDETALLESFORMULARIOS **********************
//*****************************************************************************

  Future<Null> _getDetallesFormularios() async {
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

    _detallesFormularios = [];
    _detallesFormulariosAux = [];
    _detallesFormulariosCompleto = [];

    Response response = Response(isSuccess: false);

    response = await ApiHelper.GetDetallesFormularios(_cliente);

    if (response.isSuccess) {
      _detallesFormulariosAux = response.result;
    }

    _detallesFormulariosAux.forEach((detalleFormularioAux) {
      _gruposFormularios.forEach((grupoFormulario) {
        if (detalleFormularioAux.idgrupoformulario ==
            grupoFormulario.idgrupoformulario) {
          _detallesFormularios.add(detalleFormularioAux);
          detallesFormularioCompleto = new DetallesFormularioCompleto(
              idcliente: detalleFormularioAux.idcliente,
              idgrupoformulario: detalleFormularioAux.idgrupoformulario,
              descgrupoformulario: grupoFormulario.descripcion,
              detallef: detalleFormularioAux.detallef,
              descripcion: detalleFormularioAux.descripcion,
              ponderacionpuntos: detalleFormularioAux.ponderacionpuntos,
              cumple: detalleFormularioAux.cumple);
          _detallesFormulariosCompleto.add(detallesFormularioCompleto);
        }
      });
    });

    var gg = 1;

    setState(() {});
  }

//-----------------------------------------------------------------
//--------------------- METODO GENERARCUESTIONARIO ----------------
//-----------------------------------------------------------------

  _generarCuestionario() async {
    FocusScope.of(context).unfocus();
    String? result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InspeccionCuestionarioScreen(
                  user: widget.user,
                  causante: _causante,
                  observaciones: _observacionesController.text,
                  obra: obra,
                  cliente: _cliente,
                  tipotrabajo: _tipoTrabajoSelected,
                  esContratista: _esContratista,
                  nombreSR: _nombreSRController.text,
                  dniSR: _dniSRController.text,
                  detallesFormulariosCompleto: _detallesFormulariosCompleto,
                  positionUser: _positionUser,
                )));
    if (result == 'yes') {}
  }

//*****************************************************************************
//************************** METODO GETPOSITION **********************************
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

  Widget _showObra() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text("Obra: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Expanded(
                            child: obra.nombreObra != null
                                ? Text(obra.nombreObra)
                                : Text(""),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            ElevatedButton(
              child: Icon(Icons.search),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF781f1e),
                minimumSize: Size(50, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () async {
                Obra? obra2 = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ObrasScreen(
                      user: widget.user,
                      opcion: 2,
                    ),
                  ),
                );
                if (obra2 != null) {
                  obra = obra2 as Obra;
                }
                setState(() {});
              },
            ),
          ],
        ));
  }
}
