import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';

class ObraInfoDataScreen extends StatefulWidget {
  final User user;
  final Obra obra;

  const ObraInfoDataScreen({super.key, required this.user, required this.obra});

  @override
  State<ObraInfoDataScreen> createState() => _ObraInfoDataScreenState();
}

class _ObraInfoDataScreenState extends State<ObraInfoDataScreen> {
  //----------------------------------------------------------------------
  //------------------------ Variables -----------------------------------
  //----------------------------------------------------------------------

  bool _showLoader = false;
  bool _mostrarConexiones = false;
  bool _mostrarLugares = false;

  String _direccion = '';
  final String _direccionError = '';
  final bool _direccionShowError = false;
  final TextEditingController _direccionController = TextEditingController();

  final String _motivo = 'Seleccione un Motivo...';
  String _motivoError = '';
  bool _motivoShowError = false;
  final List<Option> _motivoOptions = [];

  final String _conexion = 'Seleccione una Conexión...';
  String _conexionError = '';
  bool _conexionShowError = false;
  final List<Option> _conexionOptions = [];

  final String _lugar = 'Seleccione un Lugar...';
  String _lugarError = '';
  bool _lugarShowError = false;
  final List<Option> _lugarOptions = [];

  final String _materialCanio = 'Seleccione un Material...';
  String _materialCanioError = '';
  bool _materialCanioShowError = false;
  final List<Option> _materialCanioOptions = [];

  final String _diametroCanio = 'Seleccione un Diámetro de Caño...';
  String _diametroCanioError = '';
  bool _diametroCanioShowError = false;
  final List<Option> _diametroCanioOptions = [];

  final String _fuga = 'Seleccione un Tipo de Fuga...';
  String _fugaError = '';
  bool _fugaShowError = false;
  final List<Option> _fugaOptions = [];

  final String _comentarios = '';
  String _comentariosError = '';
  bool _comentariosShowError = false;
  final TextEditingController _comentariosController = TextEditingController();

  final int _optionMotivo = 0;
  final String _optionMotivoError = '';
  final bool _optionMotivoShowError = false;

  List<DropdownMenuItem<String>> _motivos = [];
  List<DropdownMenuItem<String>> _conexiones = [];
  List<DropdownMenuItem<String>> _lugares = [];
  List<DropdownMenuItem<String>> _materialesCanio = [];
  List<DropdownMenuItem<String>> _diametrosCanio = [];
  List<DropdownMenuItem<String>> _fugas = [];

  List<Catalogo> _catalogos = [];

  Obra _obra = Obra(
    nroObra: 0,
    nombreObra: '',
    nroOE: '',
    defProy: '',
    central: '',
    elempep: '',
    observaciones: '',
    finalizada: 0,
    supervisore: '',
    codigoEstado: '',
    codigoSubEstado: '',
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
    planos: '',
    grupoCausante: '',
  );

  Position _positionUser =  Position(
    longitude: 0,
    latitude: 0,
    timestamp: DateTime.now(),
    altitudeAccuracy: 0,
    headingAccuracy: 0,
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
  );

  //----------------------------------------------------------------------
  //------------------------  initState ----------------------------------
  //----------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _obra = widget.obra;
    _obra.posx ??= '';
    _obra.posy ??= '';
    _direccionController.text = _obra.direccion != null
        ? _obra.direccion.toString()
        : '';

    if (_obra.textoLocalizacion == null || _obra.textoLocalizacion == '') {
      _obra.textoLocalizacion = 'Seleccione un Motivo...';
    }

    if (_obra.textoClase == null || _obra.textoClase == '') {
      _obra.textoClase = 'Seleccione una Conexión...';
    }

    if (_obra.textoTipo == null || _obra.textoTipo == '') {
      _obra.textoTipo = 'Seleccione un Lugar...';
    }

    if (_obra.textoComponente == null || _obra.textoComponente == '') {
      _obra.textoComponente = 'Seleccione un Material...';
    }

    if (_obra.codigoDiametro == null || _obra.codigoDiametro == '') {
      _obra.codigoDiametro = 'Seleccione un Diámetro de Caño...';
    }

    if (_obra.motivo == null || _obra.motivo == '') {
      _obra.motivo = 'Seleccione un Tipo de Fuga...';
    }

    _comentariosController.text = _obra.planos != null
        ? _obra.planos.toString()
        : '';

    _loadData();
    setState(() {});
  }

  //----------------------------------------------------------------------
  //------------------------ Pantalla ------------------------------------
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
                const SizedBox(height: 20),
                _showDireccion(),
                const Divider(color: Color(0xFF781f1e)),
                _showMotivos(),
                _showConexiones(),
                _showLugares(),
                const Divider(color: Color(0xFF781f1e)),
                _showMaterialCanio(),
                _catalogos.isEmpty
                    ? Row(
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(width: 10),
                          Text('Cargando Catálogos...'),
                        ],
                      )
                    : _showDiametroCanio(),
                const Divider(color: Color(0xFF781f1e)),
                _showFugas(),
                const Divider(color: Color(0xFF781f1e)),
                _showComentarios(),
                const Divider(color: Color(0xFF781f1e)),
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

  //-----------------------------------------------------------------
  //--------------------- _showDireccion ----------------------------
  //-----------------------------------------------------------------

  Widget _showDireccion() {
    double ancho = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [Expanded(flex: 2, child: Row(children: const []))],
          ),
          const SizedBox(height: 10),
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
                          errorText: _direccionShowError
                              ? _direccionError
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (value) {
                          _obra.direccion = value;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF781f1e),
                          minimumSize: const Size(double.infinity, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () => _address(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [Icon(Icons.location_on)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          (_obra.posx != '' && _obra.posy != '')
              ? Text('Latitud: ${_obra.posx} - Latitud: ${_obra.posy}')
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
              title: const Text('Aviso'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: const <Widget>[
                  Text('El permiso de localización está negado.'),
                  SizedBox(height: 10),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
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
                  'El permiso de localización está negado permanentemente. No se puede requerir este permiso.',
                ),
                SizedBox(height: 10),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
      return;
    }

    _positionUser = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      _positionUser.latitude,
      _positionUser.longitude,
    );
    _direccion =
        '${placemarks[0].street} - ${placemarks[0].locality}';

    _obra.posx = _positionUser.latitude.toString();
    _obra.posy = _positionUser.longitude.toString();
    _obra.direccion = _direccion;
    _direccionController.text = _obra.direccion.toString();
    setState(() {});
  }

  //-------------------------------------------------------------------------
  //-------------------------- _showMotivos ---------------------------------
  //-------------------------------------------------------------------------

  Container _showMotivos() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonFormField(
        items: _motivos,
        initialValue: _obra.textoLocalizacion,
        onChanged: (value) {
          if (value == 'Seleccione un Motivo...') {
            _mostrarConexiones = false;
            _mostrarLugares = false;
            _obra.textoClase = 'Seleccione una Conexión...';
            _obra.textoTipo = 'Seleccione un Lugar...';
          }

          if (value == 'Fuga' || value == 'Sospechoso') {
            _mostrarConexiones = true;
            _mostrarLugares = false;
            _obra.textoClase = 'Seleccione una Conexión...';
            _obra.textoTipo = 'Seleccione un Lugar...';
          }

          if (value == 'Silencioso' || value == 'No verificable') {
            _mostrarConexiones = false;
            _mostrarLugares = false;
            _obra.textoClase = 'Sin Datos';
            _obra.textoTipo = 'Sin Datos';
          }

          _obra.textoLocalizacion = value as String;

          setState(() {});
        },
        decoration: InputDecoration(
          hintText: 'Seleccione un Motivo...',
          labelText: 'Motivo',
          fillColor: Colors.white,
          filled: true,
          errorText: _motivoShowError ? _motivoError : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  //-------------------------------------------------------------------------
  //-------------------------- _showConexiones ---------------------------------
  //-------------------------------------------------------------------------

  Container _showConexiones() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonFormField(
        items: _conexiones,
        initialValue: _obra.textoClase,
        onChanged: _mostrarConexiones
            ? (value) {
                _mostrarLugares = value != 'Seleccione una Conexión...';
                _obra.textoClase = value as String;
                _obra.textoTipo = 'Seleccione un Lugar...';
                setState(() {});
              }
            : null,
        decoration: InputDecoration(
          hintText: 'Seleccione una Conexión...',
          labelText: 'Conexión',
          fillColor: Colors.white,
          filled: true,
          errorText: _conexionShowError ? _conexionError : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  //-------------------------------------------------------------------------
  //-------------------------- _showLugares ---------------------------------
  //-------------------------------------------------------------------------

  Container _showLugares() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonFormField(
        items: _getComboLugares(_obra.textoClase.toString()),
        initialValue: _obra.textoTipo,
        onChanged: _mostrarLugares
            ? (value) {
                _obra.textoTipo = value as String;
                setState(() {});
              }
            : null,
        decoration: InputDecoration(
          hintText: 'Seleccione un Lugar...',
          labelText: 'Lugar',
          fillColor: Colors.white,
          filled: true,
          errorText: _lugarShowError ? _lugarError : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  //----------------------------------------------------------------------
  //------------------------ _getMotivos ---------------------------------
  //----------------------------------------------------------------------

  void _getMotivos() async {
    await _getDiametrosCanio();
    Option opt1 = Option(id: 1, description: 'Fuga');
    Option opt2 = Option(id: 2, description: 'Sospechoso');
    Option opt3 = Option(id: 3, description: 'Silencioso');
    Option opt4 = Option(id: 4, description: 'No verificable');
    Option opt5 = Option(id: 4, description: 'Sin fugas');
    Option opt6 = Option(id: 4, description: 'Sospechoso-Medidor');
    Option opt7 = Option(id: 4, description: 'Zona peligrosa');
    Option opt8 = Option(id: 4, description: 'Zona privada');
    _motivoOptions.add(opt1);
    _motivoOptions.add(opt2);
    _motivoOptions.add(opt3);
    _motivoOptions.add(opt4);
    _motivoOptions.add(opt5);
    _motivoOptions.add(opt6);
    _motivoOptions.add(opt7);
    _motivoOptions.add(opt8);
    _getComboMotivos();

    setState(() {});
  }

  //----------------------------------------------------------------------
  //------------------------ _getComboMotivos -----------------------------------
  //----------------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboMotivos() {
    _motivos = [];

    List<DropdownMenuItem<String>> listMotivos = [];
    listMotivos.add(
      const DropdownMenuItem(
        value: 'Seleccione un Motivo...',
        child: Text('Seleccione un Motivo...'),
      ),
    );

    for (var _listoption in _motivoOptions) {
      listMotivos.add(
        DropdownMenuItem(
          value: _listoption.description,
          child: Text(_listoption.description),
        ),
      );
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
    listConexiones.add(
      const DropdownMenuItem(
        value: 'Seleccione una Conexión...',
        child: Text('Seleccione una Conexión...'),
      ),
    );

    for (var _listoption in _conexionOptions) {
      listConexiones.add(
        DropdownMenuItem(
          value: _listoption.description,
          child: Text(_listoption.description),
        ),
      );
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

    Option opt11 = Option(id: 11, description: 'Tramo de conexión');
    Option opt12 = Option(id: 12, description: 'Llave de paso');
    Option opt13 = Option(id: 13, description: 'Medidor');
    Option opt14 = Option(id: 14, description: 'Zincha/Torre');

    Option opt21 = Option(id: 21, description: 'Clandestina');
    Option opt22 = Option(id: 22, description: 'Fuga interna');
    Option opt23 = Option(id: 23, description: 'Conexión cruzada');
    Option opt24 = Option(id: 24, description: 'Parques Plazas');

    Option opt30 = Option(id: 30, description: 'Sin Datos');
    _lugarOptions.add(opt1);
    _lugarOptions.add(opt2);
    _lugarOptions.add(opt3);
    _lugarOptions.add(opt4);
    _lugarOptions.add(opt11);
    _lugarOptions.add(opt12);
    _lugarOptions.add(opt13);
    _lugarOptions.add(opt14);
    _lugarOptions.add(opt21);
    _lugarOptions.add(opt22);
    _lugarOptions.add(opt23);
    _lugarOptions.add(opt24);
    _lugarOptions.add(opt30);
  }

  //----------------------------------------------------------------------
  //------------------------ _getComboLugares ----------------------------
  //----------------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboLugares(String conexion) {
    _lugares = [];

    List<DropdownMenuItem<String>> listLugares = [];
    listLugares.add(
      const DropdownMenuItem(
        value: 'Seleccione un Lugar...',
        child: Text('Seleccione un Lugar...'),
      ),
    );

    for (var _listoption in _lugarOptions) {
      if (conexion == 'Principal') {
        if (_listoption.id < 10) {
          listLugares.add(
            DropdownMenuItem(
              value: _listoption.description,
              child: Text(_listoption.description),
            ),
          );
        }
      }

      if (conexion == 'Servicio') {
        if (_listoption.id > 10 && _listoption.id < 20) {
          listLugares.add(
            DropdownMenuItem(
              value: _listoption.description,
              child: Text(_listoption.description),
            ),
          );
        }
      }

      if (conexion == 'Privada') {
        if (_listoption.id > 20 && _listoption.id < 30) {
          listLugares.add(
            DropdownMenuItem(
              value: _listoption.description,
              child: Text(_listoption.description),
            ),
          );
        }
      }
      if (_listoption.id == 30) {
        listLugares.add(
          DropdownMenuItem(
            value: _listoption.description,
            child: Text(_listoption.description),
          ),
        );
      }
    }

    _lugares = listLugares;

    return listLugares;
  }

  //-------------------------------------------------------------------------
  //-------------------------- _showMaterialCanio ---------------------------
  //-------------------------------------------------------------------------

  Container _showMaterialCanio() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonFormField(
        items: _materialesCanio,
        initialValue: _obra.textoComponente,
        onChanged: (value) {
          _obra.textoComponente = value as String;
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: 'Seleccione un Material...',
          labelText: 'Material Caño',
          fillColor: Colors.white,
          filled: true,
          errorText: _materialCanioShowError ? _materialCanioError : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
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
    listMaterialesCanios.add(
      const DropdownMenuItem(
        value: 'Seleccione un Material...',
        child: Text('Seleccione un Material...'),
      ),
    );

    for (var _listoption in _materialCanioOptions) {
      listMaterialesCanios.add(
        DropdownMenuItem(
          value: _listoption.description,
          child: Text(_listoption.description),
        ),
      );
    }

    _materialesCanio = listMaterialesCanios;

    return listMaterialesCanios;
  }

  //-------------------------------------------------------------------------
  //-------------------------- _showDiametroCanio ---------------------------
  //-------------------------------------------------------------------------

  Container _showDiametroCanio() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonFormField(
        items: _diametrosCanio,
        initialValue: _obra.codigoDiametro,
        onChanged: (value) {
          _obra.codigoDiametro = value as String;
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: 'Seleccione un Diámetro de Caño...',
          labelText: 'Diámetro Caño',
          fillColor: Colors.white,
          filled: true,
          errorText: _diametroCanioShowError ? _diametroCanioError : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  //---------------------------------------------------------------------
  //-------------------------- _getDiametrosCanio -----------------------
  //---------------------------------------------------------------------

  Future<void> _getDiametrosCanio() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      showMyDialog(
        'Error',
        'Verifica que estés conectado a Internet',
        'Aceptar',
      );
    }

    Response response = Response(isSuccess: false);

    response = await ApiHelper.getCatalogosAysa();

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

    _catalogos = response.result;
    _catalogos.sort((a, b) {
      return a.catCatalogo.toString().toLowerCase().compareTo(
        b.catCatalogo.toString().toLowerCase(),
      );
    });

    _diametrosCanio = _getComboDiametroCanios();

    setState(() {});
  }

  //---------------------------------------------------------------------
  //-------------------------- _getComboDiametroCanios ------------------
  //---------------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboDiametroCanios() {
    List<DropdownMenuItem<String>> listCatalogos = [];
    listCatalogos.add(
      const DropdownMenuItem(
        value: 'Seleccione un Diámetro de Caño...',
        child: Text('Seleccione un Diámetro de Caño...'),
      ),
    );

    for (var catalogo in _catalogos) {
      listCatalogos.add(
        DropdownMenuItem(
          value: catalogo.catCodigo,
          child: Text(catalogo.catCatalogo.toString()),
        ),
      );
    }

    return listCatalogos;
  }

  //-------------------------------------------------------------------------
  //-------------------------- _showFugas -----------------------------------
  //-------------------------------------------------------------------------

  Container _showFugas() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonFormField(
        items: _fugas,
        initialValue: _obra.motivo,
        onChanged: (value) {
          _obra.motivo = value as String;
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: 'Seleccione un Tipo de Fuga...',
          labelText: 'Tipo de Fuga',
          fillColor: Colors.white,
          filled: true,
          errorText: _fugaShowError ? _fugaError : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
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
    listFugas.add(
      const DropdownMenuItem(
        value: 'Seleccione un Tipo de Fuga...',
        child: Text('Seleccione un Tipo de Fuga...'),
      ),
    );

    for (var _listoption in _fugaOptions) {
      listFugas.add(
        DropdownMenuItem(
          value: _listoption.description,
          child: Text(_listoption.description),
        ),
      );
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _obra.planos = value;
        },
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showButton -------------------------------
  //-----------------------------------------------------------------

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
                  Text('Guardar'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  //-----------------------------------------------------------------
  //--------------------- _save -------------------------------------
  //-----------------------------------------------------------------

  Future<void> _save() async {
    if (widget.obra.finalizada == 1) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Obra Terminada. No se pueden guardar datos.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }
    if (widget.user.rubro != 1) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Su usuario no está habilitado para guardar Datos de Obra.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

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

    if (_obra.posx == '' || _obra.posy == '' || _obra.direccion == '') {
      showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Debe cargar la dirección geolocalizada.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      isValid = false;
    }

    if (_obra.textoLocalizacion == 'Seleccione un Motivo...') {
      isValid = false;
      _motivoShowError = true;
      _motivoError = 'Debe elegir un Motivo';

      setState(() {});
      return isValid;
    } else {
      _motivoShowError = false;
    }

    if ((_obra.textoLocalizacion == 'Fuga' ||
            _obra.textoLocalizacion == 'Sospechoso') &&
        _obra.textoClase == 'Seleccione una Conexión...') {
      isValid = false;
      _conexionShowError = true;
      _conexionError = 'Debe elegir una Conexión';

      setState(() {});
      return isValid;
    } else {
      _conexionShowError = false;
    }

    if (_obra.textoClase != 'Seleccione una Conexión...' &&
        _obra.textoClase != 'Sin Datos' &&
        _obra.textoTipo == 'Seleccione un Lugar...') {
      isValid = false;
      _lugarShowError = true;
      _lugarError = 'Debe elegir un Lugar';

      setState(() {});
      return isValid;
    } else {
      _lugarShowError = false;
    }

    if (_obra.textoComponente == 'Seleccione un Material...') {
      isValid = false;
      _materialCanioShowError = true;
      _materialCanioError = 'Debe elegir un Material';

      setState(() {});
      return isValid;
    } else {
      _materialCanioShowError = false;
    }

    if (_obra.codigoDiametro == 'Seleccione un Diámetro de Caño...') {
      isValid = false;
      _diametroCanioShowError = true;
      _diametroCanioError = 'Debe elegir un Diámetro de Caño';

      setState(() {});
      return isValid;
    } else {
      _diametroCanioShowError = false;
    }

    if (_obra.motivo == 'Seleccione un Tipo de Fuga...') {
      isValid = false;
      _fugaShowError = true;
      _fugaError = 'Debe elegir un Tipo de Fuga';

      setState(() {});
      return isValid;
    } else {
      _fugaShowError = false;
    }

    if (_obra.planos!.isNotEmpty && _obra.planos!.length > 200) {
      isValid = false;
      _comentariosShowError = true;
      _comentariosError =
          'La cantidad máxima de caracteres es de 200. Ha puesto ${_obra.planos!.length}';
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
      showMyDialog(
        'Error',
        'Verifica que estés conectado a Internet',
        'Aceptar',
      );
    }

    Map<String, dynamic> request = {
      'NroObra': widget.obra.nroObra,
      'POSX': _obra.posx,
      'POSY': _obra.posy,
      'Direccion': _obra.direccion,
      'TextoLocalizacion': _obra.textoLocalizacion,
      'TextoClase': _obra.textoClase,
      'TextoTipo': _obra.textoTipo,
      'TextoComponente': _obra.textoComponente,
      'CodigoDiametro': _obra.codigoDiametro,
      'Motivo': _obra.motivo,
      'Planos': _obra.planos,
    };

    Response response = await ApiHelper.put(
      '/api/Obras/PutDatosObra/',
      widget.obra.nroObra.toString(),
      request,
    );

    if (response.isSuccess) {
      _showSnackbar('Datos de Obra grabados con éxito');
    }

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

  //-----------------------------------------------------------------
  //--------------------- _loadData --------------------------------
  //-----------------------------------------------------------------

  void _loadData() async {
    _getMotivos();
    _getConexiones();
    _getLugares();
    _getMaterialesCanio();
    _getFugas();
    await _getDiametrosCanio();
  }

  //-------------------------------------------------------------
  //-------------------- _showSnackbar --------------------------
  //-------------------------------------------------------------

  void _showSnackbar(String text) {
    SnackBar snackbar = SnackBar(
      content: Text(text),
      backgroundColor: Colors.lightGreen,
      //duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    //ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
