import 'dart:convert';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:camera/camera.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../helpers/resize_image.dart';
import '../../models/models.dart';
import '../screens.dart';

class VeredaAgregarScreen extends StatefulWidget {
  final User user;
  final Obra obra;

  const VeredaAgregarScreen({
    super.key,
    required this.user,
    required this.obra,
  });

  @override
  State<VeredaAgregarScreen> createState() => _VeredaAgregarScreenState();
}

class _VeredaAgregarScreenState extends State<VeredaAgregarScreen> {
  //---------------------------------------------------------------
  //----------------------- Variables -----------------------------
  //---------------------------------------------------------------

  String _observaciones = '';
  final String _observacionesError = '';
  final bool _observacionesShowError = false;
  final TextEditingController _observacionesController =
      TextEditingController();

  int _clase = 0;
  String _claseError = '';
  bool _claseShowError = false;

  List<StandardReparo> _clases = [];

  bool _showLoader = false;
  int _nroReg = 0;

  Position _positionUser = Position(
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

  bool _habilitaPosicion = false;

  String _direccion = '';
  String _direccionError = '';
  bool _direccionShowError = false;
  final TextEditingController _direccionController = TextEditingController();

  String _numero = '';
  String _numeroError = '';
  bool _numeroShowError = false;
  final TextEditingController _numeroController = TextEditingController();

  String _cantidadMTL = '';
  String _cantidadMTLError = '';
  bool _cantidadMTLShowError = false;
  final TextEditingController _cantidadMTLController = TextEditingController();

  String _ancho = '';
  String _anchoError = '';
  bool _anchoShowError = false;
  final TextEditingController _anchoController = TextEditingController();

  String _profundidad = '';
  String _profundidadError = '';
  bool _profundidadShowError = false;
  final TextEditingController _profundidadController = TextEditingController();

  LatLng _center = const LatLng(0, 0);
  double latitud = 0;
  double longitud = 0;
  String street = '';
  String administrativeArea = '';
  String country = '';
  String isoCountryCode = '';
  String locality = '';
  String subAdministrativeArea = '';
  String subLocality = '';

  List<DropdownMenuItem<String>> _itemsTipoVereda = [];
  String _tipoVereda = 'Seleccione Tipo de Vereda...';
  String _optionTipoVereda = 'Seleccione Tipo de Vereda...';
  String _tipoVeredaError = '';
  bool _tipoVeredaShowError = false;
  List<Option2> _listoptionsTipoVereda = [];

  bool _photoChanged = false;
  late XFile _image;

  //---------------------------------------------------------------
  //----------------------- initState -----------------------------
  //---------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _loadPositionUser();
    _getlistOptionsTipoVereda();
    _loadData();
  }

  void _loadPositionUser() async {
    _positionUser = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _center = LatLng(_positionUser.latitude, _positionUser.longitude);
  }

  //---------------------------------------------------------------
  //----------------------- Pantalla ------------------------------
  //---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    double ancho = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Vereda'), centerTitle: true),
      backgroundColor: const Color(0xff8c8c94),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                _showAddress(),
                _showZanja(),
                _showTipoVereda(),
                _showClase(),
                _showFotos(ancho),
                _showObservaciones(),
                _showButtons(),
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

  //----------------------------------------------------------------------
  //------------------------------ _showAddress --------------------------
  //----------------------------------------------------------------------

  Widget _showAddress() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _direccionController,
                  keyboardType: TextInputType.streetAddress,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Ingrese dirección...',
                    labelText: 'Dirección',
                    errorText: _direccionShowError ? _direccionError : null,
                    suffixIcon: const Icon(Icons.home),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    _direccion = value;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _numeroController,
                  keyboardType: TextInputType.streetAddress,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Ingrese N°...',
                    labelText: 'N°',
                    errorText: _numeroShowError ? _numeroError : null,
                    suffixIcon: const Icon(Icons.home),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    _numero = value;
                  },
                ),
              ),
              const SizedBox(width: 10),
              CircleAvatar(
                backgroundColor: const Color(0xFF781f1e),
                child: Center(
                  child: IconButton(
                    onPressed: () {
                      _address();
                    },
                    color: Colors.white,
                    icon: const Icon(Icons.location_on, size: 20),
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text('Latitud: $latitud'),
              const SizedBox(width: 10),
              Text('Longitud: $longitud'),
            ],
          ),
        ],
      ),
    );
  }

  //--------------------------------------------------------------------
  //------------------------------ _showTipoVereda ---------------------
  //--------------------------------------------------------------------

  Widget _showTipoVereda() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Row(
        children: [
          const SizedBox(width: 70, child: Text('Tipo de Vereda:  ')),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: DropdownButtonFormField(
                items: _itemsTipoVereda,
                initialValue: _optionTipoVereda,
                onChanged: (option2) {
                  setState(() {
                    _optionTipoVereda = option2.toString();
                    _tipoVereda = option2.toString();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Seleccione Tipo de Vereda...',
                  labelText: '',
                  fillColor: Colors.white,
                  filled: true,
                  errorText: _tipoVeredaShowError ? _tipoVeredaError : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //----------------------------------------------------------------
  //------------------------------ _showClase ----------------------
  //----------------------------------------------------------------

  Widget _showClase() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Row(
        children: [
          const SizedBox(width: 70, child: Text('Clase de Vereda: ')),
          Expanded(
            child: _clases.isEmpty
                ? Row(
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(width: 10),
                      Text('Cargando Clases de Vereda...'),
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.all(10),
                    child: DropdownButtonFormField(
                      items: _getComboClasesVereda(),
                      initialValue: _clase,
                      onChanged: (value) {
                        setState(() {
                          _clase = value as int;
                        });
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Elija una Clase de Vereda...',
                        labelText: 'Clase de Vereda',
                        errorText: _claseShowError ? _claseError : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  //---------------------------------------------------------------
  //----------------------- _getComboClasesVereda -----------------
  //---------------------------------------------------------------

  List<DropdownMenuItem<int>> _getComboClasesVereda() {
    List<DropdownMenuItem<int>> list = [];
    list.add(
      const DropdownMenuItem(
        value: 0,
        child: Text('Elija una Clase de Vereda...'),
      ),
    );

    for (var clase in _clases) {
      list.add(
        DropdownMenuItem(
          value: clase.codigostd,
          child: Text(clase.descripciontarea.toString()),
        ),
      );
    }

    return list;
  }

  //--------------------------------------------------------------
  //------------------------------ _showZanja --------------------
  //--------------------------------------------------------------

  Widget _showZanja() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _cantidadMTLController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Mts',
                    labelText: 'Mt. lineales',
                    errorText: _cantidadMTLShowError ? _cantidadMTLError : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    _cantidadMTL = value;
                  },
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _anchoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Cm',
                    labelText: 'Ancho en cm',
                    errorText: _anchoShowError ? _anchoError : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    _ancho = value;
                  },
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _profundidadController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Cm',
                    labelText: 'Profund. en cm',
                    errorText: _profundidadShowError ? _profundidadError : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    _profundidad = value;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //--------------------------------------------------------------
  //-------------------------- _showFotos ------------------------
  //--------------------------------------------------------------

  Widget _showFotos(double ancho) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: InkWell(
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: !_photoChanged
                          ? Center(
                              child: Image(
                                image: const AssetImage('assets/noimage.png'),
                                width: ancho * 0.6,
                                height: ancho * 0.6,
                                fit: BoxFit.contain,
                              ),
                            )
                          : Center(
                              child: Image.file(
                                File(_image.path),
                                width: ancho * 0.6,
                                height: ancho * 0.6,
                                fit: BoxFit.contain,
                              ),
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: ancho * 0.8,
                      child: InkWell(
                        onTap: () => _takePicture(3),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            color: const Color(0xFF781f1e),
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.photo_camera,
                              size: 30,
                              color: Color(0xFFf6faf8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: ancho * 0.1,
                      child: InkWell(
                        onTap: () => _selectPicture(3),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            color: const Color(0xFF781f1e),
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.image,
                              size: 30,
                              color: Color(0xFFf6faf8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  //----------------------------------------------------------------------------
  //------------------------------ _showObservaciones --------------------------
  //----------------------------------------------------------------------------

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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _observaciones = value;
        },
      ),
    );
  }

  //------------------------------------------------------------------
  //------------------------------ _address --------------------------
  //------------------------------------------------------------------

  void _address() async {
    setState(() {
      _showLoader = true;
    });
    await _getPosition();

    if (_center.latitude == 0 || _center.longitude == 0) {
      _direccionController.text = '';
      _numeroController.text = '';
      return;
    }

    if (_habilitaPosicion) {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _center.latitude,
        _center.longitude,
      );
      latitud = _center.latitude;
      longitud = _center.longitude;
      _direccionController.text = placemarks[0].thoroughfare.toString();
      _numeroController.text = placemarks[0].name.toString();
      setState(() {
        _showLoader = false;
      });
    }
  }

  //------------------------------------------------------------------
  //------------------------------ _getPosition ----------------------
  //------------------------------------------------------------------

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

    _habilitaPosicion = true;
    _positionUser = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  //--------------------------------------------------------------
  //-------------------------- _getlistOptionsTipoVereda ---------
  //--------------------------------------------------------------

  void _getlistOptionsTipoVereda() {
    _itemsTipoVereda = [];
    _listoptionsTipoVereda = [];

    Option2 opt1 = Option2(id: 'NoAplica', description: 'NoAplica');
    Option2 opt2 = Option2(id: 'Normal', description: 'Normal');
    Option2 opt3 = Option2(id: 'Especial', description: 'Especial');
    Option2 opt4 = Option2(id: 'Histórica)', description: 'Histórica');
    _listoptionsTipoVereda.add(opt1);
    _listoptionsTipoVereda.add(opt2);
    _listoptionsTipoVereda.add(opt3);
    _listoptionsTipoVereda.add(opt4);

    _getComboTipoVereda();
  }

  //--------------------------------------------------------------
  //----------------------- _getComboTipoVereda ------------------
  //--------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboTipoVereda() {
    _itemsTipoVereda = [];

    List<DropdownMenuItem<String>> list = [];
    list.add(
      const DropdownMenuItem(
        value: 'Seleccione Tipo de Vereda...',
        child: Text('Seleccione Tipo de Vereda...'),
      ),
    );

    for (var _listoption in _listoptionsTipoVereda) {
      list.add(
        DropdownMenuItem(
          value: _listoption.id,
          child: Text(_listoption.description),
        ),
      );
    }

    _itemsTipoVereda = list;

    return list;
  }

  //--------------------------------------------------------------
  //-------------------------- _takePicture ----------------------
  //--------------------------------------------------------------

  void _takePicture(int opcion) async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    var firstCamera = cameras.first;
    var response1 = await showAlertDialog(
      context: context,
      title: 'Seleccionar cámara',
      message: '¿Qué cámara desea utilizar?',
      actions: <AlertDialogAction>[
        const AlertDialogAction(key: 'no', label: 'Trasera'),
        const AlertDialogAction(key: 'yes', label: 'Delantera'),
        const AlertDialogAction(key: 'cancel', label: 'Cancelar'),
      ],
    );
    if (response1 == 'yes') {
      firstCamera = cameras.first;
    }
    if (response1 == 'no') {
      firstCamera = cameras.last;
    }

    if (response1 != 'cancel') {
      Response? response = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SacarFotoScreen(camera: firstCamera),
        ),
      );
      if (response != null) {
        _photoChanged = true;
        _image = response.result;

        setState(() {});
      }
    }
  }

  //--------------------------------------------------------------
  //-------------------------- _selectPicture --------------------
  //--------------------------------------------------------------

  void _selectPicture(int opcion) async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      _photoChanged = true;
      _image = image;

      setState(() {});
    }
  }

  //--------------------------------------------------------------
  //-------------------------- _showButtons ----------------------
  //--------------------------------------------------------------

  Widget _showButtons() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF120E43),
                minimumSize: const Size(100, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: _save,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.save),
                  SizedBox(width: 15),
                  Text('Guardar'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //-----------------------------------------------------------
  //-------------------------- _save --------------------------
  //-----------------------------------------------------------

  void _save() {
    if (!validateFields()) {
      setState(() {});
      return;
    }
    _addRecord();
  }

  //-----------------------------------------------------------
  //-------------------------- validateFields -----------------
  //-----------------------------------------------------------

  bool validateFields() {
    bool isValid = true;

    if (_direccionController.text == '') {
      isValid = false;
      _direccionShowError = true;
      _direccionError = 'Debe ingresar la Dirección';
    } else {
      _direccionShowError = false;
    }

    if (_numeroController.text == '') {
      isValid = false;
      _numeroShowError = true;
      _numeroError = 'Debe ingresar el N°';
    } else {
      _numeroShowError = false;
    }

    if (latitud == 0 || longitud == 0) {
      isValid = false;
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
                Text('Debe haber Geolocalización (Latitud y Longitud)'),
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
    }

    if (_cantidadMTL == '') {
      isValid = false;
      _cantidadMTLShowError = true;
      _cantidadMTLError = 'Debe ingresar los MT lineales';
    } else {
      _cantidadMTLShowError = false;
    }

    if (_ancho == '') {
      isValid = false;
      _anchoShowError = true;
      _anchoError = 'Debe ingresar el Ancho';
    } else {
      _anchoShowError = false;
    }

    if (_profundidad == '') {
      isValid = false;
      _profundidadShowError = true;
      _profundidadError = 'Debe ingresar la Profundidad';
    } else {
      _profundidadShowError = false;
    }

    if (_tipoVereda == 'Seleccione Tipo de Vereda...') {
      isValid = false;
      _tipoVeredaShowError = true;
      _tipoVeredaError = 'Debe elegir un Tipo de Vereda';
    } else {
      _tipoVeredaShowError = false;
    }

    if (_clase == 0) {
      isValid = false;
      _claseShowError = true;
      _claseError = 'Debe elegir una Clase de Vereda';
    } else {
      _claseShowError = false;
    }

    if (!_photoChanged) {
      isValid = false;
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
                Text('Debe cargar una foto'),
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
    }

    setState(() {});

    return isValid;
  }

  //-----------------------------------------------------------
  //-------------------------- _addRecord ---------------------
  //-----------------------------------------------------------

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

    String base64Image = '';

    if (_photoChanged) {
      Uint8List imageBytes = await _image.readAsBytes();
      int maxWidth = 800; // Ancho máximo
      int maxHeight = 600; // Alto máximo
      Uint8List resizedBytes = await resizeImage(
        imageBytes,
        maxWidth,
        maxHeight,
      );
      base64Image = base64Encode(resizedBytes);
    }

    Response response2 = await ApiHelper.getNroRegistroMax2();
    if (response2.isSuccess) {
      _nroReg = int.parse(response2.result.toString()) + 1;
    }

    Map<String, dynamic> request = {
      'nroregistro': _nroReg,
      'nroobra': widget.obra.nroObra,
      'direccion': _direccionController.text,
      'altura': _numeroController.text,
      'latitud': latitud.toString(),
      'longitud': longitud.toString(),
      'idusuario': widget.user.idUsuario,
      'observaciones': _observaciones,
      'tipovereda': _tipoVereda,
      'cantidadmtl': _cantidadMTL,
      'ancho': _ancho,
      'profundidad': _profundidad,
      'fechacierreelectrico': widget.obra.fechaCierreElectrico?.substring(
        0,
        10,
      ),
      'imagearray': base64Image,
      'codtipostdrparo': _clase,
      'ancho2': 0,
      'largo2': 0,
      'modulo': widget.obra.modulo,
    };

    Response response = await ApiHelper.postNoToken(
      '/api/ObrasReparos/PostObrasReparos',
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

  //-----------------------------------------------------------
  //-------------------------- _loadData ----------------------
  //-----------------------------------------------------------

  void _loadData() async {
    await _getClases();
  }

  //-----------------------------------------------------------
  //-------------------------- _getClases ---------------------
  //-----------------------------------------------------------

  Future<void> _getClases() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      showMyDialog(
        'Error',
        'Verifica que estés conectado a Internet',
        'Aceptar',
      );
    }

    Response response = Response(isSuccess: false);
    response = await ApiHelper.getStandardReparos();

    if (response.isSuccess) {
      _clases = response.result;
    }

    setState(() {});
  }
}
