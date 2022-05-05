import 'dart:convert';
import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:rowing_app/components/loader_component.dart';
import 'package:rowing_app/helpers/api_helper.dart';
import 'package:rowing_app/models/causante.dart';
import 'package:rowing_app/models/response.dart';
import 'package:rowing_app/models/tipo_novedad.dart';
import 'package:rowing_app/models/user.dart';
import 'package:rowing_app/screens/take_pictureA.dart';
import 'package:rowing_app/screens/take_pictureB.dart';

class NovedadAgregarScreen extends StatefulWidget {
  final User user;
  final Causante causante;
  NovedadAgregarScreen({required this.user, required this.causante});

  @override
  _NovedadAgregarScreenState createState() => _NovedadAgregarScreenState();
}

class _NovedadAgregarScreenState extends State<NovedadAgregarScreen> {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

  bool _showLoader = false;
  bool bandera = false;
  int intentos = 0;
  bool _photoChanged1 = false;
  bool _photoChanged2 = false;
  DateTime? fechaInicio = null;
  DateTime? fechaFin = null;
  DateTime? fechaNovedad = null;

  List<TipoNovedad> _tiposnovedades = [];

  late XFile _image1;
  late XFile _image2;

  String _observaciones = '';
  String _observacionesError = '';
  bool _observacionesShowError = false;
  TextEditingController _observacionesController = TextEditingController();

  String _tiponovedad = 'Elija una novedad...';
  String _tiponovedadError = '';
  bool _tiponovedadShowError = false;
  TextEditingController _tiponovedadController = TextEditingController();

//*****************************************************************************
//************************** INIT STATE ***************************************
//*****************************************************************************

  @override
  void initState() {
    super.initState();
    _loadData();
  }

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Agregar Nueva Novedad'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                _showNovedades(),
                _showFechas(),
                _showObservaciones(),
                SizedBox(
                  height: 5,
                ),
                _showPhotos(),
                SizedBox(
                  height: 25,
                ),
                _showButton(),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          _showLoader
              ? LoaderComponent(
                  text: 'Por favor espere...',
                )
              : Container(),
        ],
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWPHOTOS -------------------------
//-----------------------------------------------------------------

  Widget _showPhotos() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        //----------------- FOTO 1 -----------------------------
        InkWell(
          child: Stack(children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10),
              child: !_photoChanged1
                  ? Image(
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
                      child: Icon(
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
                      child: Icon(
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
              margin: EdgeInsets.only(top: 10),
              child: !_photoChanged2
                  ? Image(
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
                      child: Icon(
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
                      child: Icon(
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
//--------------------- METODO SHOWHOWNOVEDADES -------------------
//-----------------------------------------------------------------

  Widget _showNovedades() {
    return Container(
      padding: EdgeInsets.all(10),
      child: _tiposnovedades.length == 0
          ? Text('Cargando novedades...')
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
//--------------------- METODO GETCOMBONOVEDAEDS ------------------
//-----------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboNovedades() {
    List<DropdownMenuItem<String>> list = [];
    list.add(DropdownMenuItem(
      child: Text('Elija una novedad...'),
      value: 'Elija una novedad...',
    ));

    _tiposnovedades.forEach((novedad) {
      list.add(DropdownMenuItem(
        child: Text(novedad.tipodenovedad),
        value: novedad.tipodenovedad,
      ));
    });

    return list;
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWFECHAS -------------------------
//-----------------------------------------------------------------

  Widget _showFechas() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      color: Color(0xFF781f1e),
                      width: 140,
                      height: 30,
                      child: Text(
                        '  Fecha Novedad:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.center,
                        color: Color(0xFF781f1e).withOpacity(0.2),
                        width: 140,
                        height: 30,
                        child: Text(
                          fechaNovedad != null
                              ? "    ${fechaNovedad!.day}/${fechaNovedad!.month}/${fechaNovedad!.year}"
                              : "",
                          style: TextStyle(color: Color(0xFF781f1e)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_month),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF781f1e),
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () => _fechaNovedad(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
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
                      color: Color(0xFF781f1e),
                      width: 140,
                      height: 30,
                      child: Text(
                        '  Fecha Inicio:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.center,
                        color: Color(0xFF781f1e).withOpacity(0.2),
                        width: 140,
                        height: 30,
                        child: Text(
                          fechaInicio != null
                              ? "    ${fechaInicio!.day}/${fechaInicio!.month}/${fechaInicio!.year}"
                              : "",
                          style: TextStyle(color: Color(0xFF781f1e)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_month),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF781f1e),
                          minimumSize: Size(double.infinity, 50),
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
          SizedBox(
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
                      color: Color(0xFF781f1e),
                      width: 140,
                      height: 30,
                      child: Text(
                        '  Fecha Fin:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.center,
                        color: Color(0xFF781f1e).withOpacity(0.2),
                        width: 140,
                        height: 30,
                        child: Text(
                          fechaFin != null
                              ? "    ${fechaFin!.day}/${fechaFin!.month}/${fechaFin!.year}"
                              : "",
                          style: TextStyle(color: Color(0xFF781f1e)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_month),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF781f1e),
                          minimumSize: Size(double.infinity, 50),
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
//--------------------- METODO SHOWOBSERVACIONES ------------------
//-----------------------------------------------------------------

  Widget _showObservaciones() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _observacionesController,
        maxLines: 3,
        decoration: InputDecoration(
            hintText: 'Ingresa Observaciones...',
            labelText: 'Observaciones',
            errorText: _observacionesShowError ? _observacionesError : null,
            suffixIcon: Icon(Icons.notes),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _observaciones = value;
        },
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWBUTTON -------------------------
//-----------------------------------------------------------------

  Widget _showButton() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Guardar novedad'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF781f1e),
                minimumSize: Size(double.infinity, 50),
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

//*****************************************************************************
//************************** METODO SAVE **************************************
//*****************************************************************************

  _save() {
    if (!validateFields()) {
      setState(() {});
      return;
    }
    _addRecord();
  }

//*****************************************************************************
//************************** METODO VALIDATEFIELDS ****************************
//*****************************************************************************

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

    if (fechaNovedad == null) {
      isValid = false;
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text('Aviso!'),
              content:
                  Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text('Debe ingresar una Fecha Novedad.'),
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
      setState(() {});
      return isValid;
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
              title: Text('Aviso!'),
              content:
                  Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text('Debe ingresar una Fecha Inicio.'),
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
              title: Text('Aviso!'),
              content:
                  Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text('Debe ingresar una Fecha Fin.'),
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
              title: Text('Aviso!'),
              content:
                  Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text('La Fecha Fin no puede ser menor a la Fecha Incicio'),
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
      setState(() {});
      return isValid;
    }

    setState(() {});

    return isValid;
  }

//*****************************************************************************
//************************** METODO ADDRECORD *********************************
//*****************************************************************************

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
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
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

    Map<String, dynamic> request = {
      //'nroregistro': _ticket.nroregistro,
      'grupo': widget.causante.grupo,
      'causante': widget.causante.nroCausante,
      'fechacarga': DateTime.now().toString(),
      'fechanovedad': fechaNovedad.toString(),
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
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
    Navigator.pop(context, 'yes');
  }

//*****************************************************************************
//************************** METODO LOADDATA **********************************
//*****************************************************************************

  void _loadData() async {
    await _getTiposNovedades();
  }

//*****************************************************************************
//************************** METODO GETTIPOSNOVEDADES *************************
//*****************************************************************************

  Future<Null> _getTiposNovedades() async {
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
      response = await ApiHelper.getTipoNovedades();
      intentos++;
      if (response.isSuccess) {
        bandera = true;
        _tiposnovedades = response.result;
      }
    } while (bandera == false);
    // await showAlertDialog(
    //     context: context,
    //     title: 'Intentos',
    //     message: intentos.toString(),
    //     actions: <AlertDialogAction>[
    //       AlertDialogAction(key: null, label: 'Aceptar'),
    //     ]);
    setState(() {});
  }

  _fechaNovedad() async {
    FocusScope.of(context).unfocus();
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (selected != null && selected != fechaNovedad)
      setState(() {
        fechaNovedad = selected;
      });
  }

  _fechaInicio() async {
    FocusScope.of(context).unfocus();
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (selected != null && selected != fechaInicio)
      setState(() {
        fechaInicio = selected;
      });
  }

  _fechaFin() async {
    FocusScope.of(context).unfocus();
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (selected != null && selected != fechaFin)
      setState(() {
        fechaFin = selected;
      });
  }

//*****************************************************************************
//************************** METODO TAKEPICTURE1 ******************************
//*****************************************************************************

  void _takePicture1() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    var firstCamera = cameras.first;
    var response1 = await showAlertDialog(
        context: context,
        title: 'Seleccionar cámara',
        message: '¿Qué cámara desea utilizar?',
        actions: <AlertDialogAction>[
          AlertDialogAction(key: 'no', label: 'Trasera'),
          AlertDialogAction(key: 'yes', label: 'Delantera'),
          AlertDialogAction(key: 'cancel', label: 'Cancelar'),
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
              builder: (context) => TakePictureAScreen(
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

//*****************************************************************************
//************************** METODO TAKEPICTURE2 ******************************
//*****************************************************************************

  void _takePicture2() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    var firstCamera = cameras.first;
    var response1 = await showAlertDialog(
        context: context,
        title: 'Seleccionar cámara',
        message: '¿Qué cámara desea utilizar?',
        actions: <AlertDialogAction>[
          AlertDialogAction(key: 'no', label: 'Trasera'),
          AlertDialogAction(key: 'yes', label: 'Delantera'),
          AlertDialogAction(key: 'cancel', label: 'Cancelar'),
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
              builder: (context) => TakePictureBScreen(
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

//*****************************************************************************
//************************** METODO SELECTPICTURE1 ****************************
//*****************************************************************************

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

//*****************************************************************************
//************************** METODO SELECTPICTURE2 ****************************
//*****************************************************************************

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
