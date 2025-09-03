import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../screens.dart';

class Elementosencallelistado extends StatefulWidget {
  final User user;
  final Position positionUser;
  const Elementosencallelistado({
    super.key,
    required this.user,
    required this.positionUser,
  });

  @override
  State<Elementosencallelistado> createState() =>
      _ElementosencallelistadoState();
}

class _ElementosencallelistadoState extends State<Elementosencallelistado> {
  //---------------------------------------------------------------------
  //-------------------------- Variables --------------------------------
  //---------------------------------------------------------------------

  List<ElemEnCalleDet> _elemEnCalleDet = [];

  bool _showLoader = false;
  List<ElemEnCalle> _elemEnCalle = [];
  final Set<Marker> _markers = {};

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  ElemEnCalle _elemEnCalleSeleccionada = ElemEnCalle(
    idelementocab: 0,
    nroobra: 0,
    nombreObra: '',
    idusercarga: 0,
    nombreCarga: '',
    apellidoCarga: '',
    fechaCarga: '',
    grxx: '',
    gryy: '',
    domicilio: '',
    observacion: '',
    linkfoto: '',
    imageFullPath: '',
    estado: '',
    cantItems: 0,
  );

  //---------------------------------------------------------------------
  //-------------------------- initState --------------------------------
  //---------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _getElemEnCalle();
  }

  //---------------------------------------------------------------------
  //-------------------------- Pantalla --------------------------------
  //---------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: const Text('Elementos en Calle'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(onPressed: _showMap, icon: const Icon(Icons.map)),
        ],
      ),
      body: Center(
        child: _showLoader
            ? const LoaderComponent(text: 'Por favor espere...')
            : _getContent(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF781f1e),
        onPressed: () => _addReporte(),
        child: const Icon(Icons.add, size: 38),
      ),
    );
  }

  //---------------------------------------------------------------------
  //------------------------------ _getContent --------------------------
  //---------------------------------------------------------------------

  Widget _getContent() {
    return Column(
      children: <Widget>[
        _showElemEnCalleCount(),
        Expanded(child: _elemEnCalle.isEmpty ? _noContent() : _getListView()),
      ],
    );
  }

  //-----------------------------------------------------------------------
  //------------------------------ _showObrasCount ------------------------
  //-----------------------------------------------------------------------

  Widget _showElemEnCalleCount() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 40,
      child: Row(
        children: [
          const Text(
            'Cantidad de Obras con Elementos en Calle: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _elemEnCalle.length.toString(),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  //-----------------------------------------------------------------------
  //------------------------------ _noContent -----------------------------
  //-----------------------------------------------------------------------

  Widget _noContent() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: const Center(
        child: Text(
          'No hay Obras con Elementos en Calle',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //-----------------------------------------------------------------------
  //------------------------------ _getListView ---------------------------
  //-----------------------------------------------------------------------

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getElemEnCalle,
      child: ListView(
        children: _elemEnCalle.map((e) {
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
                                        e.nroobra.toString(),
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
                                        e.nombreObra,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Text(
                                      'Domicilio: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.domicilio,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Text(
                                      'Items: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.cantItems.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Text(
                                      'Usuario: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${e.nombreCarga} ${e.apellidoCarga}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Text(
                                      'Fecha: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        DateFormat(
                                          'dd/MM/yyyy',
                                        ).format(DateTime.parse(e.fechaCarga)),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
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
                  Column(
                    children: [
                      (widget.user.idUsuario == e.idusercarga)
                          ? IconButton(
                              icon: const CircleAvatar(
                                backgroundColor: Color(0xFF781f1e),
                                child: Icon(
                                  Icons.edit,
                                  size: 24,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () async {
                                _goElemEnCalle(e);
                              },
                            )
                          : Container(),
                      (widget.user.idUsuario == e.idusercarga)
                          ? IconButton(
                              icon: const CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.delete,
                                  size: 24,
                                  color: Colors.red,
                                ),
                              ),
                              onPressed: () async {
                                _goDeleteElemEnCalle(e);
                              },
                            )
                          : Container(),
                      IconButton(
                        icon: const CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.assignment_return,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          _goRecElemEnCalle(e);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _addReporte -------------------------------
  //-----------------------------------------------------------------

  void _addReporte() async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Elementosencalle(
          user: widget.user,
          positionUser: widget.positionUser,
        ),
      ),
    );
    if (result != 'xyz') {
      _getElemEnCalle();
    }
  }

  //---------------------------------------------------------------
  //----------------------- _getElemEnCalle -----------------------
  //---------------------------------------------------------------

  Future<void> _getElemEnCalle() async {
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

    response = await ApiHelper.getElemEnCalle();

    if (!response.isSuccess) {
      final _ = await showAlertDialog(
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
      _elemEnCalle = response.result;
      _elemEnCalle.sort((a, b) {
        return a.idelementocab.toString().toLowerCase().compareTo(
          b.idelementocab.toString().toLowerCase(),
        );
      });
      _showLoader = false;
    });
  }

  //---------------------------------------------------------------
  //----------------------- _goElemEnCalle ------------------------
  //---------------------------------------------------------------

  void _goElemEnCalle(ElemEnCalle elemEnCalle) async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Elementosencalleedit(
          user: widget.user,
          positionUser: widget.positionUser,
          elemEnCalle: elemEnCalle,
        ),
      ),
    );
    if (result == 'yes' || result != 'yes') {
      _getElemEnCalle();
      setState(() {});
    }
  }

  //---------------------------------------------------------------
  //----------------------- _goRecElemEnCalle ------------------------
  //---------------------------------------------------------------

  void _goRecElemEnCalle(ElemEnCalle elemEnCalle) async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Elementosencallerec(
          user: widget.user,
          positionUser: widget.positionUser,
          elemEnCalle: elemEnCalle,
        ),
      ),
    );
    if (result == 'yes' || result != 'yes') {
      _getElemEnCalle();
    }
  }

  //---------------------------------------------------------------
  //----------------------- _goDeleteElemEnCalle ------------------
  //---------------------------------------------------------------

  void _goDeleteElemEnCalle(ElemEnCalle elemEnCalle) async {
    var response = await showAlertDialog(
      context: context,
      title: 'Aviso',
      message: '¿Está seguro de borrar este registro?',
      actions: <AlertDialogAction>[
        const AlertDialogAction(key: 'si', label: 'SI'),
        const AlertDialogAction(key: 'no', label: 'NO'),
      ],
    );
    if (response == 'no') {
      return;
    }
    _deleteElemEnCalle(elemEnCalle);
  }

  //---------------------------------------------------------------
  //----------------------- _goDeleteElemEnCalle ------------------
  //---------------------------------------------------------------

  void _deleteElemEnCalle(ElemEnCalle elemEnCalle) async {
    await _loadDetalles(elemEnCalle);

    //-----------------Borra Detalle--------------
    for (ElemEnCalleDet _elem in _elemEnCalleDet) {
      await ApiHelper.delete('/api/ElementosEnCalleDet/', _elem.id.toString());
    }

    await ApiHelper.delete(
      '/api/ElementosEnCalleCab/',
      elemEnCalle.idelementocab.toString(),
    );

    _getElemEnCalle();
    setState(() {});
  }

  //-----------------------------------------------------------------
  //--------------------- _loadDetalles -----------------------------
  //-----------------------------------------------------------------

  Future<void> _loadDetalles(ElemEnCalle elemEnCalle) async {
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
      elemEnCalle.idelementocab.toString(),
    );

    if (!response.isSuccess) {
      final _ = await showAlertDialog(
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
    });
  }

  //---------------------------------------------------------------
  //----------------------- _showMap ------------------------------
  //---------------------------------------------------------------

  void _showMap() {
    if (_elemEnCalle.isEmpty) {
      return;
    }

    _markers.clear();

    double latmin = 180.0;
    double latmax = -180.0;
    double longmin = 180.0;
    double longmax = -180.0;

    for (ElemEnCalle elemEnCalle in _elemEnCalle) {
      var lat = double.tryParse(elemEnCalle.grxx.toString()) ?? 0;
      var long = double.tryParse(elemEnCalle.gryy.toString()) ?? 0;

      if (lat.toString().length > 3 && long.toString().length > 3) {
        if (lat < latmin) {
          latmin = lat;
        }
        if (lat > latmax) {
          latmax = lat;
        }
        if (long < longmin) {
          longmin = long;
        }
        if (long > longmax) {
          longmax = long;
        }

        Marker marker = Marker(
          markerId: MarkerId(elemEnCalle.nroobra.toString()),
          position: LatLng(lat, long),
          // infoWindow: InfoWindow(
          //   title:
          //       '${obraReparo.direccion.toString()} ${obraReparo.altura.toString()}',
          //   snippet: obraReparo.direccion.toString(),
          // ),
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
              Container(
                padding: const EdgeInsets.all(5),
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.info),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Obra Nº: ${elemEnCalle.nroobra.toString()}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Nombre Obra: ${elemEnCalle.nombreObra.toString()}',
                              maxLines: 3,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Domicilio: ${elemEnCalle.domicilio.toString()}',
                              maxLines: 3,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Items.: ${elemEnCalle.cantItems.toString()}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFb3b3b4),
                                    minimumSize: const Size(
                                      double.infinity,
                                      30,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  onPressed: () => _navegar(elemEnCalle),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.map, color: Color(0xff282886)),
                                      SizedBox(width: 5),
                                      Text(
                                        'Navegar',
                                        style: TextStyle(
                                          color: Color(0xff282886),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFb3b3b4),
                                    minimumSize: const Size(
                                      double.infinity,
                                      30,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  onPressed: () => _goElemEnCalle2(elemEnCalle),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'Abrir',
                                        style: TextStyle(
                                          color: Color(0xff282886),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Color(0xff282886),
                                      ),
                                    ],
                                  ),
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
              LatLng(lat, long),
            );
          },
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        );

        _markers.add(marker);
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ElemenEnCalleMapScreen(
          user: widget.user,
          positionUser: widget.positionUser,
          //posicion: LatLng(latcenter, longcenter),
          posicion: LatLng(
            widget.positionUser.latitude,
            widget.positionUser.longitude,
          ),
          markers: _markers,
          customInfoWindowController: _customInfoWindowController,
        ),
      ),
    );
  }

  //-------------------------------------------------------------------------
  //-------------------------- _navegar -------------------------------------
  //-------------------------------------------------------------------------

  Future<void> _navegar(ElemEnCalle elemEnCalle) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      var latt = double.tryParse(elemEnCalle.grxx.toString());
      var long = double.tryParse(elemEnCalle.gryy.toString());
      var uri = Uri.parse('google.navigation:q=$latt,$long&mode=d');
      if (await canLaunch(uri.toString())) {
        await launch(uri.toString());
      } else {
        throw 'Could not launch ${uri.toString()}';
      }
    } else {
      final _ = await showAlertDialog(
        context: context,
        title: 'Aviso!',
        message: 'Necesita estar conectado a Internet para acceder al mapa',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
    }
  }

  //-------------------------------------------------------------------
  //-------------------------- _goElemEnCalle -------------------------
  //-------------------------------------------------------------------

  void _goElemEnCalle2(ElemEnCalle elementoEnCalle) async {
    for (ElemEnCalle elem in _elemEnCalle) {
      if (elem.nroobra == elementoEnCalle.nroobra) {
        _elemEnCalleSeleccionada = elem;
      }
    }

    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Elementosencallerec(
          user: widget.user,
          elemEnCalle: _elemEnCalleSeleccionada,
          positionUser: widget.positionUser,
        ),
      ),
    );
    if (result == 'Yes' || result != 'Yes') {
      _getElemEnCalle();
      setState(() {});
    }
  }
}
