import 'dart:convert';
import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:rowing_app/components/loader_component.dart';
import 'package:rowing_app/helpers/helpers.dart';
import 'package:rowing_app/models/causante.dart';
import 'package:rowing_app/models/response.dart';
import 'package:rowing_app/models/tipo_novedad.dart';
import 'package:rowing_app/models/user.dart';
import 'package:rowing_app/screens/novedades/take_picturea.dart';
import 'package:rowing_app/screens/novedades/take_pictureb.dart';

class NovedadAgregarScreen extends StatefulWidget {
  final User user;
  final Causante causante;
  const NovedadAgregarScreen(
      {Key? key, required this.user, required this.causante})
      : super(key: key);

  @override
  _NovedadAgregarScreenState createState() => _NovedadAgregarScreenState();
}

class _NovedadAgregarScreenState extends State<NovedadAgregarScreen> {
//---------------------------------------------------------------
//----------------------- Variables -----------------------------
//---------------------------------------------------------------

  bool _showLoader = false;
  bool bandera = false;
  int intentos = 0;
  bool _photoChanged1 = false;
  bool _photoChanged2 = false;
  DateTime? fechaInicio;
  DateTime? fechaFin;
  //DateTime? fechaNovedad = null;

  List<TipoNovedad> _tiposnovedades = [];

  late XFile _image1;
  late XFile _image2;

  String _observaciones = '';
  final String _observacionesError = '';
  final bool _observacionesShowError = false;
  final TextEditingController _observacionesController =
      TextEditingController();

  String _tiponovedad = 'Elija una novedad...';
  String _tiponovedadError = '';
  bool _tiponovedadShowError = false;

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Agregar Nueva Novedad'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                _showNovedades(),
                _showFechas(),
                _showObservaciones(),
                const SizedBox(
                  height: 5,
                ),
                _showPhotos(),
                const SizedBox(
                  height: 25,
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
//--------------------- _showPhotos -------------------------------
//-----------------------------------------------------------------

  Widget _showPhotos() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        //----------------- FOTO 1 -----------------------------
        InkWell(
          child: Stack(children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: !_photoChanged1
                  ? const Image(
                      image: AssetImage('assets/noimage.png'),
                      width: 160,
                      height: 160,
                      fit: BoxFit.cover)
                  : Image.file(
                      File(_image1.path),
                      width: 160,
                      fit: BoxFit.contain,
                    ),
            ),
            Positioned(
                bottom: 0,
                left: 100,
                child: InkWell(
                  onTap: () => _takePicture1(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      color: Colors.green[50],
                      height: 60,
                      width: 60,
                      child: const Icon(
                        Icons.photo_camera,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                )),
            Positioned(
                bottom: 0,
                left: 0,
                child: InkWell(
                  onTap: () => _selectPicture1(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      color: Colors.green[50],
                      height: 60,
                      width: 60,
                      child: const Icon(
                        Icons.image,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                )),
          ]),
        ),
        //----------------- FOTO 2 -----------------------------
        InkWell(
          child: Stack(children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: !_photoChanged2
                  ? const Image(
                      image: AssetImage('assets/noimage.png'),
                      height: 160,
                      fit: BoxFit.contain)
                  : Image.file(
                      File(_image2.path),
                      width: 160,
                      fit: BoxFit.contain,
                    ),
            ),
            Positioned(
                bottom: 0,
                left: 100,
                child: InkWell(
                  onTap: () => _takePicture2(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      color: Colors.green[50],
                      height: 60,
                      width: 60,
                      child: const Icon(
                        Icons.photo_camera,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                )),
            Positioned(
                bottom: 0,
                left: 0,
                child: InkWell(
                  onTap: () => _selectPicture2(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      color: Colors.green[50],
                      height: 60,
                      width: 60,
                      child: const Icon(
                        Icons.image,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                )),
          ]),
        ),
      ],
    );
  }

//-----------------------------------------------------------------
//--------------------- _showNovedades ----------------------------
//-----------------------------------------------------------------

  Widget _showNovedades() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: _tiposnovedades.isEmpty
          ? const Text('Cargando novedades...')
          : DropdownButtonFormField(
              value: _tiponovedad,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Elija una novedad...',
                labelText: 'Novedad',
                errorText: _tiponovedadShowError ? _tiponovedadError : null,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              items: _getComboNovedades(),
              onChanged: (value) {
                _tiponovedad = value.toString();
              },
            ),
    );
  }

//-----------------------------------------------------------------
//--------------------- _getComboNovedades ------------------------
//-----------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboNovedades() {
    List<DropdownMenuItem<String>> list = [];
    list.add(const DropdownMenuItem(
      child: Text('Elija una novedad...'),
      value: 'Elija una novedad...',
    ));

    for (var novedad in _tiposnovedades) {
      list.add(DropdownMenuItem(
        child: Text(novedad.tipodenovedad),
        value: novedad.tipodenovedad,
      ));
    }

    return list;
  }

//-----------------------------------------------------------------
//--------------------- _showFechas -------------------------------
//-----------------------------------------------------------------

  Widget _showFechas() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: const [
                    // Container(
                    //   alignment: Alignment.centerLeft,
                    //   color: Color(0xFF781f1e),
                    //   width: 140,
                    //   height: 30,
                    //   child: Text(
                    //     '  Fecha Novedad:',
                    //     style: TextStyle(
                    //         fontWeight: FontWeight.bold, color: Colors.white),
                    //   ),
                    // ),
                    // Expanded(
                    //   flex: 3,
                    //   child: Container(
                    //     alignment: Alignment.center,
                    //     color: Color(0xFF781f1e).withOpacity(0.2),
                    //     width: 140,
                    //     height: 30,
                    //     child: Text(
                    //       fechaNovedad != null
                    //           ? "    ${fechaNovedad!.day}/${fechaNovedad!.month}/${fechaNovedad!.year}"
                    //           : "",
                    //       style: TextStyle(color: Color(0xFF781f1e)),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    // Expanded(
                    //   flex: 1,
                    //   child: ElevatedButton(
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Icon(Icons.calendar_month),
                    //       ],
                    //     ),
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Color(0xFF781f1e),
                    //       minimumSize: Size(double.infinity, 50),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(5),
                    //       ),
                    //     ),
                    //     onPressed: () => _fechaNovedad(),
                    //   ),
                    // ),
                  ],
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
                      color: const Color(0xFF781f1e),
                      width: 140,
                      height: 30,
                      child: const Text(
                        '  Fecha Inicio:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.center,
                        color: const Color(0xFF781f1e).withOpacity(0.2),
                        width: 140,
                        height: 30,
                        child: Text(
                          fechaInicio != null
                              ? "    ${fechaInicio!.day}/${fechaInicio!.month}/${fechaInicio!.year}"
                              : "",
                          style: const TextStyle(color: Color(0xFF781f1e)),
                        ),
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
                            Icon(Icons.calendar_month),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF781f1e),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () => _fechaInicio(),
                      ),
                    ),
                  ],
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
                      color: const Color(0xFF781f1e),
                      width: 140,
                      height: 30,
                      child: const Text(
                        '  Fecha Fin:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.center,
                        color: const Color(0xFF781f1e).withOpacity(0.2),
                        width: 140,
                        height: 30,
                        child: Text(
                          fechaFin != null
                              ? "    ${fechaFin!.day}/${fechaFin!.month}/${fechaFin!.year}"
                              : "",
                          style: const TextStyle(color: Color(0xFF781f1e)),
                        ),
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
                            Icon(Icons.calendar_month),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF781f1e),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () => _fechaFin(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- _showObservaciones ------------------------
//-----------------------------------------------------------------

  Widget _showObservaciones() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _observacionesController,
        maxLines: 3,
        decoration: InputDecoration(
            hintText: 'Ingresa Observaciones...',
            labelText: 'Observaciones',
            errorText: _observacionesShowError ? _observacionesError : null,
            suffixIcon: const Icon(Icons.notes),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _observaciones = value;
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.save),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Guardar novedad'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF781f1e),
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

    if (_tiponovedad == 'Elija una novedad...') {
      isValid = false;
      _tiponovedadShowError = true;
      _tiponovedadError = 'Debe elegir una Novedad';

      setState(() {});
      return isValid;
    } else {
      _tiponovedadShowError = false;
    }

    if (fechaInicio == null) {
      isValid = false;
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: const Text('Aviso!'),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Text('Debe ingresar una Fecha Inicio.'),
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
      setState(() {});
      return isValid;
    }

    if (fechaFin == null) {
      isValid = false;
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: const Text('Aviso!'),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Text('Debe ingresar una Fecha Fin.'),
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
      setState(() {});
      return isValid;
    }

    if (fechaFin != null &&
        fechaInicio != null &&
        fechaFin!.isBefore(fechaInicio!)) {
      isValid = false;
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: const Text('Aviso!'),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Text('La Fecha Fin no puede ser menor a la Fecha Incicio'),
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
      setState(() {});
      return isValid;
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
          'Error', "Verifica que estés conectado a Internet", 'Aceptar');
    }

    String base64image1 = '';
    String base64image2 = '';
    if (_photoChanged1) {
      List<int> imageBytes1 = await _image1.readAsBytes();
      base64image1 = base64Encode(imageBytes1);
    }

    if (_photoChanged2) {
      List<int> imageBytes2 = await _image2.readAsBytes();
      base64image2 = base64Encode(imageBytes2);
    }

    String ahora = DateTime.now().toString();

    Map<String, dynamic> request = {
      //'nroregistro': _ticket.nroregistro,
      'grupo': widget.causante.grupo,
      'causante': widget.causante.codigo,
      'fechacarga': ahora,
      'fechanovedad': ahora,
      'empresa': 'Rowing',
      'fechainicio': fechaInicio.toString(),
      'fechafin': fechaFin.toString(),
      'tiponovedad': _tiponovedad,
      'observaciones': _observaciones,
      'vistaRRHH': 0,
      'idusuario': widget.user.idUsuario,
      'linkadjunto1': '',
      'linkadjunto2': '',
      'imagearray1': base64image1,
      'imagearray2': base64image2,
      'fec': base64image2,
      'fechaEstado': '',
      'observacionEstado': '',
      'confirmaLeido': null,
      'iIDUsrEstado': null,
      'estado': 'Pendiente',
    };

    Response response = await ApiHelper.postNoToken(
        '/api/CausantesNovedades/PostNovedades', request);

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

//-----------------------------------------------------------------
//--------------------- _loadData ---------------------------------
//-----------------------------------------------------------------

  void _loadData() async {
    await _getTiposNovedades();
  }

//-----------------------------------------------------------------
//--------------------- _getTiposNovedades ------------------------
//-----------------------------------------------------------------

  Future<void> _getTiposNovedades() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      showMyDialog(
          'Error', "Verifica que estés conectado a Internet", 'Aceptar');
    }

    bandera = false;
    intentos = 0;

    do {
      Response response = Response(isSuccess: false);
      response = await ApiHelper.getTipoNovedades();
      intentos++;
      if (response.isSuccess) {
        bandera = true;
        _tiposnovedades = response.result;
      }
    } while (bandera == false);
    setState(() {});
  }

//-----------------------------------------------------------------
//--------------------- _fechaInicio ------------------------------
//-----------------------------------------------------------------

  _fechaInicio() async {
    FocusScope.of(context).unfocus();
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 2),
    );
    if (selected != null && selected != fechaInicio) {
      setState(() {
        fechaInicio = selected;
      });
    }
  }

//-----------------------------------------------------------------
//--------------------- _fechaFin ---------------------------------
//-----------------------------------------------------------------

  _fechaFin() async {
    FocusScope.of(context).unfocus();
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 2),
    );
    if (selected != null && selected != fechaFin) {
      setState(() {
        fechaFin = selected;
      });
    }
  }

//-----------------------------------------------------------------
//--------------------- _takePicture1 -----------------------------
//-----------------------------------------------------------------

  void _takePicture1() async {
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
        ]);
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
              builder: (context) => TakePictureaScreen(
                    camera: firstCamera,
                  )));
      if (response != null) {
        setState(() {
          _photoChanged1 = true;
          _image1 = response.result;
        });
      }
    }
  }

//-----------------------------------------------------------------
//--------------------- _takePicture2 -----------------------------
//-----------------------------------------------------------------

  void _takePicture2() async {
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
        ]);
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
              builder: (context) => TakePicturebScreen(
                    camera: firstCamera,
                  )));
      if (response != null) {
        setState(() {
          _photoChanged2 = true;
          _image2 = response.result;
        });
      }
    }
  }

//-----------------------------------------------------------------
//--------------------- _selectPicture1 ---------------------------
//-----------------------------------------------------------------

  void _selectPicture1() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image1 = await _picker.pickImage(source: ImageSource.gallery);
    if (image1 != null) {
      setState(() {
        _photoChanged1 = true;
        _image1 = image1;
      });
    }
  }

//-----------------------------------------------------------------
//--------------------- _selectPicture2 ---------------------------
//-----------------------------------------------------------------

  void _selectPicture2() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image2 = await _picker.pickImage(source: ImageSource.gallery);
    if (image2 != null) {
      setState(() {
        _photoChanged2 = true;
        _image2 = image2;
      });
    }
  }
}
