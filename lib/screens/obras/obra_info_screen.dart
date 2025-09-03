import 'dart:convert';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../helpers/resize_image.dart';
import '../../models/models.dart';
import '../screens.dart';

class ObraInfoScreen extends StatefulWidget {
  final User user;
  final Obra obra;
  final Position positionUser;
  final List<ObraEstado> estados;
  final List<ObraSubestado> subestados;

  const ObraInfoScreen({
    super.key,
    required this.user,
    required this.obra,
    required this.positionUser,
    required this.estados,
    required this.subestados,
  });

  @override
  _ObraInfoScreenState createState() => _ObraInfoScreenState();
}

class _ObraInfoScreenState extends State<ObraInfoScreen> {
  //---------------------------------------------------------------
  //----------------------- Variables -----------------------------
  //---------------------------------------------------------------

  bool _hayErrorEstado = true;
  String _subestadoexistente = '';

  String _optionEstado = 'Elija un Estado...';
  String _estado = '';
  final String _optionEstadoError = '';
  final bool _optionEstadoShowError = false;
  final TextEditingController _optionEstadoController = TextEditingController();

  String _optionSubestado = 'Elija un Subestado...';
  String _subestado = '';
  final String _optionSubestadoError = '';
  final bool _optionSubestadoShowError = false;
  final TextEditingController _optionSubestadoController =
      TextEditingController();

  late List<DropdownMenuItem<String>> _estados;
  late List<DropdownMenuItem<String>> _subestados;

  bool _photoChanged = false;
  late XFile _image;

  late Photo _photo;
  int _current = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  bool _showLoader = false;

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

  List<ObrasDocumento> _obrasDocumentos = [];
  List<ObrasDocumento> _obrasDocumentosFotos = [];
  List<ObrasDocumento> _obrasDocumentosAudios = [];
  List<ObrasDocumento> _obrasDocumentosVideos = [];

  DateTime selectedDate = DateTime.now();

  //---------------------------------------------------------------
  //----------------------- initState -----------------------------
  //---------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _obra = widget.obra;
    _optionEstado = _obra.codigoEstado != null
        ? _obra.codigoEstado!
        : 'Elija un Estado...';
    _optionSubestado = _obra.codigoSubEstado != null
        ? _obra.codigoSubEstado!
        : 'Elija un Subestado...';

    _loadData();
    _getObra();
  }

  //---------------------------------------------------------------
  //----------------------- Pantalla -----------------------------
  //---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: Text('Obra ${widget.obra.nroObra}'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _getInfoObra(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      _obrasDocumentosFotos.isNotEmpty
                          ? _showPhotosCarousel()
                          : Container(),
                      _obrasDocumentosAudios.isNotEmpty
                          ? const Text(
                              'AUDIOS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Container(),
                      _obrasDocumentosAudios.isNotEmpty
                          ? _showAudios()
                          : Container(),
                      _obrasDocumentosVideos.isNotEmpty
                          ? const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                'VIDEOS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : Container(),
                      _obrasDocumentosVideos.isNotEmpty
                          ? _showVideos()
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
  //-------------------------- _getInfoObra -------------------------------
  //-----------------------------------------------------------------------

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
                const Text(
                  'N° Obra: ',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF781f1e),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    _obra.nroObra.toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const Text(
                  'Ult.Mov.: ',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF781f1e),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: _obra.fechaUltimoMovimiento != null
                      ? Text(
                          DateFormat('dd/MM/yyyy').format(
                            DateTime.parse(
                              _obra.fechaUltimoMovimiento.toString(),
                            ),
                          ),
                          style: const TextStyle(fontSize: 12),
                        )
                      : Container(),
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
                  flex: 4,
                  child: Text(
                    _obra.modulo.toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Text(
                  'Nombre: ',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF781f1e),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    _obra.nombreObra,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Text(
                  'OP/N° Fuga: ',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF781f1e),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    _obra.elempep,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                _obra.fechaCierreElectrico == '' ||
                        _obra.fechaCierreElectrico == null
                    ? MaterialButton(
                        color: const Color(0xFF781f1e),
                        child:
                            (widget.user.modulo == 'Aysa' ||
                                widget.user.modulo == 'Cetaco')
                            ? const Text(
                                'Fec. Cierre Hidr.',
                                style: TextStyle(color: Colors.white),
                              )
                            : const Text(
                                'Fec. Cierre Eléc.',
                                style: TextStyle(color: Colors.white),
                              ),
                        onPressed: () {
                          _selectDate(context);
                        },
                      )
                    : Container(),
              ],
            ),
            SizedBox(
              height:
                  (_obra.fechaCierreElectrico != '' &&
                      _obra.fechaCierreElectrico != null)
                  ? 5
                  : 0,
            ),
            _obra.fechaCierreElectrico != '' &&
                    _obra.fechaCierreElectrico != null
                ? Row(
                    children: [
                      (widget.user.modulo == 'Aysa' ||
                              widget.user.modulo == 'Cetaco')
                          ? const Text(
                              'Fecha Cierre Hidráulico: ',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF781f1e),
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const Text(
                              'Fecha Cierre Eléctrico: ',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF781f1e),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      Expanded(
                        child: Text(
                          DateFormat('dd/MM/yyyy').format(
                            DateTime.parse(
                              _obra.fechaCierreElectrico.toString(),
                            ),
                          ),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  )
                : Container(),
            const SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _showEstado(),
                      const SizedBox(height: 10),
                      _showSubestado(),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: MaterialButton(
                    padding: const EdgeInsets.all(0),
                    color: const Color(0xFF781f1e),
                    child: const Icon(Icons.save, color: Colors.white),
                    onPressed: () {
                      _saveEstado();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _hayErrorEstado
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'La obra tiene cargado el Código de Subestado $_subestadoexistente que no corresponde al Estado que tiene cargado.',
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  //-----------------------------------------------------------------------
  //-------------------------- _showPhotosCarousel ------------------------
  //-----------------------------------------------------------------------

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
            items: _obrasDocumentosFotos.map((i) {
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
                            : i.tipoDeFoto == 5
                            ? 'Proceso de geofonía'
                            : i.tipoDeFoto == 6
                            ? 'Proceso de reparación'
                            : '',
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
            children: _obrasDocumentosFotos.asMap().entries.map((entry) {
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

  //---------------------------------------------------------------
  //-------------------------- _showAudios ------------------------
  //---------------------------------------------------------------

  Widget _showAudios() {
    return SizedBox(
      width: double.infinity,
      height: _obrasDocumentosAudios.length * 60,
      //color: Colors.yellow,
      child: ListView(
        children: _obrasDocumentosAudios.map((e) {
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
                    child: Text(
                      '${e.nroregistro.toString()}-${e.generadoPor.toString()}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: CircleAvatar(
                      backgroundColor: const Color(0xFF781f1e),
                      child: IconButton(
                        onPressed: () async {
                          await launch(e.imageFullPath!);
                        },
                        icon: const Icon(Icons.play_arrow),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        onPressed: () async {
                          _confirmDeleteAudio(e);
                        },
                        icon: const Icon(Icons.delete_forever_sharp),
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
  //---------------------------------------------------------------
  //-------------------------- _showVideos ------------------------
  //---------------------------------------------------------------

  Widget _showVideos() {
    return SizedBox(
      width: double.infinity,
      height: _obrasDocumentosVideos.length * 60,
      //color: Colors.green,
      child: ListView(
        children: _obrasDocumentosVideos.map((e) {
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
                    child: Text(
                      '${e.nroregistro.toString()}-${e.generadoPor.toString()}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: CircleAvatar(
                      backgroundColor: const Color(0xFF781f1e),
                      child: IconButton(
                        onPressed: () async {
                          await launch(e.imageFullPath!);
                        },
                        icon: const Icon(Icons.play_arrow),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        onPressed: () async {
                          _confirmDeleteVideo(e);
                        },
                        icon: const Icon(Icons.delete_forever_sharp),
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
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
              const SizedBox(width: 5),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB4161B),
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () => _confirmDeletePhoto(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [Icon(Icons.delete), Text('Elim. Foto')],
                  ),
                ),
              ),
              widget.user.modulo == 'Aysa' || widget.user.modulo == 'Cetaco'
                  ? const SizedBox(width: 5)
                  : Container(),
              widget.user.modulo == 'Aysa' || widget.user.modulo == 'Cetaco'
                  ? Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 5, 43, 80),
                          minimumSize: const Size(double.infinity, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: _goAddMultimedia,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Icon(Icons.video_call),
                            Text('Multim.'),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          const SizedBox(height: 0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 180, 38, 236),
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () => _reqmat(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [Icon(Icons.list), Text('Req. Mat.')],
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 80, 5, 8),
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: _veredas,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Icon(Icons.auto_awesome_mosaic),
                      Text('Veredas'),
                    ],
                  ),
                  // _obra.fechaCierreElectrico != "" &&
                  //         _obra.fechaCierreElectrico != null
                  //     ? _veredas
                  //     : null,
                ),
              ),
              widget.user.modulo == 'Aysa' || widget.user.modulo == 'Cetaco'
                  ? const SizedBox(width: 5)
                  : Container(),
              widget.user.modulo == 'Aysa' || widget.user.modulo == 'Cetaco'
                  ? Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 43, 4, 66),
                          minimumSize: const Size(double.infinity, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: _goInfoData,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [Icon(Icons.info), Text('Datos')],
                        ),
                      ),
                    )
                  : Container(),
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

    if (widget.obra.finalizada == 1) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Obra Terminada. No se puede agregar fotos.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
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

  //--------------------------------------------------------
  //--------------------- _reqmat --------------------------
  //--------------------------------------------------------

  void _reqmat() async {
    if (widget.obra.finalizada == 1) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Obra Terminada. No se puede agregar requerimientos.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    if (widget.user.conceptomova != 1) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Su usuario no está habilitado para agregar Requerimentos.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReqAppScreen(user: widget.user, obra: _obra),
      ),
    );
  }

  //----------------------------------------------------------
  //--------------------- _veredas ---------------------------
  //----------------------------------------------------------

  void _veredas() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VeredasScreen(
          user: widget.user,
          obra: _obra,
          positionUser: widget.positionUser,
        ),
      ),
    );
  }

  //-----------------------------------------------------------------------------
  //------------------------------ _goInfoData ----------------------------------
  //-----------------------------------------------------------------------------

  void _goInfoData() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ObraInfoDataScreen(user: widget.user, obra: _obra),
      ),
    );
  }

  //-----------------------------------------------------------------------------
  //------------------------------ _takePicture ---------------------------------
  //-----------------------------------------------------------------------------

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
          builder: (context) => TakePictureScreen(camera: firstCamera),
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
          builder: (context) => DisplayPictureScreen(image: image2),
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
      'obra': _obra,
    };

    Response response = await ApiHelper.post(
      '/api/ObrasDocuments/ObrasDocument',
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
      _getObra();
    });
  }

  //-----------------------------------------------------------------------------
  //------------------------------ _confirmDeletePhoto --------------------------
  //-----------------------------------------------------------------------------

  void _confirmDeletePhoto() async {
    if (_obrasDocumentosFotos.isEmpty) {
      return;
    }

    if (widget.obra.finalizada == 1) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Obra Terminada. No se puede eliminar fotos.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    if (widget.user.habilitaFotos != 1) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Su usuario no está habilitado para eliminar Fotos.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    if (widget.user.login != _obra.obrasDocumentos[_current].generadoPor) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message:
            'Esta foto (NROREGISTRO ${_obra.obrasDocumentos[_current].nroregistro}) sólo puede ser eliminada por el Usuario que la cargó (${_obra.obrasDocumentos[_current].generadoPor}). De ser necesario borrarla comuníquese con el administrador del Sistema.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
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
    }
  }

  //----------------------------------------------------------------------
  //------------------------------ _deletePhoto --------------------------
  //----------------------------------------------------------------------

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

    Response response = await ApiHelper.delete(
      '/api/ObrasDocuments/',
      _obra.obrasDocumentos[_current].nroregistro.toString(),
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
      _getObra();
    });
  }

  //------------------------------------------------------------------
  //------------------------------ _getObra --------------------------
  //------------------------------------------------------------------

  Future<void> _getObra() async {
    _obrasDocumentos = [];
    _obrasDocumentosFotos = [];
    _obrasDocumentosAudios = [];
    _obrasDocumentosVideos = [];

    //setState(() {});

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

    Response response = await ApiHelper.getObra(_obra.nroObra.toString());

    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'N° de Obra no válido',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );

      setState(() {});
      return;
    }
    _obra = response.result;
    _obrasDocumentos = _obra.obrasDocumentos.toList();

    for (ObrasDocumento obraDocumento in _obrasDocumentos) {
      if (obraDocumento.tipoDeFoto == null) {
        continue;
      }

      if (obraDocumento.sector != 'App') {
        continue;
      }

      if (obraDocumento.tipoDeFoto == 3) {
        obraDocumento.tipoDeFoto = 4;
      }
      if (obraDocumento.tipoDeFoto == 10) {
        obraDocumento.tipoDeFoto = 3;
      }
      if (obraDocumento.tipoDeFoto == 20) {
        _obrasDocumentosAudios.add(obraDocumento);
      }
      if (obraDocumento.tipoDeFoto == 30) {
        _obrasDocumentosVideos.add(obraDocumento);
      }
      if (obraDocumento.tipoDeFoto! < 20) {
        _obrasDocumentosFotos.add(obraDocumento);
      }
    }

    _obrasDocumentosFotos.sort((a, b) {
      return a.tipoDeFoto.toString().toLowerCase().compareTo(
        b.tipoDeFoto.toString().toLowerCase(),
      );
    });
    _current = 0;

    setState(() {
      if (_obrasDocumentosFotos.isNotEmpty) {
        //_carouselController.jumpToPage(0);
      }
    });
  }

  //-----------------------------------------------------
  //-------------------- _selectDate --------------------
  //-----------------------------------------------------

  void _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 15)),
      lastDate: DateTime.now().add(const Duration(days: 0)),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
        _grabar();
      });
    }
  }

  //-----------------------------------------------------
  //-------------------- _saveEstado --------------------
  //-----------------------------------------------------

  void _saveEstado() async {
    if (_optionEstado == 'Elija un Estado...') {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Debe elegir un Estado',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    if (_optionSubestado == 'Elija un Subestado...') {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Debe elegir un SubEstado',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    Map<String, dynamic> requestEstadoSubestado = {
      // 'nrosuministro': 0,
      'NroObra': widget.obra.nroObra,
      'CodigoEstado': _optionEstado,
      'CodigoSubEstado': _optionSubestado,
    };

    Response response = await ApiHelper.put(
      '/api/Obras/PutEstadoSubestado/',
      widget.obra.nroObra.toString(),
      requestEstadoSubestado,
    );

    if (response.isSuccess) {
      _showSnackbar('Estado y SubEstado grabados con éxito');
    }
  }

  //-------------------------------------------------
  //-------------------- _grabar --------------------
  //-------------------------------------------------

  Future<void> _grabar() async {
    _obra.fechaCierreElectrico = selectedDate.toString().substring(0, 10);
    setState(() {});

    Map<String, dynamic> requestFechaCierreElectrico = {
      // 'nrosuministro': 0,
      'NroObra': widget.obra.nroObra,
      'FechaCierreElectrico': selectedDate.toString().substring(0, 10),
    };

    Response response = await ApiHelper.put(
      '/api/Obras/',
      widget.obra.nroObra.toString(),
      requestFechaCierreElectrico,
    );

    if (response.isSuccess) {
      _showSnackbar('Fecha de Cierre Eléctrico grabada con éxito');
    }
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

  //-------------------------------------------------------------
  //-------------------- _selectAudio ---------------------------
  //-------------------------------------------------------------

  Future<void> _selectAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      withData: true,
      allowedExtensions: ['wav'],
    );

    if (result != null) {
      _showLoader = true;
      setState(() {});

      File file = File(result.files.single.path!);

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

      const uuii = Uuid();
      String fileName = uuii.v4();

      await ApiHelper.sendAudioFile(file, fileName);

      Map<String, dynamic> request = {
        'link': '~/images/Multimedia/$fileName.wav',
        'nroobra': _obra.nroObra,
        'observacion': '',
        'estante': 'App',
        'generadopor': widget.user.login,
        'modulo': widget.user.modulo,
        'nrolote': 'App',
        'sector': 'App',
        'latitud': null,
        'longitud': null,
        'tipodefoto': 20,
        'direccionfoto': '',
        'obra': _obra,
      };

      Response response = await ApiHelper.post(
        '/api/ObrasDocuments/ObrasDocumentMultimediaAudio',
        request,
      );

      if (!response.isSuccess) {
        await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ],
        );
        _showLoader = false;
        setState(() {});

        return;
      }
      _showSnackbar('Audio guardado con éxito');
      _getObra();
      setState(() {
        _showLoader = false;
      });
    }
  }

  //-------------------------------------------------------------
  //-------------------- _selectVideo ---------------------------
  //-------------------------------------------------------------

  Future<void> _selectVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      withData: true,
      allowedExtensions: ['mp4'],
    );

    if (result != null) {
      _showLoader = true;
      setState(() {});

      File file = File(result.files.single.path!);

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

      const uuii = Uuid();
      String fileName = uuii.v4();

      await ApiHelper.sendVideoFile(file, fileName);

      Map<String, dynamic> request = {
        'link': '~/images/Multimedia/$fileName.mp4',
        'nroobra': _obra.nroObra,
        'observacion': '',
        'estante': 'App',
        'generadopor': widget.user.login,
        'modulo': widget.user.modulo,
        'nrolote': 'App',
        'sector': 'App',
        'latitud': null,
        'longitud': null,
        'tipodefoto': 30,
        'direccionfoto': '',
        'obra': _obra,
      };

      Response response = await ApiHelper.post(
        '/api/ObrasDocuments/ObrasDocumentMultimediaVideo',
        request,
      );

      if (!response.isSuccess) {
        await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ],
        );
        _showLoader = false;
        setState(() {});

        return;
      }
      _showSnackbar('Video guardado con éxito');
      _getObra();
      setState(() {
        _showLoader = false;
      });
    }
  }

  //---------------------------------------------------------------------
  //------------------------- _goAddMultimedia --------------------------
  //---------------------------------------------------------------------

  void _goAddMultimedia() async {
    if (widget.obra.finalizada == 1) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Obra Terminada. No se puede agregar multimedia.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }
    if (widget.user.habilitaFotos != 1) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Su usuario no está habilitado para agregar Multimedia.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    var response = await showAlertDialog(
      context: context,
      title: 'Confirmación',
      message: '¿Qué tipo de archivo desea guardar?',
      actions: <AlertDialogAction>[
        const AlertDialogAction(key: 'cancel', label: 'Cancelar'),
        const AlertDialogAction(key: 'audio', label: 'Audio'),
        const AlertDialogAction(key: 'video', label: 'Video'),
      ],
    );

    if (response == 'cancel') {
      return;
    }

    if (response == 'audio') {
      await _selectAudio();
    } else {
      await _selectVideo();
    }

    if (_photoChanged) {
      _addPicture();
    }
  }

  //---------------------------------------------------------------------------
  //-------------------------- _confirmDeleteAudio ----------------------------
  //---------------------------------------------------------------------------

  void _confirmDeleteAudio(ObrasDocumento obraDocumento) async {
    if (widget.user.habilitaFotos != 1) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Su usuario no está habilitado para eliminar Audios.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    if (widget.user.login != obraDocumento.generadoPor) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message:
            'Este audio (NROREGISTRO ${obraDocumento.nroregistro}) sólo puede ser eliminado por el Usuario que lo cargó (${obraDocumento.generadoPor}). De ser necesario borrarlo comuníquese con el administrador del Sistema.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    var response = await showAlertDialog(
      context: context,
      title: 'Confirmación',
      message: '¿Estas seguro de querer borrar este audio?',
      actions: <AlertDialogAction>[
        const AlertDialogAction(key: 'no', label: 'No'),
        const AlertDialogAction(key: 'yes', label: 'Sí'),
      ],
    );

    if (response == 'yes') {
      await _deleteMultimedia(obraDocumento);
    }
  }

  //---------------------------------------------------------------------------
  //-------------------------- _confirmDeleteVideo ----------------------------
  //---------------------------------------------------------------------------

  void _confirmDeleteVideo(ObrasDocumento obraDocumento) async {
    if (widget.user.habilitaFotos != 1) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Su usuario no está habilitado para eliminar Videos.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    if (widget.user.login != obraDocumento.generadoPor) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message:
            'Este video (NROREGISTRO ${obraDocumento.nroregistro}) sólo puede ser eliminado por el Usuario que lo cargó (${obraDocumento.generadoPor}). De ser necesario borrarlo comuníquese con el administrador del Sistema.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    var response = await showAlertDialog(
      context: context,
      title: 'Confirmación',
      message: '¿Estas seguro de querer borrar este video?',
      actions: <AlertDialogAction>[
        const AlertDialogAction(key: 'no', label: 'No'),
        const AlertDialogAction(key: 'yes', label: 'Sí'),
      ],
    );

    if (response == 'yes') {
      await _deleteMultimedia(obraDocumento);
    }
  }

  //---------------------------------------------------------------------------
  //-------------------------- _deleteMultimedia ------------------------------
  //---------------------------------------------------------------------------

  Future<void> _deleteMultimedia(ObrasDocumento obraDocumento) async {
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

    Response response = await ApiHelper.delete(
      '/api/ObrasDocuments/',
      obraDocumento.nroregistro.toString(),
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
      _getObra();
    });
  }

  //---------------------------------------------------------------
  //----------------------- _showEstado -------------------------
  //---------------------------------------------------------------

  Widget _showEstado() {
    return Row(
      children: [
        const SizedBox(
          width: 75,
          child: Text(
            'Estado: ',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF781f1e),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF781f1e), width: 1),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 30,
            child: DropdownButtonFormField(
              items: _estados,
              initialValue: _optionEstado,
              onChanged: (option) {
                setState(() {
                  _optionEstado = option as String;
                  _estado = option.toString();
                  _subestado = 'Elija un Subestado...';
                  _optionSubestado = 'Elija un Subestado...';
                });
              },
              decoration: const InputDecoration.collapsed(
                hintText: 'Elija un Estado...',
                //labelText: '',
                fillColor: Colors.white,
                filled: true,
                //errorText: _optionEstadoShowError ? _optionEstadoError : null,
                //border:OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _getComboEstados --------------------------
  //-----------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboEstados() {
    List<DropdownMenuItem<String>> list = [];
    list.add(
      const DropdownMenuItem(
        value: 'Elija un Estado...',
        child: Text('Elija un Estado...'),
      ),
    );

    for (var estado in widget.estados) {
      list.add(
        DropdownMenuItem(
          value: estado.codigo,
          child: Text(estado.descripcion!.replaceAll('  ', '')),
        ),
      );
    }

    return list;
  }

  //---------------------------------------------------------------
  //----------------------- _showSubestado ------------------------
  //---------------------------------------------------------------

  Widget _showSubestado() {
    return Row(
      children: [
        const SizedBox(
          width: 75,
          child: Text(
            'SubEstado: ',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF781f1e),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF781f1e), width: 1),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 30,
            child: DropdownButtonFormField(
              items: _getComboSubestados(),
              initialValue: _optionSubestado,
              onChanged: (option) {
                setState(() {
                  _optionSubestado = option as String;
                  _subestado = option.toString();
                });
              },
              decoration: const InputDecoration.collapsed(
                hintText: 'Elija un Subestado...',
                //labelText: '',
                fillColor: Colors.white,
                filled: true,
                //errorText:_optionSubestadoShowError ? _optionSubestadoError : null,
                //border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _getComboSubestados -----------------------
  //-----------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboSubestados() {
    List<DropdownMenuItem<String>> list = [];
    list.add(
      const DropdownMenuItem(
        value: 'Elija un Subestado...',
        child: Text('Elija un Subestado...'),
      ),
    );

    for (var subestado in widget.subestados) {
      if (subestado.codigoestado == _optionEstado) {
        list.add(
          DropdownMenuItem(
            value: subestado.codigosubestado,
            child: Text(subestado.descripcion!.replaceAll('  ', '')),
          ),
        );
      }
    }

    return list;
  }

  List<DropdownMenuItem<String>> _getComboSubestadosIni() {
    List<DropdownMenuItem<String>> list = [];
    list.add(
      const DropdownMenuItem(
        value: 'Elija un Subestado...',
        child: Text('Elija un Subestado...'),
      ),
    );

    for (var subestado in widget.subestados) {
      if (subestado.codigoestado == _optionEstado) {
        list.add(
          DropdownMenuItem(
            value: subestado.codigosubestado,
            child: Text(subestado.descripcion!.replaceAll('  ', '')),
          ),
        );
      }
    }
    _subestadoexistente = _optionSubestado;
    _optionSubestado = 'Elija un Subestado...';

    for (var subest in list) {
      if (subest.value == _subestadoexistente) {
        _optionSubestado = _subestadoexistente;
        _hayErrorEstado = false;
      }
    }

    return list;
  }

  //--------------------------------------------------------
  //--------------------- _loadData ------------------------
  //--------------------------------------------------------

  void _loadData() {
    _estados = _getComboEstados();
    _subestados = _getComboSubestadosIni();
  }
}
