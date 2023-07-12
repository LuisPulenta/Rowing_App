import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rowing_app/components/loader_component.dart';
import 'package:rowing_app/helpers/api_helper.dart';
import 'package:rowing_app/models/models.dart';

class ObraInfoDataScreen extends StatefulWidget {
  final User user;
  final Obra obra;

  const ObraInfoDataScreen({Key? key, required this.user, required this.obra})
      : super(key: key);

  @override
  State<ObraInfoDataScreen> createState() => _ObraInfoDataScreenState();
}

class _ObraInfoDataScreenState extends State<ObraInfoDataScreen> {
//----------------------------------------------------------------------
//------------------------ Variables -----------------------------------
//----------------------------------------------------------------------
  bool _showLoader = false;

  String _direccion = '';
  String _direccionError = '';
  bool _direccionShowError = false;
  final TextEditingController _direccionController = TextEditingController();

  String _motivo = 'Seleccione un Motivo...';
  String _motivoError = '';
  bool _motivoShowError = false;
  List<Option> _motivoOptions = [];

  String _conexion = 'Seleccione una Conexión...';
  String _conexionError = '';
  bool _conexionShowError = false;
  List<Option> _conexionOptions = [];

  String _lugar = 'Seleccione un Lugar...';
  String _lugarError = '';
  bool _lugarShowError = false;
  List<Option> _lugarOptions = [];

  String _materialCanio = 'Seleccione un Material...';
  String _materialCanioError = '';
  bool _materialCanioShowError = false;
  List<Option> _materialCanioOptions = [];

  String _diametroCanio = 'Seleccione un Diámetro de Caño...';
  String _diametroCanioError = '';
  bool _diametroCanioShowError = false;
  List<Option> _diametroCanioOptions = [];

  String _fuga = 'Seleccione un Tipo de Fuga...';
  String _fugaError = '';
  bool _fugaShowError = false;
  List<Option> _fugaOptions = [];

  String _comentarios = '';
  String _comentariosError = '';
  bool _comentariosShowError = false;
  final TextEditingController _comentariosController = TextEditingController();

  int _optionMotivo = 0;
  String _optionMotivoError = '';
  bool _optionMotivoShowError = false;

  List<DropdownMenuItem<String>> _motivos = [];
  List<DropdownMenuItem<String>> _conexiones = [];
  List<DropdownMenuItem<String>> _lugares = [];
  List<DropdownMenuItem<String>> _materialesCanio = [];
  List<DropdownMenuItem<String>> _diametrosCanio = [];
  List<DropdownMenuItem<String>> _fugas = [];

  Obra _obra = Obra(
      nroObra: 0,
      nombreObra: '',
      elempep: '',
      observaciones: '',
      finalizada: 0,
      supervisore: '',
      codigoEstado: '',
      modulo: '',
      grupoAlmacen: '',
      obrasDocumentos: [],
      fechaCierreElectrico: '',
      fechaUltimoMovimiento: '',
      photos: 0,
      audios: 0,
      videos: 0,
      posx: '',
      posy: '',
      direccion: '',
      textoLocalizacion: '',
      textoClase: '',
      textoTipo: '',
      textoComponente: '',
      codigoDiametro: '',
      motivo: '',
      planos: '');

  Position _positionUser = Position(
      longitude: 0,
      latitude: 0,
      timestamp: null,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);

//----------------------------------------------------------------------
//------------------------  initState ----------------------------------
//----------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _obra = widget.obra;
    _obra.posx ??= '';
    _obra.posy ??= '';
    _direccionController.text =
        _obra.direccion != null ? _obra.direccion.toString() : '';

    _getMotivos();
    _getConexiones();
    _getLugares();
    _getMaterialesCanio();
    _getDiametrosCanio();
    _getFugas();
  }

//----------------------------------------------------------------------
//------------------------ Pantalla -----------------------------------
//----------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Datos Obra ${widget.obra.nroObra}'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                _showDireccion(),
                const Divider(
                  color: Color(0xFF781f1e),
                ),
                _showMotivos(),
                _showConexiones(),
                _showLugares(),
                const Divider(
                  color: Color(0xFF781f1e),
                ),
                _showMaterialCanio(),
                _showDiametroCanio(),
                const Divider(
                  color: Color(0xFF781f1e),
                ),
                _showFugas(),
                const Divider(
                  color: Color(0xFF781f1e),
                ),
                _showComentarios(),
                const Divider(
                  color: Color(0xFF781f1e),
                ),
                _showButton(),
                const SizedBox(
                  height: 10,
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
//--------------------- METODO _showDireccion ---------------------
//-----------------------------------------------------------------

  Widget _showDireccion() {
    double ancho = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: const [],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: ancho * 0.75,
                      height: 60,
                      child: TextField(
                        controller: _direccionController,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Dirección',
                            labelText: 'Dirección',
                            errorText:
                                _direccionShowError ? _direccionError : null,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onChanged: (value) {
                          _obra.direccion = value;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.location_on),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF781f1e),
                            minimumSize: const Size(double.infinity, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () => _address()),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          (_obra.posx != '' && _obra.posy != '')
              ? Text(
                  'Latitud: ${_obra.posx} - Latitud: ${_obra.posy}',
                )
              : const Text(
                  'No hay coordenadas cargadas',
                  style: TextStyle(color: Colors.red),
                ),
        ],
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- _address ----------------------------------
//-----------------------------------------------------------------
  void _address() async {
    await _getPosition();
  }

//-----------------------------------------------------------------
//--------------------- _getPosition ------------------------------
//-----------------------------------------------------------------
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
                    child: Text('Ok')),
              ],
            );
          });
      return;
    }

    _positionUser = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks = await placemarkFromCoordinates(
        _positionUser.latitude, _positionUser.longitude);
    _direccion = placemarks[0].street.toString() +
        " - " +
        placemarks[0].locality.toString();

    _obra.posx = _positionUser.latitude.toString();
    _obra.posy = _positionUser.longitude.toString();
    _obra.direccion = _direccion;
    _direccionController.text = _obra.direccion.toString();
    setState(() {});
  }

//-------------------------------------------------------------------------
//-------------------------- _showMotivos ---------------------------------
//-------------------------------------------------------------------------

  _showMotivos() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonFormField(
          items: _motivos,
          value: _motivo,
          onChanged: (option) {
            setState(() {});
          },
          decoration: InputDecoration(
            hintText: 'Seleccione un Motivo...',
            labelText: 'Motivo',
            fillColor: Colors.white,
            filled: true,
            errorText: _motivoShowError ? _motivoError : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          )),
    );
  }

//-------------------------------------------------------------------------
//-------------------------- _showConexiones ---------------------------------
//-------------------------------------------------------------------------

  _showConexiones() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonFormField(
          items: _conexiones,
          value: _conexion,
          onChanged: (option) {
            setState(() {});
          },
          decoration: InputDecoration(
            hintText: 'Seleccione una Conexión...',
            labelText: 'Conexión',
            fillColor: Colors.white,
            filled: true,
            errorText: _conexionShowError ? _conexionError : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          )),
    );
  }

//-------------------------------------------------------------------------
//-------------------------- _showLugares ---------------------------------
//-------------------------------------------------------------------------

  _showLugares() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonFormField(
          items: _lugares,
          value: _lugar,
          onChanged: (option) {
            setState(() {});
          },
          decoration: InputDecoration(
            hintText: 'Seleccione un Lugar...',
            labelText: 'Lugar',
            fillColor: Colors.white,
            filled: true,
            errorText: _lugarShowError ? _lugarError : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          )),
    );
  }

//----------------------------------------------------------------------
//------------------------ _getMotivos ---------------------------------
//----------------------------------------------------------------------

  void _getMotivos() {
    Option opt1 = Option(id: 1, description: 'Fuga');
    Option opt2 = Option(id: 2, description: 'Sospechoso');
    Option opt3 = Option(id: 3, description: 'Silencioso');
    Option opt4 = Option(id: 4, description: 'No verificable');
    _motivoOptions.add(opt1);
    _motivoOptions.add(opt2);
    _motivoOptions.add(opt3);
    _motivoOptions.add(opt4);
    _getComboMotivos();
  }

//----------------------------------------------------------------------
//------------------------ _getComboMotivos -----------------------------------
//----------------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboMotivos() {
    _motivos = [];

    List<DropdownMenuItem<String>> listMotivos = [];
    listMotivos.add(const DropdownMenuItem(
      child: Text('Seleccione un Motivo...'),
      value: 'Seleccione un Motivo...',
    ));

    for (var _listoption in _motivoOptions) {
      listMotivos.add(DropdownMenuItem(
        child: Text(_listoption.description),
        value: _listoption.description,
      ));
    }

    _motivos = listMotivos;

    return listMotivos;
  }

//----------------------------------------------------------------------
//------------------------ _getConexiones ------------------------------
//----------------------------------------------------------------------

  void _getConexiones() {
    Option opt1 = Option(id: 1, description: 'Principal');
    Option opt2 = Option(id: 2, description: 'Servicio');
    Option opt3 = Option(id: 3, description: 'Privada');
    Option opt4 = Option(id: 4, description: 'Sin Datos');
    _conexionOptions.add(opt1);
    _conexionOptions.add(opt2);
    _conexionOptions.add(opt3);
    _conexionOptions.add(opt4);
    _getComboConexiones();
  }

//----------------------------------------------------------------------
//------------------------ _getComboConexiones -------------------------
//----------------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboConexiones() {
    _conexiones = [];

    List<DropdownMenuItem<String>> listConexiones = [];
    listConexiones.add(const DropdownMenuItem(
      child: Text('Seleccione una Conexión...'),
      value: 'Seleccione una Conexión...',
    ));

    for (var _listoption in _conexionOptions) {
      listConexiones.add(DropdownMenuItem(
        child: Text(_listoption.description),
        value: _listoption.description,
      ));
    }

    _conexiones = listConexiones;

    return listConexiones;
  }

//----------------------------------------------------------------------
//------------------------ _getLugares ---------------------------------
//----------------------------------------------------------------------

  void _getLugares() {
    Option opt1 = Option(id: 1, description: 'Cañería Principal');
    Option opt2 = Option(id: 2, description: 'Válvula');
    Option opt3 = Option(id: 3, description: 'Hidrante');
    Option opt4 = Option(id: 4, description: 'Conex. Arranques');
    _lugarOptions.add(opt1);
    _lugarOptions.add(opt2);
    _lugarOptions.add(opt3);
    _lugarOptions.add(opt4);
    _getComboLugares();
  }

//----------------------------------------------------------------------
//------------------------ _getComboLugares ----------------------------
//----------------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboLugares() {
    _lugares = [];

    List<DropdownMenuItem<String>> listLugares = [];
    listLugares.add(const DropdownMenuItem(
      child: Text('Seleccione un Lugar...'),
      value: 'Seleccione un Lugar...',
    ));

    for (var _listoption in _lugarOptions) {
      listLugares.add(DropdownMenuItem(
        child: Text(_listoption.description),
        value: _listoption.description,
      ));
    }

    _lugares = listLugares;

    return listLugares;
  }

//-------------------------------------------------------------------------
//-------------------------- _showMaterialCanio ---------------------------
//-------------------------------------------------------------------------

  _showMaterialCanio() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonFormField(
          items: _materialesCanio,
          value: _materialCanio,
          onChanged: (option) {
            setState(() {});
          },
          decoration: InputDecoration(
            hintText: 'Seleccione un Material...',
            labelText: 'Material Caño',
            fillColor: Colors.white,
            filled: true,
            errorText: _materialCanioShowError ? _materialCanioError : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          )),
    );
  }

//----------------------------------------------------------------------
//------------------------ _getMaterialesCanio -------------------------
//----------------------------------------------------------------------

  void _getMaterialesCanio() {
    Option opt1 = Option(id: 1, description: 'Hierro Fundido');
    Option opt2 = Option(id: 2, description: 'Asbesto cemento');
    Option opt3 = Option(id: 3, description: 'Poliet./PVC');
    Option opt4 = Option(id: 4, description: 'Plomo');
    Option opt5 = Option(id: 4, description: 'Sin Datos');
    _materialCanioOptions.add(opt1);
    _materialCanioOptions.add(opt2);
    _materialCanioOptions.add(opt3);
    _materialCanioOptions.add(opt4);
    _materialCanioOptions.add(opt5);
    _getComboMaterialCanios();
  }

//----------------------------------------------------------------------
//------------------------ _getComboMaterialCanios ---------------------
//----------------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboMaterialCanios() {
    List<DropdownMenuItem<String>> listMaterialesCanios = [];
    listMaterialesCanios.add(const DropdownMenuItem(
      child: Text('Seleccione un Material...'),
      value: 'Seleccione un Material...',
    ));

    for (var _listoption in _materialCanioOptions) {
      listMaterialesCanios.add(DropdownMenuItem(
        child: Text(_listoption.description),
        value: _listoption.description,
      ));
    }

    _materialesCanio = listMaterialesCanios;

    return listMaterialesCanios;
  }

//-------------------------------------------------------------------------
//-------------------------- _showDiametroCanio ---------------------------
//-------------------------------------------------------------------------

  _showDiametroCanio() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonFormField(
          items: _diametrosCanio,
          value: _diametroCanio,
          onChanged: (option) {
            setState(() {});
          },
          decoration: InputDecoration(
            hintText: 'Seleccione un Diámetro de Caño...',
            labelText: 'Diámetro Caño',
            fillColor: Colors.white,
            filled: true,
            errorText: _diametroCanioShowError ? _diametroCanioError : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          )),
    );
  }

//----------------------------------------------------------------------
//------------------------ _getDiametrosCanio --------------------------
//----------------------------------------------------------------------

  void _getDiametrosCanio() {
    Option opt1 = Option(id: 1, description: 'Hierro Fundido');
    Option opt2 = Option(id: 2, description: 'Asbesto cemento');
    Option opt3 = Option(id: 3, description: 'Poliet./PVC');
    Option opt4 = Option(id: 4, description: 'Plomo');
    Option opt5 = Option(id: 4, description: 'Sin Datos');
    _diametroCanioOptions.add(opt1);
    _diametroCanioOptions.add(opt2);
    _diametroCanioOptions.add(opt3);
    _diametroCanioOptions.add(opt4);
    _diametroCanioOptions.add(opt5);
    _getComboDiametroCanios();
  }

//----------------------------------------------------------------------
//------------------------ _getComboDiametroCanios ---------------------
//----------------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboDiametroCanios() {
    List<DropdownMenuItem<String>> listDiametrosCanios = [];
    listDiametrosCanios.add(const DropdownMenuItem(
      child: Text('Seleccione un Diámetro de Caño...'),
      value: 'Seleccione un Diámetro de Caño...',
    ));

    for (var _listoption in _diametroCanioOptions) {
      listDiametrosCanios.add(DropdownMenuItem(
        child: Text(_listoption.description),
        value: _listoption.description,
      ));
    }

    _diametrosCanio = listDiametrosCanios;

    return listDiametrosCanios;
  }

//-------------------------------------------------------------------------
//-------------------------- _showFugas -----------------------------------
//-------------------------------------------------------------------------

  _showFugas() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonFormField(
          items: _fugas,
          value: _fuga,
          onChanged: (option) {
            setState(() {});
          },
          decoration: InputDecoration(
            hintText: 'Seleccione un Tipo de Fuga...',
            labelText: 'Tipo de Fuga',
            fillColor: Colors.white,
            filled: true,
            errorText: _fugaShowError ? _fugaError : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          )),
    );
  }

//----------------------------------------------------------------------
//------------------------ _getFugas -----------------------------------
//----------------------------------------------------------------------

  void _getFugas() {
    Option opt1 = Option(id: 1, description: 'Visible');
    Option opt2 = Option(id: 2, description: 'Semivisible');
    Option opt3 = Option(id: 3, description: 'Invisible');
    Option opt4 = Option(id: 4, description: 'Goteo');
    Option opt5 = Option(id: 4, description: 'Sin Datos');
    _fugaOptions.add(opt1);
    _fugaOptions.add(opt2);
    _fugaOptions.add(opt3);
    _fugaOptions.add(opt4);
    _fugaOptions.add(opt5);
    _getComboFugas();
  }

//----------------------------------------------------------------------
//------------------------ _getComboFugas ------------------------------
//----------------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboFugas() {
    List<DropdownMenuItem<String>> listFugas = [];
    listFugas.add(const DropdownMenuItem(
      child: Text('Seleccione un Tipo de Fuga...'),
      value: 'Seleccione un Tipo de Fuga...',
    ));

    for (var _listoption in _fugaOptions) {
      listFugas.add(DropdownMenuItem(
        child: Text(_listoption.description),
        value: _listoption.description,
      ));
    }

    _fugas = listFugas;

    return listFugas;
  }

//-----------------------------------------------------------------
//--------------------- _showComentarios --------------------------
//-----------------------------------------------------------------

  Widget _showComentarios() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextField(
        controller: _comentariosController,
        maxLines: 3,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Ingrese Comentarios...',
            labelText: 'Comentarios:',
            errorText: _comentariosShowError ? _comentariosError : null,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {},
        //enabled: _enabled,
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWBUTTON -------------------------
//-----------------------------------------------------------------

  Widget _showButton() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.save),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Guardar'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF781f1e),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: _save,
            ),
          ),
        ],
      ),
    );
  }
//-----------------------------------------------------------------
//--------------------- _save -------------------------------------
//-----------------------------------------------------------------

  _save() {
    if (!validateFields()) {
      setState(() {});
      return;
    }
    _addRecord();
  }

//-----------------------------------------------------------------
//--------------------- validateFields ----------------------------
//-----------------------------------------------------------------

  bool validateFields() {
    bool isValid = true;

    if (_motivo == 'Elija un Motivo...') {
      isValid = false;
      _motivoShowError = true;
      _motivoError = 'Debe elegir un Motivo';

      setState(() {});
      return isValid;
    } else {
      _motivoShowError = false;
    }

    setState(() {});

    return isValid;
  }

//-----------------------------------------------------------------
//--------------------- _addRecord --------------------------------
//-----------------------------------------------------------------

  void _addRecord() async {
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

    Map<String, dynamic> request = {
      'grupo': '',
      'causante': '',
    };

    Response response = await ApiHelper.put(
        '/api/CausantesNovedades/PostNovedades', '1', request);

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
    Navigator.pop(context, 'yes');
  }
}
