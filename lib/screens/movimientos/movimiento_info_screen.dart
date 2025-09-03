import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:camera/camera.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../helpers/resize_image.dart';
import '../../models/models.dart';
import '../screens.dart';

class MovimientoInfoScreen extends StatefulWidget {
  final User user;
  final Movimiento movimiento;
  const MovimientoInfoScreen({
    super.key,
    required this.user,
    required this.movimiento,
  });

  @override
  State<MovimientoInfoScreen> createState() => _MovimientoInfoScreenState();
}

class _MovimientoInfoScreenState extends State<MovimientoInfoScreen> {
  //---------------------------------------------------------------
  //----------------------- Variables -----------------------------
  //---------------------------------------------------------------

  Movimiento _movimiento = Movimiento(
    nroMovimiento: 0,
    fechaCarga: '',
    codigoConcepto: '',
    codigoGrupo: '',
    codigoCausante: '',
    codigoGrupoRec: '',
    codigoCausanteRec: '',
    nroRemitoR: 0,
    docSAP: '',
    nroLote: 0,
    usrAlta: 0,
    linkRemito: '',
    imageFullPath: '',
  );

  final bool _showLoader = false;

  bool _photoChanged = false;
  late Photo _photo;
  late XFile _image;

  //---------------------------------------------------------------
  //----------------------- initState -----------------------------
  //---------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _movimiento = widget.movimiento;
  }

  //---------------------------------------------------------------
  //----------------------- Pantalla -----------------------------
  //---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    double ancho = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: Text('Movimiento ${_movimiento.nroMovimiento.toString()}'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _getInfoMovimiento(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      _movimiento.linkRemito != null
                          ? Center(
                              child: FadeInImage(
                                width: ancho * 0.9,
                                placeholder: const AssetImage(
                                  'assets/loading.gif',
                                ),
                                image: NetworkImage(_movimiento.imageFullPath!),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              _showImageButtons(),
              const SizedBox(height: 5),
            ],
          ),
          _showLoader
              ? const LoaderComponent(text: 'Por favor espere...')
              : Container(),
        ],
      ),
    );
  }

  //-----------------------------------------------------------------------
  //-------------------------- _getInfoMovimiento -------------------------
  //-----------------------------------------------------------------------

  Widget _getInfoMovimiento() {
    return Card(
      color: _movimiento.linkRemito != ''
          ? const Color(0xFFC7C7C8)
          : const Color.fromARGB(255, 240, 202, 151),
      shadowColor: Colors.white,
      elevation: 10,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: InkWell(
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
                                const Text(
                                  'N°: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF781f1e),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    _movimiento.nroMovimiento.toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                const Text(
                                  'Fecha: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF781f1e),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: _movimiento.fechaCarga != null
                                      ? Text(
                                          DateFormat('dd/MM/yyyy').format(
                                            DateTime.parse(
                                              _movimiento.fechaCarga.toString(),
                                            ),
                                          ),
                                          style: const TextStyle(fontSize: 12),
                                        )
                                      : Container(),
                                ),
                                const Text(
                                  'C.Conc.: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF781f1e),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    _movimiento.codigoConcepto.toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Text(
                                  'Grupo Desde: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF781f1e),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    _movimiento.codigoGrupo!,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                const Text(
                                  'Causante Desde: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF781f1e),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    _movimiento.codigoCausante!,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Text(
                                  'Grupo Recibe: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF781f1e),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    _movimiento.codigoGrupoRec!,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                const Text(
                                  'Causante Recibe: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF781f1e),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    _movimiento.codigoCausanteRec!,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Text(
                                  'N° Remito: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF781f1e),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    _movimiento.nroRemitoR.toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                const Text(
                                  'N° Lote: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF781f1e),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    _movimiento.nroLote.toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                const Text(
                                  'Foto: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF781f1e),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: _movimiento.linkRemito != null
                                      ? const Text(
                                          'SI',
                                          style: TextStyle(fontSize: 12),
                                        )
                                      : const Text(
                                          'NO',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
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
  }

  //-----------------------------------------------------------------------
  //-------------------------- _showImageButtons --------------------------
  //-----------------------------------------------------------------------

  Widget _showImageButtons() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF120E43),
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () => _goAddPhoto(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Icon(Icons.add_a_photo),
                      Text('Adic. Foto'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //-----------------------------------------------------------------
  //-------------------------- _goAddPhoto --------------------------
  //-----------------------------------------------------------------

  void _goAddPhoto() async {
    var response = await showAlertDialog(
      context: context,
      title: 'Confirmación',
      message: '¿De donde deseas obtener la imagen?',
      actions: <AlertDialogAction>[
        const AlertDialogAction(key: 'cancel', label: 'Cancelar'),
        const AlertDialogAction(key: 'camera', label: 'Cámara'),
        const AlertDialogAction(key: 'gallery', label: 'Galería'),
      ],
    );

    if (response == 'cancel') {
      return;
    }

    if (response == 'camera') {
      await _takePicture();
    } else {
      await _selectPicture();
    }

    if (_photoChanged) {
      _addPicture();
    }
  }

  //-----------------------------------------------------------------------
  //-------------------------- _takePicture -------------------------------
  //-----------------------------------------------------------------------

  Future _takePicture() async {
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
          builder: (context) => TakePictureMovScreen(camera: firstCamera),
        ),
      );
      if (response != null) {
        setState(() {
          _photoChanged = true;
          _photo = response.result;
          _image = _photo.image;
        });
      }
    }
  }

  //-----------------------------------------------------------------------------
  //------------------------------ _selectPicture -------------------------------
  //-----------------------------------------------------------------------------

  Future<void> _selectPicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image2 = await picker.pickImage(source: ImageSource.gallery);

    if (image2 != null) {
      _photoChanged = true;
      Response? response = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureMovScreen(image: image2),
        ),
      );

      _photoChanged = false;
      if (response != null) {
        setState(() {
          _photoChanged = true;
          _photo = response.result;
          _image = _photo.image;
        });
      }
    }
  }

  //-----------------------------------------------------------------------------
  //------------------------------ _addPicture ----------------------------------
  //-----------------------------------------------------------------------------

  void _addPicture() async {
    setState(() {});

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {});
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Verifica que estes conectado a internet.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    Uint8List imageBytes = await _image.readAsBytes();
    int maxWidth = 800; // Ancho máximo
    int maxHeight = 600; // Alto máximo
    Uint8List resizedBytes = await resizeImage(imageBytes, maxWidth, maxHeight);
    String base64Image = base64Encode(resizedBytes);

    Map<String, dynamic> request = {
      'imagearray': base64Image,
      'NroMovimiento': _movimiento.nroMovimiento,
    };

    Response response = await ApiHelper.postNoToken(
      '/api/Movimientos/PostMovimiento',
      request,
    );

    setState(() {});

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
      _getMovimiento();
    });
  }

  //------------------------------------------------------------------
  //------------------------------ _getMovimiento --------------------
  //------------------------------------------------------------------

  Future<void> _getMovimiento() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {});
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Verifica que estes conectado a internet.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    Response response = await ApiHelper.getMovimiento(
      _movimiento.nroMovimiento.toString(),
    );

    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'N° de Movimiento no válido',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }
    _movimiento = response.result;
    setState(() {});
  }
}
