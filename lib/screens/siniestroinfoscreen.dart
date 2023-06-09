import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rowing_app/helpers/api_helper.dart';
import 'package:rowing_app/models/models.dart';
import 'package:rowing_app/models/vehiculos_siniestros_foto.dart';
import 'package:rowing_app/screens/screens.dart';

class SiniestroInfoScreen extends StatefulWidget {
  final User user;
  final VehiculosSiniestro siniestro;

  const SiniestroInfoScreen(
      {Key? key, required this.user, required this.siniestro})
      : super(key: key);

  @override
  _SiniestroInfoScreenState createState() => _SiniestroInfoScreenState();
}

class _SiniestroInfoScreenState extends State<SiniestroInfoScreen> {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

  bool _photoChanged = false;
  late XFile _image;

  late PhotoSiniestro _photo;
  int _current = 0;
  final CarouselController _carouselController = CarouselController();

  List<VehiculosSiniestrosFoto> _fotos = [];

  int fotospropiocarnetfrente = 0;
  int fotospropiocarnetdorso = 0;
  int fotospropiocedulafrente = 0;
  int fotospropioceduladorso = 0;
  int fotospropiosiniestrolateralderecho = 0;
  int fotospropiosiniestrolateralizquierdo = 0;
  int fotospropiosiniestrofrente = 0;
  int fotospropiosiniestrotrasero = 0;
  int fotostercerocarnetfrente = 0;
  int fotostercerocarnetdorso = 0;
  int fotostercerocedulafrente = 0;
  int fotosterceroceduladorso = 0;
  int fotostercerosiniestrolateralderecho = 0;
  int fotostercerosiniestrolateralizquierdo = 0;
  int fotostercerosiniestrofrente = 0;
  int fotostercerosiniestrotrasero = 0;
  int fotostercerosegurofrente = 0;
  int fotostercerosegurodorso = 0;

//*****************************************************************************
//************************** INIT STATE ***************************************
//*****************************************************************************
  @override
  void initState() {
    super.initState();
    _getFotosSiniestro();
  }

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: const Text('Siniestro'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _getInfoSiniestro(),
                  _showPhotosCarousel(),
                ],
              ),
            ),
          ),
          _showImageButtons(),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

//-----------------------------------------------------------------------------
//-------------------------- METODO _getInfoSiniestro -------------------------
//-----------------------------------------------------------------------------

  Widget _getInfoSiniestro() {
    return Card(
      color: Colors.white,
      //color: Color(0xFFC7C7C8),
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
                                width: 70,
                                child: Text("Fecha: ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0e4888),
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              SizedBox(
                                width: 100,
                                child: Text(
                                    DateFormat('dd/MM/yyyy').format(
                                        DateTime.parse(widget
                                            .siniestro.fechacarga
                                            .toString())),
                                    style: const TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                              const SizedBox(
                                width: 40,
                                child: Text("Hora: ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0e4888),
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              Expanded(
                                child: Text(
                                    _HoraMinuto(widget.siniestro.horasiniestro),
                                    style: const TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 70,
                                child: Text("Patente: ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0e4888),
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              Expanded(
                                child: Text(widget.siniestro.numcha,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 70,
                                child: Text("Tercero: ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0e4888),
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              Expanded(
                                child:
                                    Text(widget.siniestro.apellidonombretercero,
                                        style: const TextStyle(
                                          fontSize: 12,
                                        )),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 70,
                                child: Text("Dirección: ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0e4888),
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              Expanded(
                                child: Text(
                                    widget.siniestro.direccionsiniestro +
                                        " " +
                                        widget.siniestro.altura,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 70,
                                child: Text("Ciudad: ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0e4888),
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              Expanded(
                                child: Text(widget.siniestro.ciudad,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 70,
                                child: Text("Provincia: ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF0e4888),
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              Expanded(
                                child: Text(widget.siniestro.provincia,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    )),
                              ),
                            ],
                          ),
                          const Divider(
                            height: 2,
                            color: Colors.black,
                          ),
                          const Text("FOTOS",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          Table(
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            //defaultColumnWidth: FixedColumnWidth(100),
                            columnWidths: const {
                              0: FractionColumnWidth(0.5),
                              1: FractionColumnWidth(0.5),
                            },
                            border: TableBorder.all(),
                            children: const [
                              TableRow(children: [
                                Text("PROPIO",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                Text("TERCERO",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ]),
                            ],
                          ),
                          Table(
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            //defaultColumnWidth: FixedColumnWidth(100),
                            columnWidths: const {
                              0: FractionColumnWidth(0.4),
                              1: FractionColumnWidth(0.1),
                              2: FractionColumnWidth(0.4),
                              3: FractionColumnWidth(0.1),
                            },
                            border: TableBorder.all(),
                            children: [
                              TableRow(children: [
                                const Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text("Carnet Frente:",
                                      style: TextStyle(fontSize: 12)),
                                ),
                                Text(fotospropiocarnetfrente.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: fotospropiocarnetfrente == 0
                                            ? Colors.red
                                            : Colors.blue)),
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text("Carnet Frente:",
                                      style: TextStyle(fontSize: 12)),
                                ),
                                Text(fotostercerocarnetfrente.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: fotostercerocarnetfrente == 0
                                            ? Colors.red
                                            : Colors.blue)),
                              ]),
                              TableRow(children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text("Carnet Dorso:",
                                      style: TextStyle(fontSize: 12)),
                                ),
                                Text(fotospropiocarnetdorso.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: fotospropiocarnetdorso == 0
                                            ? Colors.red
                                            : Colors.blue)),
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text("Carnet Dorso:",
                                      style: TextStyle(fontSize: 12)),
                                ),
                                Text(fotostercerocarnetdorso.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: fotostercerocarnetdorso == 0
                                            ? Colors.red
                                            : Colors.blue)),
                              ]),
                              TableRow(children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: const Text("Cédula Frente:",
                                      style: const TextStyle(fontSize: 12)),
                                ),
                                Text(fotospropiocedulafrente.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: fotospropiocedulafrente == 0
                                            ? Colors.red
                                            : Colors.blue)),
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text("Cédula Frente:",
                                      style: TextStyle(fontSize: 12)),
                                ),
                                Text(fotostercerocedulafrente.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: fotostercerocedulafrente == 0
                                            ? Colors.red
                                            : Colors.blue)),
                              ]),
                              TableRow(children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: const Text("Cédula Dorso:",
                                      style: TextStyle(fontSize: 12)),
                                ),
                                Text(fotospropioceduladorso.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: fotospropioceduladorso == 0
                                            ? Colors.red
                                            : Colors.blue)),
                                const Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: const Text("Cédula Dorso:",
                                      style: const TextStyle(fontSize: 12)),
                                ),
                                Text(fotosterceroceduladorso.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: fotosterceroceduladorso == 0
                                            ? Colors.red
                                            : Colors.blue)),
                              ]),
                              TableRow(children: [
                                const Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: const Text("Sin. Lateral Derecho:",
                                      style: TextStyle(fontSize: 12)),
                                ),
                                Text(
                                    fotospropiosiniestrolateralderecho
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            fotospropiosiniestrolateralderecho ==
                                                    0
                                                ? Colors.red
                                                : Colors.blue)),
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text("Sin. Lateral Derecho:",
                                      style: TextStyle(fontSize: 12)),
                                ),
                                Text(
                                    fotostercerosiniestrolateralderecho
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            fotostercerosiniestrolateralderecho ==
                                                    0
                                                ? Colors.red
                                                : Colors.blue)),
                              ]),
                              TableRow(children: [
                                const Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: const Text("Sin. Lateral Izquierdo:",
                                      style: TextStyle(fontSize: 12)),
                                ),
                                Text(
                                    fotospropiosiniestrolateralizquierdo
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            fotospropiosiniestrolateralizquierdo ==
                                                    0
                                                ? Colors.red
                                                : Colors.blue)),
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text("Sin. Lateral Izquierdo:",
                                      style: TextStyle(fontSize: 12)),
                                ),
                                Text(
                                    fotostercerosiniestrolateralizquierdo
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            fotostercerosiniestrolateralizquierdo ==
                                                    0
                                                ? Colors.red
                                                : Colors.blue)),
                              ]),
                              TableRow(children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: const Text("Sin. Frente:",
                                      style: TextStyle(fontSize: 12)),
                                ),
                                Text(fotospropiosiniestrofrente.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: fotospropiosiniestrofrente == 0
                                            ? Colors.red
                                            : Colors.blue)),
                                const Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: const Text("Sin. Frente:",
                                      style: TextStyle(fontSize: 12)),
                                ),
                                Text(fotostercerosiniestrofrente.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: fotostercerosiniestrofrente == 0
                                            ? Colors.red
                                            : Colors.blue)),
                              ]),
                              TableRow(children: [
                                const Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text("Sin. Trasero:",
                                      style: TextStyle(fontSize: 12)),
                                ),
                                Text(fotospropiosiniestrotrasero.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: fotospropiosiniestrotrasero == 0
                                            ? Colors.red
                                            : Colors.blue)),
                                const Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text("Sin. Trasero:",
                                      style: TextStyle(fontSize: 12)),
                                ),
                                Text(fotostercerosiniestrotrasero.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: fotostercerosiniestrotrasero == 0
                                            ? Colors.red
                                            : Colors.blue)),
                              ]),
                              TableRow(children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(""),
                                ),
                                const Text(""),
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text("Seguro Frente:",
                                      style: TextStyle(fontSize: 12)),
                                ),
                                Text(fotostercerosegurofrente.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: fotostercerosegurofrente == 0
                                            ? Colors.red
                                            : Colors.blue)),
                              ]),
                              TableRow(children: [
                                const Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: const Text(""),
                                ),
                                const Text(""),
                                const Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: const Text("Seguro Dorso:",
                                      style: const TextStyle(fontSize: 12)),
                                ),
                                Text(fotostercerosegurodorso.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: fotostercerosegurodorso == 0
                                            ? Colors.red
                                            : Colors.blue)),
                              ]),
                            ],
                          ),
                          const SizedBox(
                            height: 1,
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

//-----------------------------------------------------------------------------
//-------------------------- METODO SHOWPHOTOSCAROUSEL ------------------------
//-----------------------------------------------------------------------------

  Widget _showPhotosCarousel() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
                height: 460,
                autoPlay: false,
                initialPage: 0,
                autoPlayInterval: const Duration(seconds: 0),
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
            carouselController: _carouselController,
            items: _fotos.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Column(
                    children: [
                      Expanded(
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                imageUrl: i.imageFullPath == null
                                    ? ''
                                    : i.imageFullPath.toString(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.contain,
                                height: 360,
                                width: 460,
                                placeholder: (context, url) => const Image(
                                  image: AssetImage('assets/loading.gif'),
                                  fit: BoxFit.contain,
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        i.correspondea,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        i.observacion,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  );
                },
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Flexible(
                child: ElevatedButton(
                  onPressed: () => _carouselController.previousPage(),
                  child: Text('←'),
                ),
              ),
              Text("Fotos: ${_fotos.length.toString()}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              Flexible(
                child: ElevatedButton(
                  onPressed: () => _carouselController.nextPage(),
                  child: Text('→'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

//-----------------------------------------------------------------------------
//-------------------------- METODO SHOWIMAGEBUTTONS --------------------------
//-----------------------------------------------------------------------------

  Widget _showImageButtons() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Icon(Icons.add_a_photo),
                  Text('Adicionar Foto'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF120E43),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () => _goAddPhoto(),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Icon(Icons.delete),
                  Text('Eliminar Foto'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFFB4161B),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () => _confirmDeletePhoto(),
            ),
          ),
        ],
      ),
    );
  }

//*****************************************************************************
//************************** METODO GOADDPHOTO ********************************
//*****************************************************************************

  void _goAddPhoto() async {
    var response = await showAlertDialog(
        context: context,
        title: 'Confirmación',
        message: '¿De donde deseas obtener la imagen?',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: 'cancel', label: 'Cancelar'),
          const AlertDialogAction(key: 'camera', label: 'Cámara'),
          const AlertDialogAction(key: 'gallery', label: 'Galería'),
        ]);

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

//*****************************************************************************
//************************** METODO TAKEPICTURE *******************************
//*****************************************************************************

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
              builder: (context) => TakePicture4Screen(
                    camera: firstCamera,
                  )));
      if (response != null) {
        setState(() {
          _photoChanged = true;
          _photo = response.result;
          _image = _photo.image;
        });
      }
    }
  }

//*****************************************************************************
//************************** METODO SELECTPICTURE *****************************
//*****************************************************************************

  Future<void> _selectPicture() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? _image2 = await _picker.pickImage(source: ImageSource.gallery);

    if (_image2 != null) {
      _photoChanged = true;
      Response? response = await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DisplayPicture4Screen(
                image: _image2,
              )));
      if (response != null) {
        setState(() {
          _photoChanged = true;
          _photo = response.result;
          _image = _photo.image;
        });
      }
    }
  }

//*****************************************************************************
//************************** METODO ADDPICTURE ********************************
//*****************************************************************************

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
          ]);
      return;
    }

    List<int> imageBytes = await _image.readAsBytes();

    String base64Image = base64Encode(imageBytes);

    Map<String, dynamic> request = {
      'ImageArray': base64Image,
      'NROSINIESTROCAB': widget.siniestro.nrosiniestro,
      'OBSERVACION': _photo.observaciones,
      'CORRESPONDEA': _photo.tipofoto,
      'LINKFOTO': '',
    };

    Response response = await ApiHelper.post(
        '/api/VehiculosSiniestrosFotos/VehiculosSiniestrosFoto', request);

    setState(() {});

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

    _getFotosSiniestro();
    setState(() {});
  }

//*****************************************************************************
//************************** METODO CONFIRMDELETEPHOTO ************************
//*****************************************************************************

  void _confirmDeletePhoto() async {
    if (_fotos.isEmpty) {
      return;
    }

    if (widget.user.habilitaFotos != 1) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Su usuario no está habilitado para eliminar Fotos.',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    var response = await showAlertDialog(
        context: context,
        title: 'Confirmación',
        message: '¿Estas seguro de querer borrar esta foto?',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: 'no', label: 'No'),
          const AlertDialogAction(key: 'yes', label: 'Sí'),
        ]);

    if (response == 'yes') {
      await _deletePhoto();
    }
    _getFotosSiniestro();
    setState(() {});
  }

//*****************************************************************************
//************************** METODO DELETEPHOTO *******************************
//*****************************************************************************

  Future<void> _deletePhoto() async {
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
          ]);
      return;
    }

    Response response = await ApiHelper.delete('/api/VehiculosSiniestrosFotos/',
        _fotos[_current].idfotosiniestro.toString());

    setState(() {});

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
  }

//*****************************************************************************
//************************** METODO _getFotosSiniestro ************************
//*****************************************************************************

  Future<void> _getFotosSiniestro() async {
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
          ]);
      return;
    }

    Response response = await ApiHelper.getFotosSiniestro(
        widget.siniestro.nrosiniestro.toString());

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: "N° de Siniestro no válido",
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);

      setState(() {});
      return;
    }
    _fotos = response.result;

    _current = 0;

    fotospropiocarnetfrente = 0;
    fotospropiocarnetdorso = 0;
    fotospropiocedulafrente = 0;
    fotospropioceduladorso = 0;
    fotospropiosiniestrolateralderecho = 0;
    fotospropiosiniestrolateralizquierdo = 0;
    fotospropiosiniestrofrente = 0;
    fotospropiosiniestrotrasero = 0;
    fotostercerocarnetfrente = 0;
    fotostercerocarnetdorso = 0;
    fotostercerocedulafrente = 0;
    fotosterceroceduladorso = 0;
    fotostercerosiniestrolateralderecho = 0;
    fotostercerosiniestrolateralizquierdo = 0;
    fotostercerosiniestrofrente = 0;
    fotostercerosiniestrotrasero = 0;
    fotostercerosegurofrente = 0;
    fotostercerosegurodorso = 0;

    _fotos.forEach((foto) {
      if (foto.correspondea == 'Propio-Carnet-Frente') {
        fotospropiocarnetfrente = fotospropiocarnetfrente + 1;
      }
      if (foto.correspondea == 'Propio-Carnet-Dorso') {
        fotospropiocarnetdorso = fotospropiocarnetdorso + 1;
      }
      if (foto.correspondea == 'Propio-Cédula-Frente') {
        fotospropiocedulafrente = fotospropiocedulafrente + 1;
      }
      if (foto.correspondea == 'Propio-Cédula-Dorso') {
        fotospropioceduladorso = fotospropioceduladorso + 1;
      }
      if (foto.correspondea == 'Propio-Siniestro-Lateral Derecho') {
        fotospropiosiniestrolateralderecho =
            fotospropiosiniestrolateralderecho + 1;
      }
      if (foto.correspondea == 'Propio-Siniestro-Lateral Izquierdo') {
        fotospropiosiniestrolateralizquierdo =
            fotospropiosiniestrolateralizquierdo + 1;
      }
      if (foto.correspondea == 'Propio-Siniestro-Frente') {
        fotospropiosiniestrofrente = fotospropiosiniestrofrente + 1;
      }
      if (foto.correspondea == 'Propio-Siniestro-Trasero') {
        fotospropiosiniestrotrasero = fotospropiosiniestrotrasero + 1;
      }
      if (foto.correspondea == 'Tercero-Carnet-Frente') {
        fotostercerocarnetfrente = fotostercerocarnetfrente + 1;
      }
      if (foto.correspondea == 'Tercero-Carnet-Dorso') {
        fotostercerocarnetdorso = fotostercerocarnetdorso + 1;
      }
      if (foto.correspondea == 'Tercero-Cédula-Frente') {
        fotostercerocedulafrente = fotostercerocedulafrente + 1;
      }
      if (foto.correspondea == 'Tercero-Cédula-Dorso') {
        fotosterceroceduladorso = fotosterceroceduladorso + 1;
      }
      if (foto.correspondea == 'Tercero-Seguro-Frente') {
        fotostercerosegurofrente = fotostercerosegurofrente + 1;
      }
      if (foto.correspondea == 'Tercero-Seguro-Dorso') {
        fotostercerosegurodorso = fotostercerosegurodorso + 1;
      }
      if (foto.correspondea == 'Tercero-Siniestro-Lateral Derecho') {
        fotostercerosiniestrolateralderecho =
            fotostercerosiniestrolateralderecho + 1;
      }
      if (foto.correspondea == 'Tercero-Siniestro-Lateral Izquierdo') {
        fotostercerosiniestrolateralizquierdo =
            fotostercerosiniestrolateralizquierdo + 1;
      }
      if (foto.correspondea == 'Tercero-Siniestro-Frente') {
        fotostercerosiniestrofrente = fotostercerosiniestrofrente + 1;
      }
      if (foto.correspondea == 'Tercero-Siniestro-Trasero') {
        fotostercerosiniestrotrasero = fotostercerosiniestrotrasero + 1;
      }
    });
    setState(() {
      _carouselController.jumpToPage(0);
    });
  }

//*****************************************************************************
//************************** METODO _HoraMinuto *******************************
//*****************************************************************************

  String _HoraMinuto(int valor) {
    String hora = (valor / 3600).floor().toString();
    String minutos =
        ((valor - ((valor / 3600).floor()) * 3600) / 60).round().toString();

    if (minutos.length == 1) {
      minutos = "0" + minutos;
    }
    return hora.toString() + ':' + minutos.toString();
  }
}
