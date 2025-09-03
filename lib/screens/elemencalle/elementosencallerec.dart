import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:camera/camera.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../screens.dart';

class Elementosencallerec extends StatefulWidget {
  final User user;
  final Position positionUser;
  final ElemEnCalle elemEnCalle;

  const Elementosencallerec({
    super.key,
    required this.user,
    required this.positionUser,
    required this.elemEnCalle,
  });

  @override
  State<Elementosencallerec> createState() => _ElementosencallerecState();
}

class _ElementosencallerecState extends State<Elementosencallerec> {
  //---------------------------------------------------------------------
  //-------------------------- Variables --------------------------------
  //---------------------------------------------------------------------

  final int _nroReg = 0;
  int _nroObra = 0;
  String _nombreObra = '';
  String _estado = '';

  List<ElemEnCalleDet> _elemEnCalleDet = [];

  String _cantidad = '';
  final String _cantidadError = '';
  final bool _cantidadShowError = false;
  final TextEditingController _cantidadController = TextEditingController();

  List<Catalogo> _catalogos = [];
  List<Catalogo> _catalogos2 = [];

  late XFile _image;

  late Obra obra2;

  bool _photoChanged = false;

  String _observaciones = '';
  final String _observacionesError = '';
  final bool _observacionesShowError = false;
  final TextEditingController _observacionesController =
      TextEditingController();

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

  LatLng _center = const LatLng(0, 0);

  bool _showLoader = false;

  double latitud = 0;
  double longitud = 0;

  String _direccion = '';
  final String _direccionError = '';
  final bool _direccionShowError = false;
  final TextEditingController _direccionController = TextEditingController();

  Obra obra = Obra(
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

  //---------------------------------------------------------------------
  //-------------------------- initState --------------------------------
  //---------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _loadPositionUser();
    _loadData();
  }

  void _loadPositionUser() async {
    _positionUser = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _center = LatLng(_positionUser.latitude, _positionUser.longitude);
  }

  //---------------------------------------------------------------------
  //-------------------------- Pantalla --------------------------------
  //---------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    double ancho = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 195, 191, 191),
      appBar: AppBar(
        title: const Text('Recuperar Elem. en Calle'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Card(
                color: Colors.white,
                shadowColor: Colors.white,
                elevation: 10,
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _showObra(),
                      _showAddress(),
                      _showObservaciones(),
                      _showPhoto(ancho),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 3),
              const Divider(color: Colors.black),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Text(
                    'Material               ',
                    style: TextStyle(color: Colors.black),
                  ),
                  Text('Cant. Dejada', style: TextStyle(color: Colors.black)),
                  Text(
                    'Recup.                  ',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Expanded(child: _getListView()),
              _showButtons(),
              const SizedBox(height: 10),
            ],
          ),
          _showLoader
              ? const LoaderComponent(text: 'Por favor espere...')
              : Container(),
        ],
      ),
    );
  }
  //-----------------------------------------------------------
  //--------------------- _showObra ---------------------------
  //-----------------------------------------------------------

  Widget _showObra() {
    return Row(
      children: [
        const Text(
          'Obra: ',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF781f1e),
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            widget.elemEnCalle.nombreObra,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  //----------------------------------------------------------------------
  //------------------------------ _showAddress --------------------------
  //----------------------------------------------------------------------

  Widget _showAddress() {
    return Row(
      children: [
        const Text(
          'Dirección: ',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF781f1e),
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            widget.elemEnCalle.domicilio,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
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
      return;
    }

    if (_habilitaPosicion) {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _center.latitude,
        _center.longitude,
      );
      latitud = _center.latitude;
      longitud = _center.longitude;
      _direccionController.text =
          '${placemarks[0].thoroughfare} ${placemarks[0].name} ${placemarks[0].locality}';
      _direccion = _direccionController.text;
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

  //----------------------------------------------------------------------------
  //------------------------------ _showObservaciones --------------------------
  //----------------------------------------------------------------------------

  Widget _showObservaciones() {
    return Row(
      children: [
        const Text(
          'Observaciones: ',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF781f1e),
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            widget.elemEnCalle.observacion,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  //--------------------------------------------------------------
  //-------------------------- _showPhoto ------------------------
  //--------------------------------------------------------------

  Widget _showPhoto(double ancho) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                Container(
                  child: !_photoChanged
                      ? Center(
                          child: FadeInImage(
                            width: 160,
                            height: 120,
                            placeholder: const AssetImage('assets/loading.gif'),
                            image: NetworkImage(
                              widget.elemEnCalle.imageFullPath,
                            ),
                          ),
                        )
                      : Center(
                          child: Image.file(
                            File(_image.path),
                            width: 160,
                            height: 120,
                            fit: BoxFit.contain,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
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
      if (response != null) {
        if (opcion == 1) {
          _photoChanged = true;
          _image = response.result;
        }
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
      if (opcion == 1) {
        _photoChanged = true;
        _image = image;
      }
      setState(() {});
    }
  }

  //-----------------------------------------------------------------
  //--------------------- _getCatalogos -----------------------------
  //-----------------------------------------------------------------

  Future<void> _getCatalogos() async {
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

    response = await ApiHelper.GetCatalogosEnCalle(widget.user.modulo);

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
      _catalogos = response.result;
    });
  }

  //-----------------------------------------------------------------
  //--------------------- _getListView ------------------------------
  //-----------------------------------------------------------------

  Widget _getListView() {
    return ListView(
      children: _catalogos.map((e) {
        return Card(
          color: const Color.fromARGB(255, 255, 255, 255),
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
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      e.catCatalogo.toString(),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      e.cantidad.toString(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      e.cantidad2.toString(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  IconButton(
                                    onPressed: () {
                                      _cantidadController.text =
                                          e.cantidad2 == 0.0
                                          ? ''
                                          : e.cantidad2.toString();
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.grey[300],
                                            title: const Text(
                                              'Ingrese la cantidad',
                                            ),
                                            content: TextField(
                                              autofocus: true,
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: _cantidadController,
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                filled: true,
                                                hintText: '',
                                                labelText: '',
                                                isDense: true,
                                                errorText: _cantidadShowError
                                                    ? _cantidadError
                                                    : null,
                                                prefixIcon: const Icon(
                                                  Icons.tag,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              onChanged: (value) {
                                                _cantidad = value;
                                              },
                                            ),
                                            actions: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            const Color(
                                                              0xFFB4161B,
                                                            ),
                                                        minimumSize: const Size(
                                                          double.infinity,
                                                          30,
                                                        ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                5,
                                                              ),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: const [
                                                          Icon(Icons.cancel),
                                                          Text('Cancelar'),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            const Color(
                                                              0xFF120E43,
                                                            ),
                                                        minimumSize: const Size(
                                                          double.infinity,
                                                          30,
                                                        ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                5,
                                                              ),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        for (Catalogo catalogo
                                                            in _catalogos) {
                                                          if (catalogo
                                                                  .catCodigo ==
                                                              e.catCodigo) {
                                                            catalogo.cantidad2 =
                                                                double.parse(
                                                                  _cantidad,
                                                                );
                                                          }
                                                        }

                                                        Navigator.pop(context);
                                                        setState(() {});
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: const [
                                                          Icon(Icons.save),
                                                          Text('Aceptar'),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          );
                                        },
                                        barrierDismissible: false,
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.loop,
                                      color: Colors.blue,
                                    ),
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
      }).toList(),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showButtons ------------------------------
  //-----------------------------------------------------------------

  Widget _showButtons() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[_showRecButton()],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[_showSaveButton()],
          ),
        ],
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showRecButton ---------------------------
  //-----------------------------------------------------------------

  Widget _showRecButton() {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 42, 120, 30),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        onPressed: () => _recTodo(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.assignment_return),
            SizedBox(width: 15),
            Text('Recuperar Todo'),
          ],
        ),
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showSaveButton ---------------------------
  //-----------------------------------------------------------------

  Widget _showSaveButton() {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF781f1e),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _save -------------------------------------
  //-----------------------------------------------------------------

  Future<void> _save() async {
    //-----------------Controlo que haya catálogos con cantidades--------------
    bool bandera = false;
    for (Catalogo catalogo in _catalogos) {
      if (catalogo.cantidad != catalogo.cantidad2) {
        bandera = true;
      }
    }

    if (bandera) {
      _estado = 'PARCIAL';
    } else {
      _estado = 'TOTAL';
    }

    //-----------------Grabar Cabecera y Detalle--------------

    //-----------------Chequea Internet--------------
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

    //-----------------Graba Cabecera--------------
    Map<String, dynamic> request = {
      'ID': widget.elemEnCalle.idelementocab,
      'NROOBRA': widget.elemEnCalle.nroobra,
      'IDUSERCARGA': widget.elemEnCalle.idusercarga,
      'FECHA': widget.elemEnCalle.fechaCarga.substring(0, 10),
      'GRXX': widget.elemEnCalle.grxx,
      'GRYY': widget.elemEnCalle.gryy,
      'DOMICILIO': widget.elemEnCalle.domicilio,
      'OBSERVACION': widget.elemEnCalle.observacion,
      'ESTADO': _estado,
      'IDUSERRECUPERA': widget.user.idUsuario,
      'ImageArray': '',
    };

    Response response = await ApiHelper.put(
      '/api/ElementosEnCalleCab/PutElementosEnCalleCab/',
      widget.elemEnCalle.idelementocab.toString(),
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
    }

    //-----------------Borra Detalle--------------
    for (ElemEnCalleDet _elem in _elemEnCalleDet) {
      Response response = await ApiHelper.delete(
        '/api/ElementosEnCalleDet/',
        _elem.id.toString(),
      );
    }

    //-----------------Graba Detalle--------------
    for (Catalogo catalogo in _catalogos) {
      if (catalogo.cantidad != 0) {
        bandera = true;
        Map<String, dynamic> request = {
          'IDELEMENTOCAB': widget.elemEnCalle.idelementocab,
          'CATSIAG': catalogo.catCodigo,
          'CATSAP': catalogo.codigoSap,
          'CANTDEJADA': catalogo.cantidad,
          'CANTRECUPERADA': catalogo.cantidad2,
        };

        Response response = await ApiHelper.post(
          '/api/ElementosEnCalleDet/PostElementosEnCalleDet',
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
        }
      }
    }

    await showAlertDialog(
      context: context,
      title: 'Aviso',
      message: 'Elementos en Calle guardado con éxito!',
      actions: <AlertDialogAction>[
        const AlertDialogAction(key: null, label: 'Aceptar'),
      ],
    );
    Navigator.pop(context);
  }

  //-----------------------------------------------------------------
  //--------------------- _loadData ---------------------------------
  //-----------------------------------------------------------------

  void _recTodo() async {
    for (Catalogo catalogo in _catalogos) {
      catalogo.cantidad2 = catalogo.cantidad;
    }
    setState(() {});
  }

  //-----------------------------------------------------------------
  //--------------------- _loadData ---------------------------------
  //-----------------------------------------------------------------

  void _loadData() async {
    await _getCatalogos();

    _nroObra = widget.elemEnCalle.nroobra;
    _nombreObra = widget.elemEnCalle.nombreObra;
    _direccion = widget.elemEnCalle.domicilio;
    _direccionController.text = _direccion;
    latitud = double.tryParse(widget.elemEnCalle.grxx)!;
    longitud = double.tryParse(widget.elemEnCalle.gryy)!;
    _observaciones = widget.elemEnCalle.observacion;
    _observacionesController.text = _observaciones;

    await _loadDetalles();

    for (Catalogo catalogo in _catalogos) {
      catalogo.cantidad = 0;
      catalogo.cantidad2 = 0;
    }

    for (Catalogo catalogo in _catalogos) {
      for (ElemEnCalleDet elem in _elemEnCalleDet) {
        if (elem.catsiag == catalogo.catCodigo) {
          catalogo.cantidad = elem.cantdejada;
        }
      }
    }

    _catalogos2 = [];

    for (Catalogo catalogo in _catalogos) {
      if (catalogo.cantidad! > 0) {
        _catalogos2.add(catalogo);
      }
    }
    _catalogos = _catalogos2;
    _catalogos2 = [];
  }

  //-----------------------------------------------------------------
  //--------------------- _loadDetalles -----------------------------
  //-----------------------------------------------------------------

  Future<void> _loadDetalles() async {
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

    response = await ApiHelper.getElemEnCalleDet(
      widget.elemEnCalle.idelementocab.toString(),
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
      return;
    }
    setState(() {
      _elemEnCalleDet = response.result;
      _elemEnCalleDet.sort((a, b) {
        return a.idelementocab.toString().toLowerCase().compareTo(
          b.idelementocab.toString().toLowerCase(),
        );
      });
      _showLoader = false;
    });
  }
}
