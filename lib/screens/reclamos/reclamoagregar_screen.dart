import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/obra.dart';
import '../../models/response.dart';
import '../../models/user.dart';

class ReclamoAgregarScreen extends StatefulWidget {
  final User user;
  const ReclamoAgregarScreen({super.key, required this.user});

  @override
  _ReclamoAgregarScreenState createState() => _ReclamoAgregarScreenState();
}

class _ReclamoAgregarScreenState extends State<ReclamoAgregarScreen> {
  //---------------------------------------------------------------
  //----------------------- Variables -----------------------------
  //---------------------------------------------------------------

  bool _showLoader = false;

  int _obraId = 0;
  String _obraIdError = '';
  bool _obraIdShowError = false;
  List<Obra> _obras = [];

  String _zona = '';
  String _zonaError = '';
  bool _zonaShowError = false;
  final TextEditingController _zonaController = TextEditingController();

  String _direccion = '';
  String _direccionError = '';
  bool _direccionShowError = false;
  final TextEditingController _direccionController = TextEditingController();

  String _numero = '';
  String _numeroError = '';
  bool _numeroShowError = false;
  final TextEditingController _numeroController = TextEditingController();

  String _asreclamo = '';
  String _asreclamoError = '';
  bool _asreclamoShowError = false;
  final TextEditingController _asreclamoController = TextEditingController();

  String _descripcion = '';
  String _descripcionError = '';
  bool _descripcionShowError = false;
  final TextEditingController _descripcionController = TextEditingController();

  //---------------------------------------------------------------
  //----------------------- initState -----------------------------
  //---------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  //---------------------------------------------------------------
  //----------------------- Pantalla ------------------------------
  //---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('Agregar Nuevo Reclamo'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _showObra(),
                _showZona(),
                _showDireccion(),
                _showNumero(),
                _showASReclamo(),
                _showDescripcion(),
                const SizedBox(height: 30),
                _showButton(),
                const SizedBox(height: 10),
              ],
            ),
          ),
          _showLoader
              ? const LoaderComponent(text: 'Por favor espere...')
              : Container(),
        ],
      ),
    );
  }

  //---------------------------------------------------------------
  //----------------------- _showObra -----------------------------
  //---------------------------------------------------------------

  Widget _showObra() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: _obras.isEmpty
          ? const Text('Cargando obras...')
          : DropdownButtonFormField(
              items: _getComboObras(),
              initialValue: _obraId,
              onChanged: (option) {
                setState(() {
                  _obraId = option as int;
                });
              },
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Seleccione una obra...',
                labelText: 'Obra',
                errorText: _obraIdShowError ? _obraIdError : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
    );
  }

  //---------------------------------------------------------------
  //----------------------- _getComboObras ------------------------
  //---------------------------------------------------------------

  List<DropdownMenuItem<int>> _getComboObras() {
    List<DropdownMenuItem<int>> list = [];
    list.add(
      const DropdownMenuItem(value: 0, child: Text('Seleccione una Obra...')),
    );

    for (var obra in _obras) {
      list.add(
        DropdownMenuItem(
          value: obra.nroObra,
          child: Text(obra.nombreObra.toString().substring(0, 35)),
        ),
      );
    }

    return list;
  }

  //---------------------------------------------------------------
  //----------------------- _showZona -----------------------------
  //---------------------------------------------------------------

  Widget _showZona() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _zonaController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingresa Zona...',
          labelText: 'Zona',
          errorText: _zonaShowError ? _zonaError : null,
          suffixIcon: const Icon(Icons.map),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _zona = value;
        },
      ),
    );
  }

  //---------------------------------------------------------------
  //----------------------- _showDireccion ------------------------
  //---------------------------------------------------------------

  Widget _showDireccion() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _direccionController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingresa Dirección...',
          labelText: 'Dirección',
          errorText: _direccionShowError ? _direccionError : null,
          suffixIcon: const Icon(Icons.home),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _direccion = value;
        },
      ),
    );
  }

  //---------------------------------------------------------------
  //----------------------- _showNumero ---------------------------
  //---------------------------------------------------------------

  Widget _showNumero() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _numeroController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingresa Número...',
          labelText: 'Número',
          errorText: _numeroShowError ? _numeroError : null,
          suffixIcon: const Icon(Icons.tag),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _numero = value;
        },
      ),
    );
  }

  //---------------------------------------------------------------
  //----------------------- _showASReclamo ------------------------
  //---------------------------------------------------------------

  Widget _showASReclamo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _asreclamoController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingresa AS/N° Reclamo...',
          labelText: 'AS/N° Reclamo',
          errorText: _asreclamoShowError ? _asreclamoError : null,
          suffixIcon: const Icon(Icons.pin),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _asreclamo = value;
        },
      ),
    );
  }

  //---------------------------------------------------------------
  //----------------------- _showDescripcion ----------------------
  //---------------------------------------------------------------

  Widget _showDescripcion() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _descripcionController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingresa Descripción / Nombre...',
          labelText: 'Descripción / Nombre',
          errorText: _descripcionShowError ? _descripcionError : null,
          suffixIcon: const Icon(Icons.notes),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _descripcion = value;
        },
      ),
    );
  }

  //---------------------------------------------------------------
  //----------------------- _showButton ---------------------------
  //---------------------------------------------------------------

  Widget _showButton() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF781f1e),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: _save,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.save),
                  SizedBox(width: 20),
                  Text('Guardar cambios'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //---------------------------------------------------------------
  //----------------------- _save ---------------------------------
  //---------------------------------------------------------------

  void _save() {
    if (!validateFields()) {
      return;
    }
    _addRecord();
  }

  //---------------------------------------------------------------
  //----------------------- _loadData -----------------------------
  //---------------------------------------------------------------

  void _loadData() async {
    await _getObras();
  }

  //---------------------------------------------------------------
  //----------------------- _getObras -----------------------------
  //---------------------------------------------------------------

  Future<void> _getObras() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      showMyDialog(
        'Error',
        'Verifica que estés conectado a Internet',
        'Aceptar',
      );
    }

    Response response = Response(isSuccess: false);

    response = await ApiHelper.getObrasReclamos(
      'ObrasTasa',
    ); //widget.user.modulo

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
        ],
      );
      return;
    }

    setState(() {
      _obras = response.result;
    });
  }

  //---------------------------------------------------------------
  //----------------------- validateFields ------------------------
  //---------------------------------------------------------------

  bool validateFields() {
    bool isValid = true;

    if (_obraId == 0) {
      isValid = false;
      _obraIdShowError = true;
      _obraIdError = 'Debes seleccionar una Obra';
    } else {
      _obraIdShowError = false;
    }

    if (_zona.isEmpty) {
      isValid = false;
      _zonaShowError = true;
      _zonaError = 'Debes ingresar una Zona';
    } else {
      _zonaShowError = false;
    }

    if (_direccion.isEmpty) {
      isValid = false;
      _direccionShowError = true;
      _direccionError = 'Debes ingresar una Dirección';
    } else {
      _direccionShowError = false;
    }

    if (_numero.isEmpty) {
      isValid = false;
      _numeroShowError = true;
      _numeroError = 'Debes ingresar un Número';
    } else {
      _numeroShowError = false;
    }

    if (_asreclamo.isEmpty) {
      isValid = false;
      _asreclamoShowError = true;
      _asreclamoError = 'Debes ingresar un AS/N° Reclamo';
    } else {
      _asreclamoShowError = false;
    }

    if (_descripcion.isEmpty) {
      isValid = false;
      _descripcionShowError = true;
      _descripcionError = 'Debes ingresar una Descripción';
    } else {
      _descripcionShowError = false;
    }

    setState(() {});

    return isValid;
  }

  //---------------------------------------------------------------
  //----------------------- _addRecord ----------------------------
  //---------------------------------------------------------------

  void _addRecord() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      showMyDialog(
        'Error',
        'Verifica que estés conectado a Internet',
        'Aceptar',
      );
    }

    Map<String, dynamic> request = {
      //'nroregistro': _ticket.nroregistro,
      'nroobra': _obraId,
      'asticket': _asreclamo,
      'cliente': '',
      'direccion': _direccion,
      'numeracion': _numero,
      'localidad': '',
      'telefono': '',
      'tipoImput': 'Reclamos',
      'certificado': 'No',
      'serieMedidorColocado': '',
      'precinto': '',
      'cajaDAE': '',
      'IDActaCertif': 0,
      'observaciones': '',
      'lindero1': '',
      'lindero2': '',
      'zona': _zona,
      'terminal': _descripcion,
      'subcontratista': widget.user.codigogrupo,
      'causanteC': widget.user.codigocausante,
      'grxx': '',
      'gryy': '',
      'idUsrIn': widget.user.idUsuario,
      'observacionAdicional': 'App',
      'riesgoElectrico': 'No',
      'mes': DateTime.now().month,
    };

    Response response = await ApiHelper.post(
      '/api/ObrasPostes/PostReclamo',
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
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }
    Navigator.pop(context, 'yes');
  }
}
