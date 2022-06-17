import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rowing_app/helpers/api_helper.dart';
import 'package:rowing_app/models/obra.dart';
import 'package:rowing_app/models/obras_documento.dart';
import 'package:rowing_app/models/photo.dart';
import 'package:rowing_app/models/response.dart';
import 'package:rowing_app/models/user.dart';
import 'package:rowing_app/screens/display_picture_screen.dart';
import 'package:rowing_app/screens/take_picture.dart';

class ObraInfoScreen extends StatefulWidget {
  final User user;
  final Obra obra;

  const ObraInfoScreen({Key? key, required this.user, required this.obra})
      : super(key: key);

  @override
  _ObraInfoScreenState createState() => _ObraInfoScreenState();
}

class _ObraInfoScreenState extends State<ObraInfoScreen> {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

  bool _photoChanged = false;
  late XFile _image;

  late Photo _photo;
  int _current = 0;
  final CarouselController _carouselController = CarouselController();

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
      obrasDocumentos: []);

  List<ObrasDocumento> _obrasDocumentos = [];

//*****************************************************************************
//************************** INIT STATE ***************************************
//*****************************************************************************
  @override
  void initState() {
    super.initState();
    _getObra();
  }

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: const Text('Obra Info'),
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              _getInfoObra(),
              _showPhotosCarousel(),
              _showImageButtons()
            ],
          )
        ],
      ),
    );
  }

//-----------------------------------------------------------------------------
//-------------------------- METODO GETINFOOBRA -------------------------------
//-----------------------------------------------------------------------------

  Widget _getInfoObra() {
    return Card(
      color: const Color(0xFFC7C7C8),
      shadowColor: Colors.white,
      elevation: 10,
      margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                const Text("N° Obra: ",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF781f1e),
                      fontWeight: FontWeight.bold,
                    )),
                Expanded(
                  child: Text(_obra.nroObra.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const Text("Nombre: ",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF781f1e),
                      fontWeight: FontWeight.bold,
                    )),
                Expanded(
                  child: Text(_obra.nombreObra,
                      style: const TextStyle(
                        fontSize: 14,
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const Text("OP/N° Fuga: ",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF781f1e),
                      fontWeight: FontWeight.bold,
                    )),
                Expanded(
                  child: Text(_obra.elempep,
                      style: const TextStyle(
                        fontSize: 14,
                      )),
                ),
              ],
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
                }),
            carouselController: _carouselController,
            items: _obrasDocumentos.map((i) {
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
                        i.tipoDeFoto == 0
                            ? 'Relevamiento(Vereda/Calzada/Traza)'
                            : i.tipoDeFoto == 1
                                ? 'Previa al trabajo'
                                : i.tipoDeFoto == 2
                                    ? 'Durante el trabajo'
                                    : i.tipoDeFoto == 3
                                        ? 'Vereda conforme'
                                        : i.tipoDeFoto == 4
                                            ? 'Finalización del Trabajo'
                                            : '',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                },
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _obra.obrasDocumentos.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _carouselController.animateToPage(entry.key),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
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
    if (widget.user.habilitaFotos != 1) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Su usuario no está habilitado para agregar Fotos.',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

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
              builder: (context) => TakePictureScreen(
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
          builder: (context) => DisplayPictureScreen(
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
      'imagearray': base64Image,
      'fecha': DateTime.now().toString(),
      'nroobra': _obra.nroObra,
      'observacion': _photo.observaciones,
      'estante': 'App',
      'generadopor': widget.user.login,
      'modulo': widget.user.modulo,
      'nrolote': 'App',
      'sector': 'App',
      'latitud': _photo.latitud,
      'longitud': _photo.longitud,
      'tipodefoto': _photo.tipofoto,
      'direccionfoto': _photo.direccion,
      'fechaHsFoto': DateTime.now().toString(),
      'obra': _obra,
    };

    Response response =
        await ApiHelper.post('/api/ObrasDocuments/ObrasDocument', request);

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

    setState(() {
      _getObra();
    });
  }

//*****************************************************************************
//************************** METODO CONFIRMDELETEPHOTO ************************
//*****************************************************************************

  void _confirmDeletePhoto() async {
    if (_obrasDocumentos.isEmpty) {
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

    Response response = await ApiHelper.delete('/api/ObrasDocuments/',
        _obra.obrasDocumentos[_current].nroregistro.toString());

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

    setState(() {
      _getObra();
    });
  }

//*****************************************************************************
//************************** METODO GETOBRA ***********************************
//*****************************************************************************

  Future<void> _getObra() async {
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

    Response response = await ApiHelper.getObra(widget.obra.nroObra.toString());

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: "N° de Obra no válido",
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);

      setState(() {});
      return;
    }
    _obra = response.result;
    _obrasDocumentos = _obra.obrasDocumentos.toList();

    for (ObrasDocumento obraDocumento in _obrasDocumentos) {
      if (obraDocumento.tipoDeFoto == 3) {
        obraDocumento.tipoDeFoto = 4;
      }
      if (obraDocumento.tipoDeFoto == 10) {
        obraDocumento.tipoDeFoto = 3;
      }
    }

    _obrasDocumentos.sort((a, b) {
      return a.tipoDeFoto
          .toString()
          .toLowerCase()
          .compareTo(b.tipoDeFoto.toString().toLowerCase());
    });
    _current = 0;

    setState(() {
      _carouselController.jumpToPage(0);
    });
  }
}
