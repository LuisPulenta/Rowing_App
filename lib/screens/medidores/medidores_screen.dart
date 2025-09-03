import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../helpers/resize_image.dart';
import '../../models/models.dart';
import '../screens.dart';

class MedidoresScreen extends StatefulWidget {
  final User user;
  const MedidoresScreen({super.key, required this.user});

  @override
  _MedidoresScreenState createState() => _MedidoresScreenState();
}

class _MedidoresScreenState extends State<MedidoresScreen> {
  //---------------------------------------------------------------
  //----------------------- Variables -----------------------------
  //---------------------------------------------------------------

  bool _showLoader = false;
  bool _photoChanged = false;
  bool _enabled = false;
  final bool _codigoShowError = false;

  int _current = 0;

  late XFile _image;
  late Photo _photo;
  late Ticket _ticket;
  late Ticket _ticketVacio;

  //String _codigo = 'SE0012641832';
  String _codigo = '';
  final String _codigoError = '';
  final TextEditingController _codigoController = TextEditingController();

  List<ObrasDocumento> _obrasDocumentos = [];

  final CarouselSliderController _carouselController =
      CarouselSliderController();

  String _medidor = '';
  String _medidorError = '';
  bool _medidorShowError = false;
  final TextEditingController _medidorController = TextEditingController();

  String _precinto = '';
  String _precintoError = '';
  bool _precintoShowError = false;
  final TextEditingController _precintoController = TextEditingController();

  String _cajaDAE = '';
  String _cajaDAEError = '';
  bool _cajaDAEShowError = false;
  final TextEditingController _cajaDAEController = TextEditingController();

  String _lindero1 = '';
  String _lindero1Error = '';
  bool _lindero1ShowError = false;
  final TextEditingController _lindero1Controller = TextEditingController();

  String _lindero2 = '';
  String _lindero2Error = '';
  bool _lindero2ShowError = false;
  final TextEditingController _lindero2Controller = TextEditingController();

  String _observaciones = '';
  String _observacionesError = '';
  bool _observacionesShowError = false;
  final TextEditingController _observacionesController =
      TextEditingController();

  //---------------------------------------------------------------
  //----------------------- initState -----------------------------
  //---------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _ticket = Ticket(
      nroregistro: 0,
      nroobra: 0,
      asticket: '',
      cliente: '',
      direccion: '',
      numeracion: '',
      localidad: '',
      telefono: '',
      tipoImput: '',
      certificado: '',
      serieMedidorColocado: '',
      precinto: '',
      cajaDAE: '',
      idActaCertif: 0,
      observaciones: '',
      lindero1: '',
      lindero2: '',
      zona: '',
      terminal: '',
      subcontratista: '',
      causanteC: '',
      grxx: '',
      gryy: '',
      idUsrIn: 0,
      observacionAdicional: '',
      fechaCarga: '',
      riesgoElectrico: '',
      fechaasignacion: '',
      mes: 0,
    );

    _ticketVacio = _ticket;
  }

  //---------------------------------------------------------------
  //----------------------- Pantalla ------------------------------
  //---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(title: const Text('Medidores'), centerTitle: true),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 15,
                    margin: const EdgeInsets.all(5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[_showConsultaTicket()],
                      ),
                    ),
                  ),
                ),
                _showInfoTicket(),
                const Divider(height: 3, color: Colors.white),
                const SizedBox(height: 10),
                _showCampos(),
                const SizedBox(height: 10),
                _showButton(),
                const SizedBox(height: 10),
                const Divider(height: 3, color: Colors.white),
                _showPhotosCarousel(),
                _showImageButtons(),
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

  //-----------------------------------------------------------------------
  //-------------------------- _showConsultaTicket ------------------------
  //-----------------------------------------------------------------------

  Widget _showConsultaTicket() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _codigoController,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: 'Ingrese N° de Ticket...',
              labelText: 'N° de Ticket:',
              errorText: _codigoShowError ? _codigoError : null,
              prefixIcon: const Icon(Icons.confirmation_number),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) {
              _codigo = value;
            },
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF781f1e),
            minimumSize: const Size(50, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onPressed: () => _search(),
          child: const Icon(Icons.search),
        ),
      ],
    );
  }

  //--------------------------------------------------------------------------
  //-------------------------- _showInfoTicket -------------------------------
  //--------------------------------------------------------------------------

  Widget _showInfoTicket() {
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
                const Icon(Icons.person, color: Colors.blue),
                const Text(
                  'Cliente: ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF781f1e),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    _ticket.cliente == null ? '' : _ticket.cliente.toString(),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.directions, color: Colors.blue),
                const Text(
                  'Dirección: ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF781f1e),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    _ticket.direccion == null
                        ? ''
                        : _ticket.direccion.toString(),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.blue),
                const Text(
                  'Teléfono: ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF781f1e),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    _ticket.telefono == null ? '' : _ticket.telefono.toString(),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //-----------------------------------------------------------------------
  //-------------------------- _showCampos --------------------------------
  //-----------------------------------------------------------------------

  Widget _showCampos() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 15,
      margin: const EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextField(
                controller: _medidorController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Ingrese Serie Medidor colocado:...',
                  labelText: 'Serie Medidor colocado:',
                  errorText: _medidorShowError ? _medidorError : null,
                  prefixIcon: const Icon(Icons.pin),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  _medidor = value;
                },
                enabled: _enabled,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextField(
                controller: _precintoController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Ingrese Precinto...',
                  labelText: 'Precinto:',
                  errorText: _precintoShowError ? _precintoError : null,
                  prefixIcon: const Icon(Icons.tag),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  _precinto = value;
                },
                enabled: _enabled,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextField(
                controller: _cajaDAEController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Ingrese Caja DAE...',
                  labelText: 'Caja DAE:',
                  errorText: _cajaDAEShowError ? _cajaDAEError : null,
                  prefixIcon: const Icon(Icons.inbox),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  _cajaDAE = value;
                },
                enabled: _enabled,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextField(
                controller: _lindero1Controller,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Ingrese Lindero 1...',
                  labelText: 'Lindero 1:',
                  errorText: _lindero1ShowError ? _lindero1Error : null,
                  prefixIcon: const Icon(Icons.looks_one),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  _lindero1 = value;
                },
                enabled: _enabled,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextField(
                controller: _lindero2Controller,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Ingrese Lindero 2...',
                  labelText: 'Lindero 2:',
                  errorText: _lindero2ShowError ? _lindero2Error : null,
                  prefixIcon: const Icon(Icons.looks_two),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  _lindero2 = value;
                },
                enabled: _enabled,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextField(
                controller: _observacionesController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Ingrese Observaciones...',
                  labelText: 'Observaciones:',
                  errorText: _observacionesShowError
                      ? _observacionesError
                      : null,
                  prefixIcon: const Icon(Icons.chat),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  _observaciones = value;
                },
                enabled: _enabled,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //-----------------------------------------------------------------------
  //-------------------------- _showButton --------------------------------
  //-----------------------------------------------------------------------

  Widget _showButton() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
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
              onPressed: _enabled ? _save : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.save),
                  SizedBox(width: 20),
                  Text('Guardar cambios'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //----------------------------------------------------------------------
  //-------------------------- _showPhotosCarousel -----------------------
  //----------------------------------------------------------------------

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
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        i.tipoDeFoto == 4
                            ? 'N° Medidor Colocado'
                            : i.tipoDeFoto == 5
                            ? 'Estado de medidor retirado'
                            : i.tipoDeFoto == 6
                            ? 'N° de precinto'
                            : i.tipoDeFoto == 7
                            ? 'N° de tapa o caja'
                            : i.tipoDeFoto == 8
                            ? 'Lindero 1'
                            : i.tipoDeFoto == 9
                            ? 'Lindero 2'
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
            children: _obrasDocumentos.asMap().entries.map((entry) {
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

  //---------------------------------------------------------------------------
  //-------------------------- _showImageButtons ------------------------------
  //---------------------------------------------------------------------------

  Widget _showImageButtons() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
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
              onPressed: _enabled ? _goAddPhoto : null,
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
              onPressed: _enabled ? _confirmDeletePhoto : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [Icon(Icons.delete), Text('Eliminar Foto')],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //---------------------------------------------------------------------
  //-------------------------- _goAddPhoto ------------------------------
  //---------------------------------------------------------------------

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

  //---------------------------------------------------------------------
  //-------------------------- _takePicture -----------------------------
  //---------------------------------------------------------------------

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
          builder: (context) => TakePicture2Screen(camera: firstCamera),
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

  //---------------------------------------------------------------------
  //-------------------------- _selectPicture ---------------------------
  //---------------------------------------------------------------------

  Future<void> _selectPicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image2 = await picker.pickImage(source: ImageSource.gallery);

    if (image2 != null) {
      _photoChanged = true;
      Response? response = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPicture2Screen(image: image2),
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

  //------------------------------------------------------------------
  //-------------------------- _addPicture ---------------------------
  //------------------------------------------------------------------

  void _addPicture() async {
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

    Map<String, dynamic> request33 = {
      'imagearray': base64Image,
      'nroobra': _ticket.nroobra,
      'idObrasPostes': _ticket.nroregistro,
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
    };

    Response response = await ApiHelper.post(
      '/api/ObrasDocuments/ObrasDocument2',
      request33,
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
      _search();
    });
  }

  //------------------------------------------------------------------
  //-------------------- _confirmDeletePhoto -------------------------
  //------------------------------------------------------------------

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

  //------------------------------------------------------------------
  //-------------------- _deletePhoto --------------------------------
  //------------------------------------------------------------------

  Future<void> _deletePhoto() async {
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
        message: 'Verifica que estes conectado a internet.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    Response response = await ApiHelper.delete(
      '/api/ObrasDocuments/',
      _obrasDocumentos[_current].nroregistro.toString(),
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
      _search();
    });
  }

  //-------------------------------------------------------------
  //-------------------- _search --------------------------------
  //-------------------------------------------------------------

  Future<void> _search() async {
    FocusScope.of(context).unfocus();
    if (_codigo.isEmpty) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Ingrese un Ticket.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }
    await _getTicket();

    _current = 0;
    setState(() {
      _showLoader = false;
      _carouselController.jumpToPage(0);
    });
  }

  //-------------------------------------------------------------
  //-------------------- _getTicket -----------------------------
  //-------------------------------------------------------------

  Future<void> _getTicket() async {
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
        message: 'Verifica que estes conectado a internet.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    Response response = await ApiHelper.getTicket(_codigo);

    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'N° de Ticket no válido',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );

      setState(() {
        _ticket = _ticketVacio;
        _medidor = _ticket.serieMedidorColocado.toString();
        _precinto = _ticket.precinto.toString();
        _cajaDAE = _ticket.cajaDAE.toString();
        _lindero1 = _ticket.lindero1.toString();
        _lindero2 = _ticket.lindero2.toString();
        _observaciones = _ticket.observaciones.toString();
        _medidorController.text = _medidor;
        _precintoController.text = _precinto;
        _cajaDAEController.text = _cajaDAE;
        _lindero1Controller.text = _lindero1;
        _lindero2Controller.text = _lindero2;
        _observacionesController.text = _observaciones;
        _enabled = true;
        _showLoader = false;
        _enabled = false;
      });
      return;
    }
    _ticket = response.result;

    if (_ticket.idActaCertif != 0) {
      await showAlertDialog(
        context: context,
        title: 'Aviso',
        message: 'Este medidor ya fue certificado',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );

      setState(() {
        _ticket = _ticketVacio;
        _medidor = _ticket.serieMedidorColocado.toString();
        _precinto = _ticket.precinto.toString();
        _cajaDAE = _ticket.cajaDAE.toString();
        _lindero1 = _ticket.lindero1.toString();
        _lindero2 = _ticket.lindero2.toString();
        _observaciones = _ticket.observaciones.toString();
        _medidorController.text = _medidor;
        _precintoController.text = _precinto;
        _cajaDAEController.text = _cajaDAE;
        _lindero1Controller.text = _lindero1;
        _lindero2Controller.text = _lindero2;
        _observacionesController.text = _observaciones;
        _enabled = true;
        _showLoader = false;
        _enabled = false;
      });
      return;
    }

    Response response2 = await ApiHelper.getObrasDocumentos(
      _ticket.nroregistro.toString(),
    );

    _obrasDocumentos = response2.result;
    _obrasDocumentos.sort((a, b) {
      return a.tipoDeFoto.toString().toLowerCase().compareTo(
        b.tipoDeFoto.toString().toLowerCase(),
      );
    });

    setState(() {
      _showLoader = false;
      _ticket = response.result;
      _medidor = _ticket.serieMedidorColocado.toString();
      _precinto = _ticket.precinto.toString();
      _cajaDAE = _ticket.cajaDAE.toString();
      _lindero1 = _ticket.lindero1.toString();
      _lindero2 = _ticket.lindero2.toString();
      _observaciones = _ticket.observaciones.toString();
      _medidorController.text = _medidor;
      _precintoController.text = _precinto;
      _cajaDAEController.text = _cajaDAE;
      _lindero1Controller.text = _lindero1;
      _lindero2Controller.text = _lindero2;
      _observacionesController.text = _observaciones;
      _enabled = true;
    });
  }

  //--------------------------------------------------------
  //-------------------- _save -----------------------------
  //--------------------------------------------------------

  void _save() {
    if (!validateFields()) {
      return;
    }
    _saveRecord();
  }

  //-----------------------------------------------------------------
  //-------------------- validateFields -----------------------------
  //-----------------------------------------------------------------

  bool validateFields() {
    bool isValid = true;

    if (_medidor.isNotEmpty) {
      if (_medidor.length > 20) {
        isValid = false;
        _medidorShowError = true;
        _medidorError =
            'Serie de Medidor colocado no puede tener más de 20 caracteres';
      } else {
        _medidorShowError = false;
      }
    }

    if (_precinto.isNotEmpty) {
      if (_precinto.length > 20) {
        isValid = false;
        _precintoShowError = true;
        _precintoError = 'Precinto no puede tener más de 20 caracteres';
      } else {
        _precintoShowError = false;
      }
    }

    if (_cajaDAE.isNotEmpty) {
      if (_cajaDAE.length > 20) {
        isValid = false;
        _cajaDAEShowError = true;
        _cajaDAEError = 'CajaDAE no puede tener más de 20 caracteres';
      } else {
        _cajaDAEShowError = false;
      }
    }

    if (_lindero1.isNotEmpty) {
      if (_lindero1.length > 50) {
        isValid = false;
        _lindero1ShowError = true;
        _lindero1Error = 'Lindero1 no puede tener más de 50 caracteres';
      } else {
        _medidorShowError = false;
      }
    }

    if (_lindero1.isNotEmpty) {
      if (_lindero2.length > 50) {
        isValid = false;
        _lindero2ShowError = true;
        _lindero2Error = 'Lindero2 no puede tener más de 50 caracteres';
      } else {
        _medidorShowError = false;
      }
    }

    if (_lindero1.isNotEmpty) {
      if (_observaciones.length > 500) {
        isValid = false;
        _observacionesShowError = true;
        _observacionesError =
            'Observaciones no puede tener más de 500 caracteres';
      } else {
        _medidorShowError = false;
      }
    }

    setState(() {});

    return isValid;
  }

  //--------------------------------------------------------------
  //-------------------- _saveRecord -----------------------------
  //--------------------------------------------------------------

  Future<void> _saveRecord() async {
    setState(() {
      _showLoader = true;
    });

    Map<String, dynamic> request = {
      'nroregistro': _ticket.nroregistro,
      'nroobra': _ticket.nroobra,
      'asticket': _ticket.asticket,
      'cliente': _ticket.cliente,
      'direccion': _ticket.direccion,
      'numeracion': _ticket.numeracion,
      'localidad': _ticket.localidad,
      'telefono': _ticket.telefono,
      'tipoImput': _ticket.tipoImput,
      'certificado': _ticket.certificado,
      'serieMedidorColocado': _medidor,
      'precinto': _precinto,
      'cajaDAE': _cajaDAE,
      'observaciones': _observaciones,
      'lindero1': _lindero1,
      'lindero2': _lindero2,
      'zona': _ticket.zona,
      'terminal': _ticket.terminal,
      'subcontratista': _ticket.subcontratista,
      'causanteC': _ticket.causanteC,
      'grxx': _ticket.grxx,
      'gryy': _ticket.gryy,
      'idUsrIn': _ticket.idUsrIn,
      'observacionAdicional': _ticket.observacionAdicional,
      'fechaCarga': _ticket.fechaCarga,
      'riesgoElectrico': _ticket.riesgoElectrico,
      'fechaasignacion': _ticket.fechaasignacion,
      'mes': _ticket.mes,
      'fechaActualizada': DateTime.now().toString().substring(0, 10),
      'iDUsrAcualiza': widget.user.idUsuario,
      'provieneAct': 'APP',
    };

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

    Response response = await ApiHelper.put(
      '/api/ObrasPostes/',
      _ticket.nroregistro.toString(),
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
    _codigo = '';
    _codigoController.text = '';
    _ticket = _ticketVacio;
    _medidor = '';
    _medidorController.text = '';
    _precinto = '';
    _precintoController.text = '';
    _cajaDAE = '';
    _cajaDAEController.text = '';
    _lindero1 = '';
    _lindero1Controller.text = '';
    _lindero2 = '';
    _lindero2Controller.text = '';
    _observaciones = '';
    _observacionesController.text = '';

    setState(() {});
  }
}
