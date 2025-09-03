import 'dart:convert';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../helpers/resize_image.dart';
import '../../models/models.dart';
import '../screens.dart';

class VeredaInfoScreen extends StatefulWidget {
  final User user;
  final ObrasReparo obra;
  final Position positionUser;

  const VeredaInfoScreen({
    super.key,
    required this.user,
    required this.obra,
    required this.positionUser,
  });

  @override
  _VeredaInfoScreenState createState() => _VeredaInfoScreenState();
}

class _VeredaInfoScreenState extends State<VeredaInfoScreen> {
  //-------------------------------------------------------------
  //-------------------------- Variables ------------------------
  //-------------------------------------------------------------

  String _largo2 = '';
  String _largo2Error = '';
  bool _largo2ShowError = false;
  final TextEditingController _largo2Controller = TextEditingController();

  String _ancho2 = '';
  String _ancho2Error = '';
  bool _ancho2ShowError = false;
  final TextEditingController _ancho2Controller = TextEditingController();

  final bool _photoChanged = false;
  late XFile _image;

  bool _photoInicioChanged = false;
  late XFile _imageInicio;

  bool _photoFinChanged = false;
  late XFile _imageFin;

  bool _showLoader = false;

  String? _observacionesFotoInicio = '';
  final String _observacionesFotoInicioError = '';
  final bool _observacionesFotoInicioShowError = false;
  final TextEditingController _observacionesFotoInicioController =
      TextEditingController();

  String? _observacionesFotoFin = '';
  final String _observacionesFotoFinError = '';
  final bool _observacionesFotoFinShowError = false;
  final TextEditingController _observacionesFotoFinController =
      TextEditingController();

  DateTime selectedDate = DateTime.now();

  //-------------------------------------------------------------
  //-------------------------- initState ------------------------
  //-------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _loadFieldValues();
    // _getObra();
  }

  //-------------------------------------------------------------
  //-------------------------- Pantalla -------------------------
  //-------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    double ancho = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFC7C7C8),
      appBar: AppBar(title: const Text('Vereda Info'), centerTitle: true),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 5),
                _getInfoVereda(),
                _titulo('FOTO RELEVAMIENTO'),
                _getFoto1(ancho),
                _titulo('FOTO INICIO'),
                _getFotoInicio(ancho),
                _showObservacionesFotoInicio(),
                _showZanja(),
                _titulo('FOTO FIN'),
                _getFotoFin(ancho),
                _showObservacionesFotoFin(),
                const SizedBox(height: 5),
                _showButtons(),
                const SizedBox(height: 5),
              ],
            ),
          ),
          const SizedBox(height: 5),
          _showLoader
              ? const LoaderComponent(text: 'Por favor espere...')
              : Container(),
        ],
      ),
    );
  }

  //-----------------------------------------------------------------
  //----------------- _showObservacionesFotoInicio ------------------
  //-----------------------------------------------------------------

  Widget _showObservacionesFotoInicio() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        controller: _observacionesFotoInicioController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Observaciones Foto Inicio...',
          labelText: 'Observaciones Foto Inicio',
          errorText: _observacionesFotoInicioShowError
              ? _observacionesFotoInicioError
              : null,
          prefixIcon: const Icon(Icons.start),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _observacionesFotoInicio = value;
        },
      ),
    );
  }

  //--------------------------------------------------------------------
  //------------------------------ _showZanja --------------------------
  //--------------------------------------------------------------------

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
                  controller: _largo2Controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Largo',
                    labelText: 'Largo',
                    errorText: _largo2ShowError ? _largo2Error : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    _largo2 = value;
                  },
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _ancho2Controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Cm',
                    labelText: 'Ancho en cm',
                    errorText: _ancho2ShowError ? _ancho2Error : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    _ancho2 = value;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //------------------------------------------------------------------
  //------------------ _showObservacionesFotoFin ---------------------
  //------------------------------------------------------------------

  Widget _showObservacionesFotoFin() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        controller: _observacionesFotoFinController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Observaciones Foto Fin...',
          labelText: 'Observaciones Foto Fin',
          errorText: _observacionesFotoFinShowError
              ? _observacionesFotoFinError
              : null,
          prefixIcon: const Icon(Icons.keyboard_tab),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _observacionesFotoFin = value;
        },
      ),
    );
  }

  //------------------------------------------------------------------
  //-------------------------- _titulo -------------------------------
  //------------------------------------------------------------------

  Container _titulo(String texto) {
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 10, 5, 5),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF781f1e), width: 4),
      ),
      child: Center(
        child: Text(
          texto,
          style: const TextStyle(
            color: Color(0xFF781f1e),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  //---------------------------------------------------------------
  //-------------------------- _getInfoVereda ---------------------
  //---------------------------------------------------------------

  Widget _getInfoVereda() {
    return Card(
      color: const Color(0xFFC7C7C8),
      shadowColor: Colors.white,
      elevation: 10,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Container(
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                width: 110,
                                child: Text(
                                  'N° Obra: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF781f1e),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Text(
                                  widget.obra.nroobra.toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              const Text(
                                'Módulo: ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF781f1e),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  widget.obra.modulo.toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 110,
                                child: Text(
                                  'Dirección: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${widget.obra.direccion!} ${widget.obra.altura}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 110,
                                child: Text(
                                  'Tipo Vereda: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  widget.obra.tipoVereda!,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 1),
                          Row(
                            children: [
                              const SizedBox(
                                width: 110,
                                child: Text(
                                  'Mts. lineales: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  widget.obra.cantidadMTL.toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 1),
                          Row(
                            children: [
                              const SizedBox(
                                width: 110,
                                child: Text(
                                  'Ancho [cm]: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  widget.obra.ancho.toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 1),
                          Row(
                            children: [
                              const SizedBox(
                                width: 110,
                                child: Text(
                                  'Profundidad [cm]: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0e4888),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  widget.obra.profundidad.toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Fecha Cierre Eléctrico: ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF0e4888),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: widget.obra.fechaCierreElectrico != null
                                    ? Text(
                                        DateFormat('dd/MM/yyyy').format(
                                          DateTime.parse(
                                            widget.obra.fechaCierreElectrico
                                                .toString(),
                                          ),
                                        ),
                                        style: const TextStyle(fontSize: 12),
                                      )
                                    : Container(),
                              ),
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
    );
  }

  //--------------------------------------------------------------------
  //-------------------------- _getFoto1 -------------------------------
  //--------------------------------------------------------------------

  Widget _getFoto1(double ancho) {
    return Stack(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: _photoChanged
              ? Image.file(
                  File(_image.path),
                  width: ancho * 0.6,
                  height: ancho * 0.6,
                  fit: BoxFit.contain,
                )
              : CachedNetworkImage(
                  imageUrl: widget.obra.imageFullPath!,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.contain,
                  width: ancho * 0.6,
                  height: ancho * 0.6,
                  placeholder: (context, url) => Image(
                    image: const AssetImage('assets/logo.png'),
                    fit: BoxFit.contain,
                    width: ancho * 0.6,
                    height: ancho * 0.6,
                  ),
                ),
        ),
      ],
    );
  }

  //-----------------------------------------------------------------------
  //-------------------------- _getFotoInicio -----------------------------
  //-----------------------------------------------------------------------

  Widget _getFotoInicio(double ancho) {
    return Stack(
      children: <Widget>[
        Container(width: double.infinity),
        Center(
          child: SizedBox(
            width: ancho * 0.6,
            height: ancho * 0.6,
            child: !_photoInicioChanged
                ? FadeInImage(
                    fit: BoxFit.contain,
                    placeholder: const AssetImage('assets/loading.gif'),
                    image: NetworkImage(widget.obra.fotoInicioFullPath!),
                  )
                : Center(
                    child: Image.file(
                      File(_imageInicio.path),
                      fit: BoxFit.contain,
                    ),
                  ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: ancho * 0.8,
          child: InkWell(
            onTap: () => _takePicture(4),
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
            onTap: () => _selectPicture(4),
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
    );
  }

  //----------------------------------------------------------------------
  //-------------------------- _getFotoFin -------------------------------
  //----------------------------------------------------------------------

  Widget _getFotoFin(double ancho) {
    return Stack(
      children: <Widget>[
        Container(width: double.infinity),
        Center(
          child: SizedBox(
            width: ancho * 0.6,
            height: ancho * 0.6,
            child: !_photoFinChanged
                ? FadeInImage(
                    fit: BoxFit.contain,
                    placeholder: const AssetImage('assets/loading.gif'),
                    image: NetworkImage(widget.obra.fotoFinFullPath!),
                  )
                : Center(
                    child: Image.file(
                      File(_imageFin.path),
                      fit: BoxFit.contain,
                    ),
                  ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: ancho * 0.8,
          child: InkWell(
            onTap: () => _takePicture(5),
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
            onTap: () => _selectPicture(5),
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
    );
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
      if (response != null && opcion == 4) {
        _photoInicioChanged = true;
        _imageInicio = response.result;

        setState(() {});
      }

      if (response != null && opcion == 5) {
        _photoFinChanged = true;
        _imageFin = response.result;

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

    if (image != null && opcion == 4) {
      _photoInicioChanged = true;
      _imageInicio = image;

      setState(() {});
    }

    if (image != null && opcion == 5) {
      _photoFinChanged = true;
      _imageFin = image;

      setState(() {});
    }
  }

  //---------------------------------------------------------
  //----------------------- _showButtons --------------------
  //---------------------------------------------------------

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
              onPressed: () => _save(),
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

  //---------------------------------------------------------
  //----------------------- _save ---------------------------
  //---------------------------------------------------------

  void _save() {
    if (!validateFields()) {
      return;
    }
    _saveRecord();
  }

  //---------------------------------------------------------
  //----------------------- validateFields ------------------
  //---------------------------------------------------------

  bool validateFields() {
    bool isValid = true;

    if (_largo2.isEmpty) {
      isValid = false;
      _largo2ShowError = true;
      _largo2Error = 'Debes ingresar un Largo';
    } else {
      _largo2ShowError = false;
    }

    if (_ancho2.isEmpty) {
      isValid = false;
      _ancho2ShowError = true;
      _ancho2Error = 'Debes ingresar un Ancho';
    } else {
      _ancho2ShowError = false;
    }

    setState(() {});

    return isValid;
  }

  //---------------------------------------------------------
  //--------------------- _saveRecord -----------------------
  //---------------------------------------------------------

  Future<void> _saveRecord() async {
    FocusScope.of(context).unfocus();
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

    String base64ImageInicio = '';

    if (_photoInicioChanged) {
      Uint8List imageInicioBytes = await _imageInicio.readAsBytes();
      int maxWidth = 800; // Ancho máximo
      int maxHeight = 600; // Alto máximo
      Uint8List resizedBytes = await resizeImage(
        imageInicioBytes,
        maxWidth,
        maxHeight,
      );
      base64ImageInicio = base64Encode(resizedBytes);
    }

    String base64ImageFin = '';

    if (_photoFinChanged) {
      Uint8List imageFinBytes = await _imageFin.readAsBytes();
      int maxWidth = 800; // Ancho máximo
      int maxHeight = 600; // Alto máximo
      Uint8List resizedBytes = await resizeImage(
        imageFinBytes,
        maxWidth,
        maxHeight,
      );
      base64ImageFin = base64Encode(resizedBytes);
    }

    Map<String, dynamic> request = {
      'NROREGISTRO': widget.obra.nroregistro,
      'FotoInicioArray': base64ImageInicio,
      'FotoFinArray': base64ImageFin,
      'ObservacionesFotoInicio': _observacionesFotoInicio,
      'ObservacionesFotoFin': _observacionesFotoFin,
      'Largo2': _largo2,
      'Ancho2': _ancho2,
    };

    Response response = await ApiHelper.put(
      '/api/ObrasReparos/',
      widget.obra.nroregistro.toString(),
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
    } else {
      await showAlertDialog(
        context: context,
        title: 'Aviso',
        message: 'Guardado con éxito!',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      Navigator.pop(context, 'yes');
    }
  }

  //---------------------------------------------------------
  //--------------------- _loadFieldValues ------------------
  //---------------------------------------------------------

  void _loadFieldValues() {
    _observacionesFotoInicio = widget.obra.observacionesFotoInicio;
    _observacionesFotoFin = widget.obra.observacionesFotoFin;

    _observacionesFotoInicio ??= '';
    _observacionesFotoFin ??= '';

    _observacionesFotoInicioController.text = _observacionesFotoInicio
        .toString();
    _observacionesFotoFinController.text = _observacionesFotoFin.toString();
  }
}
