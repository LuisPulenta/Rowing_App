import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../helpers/helpers.dart';
import '../../helpers/resize_image.dart';
import '../../models/models.dart';
import '../screens.dart';

class GruasCheckListFotosScreen extends StatefulWidget {
  final User user;
  final VehiculosCheckList vehiculosCheckList;

  const GruasCheckListFotosScreen({
    super.key,
    required this.user,
    required this.vehiculosCheckList,
  });

  @override
  _GruasCheckListFotosScreenState createState() =>
      _GruasCheckListFotosScreenState();
}

class _GruasCheckListFotosScreenState extends State<GruasCheckListFotosScreen> {
  //---------------------------------------------------------------------
  //-------------------------- Variables --------------------------------
  //---------------------------------------------------------------------

  bool _photoChanged = false;
  late XFile _image;

  bool _showLoader = false;

  VehiculosCheckList _vehiculosCheckList = VehiculosCheckList(
    idCheckList: 0,
    fecha: '',
    idUser: 0,
    idCliente: 0,
    cliente: '',
    idVehiculo: 0,
    numcha: '',
    nrotar: '',
    codProducto: '',
    aniofa: 0,
    descripcion: '',
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
    campomemo: '',
    vtv: '',
    fechaVencVTV: '',
    vth: '',
    fechaVencVTH: '',
    cubiertas: '',
    correaCinturon: '',
    apoyaCabezas: '',
    limpiavidrios: '',
    espejos: '',
    indicadoresDeGiro: '',
    bocina: '',
    dispositivoPAT: '',
    ganchos: '',
    alarmaRetroceso: '',
    manguerasCircuitoHidraulico: '',
    farosDelanteros: '',
    farosTraseros: '',
    luzPosicion: '',
    luzFreno: '',
    luzRetroceso: '',
    luzEmergencia: '',
    balizaPortatil: '',
    matafuegos: '',
    identificadorEmpresa: '',
    sobreSalientesPeligro: '',
    diagramaDeCarga: '',
    fajas: '',
    grilletes: '',
    cintaSujecionCarga: '',
    jefeDirecto: '',
    responsableVehiculo: '',
    observaciones: '',
    grupoC: '',
    causanteC: '',
    nombre: '',
    dni: '',
    apellidoNombre: '',
    seguro: '',
    fechaVencSeguro: '',
  );

  late Photo _photo;
  int _current = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  List<CheckListFoto> _vehiculosCheckListFotos = [];

  DateTime selectedDate = DateTime.now();

  //---------------------------------------------------------------------
  //-------------------------- initState --------------------------------
  //---------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _vehiculosCheckList = widget.vehiculosCheckList;
    _getFotos();
  }

  //---------------------------------------------------------------------
  //-------------------------- Pantalla ---------------------------------
  //---------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(title: const Text('Check List Fotos'), centerTitle: true),
      body: Column(
        children: [
          _getInfoObra(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: <Widget>[_showPhotosCarousel()]),
            ),
          ),
          _showImageButtons(),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  //-----------------------------------------------------------------------------
  //-------------------------- _getInfoObra -------------------------------------
  //-----------------------------------------------------------------------------

  Widget _getInfoObra() {
    double ancho = MediaQuery.of(context).size.width;
    double anchoTitulo = ancho * 0.2;
    return Card(
      color: const Color(0xFFC7C7C8),
      shadowColor: Colors.white,
      elevation: 10,
      margin: const EdgeInsets.fromLTRB(10, 15, 10, 0),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(0),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _RowCustom(
                            anchoTitulo: anchoTitulo,
                            titulo: 'Id:',
                            dato: _vehiculosCheckList.idCheckList.toString(),
                          ),
                          _RowCustom(
                            anchoTitulo: anchoTitulo,
                            titulo: 'Fecha:',
                            dato: DateFormat('dd/MM/yyyy').format(
                              DateTime.parse(_vehiculosCheckList.fecha!),
                            ),
                          ),
                          _RowCustom(
                            anchoTitulo: anchoTitulo,
                            titulo: 'Patente:',
                            dato: _vehiculosCheckList.numcha!,
                          ),
                          _RowCustom(
                            anchoTitulo: anchoTitulo,
                            titulo: 'Descripción:',
                            dato: _vehiculosCheckList.descripcion!,
                          ),
                          _RowCustom(
                            anchoTitulo: anchoTitulo,
                            titulo: 'Cliente:',
                            dato: _vehiculosCheckList.cliente!,
                          ),
                          _RowCustom(
                            anchoTitulo: anchoTitulo,
                            titulo: 'Descripción:',
                            dato: _vehiculosCheckList.descripcion!,
                          ),
                          _RowCustom(
                            anchoTitulo: anchoTitulo,
                            titulo: 'Nombre y Apellido:',
                            dato: _vehiculosCheckList.apellidoNombre!,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //-----------------------------------------------------------------------------
  //-------------------------- _showPhotosCarousel ------------------------------
  //-----------------------------------------------------------------------------

  Widget _showPhotosCarousel() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
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
              },
            ),
            carouselController: _carouselController,
            items: _vehiculosCheckListFotos.map((i) {
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
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        i.descripcion.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                },
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _vehiculosCheckListFotos.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _carouselController.animateToPage(entry.key),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 4.0,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black)
                            .withOpacity(_current == entry.key ? 0.9 : 0.4),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  //-----------------------------------------------------------------------------
  //-------------------------- _showImageButtons --------------------------------
  //-----------------------------------------------------------------------------

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
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () => _goAddPhoto(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Icon(Icons.add_a_photo),
                      Text('Adicionar Foto'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB4161B),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () => _confirmDeletePhoto(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [Icon(Icons.delete), Text('Eliminar Foto')],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  //-----------------------------------------------------------------------
  //-------------------------- _goAddPhoto --------------------------------
  //-----------------------------------------------------------------------

  void _goAddPhoto() async {
    if (widget.user.habilitaFotos != 1) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Su usuario no está habilitado para agregar Fotos.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    var response = await showAlertDialog(
      context: context,
      title: 'Seleccione una opción',
      message: '¿De dónde deseas obtener la imagen?',
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
          builder: (context) => TakePicture3Screen(camera: firstCamera),
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

  //-----------------------------------------------------------------------
  //-------------------------- _selectPicture -----------------------------
  //-----------------------------------------------------------------------

  Future<void> _selectPicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image2 = await picker.pickImage(source: ImageSource.gallery);

    if (image2 != null) {
      _photoChanged = true;
      Response? response = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureCScreen(image: image2),
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

  //-----------------------------------------------------------------------
  //-------------------------- _addPicture --------------------------------
  //-----------------------------------------------------------------------

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
      'IDCHECKLISTCAB': widget.vehiculosCheckList.idCheckList,
      'DESCRIPCION': _photo.observaciones,
      'LINKFOTO': '',
      'ImageArray': base64Image,
    };

    Response response = await ApiHelper.post(
      '/api/VehiculosCheckListsFotos/PostVehiculosCheckListsFoto',
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

    _getFotos();

    setState(() {});
  }

  //-----------------------------------------------------------------------
  //-------------------------- _confirmDeletePhoto ------------------------
  //-----------------------------------------------------------------------

  void _confirmDeletePhoto() async {
    if (_vehiculosCheckListFotos.isEmpty) {
      return;
    }

    var response = await showAlertDialog(
      context: context,
      title: 'Confirmación',
      message: '¿Estas seguro de querer borrar esta foto?',
      actions: <AlertDialogAction>[
        const AlertDialogAction(key: 'no', label: 'No'),
        const AlertDialogAction(key: 'yes', label: 'Sí'),
      ],
    );

    if (response == 'yes') {
      await _deletePhoto();
      _getFotos();
    }
  }

  //-----------------------------------------------------------------------
  //-------------------------- _deletePhoto -------------------------------
  //-----------------------------------------------------------------------

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
        ],
      );
      return;
    }

    int aa = _vehiculosCheckListFotos[_current].idregistro;

    Response response = await ApiHelper.deleteVehiculosCheckListsFoto(
      _vehiculosCheckListFotos[_current].idregistro.toString(),
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

    setState(() {});
  }

  //-------------------------------------------------------------
  //-------------------- _geFotos -------------------------------
  //-------------------------------------------------------------

  Future<void> _getFotos() async {
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

    response = await ApiHelper.getCheckListFotos(
      widget.vehiculosCheckList.idCheckList.toString(),
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

    setState(() {
      _vehiculosCheckListFotos = response.result;
      _vehiculosCheckListFotos.sort((a, b) {
        return a.idregistro.toString().toLowerCase().compareTo(
          b.idregistro.toString().toLowerCase(),
        );
      });
    });
  }
}

//-----------------------------------------------------------------
//-------------------------- _RowCustom ---------------------------
//-----------------------------------------------------------------
class _RowCustom extends StatelessWidget {
  const _RowCustom({
    super.key,
    required this.anchoTitulo,
    required this.titulo,
    required this.dato,
  });

  final double anchoTitulo;
  final String titulo;
  final String dato;

  @override
  Widget build(BuildContext context) {
    double ancho = MediaQuery.of(context).size.width * 0.75;
    return SizedBox(
      width: ancho,
      child: Row(
        children: [
          SizedBox(
            width: anchoTitulo,
            child: Text(
              titulo,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF781f1e),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(child: Text(dato, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}
