import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rowing_app/components/loader_component.dart';
import 'package:rowing_app/helpers/api_helper.dart';
import 'package:rowing_app/models/models.dart';
import 'package:rowing_app/screens/entregas_screen.dart';
import 'package:rowing_app/widgets/widgets.dart';

class FlotaScreen extends StatefulWidget {
  final User user;
  FlotaScreen({required this.user});

  @override
  _FlotaScreenState createState() => _FlotaScreenState();
}

class _FlotaScreenState extends State<FlotaScreen> {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

  String _codigo = '';
  String _codigoError = '';
  bool _codigoShowError = false;
  bool _enabled = false;
  bool _showLoader = false;
  late Vehiculo _vehiculo;
  late VFlota _vFlota;
  TextEditingController _codigoController = TextEditingController();

  String kmFechaAnterior = '';
  int kmFinAnterior = 0;

  String _km = '';
  String _kmError = '';
  bool _kmShowError = false;
  TextEditingController _kmController = TextEditingController();

  List<VehiculosKilometraje> _kilometrajes = [];
  List<VehiculosProgramaPrev> _programasprev = [];

  int _nroReg = 0;
  bool _seguimientoGrabado = false;

  void initState() {
    super.initState();
    _vehiculo = new Vehiculo(
        codveh: 0,
        numcha: '',
        codProducto: '',
        aniofa: 0,
        descripcion: '',
        nmotor: '',
        chasis: '',
        fechaVencITV: 0,
        nroPolizaSeguro: '',
        centroCosto: '',
        propiedadDe: '',
        telepase: '',
        kmhsactual: 0,
        usaHoras: 0,
        habilitado: 0,
        fechaVencObleaGAS: 0,
        modulo: '',
        campomemo: '');
  }

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF484848),
        appBar: AppBar(
          title: Text("Flotas"),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  _showLogo(),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 15,
                    margin: EdgeInsets.all(5),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            children: [
                              Expanded(
                                child: _showLegajo(),
                                flex: 5,
                              ),
                              Expanded(
                                child: _showButton(),
                                flex: 3,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  _showInfo(),
                  SizedBox(
                    height: 5,
                  ),
                  _showButtons(),
                ],
              ),
            ),
            _showLoader
                ? LoaderComponent(
                    text: 'Por favor espere...',
                  )
                : Container(),
          ],
        ));
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWLOGO ---------------------------
//-----------------------------------------------------------------

  Widget _showLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Image.asset(
          "assets/flota1.png",
          width: 70,
          height: 70,
        ),
        Image.asset(
          "assets/logo.png",
          height: 70,
          width: 200,
        ),
        Image.asset(
          "assets/flota2.png",
          width: 70,
          height: 70,
          color: Colors.white,
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
        controller: _codigoController,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Ingrese Patente...',
            labelText: 'Patente:',
            errorText: _codigoShowError ? _codigoError : null,
            prefixIcon: Icon(Icons.badge),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _codigo = value;
        },
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWBUTTON ---------------------------
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
                  Text('Consultar'),
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
              icon: Icons.abc_outlined,
              nombredato: 'Cód. Inventario:',
              dato: _Dato(_vehiculo.codProducto),
            ),
            CustomRow(
              icon: Icons.numbers_outlined,
              nombredato: 'Modelo:',
              dato: _vehiculo.aniofa != 0
                  ? _Dato(_vehiculo.aniofa.toString())
                  : '',
            ),
            CustomRow(
              icon: Icons.description,
              nombredato: 'Descripción:',
              dato: _Dato(_vehiculo.descripcion),
            ),
            CustomRow(
              icon: Icons.filter_1,
              nombredato: 'N° Motor:',
              dato: _Dato(_vehiculo.nmotor),
            ),
            CustomRow(
              icon: Icons.filter_2,
              nombredato: 'N° Chásis:',
              dato: _Dato(_vehiculo.chasis),
            ),
            CustomRow(
              icon: Icons.date_range,
              nombredato: 'Venc. VTV:',
              dato: _vehiculo.fechaVencITV != 0
                  ? _Dato(
                      '${DateFormat('dd/MM/yyyy').format(DateTime(2022, 01, 01).add(Duration(days: (_vehiculo.fechaVencITV! - 80723))))}')
                  : '',
              alert: _vehiculo.fechaVencITV != 0
                  ? DateTime(2022, 01, 01)
                              .add(Duration(
                                  days: (_vehiculo.fechaVencITV! - 80723)))
                              .difference(DateTime.now()) >=
                          Duration(days: 50)
                      ? false
                      : true
                  : false,
            ),
            CustomRow(
              icon: Icons.date_range,
              nombredato: 'Venc. Oblea Gas:',
              dato: _vehiculo.fechaVencObleaGAS != 0
                  ? _Dato(
                      '${DateFormat('dd/MM/yyyy').format(DateTime(2022, 01, 01).add(Duration(days: (_vehiculo.fechaVencObleaGAS! - 80723))))}')
                  : '',
              alert: _vehiculo.fechaVencObleaGAS != 0
                  ? DateTime(2022, 01, 01)
                              .add(Duration(
                                  days: (_vehiculo.fechaVencObleaGAS! - 80723)))
                              .difference(DateTime.now()) >=
                          Duration(days: 30)
                      ? false
                      : true
                  : false,
            ),
            CustomRow(
              icon: Icons.security,
              nombredato: 'N° Póliza Seguro:',
              dato: _Dato(_vehiculo.nroPolizaSeguro),
            ),
            CustomRow(
              icon: Icons.request_quote,
              nombredato: 'Centro de Costo:',
              dato: _Dato(_vehiculo.centroCosto),
            ),
            CustomRow(
              icon: Icons.factory,
              nombredato: 'Propiedad de:',
              dato: _Dato(_vehiculo.propiedadDe),
            ),
            CustomRow(
              icon: Icons.code,
              nombredato: 'Telepase:',
              dato: _Dato(_vehiculo.telepase),
            ),
            CustomRow(
              icon: Icons.ac_unit,
              nombredato: _vehiculo.usaHoras == 1 ? 'Horas:' : 'Kilómetros',
              dato: _vehiculo.kmhsactual != 0
                  ? _Dato(_vehiculo.kmhsactual != null
                      ? _vehiculo.kmhsactual.toString()
                      : '')
                  : '',
            ),
            CustomRow(
              icon: Icons.circle,
              nombredato: 'Habilitado:',
              dato: _vehiculo.numcha != ''
                  ? (_vehiculo.habilitado == 1 ? 'Si' : 'No')
                  : '',
            ),
            CustomRow(
              icon: Icons.code,
              nombredato: 'Módulo:',
              dato: _Dato(_vehiculo.modulo),
            ),
            CustomRow(
              icon: Icons.person,
              nombredato: 'Asignado a:',
              dato: _Dato(_vehiculo.campomemo),
            ),
          ],
        ),
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- WIDGET SHOWBUTTONS ------------------------
//-----------------------------------------------------------------

  Widget _showButtons() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _kmController,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: _vehiculo.usaHoras == 1
                      ? 'Ingrese Hs...'
                      : 'Ingrese Km...',
                  labelText: _vehiculo.usaHoras == 1 ? 'Hs:' : 'Km',
                  errorText: _kmShowError ? _kmError : null,
                  prefixIcon: Icon(Icons.ac_unit),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              onChanged: (value) {
                _km = value;
                setState(() {});
              },
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.save),
                  Text('Guardar'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF120E43),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: _km != '' ? _kilometros : null,
            ),
          ),
        ],
      ),
    );
  }

//*****************************************************************************
//************************** METODO SEARCH ************************************
//*****************************************************************************

  _search() async {
    FocusScope.of(context).unfocus();
    _codigoController.text = _codigo.toUpperCase();
    if (_codigo.isEmpty) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Ingrese una Patente.',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    if (widget.user.habilitaFlotas == "SI") {
      await _getUsuarioChapa();
    } else {
      await _getVehiculo();
    }
  }

//*****************************************************************************
//************************** METODO KILOMETROS ************************************
//*****************************************************************************

  void _kilometros() async {
    FocusScope.of(context).unfocus(); //Oculta el teclado
//--------------------- CHEQUEA VALOR INGRESADO ------------------------

    if (int.parse(_km) < kmFinAnterior) {
      var response = await showAlertDialog(
          context: context,
          title: 'Aviso',
          message: _vehiculo.usaHoras == 1
              ? 'El valor de Hs ingresado es menor al último guardado. ¿Está seguro de guardar?'
              : 'El valor de Km ingresado es menor al último guardado. ¿Está seguro de guardar?',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: 'si', label: 'SI'),
            AlertDialogAction(key: 'no', label: 'NO'),
          ]);
      if (response == 'no') {
        return;
      }
    }

//--------------------- CHEQUEA CONEXION A INTERNET ------------------------

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

//---------------- GRABA NUEVO REGISTRO EN TABLA VEHICULOSKILOMETRAJES ---------

    do {
      setState(() {
        _showLoader = true;
      });

      Response response2 = await ApiHelper.getNroRegistroMax();
      if (response2.isSuccess) {
        _nroReg = int.parse(response2.result.toString()) + 1;
      }

      Map<String, dynamic> request = {
        'orden': _nroReg,
        'fecha': DateTime.now().toString(),
        'equipo': _vehiculo.codProducto,
        'kilini': kmFinAnterior,
        'kilfin': int.parse(_km),
        'horsal': 0,
        'horlle': 0,
        'codsuc': 0,
        'nrodeot': 0,
        'cambio': 0,
        'procesado': 0,
        'kmfechaanterior': kmFechaAnterior != '' ? kmFechaAnterior : null,
        'nopromediar': 0,
        'fechaalta': DateTime.now().toString(),
      };

      Response response =
          await ApiHelper.postNoToken('/api/VehiculosKilometraje/', request);

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
      } else {
        _seguimientoGrabado = true;
      }
    } while (_seguimientoGrabado == false);

//---------------- ACTUALIZA KM EN TABLA VEHICULOS ---------

    Map<String, dynamic> request2 = {
      'id': _vehiculo.codveh,
      'kmhsactual': _km,
    };

    Response response = await ApiHelper.put(
        '/api/Vehiculos/', _vehiculo.codveh.toString(), request2);

//---------------- ACTUALIZA KM EN TABLA VEHICULOSPROGRAMASPREV ---------
    Response response3 = Response(isSuccess: false);

    response3 =
        await ApiHelper.GetProgramasPrev(_vehiculo.codProducto.toString());
    _programasprev = response3.result;

    _programasprev.forEach((element) async {
      Map<String, dynamic> request3 = {
        'nrointerno': element.nroInterno,
        'kmhsactual': int.parse(_km) - kmFinAnterior,
      };

      Response response = await ApiHelper.put('/api/VehiculosProgramasPrev/',
          element.nroInterno.toString(), request3);
    });

//---------------- MENSAJE FINAL Y CIERRE DE PAGINA ---------
    await showAlertDialog(
        context: context,
        title: 'Aviso',
        message: 'Valor guardado con éxito!',
        actions: <AlertDialogAction>[
          AlertDialogAction(key: null, label: 'Aceptar'),
        ]);
    Navigator.pop(context, 'yes');
  }

//*****************************************************************************
//************************** METODO GETVEHICULO *******************************
//*****************************************************************************

  Future<Null> _getVehiculo() async {
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

    Response response = await ApiHelper.getVehiculoByChapa(_codigo);

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: "Patente no válida",
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
      _vehiculo = response.result;
      _enabled = true;
    });

    Response response2 = Response(isSuccess: false);

    response2 =
        await ApiHelper.getKilometrajes(_vehiculo.codProducto.toString());
    _kilometrajes = response2.result;

    kmFechaAnterior = _kilometrajes.length > 0
        ? _kilometrajes[_kilometrajes.length - 1].fecha.toString()
        : '';
    kmFinAnterior = (_kilometrajes.length > 0
        ? _kilometrajes[_kilometrajes.length - 1].kilfin!
        : _vehiculo.kmhsactual)!;
    var a = 1;
  }

//*****************************************************************************
//************************** METODO GETUSUARIOCHAPA ***************************
//*****************************************************************************

  Future<Null> _getUsuarioChapa() async {
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

    Response response = await ApiHelper.getUsuarioChapa(_codigo);

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: "Patente no válida",
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
      _vFlota = response.result;
      _enabled = true;
    });

    if (_vFlota.grupoV == widget.user.codigogrupo &&
        _vFlota.causanteV == widget.user.codigoCausante) {
      _getVehiculo();
    } else {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: "Esta patente no está asignada a su Usuario",
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
    }
    setState(() {});
  }

//*****************************************************************************
//************************** METODO DATO **************************************
//*****************************************************************************

  String _Dato(String? dato) {
    return dato != null ? dato.toString() : '';
  }
}
