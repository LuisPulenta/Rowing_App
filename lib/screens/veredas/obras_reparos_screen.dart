import 'dart:math';

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

class ObrasReparosScreen extends StatefulWidget {
  final User user;
  final Position positionUser;
  const ObrasReparosScreen({
    super.key,
    required this.user,
    required this.positionUser,
  });

  @override
  _ObrasReparosScreenState createState() => _ObrasReparosScreenState();
}

class _ObrasReparosScreenState extends State<ObrasReparosScreen> {
  //---------------------------------------------------------------
  //----------------------- Variables -----------------------------
  //---------------------------------------------------------------

  List<ObrasReparo> _obras = [];
  List<ObrasReparo> _obrasReparosTodas = [];

  final int _clase = 0;
  final String _claseError = '';
  final bool _claseShowError = false;

  List<StandardReparo> _clases = [];

  bool _showLoader = false;
  bool _isFiltered = false;
  String _search = '';
  ObrasReparo obraSelected = ObrasReparo(
    nroregistro: 0,
    nroobra: 0,
    fechaalta: '',
    fechainicio: '',
    fechacumplimento: '',
    requeridopor: '',
    subcontratista: '',
    subcontratistareparo: '',
    codcausante: '',
    nroctoc: '',
    direccion: '',
    altura: '',
    latitud: '',
    longitud: '',
    codtipostdrparo: 0,
    estadosubcon: '',
    recursos: '',
    montodisponible: 0.0,
    grua: '',
    idUsuario: 0,
    terminal: '',
    observaciones: '',
    foto1: '',
    tipoVereda: '',
    cantidadMTL: 0,
    ancho: 0,
    profundidad: 0,
    fechaCierreElectrico: '',
    imageFullPath: '',
    fotoInicio: '',
    fotoFin: '',
    modulo: '',
    observacionesFotoInicio: '',
    observacionesFotoFin: '',
    fotoInicioFullPath: '',
    fotoFinFullPath: '',
    clase: '',
    ancho2: 0,
    largo2: 0,
  );

  ObrasReparo _obraSeleccionada = ObrasReparo(
    nroregistro: 0,
    nroobra: 0,
    fechaalta: '',
    fechainicio: '',
    fechacumplimento: '',
    requeridopor: '',
    subcontratista: '',
    subcontratistareparo: '',
    codcausante: '',
    nroctoc: '',
    direccion: '',
    altura: '',
    latitud: '',
    longitud: '',
    codtipostdrparo: 0,
    estadosubcon: '',
    recursos: '',
    montodisponible: 0.0,
    grua: '',
    idUsuario: 0,
    terminal: '',
    observaciones: '',
    foto1: '',
    tipoVereda: '',
    cantidadMTL: 0,
    ancho: 0,
    profundidad: 0,
    fechaCierreElectrico: '',
    imageFullPath: '',
    fotoInicio: '',
    fotoFin: '',
    modulo: '',
    observacionesFotoInicio: '',
    observacionesFotoFin: '',
    fotoInicioFullPath: '',
    fotoFinFullPath: '',
    clase: '',
    ancho2: 0,
    largo2: 0,
  );

  final Set<Marker> _markers = {};

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  //---------------------------------------------------------------
  //----------------------- initState -----------------------------
  //---------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _getClases();
  }

  //---------------------------------------------------------------
  //----------------------- Pantalla ------------------------------
  //---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: const Text('Veredas'),
        centerTitle: true,
        actions: <Widget>[
          _isFiltered
              ? IconButton(
                  onPressed: _removeFilter,
                  icon: const Icon(Icons.filter_none),
                )
              : IconButton(
                  onPressed: _showFilter,
                  icon: const Icon(Icons.filter_alt),
                ),
          IconButton(onPressed: _showMap, icon: const Icon(Icons.map)),
        ],
      ),
      body: Center(
        child: _showLoader
            ? const LoaderComponent(text: 'Por favor espere...')
            : _getContent(),
      ),
    );
  }

  //-----------------------------------------------------------------
  //------------------------------ _filter --------------------------
  //-----------------------------------------------------------------

  void _filter() {
    if (_search.isEmpty) {
      return;
    }
    List<ObrasReparo> filteredList = [];
    for (var obra in _obras) {
      if (obra.direccion!.toLowerCase().contains(_search.toLowerCase()) ||
          obra.nroobra.toString().toLowerCase().contains(
            _search.toLowerCase(),
          ) ||
          obra.modulo.toString().toLowerCase().contains(
            _search.toLowerCase(),
          )) {
        filteredList.add(obra);
      }
    }

    setState(() {
      _obras = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
  }

  //-----------------------------------------------------------------------
  //------------------------------ _removeFilter --------------------------
  //-----------------------------------------------------------------------

  void _removeFilter() {
    setState(() {
      _isFiltered = false;
    });
    _getObrasReparos();
  }

  //---------------------------------------------------------------------
  //------------------------------ _showFilter --------------------------
  //---------------------------------------------------------------------

  void _showFilter() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('Filtrar Veredas'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Escriba texto o números a buscar en Dirección o N° de Obra o Módulo: ',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 10),
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Criterio de búsqueda...',
                  labelText: 'Buscar',
                  suffixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  _search = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => _filter(),
              child: const Text('Filtrar'),
            ),
          ],
        );
      },
    );
  }

  //---------------------------------------------------------------------
  //------------------------------ _getContent --------------------------
  //---------------------------------------------------------------------

  Widget _getContent() {
    return Column(
      children: <Widget>[
        _showObrasCount(),
        Expanded(child: _obras.isEmpty ? _noContent() : _getListView()),
      ],
    );
  }

  //-----------------------------------------------------------------------
  //------------------------------ _showObrasCount ------------------------
  //-----------------------------------------------------------------------

  Widget _showObrasCount() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 40,
      child: Row(
        children: [
          const Text(
            'Cantidad de Veredas sin Fecha Cumplida: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _obras.length.toString(),
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
      child: Center(
        child: Text(
          _isFiltered
              ? 'No hay Veredas con ese criterio de búsqueda'
              : 'No hay Veredas registradas',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //-----------------------------------------------------------------------
  //------------------------------ _getListView ---------------------------
  //-----------------------------------------------------------------------

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getObrasReparos,
      child: ListView(
        children: _obras.map((e) {
          return Card(
            color: const Color(0xFFC7C7C8),
            shadowColor: Colors.white,
            elevation: 10,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: InkWell(
              onTap: () {
                obraSelected = e;
                _goInfoObra(e);
              },
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
                                        width: 110,
                                        child: Text(
                                          'N° Obra: ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF781f1e),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Text(
                                          e.nroobra.toString(),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      const Text(
                                        'Módulo: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      e.modulo != null
                                          ? Expanded(
                                              flex: 5,
                                              child: Text(
                                                e.modulo.toString(),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            )
                                          : const Expanded(
                                              flex: 5,
                                              child: Text(
                                                'SIN MODULO',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 110,
                                        child: Text(
                                          'Dirección: ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF0e4888),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${e.direccion!} ${e.altura}',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 110,
                                        child: Text(
                                          'Tipo Vereda: ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF0e4888),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          e.tipoVereda!,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 1),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 110,
                                        child: Text(
                                          'Clase Vereda: ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF0e4888),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          e.clase!,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 1),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 110,
                                        child: Text(
                                          'Mts. lineales: ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF0e4888),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          e.cantidadMTL.toString(),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 1),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 110,
                                        child: Text(
                                          'Ancho [cm]: ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF0e4888),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          e.ancho.toString(),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 1),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 110,
                                        child: Text(
                                          'Profundidad [cm]: ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF0e4888),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          e.profundidad.toString(),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        'Fec. Cierre Eléctr.: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF0e4888),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        child: e.fechaCierreElectrico != null
                                            ? Text(
                                                DateFormat('dd/MM/yyyy').format(
                                                  DateTime.parse(
                                                    e.fechaCierreElectrico
                                                        .toString(),
                                                  ),
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              )
                                            : Container(),
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
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  //-----------------------------------------------------------------------
  //------------------------------ _getObrasReparos -----------------------
  //-----------------------------------------------------------------------

  Future<void> _getObrasReparos() async {
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

    response = await ApiHelper.getObrasReparo(widget.user.codigoCausante);

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
      _obras = response.result;
      _obras.sort((a, b) {
        return a.direccion.toString().toLowerCase().compareTo(
          b.direccion.toString().toLowerCase(),
        );
      });
    });

    for (ObrasReparo obra in _obras) {
      for (StandardReparo clase in _clases) {
        if (obra.codtipostdrparo == clase.codigostd) {
          obra.clase = clase.descripciontarea;
        }
      }
    }

    await _getVeredas();
  }

  //------------------------------------------------------------------
  //------------------------------ _goInfoObra -----------------------
  //------------------------------------------------------------------

  void _goInfoObra(ObrasReparo obra) async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VeredaInfoScreen(
          user: widget.user,
          obra: obra,
          positionUser: widget.positionUser,
        ),
      ),
    );
    if (result == 'yes' || result != 'yes') {
      _getObrasReparos();
      setState(() {});
    }
  }

  //---------------------------------------------------------------
  //------------------------------ _showMap -----------------------
  //---------------------------------------------------------------

  void _showMap() {
    if (_obrasReparosTodas.isEmpty) {
      return;
    }

    _markers.clear();

    for (ObrasReparo obraReparo in _obrasReparosTodas) {
      var lat = double.tryParse(obraReparo.latitud.toString()) ?? 0;
      var long = double.tryParse(obraReparo.longitud.toString()) ?? 0;
      int tipomarker = 100;
      BitmapDescriptor iconSelected = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueCyan,
      );

      if (lat.toString().length > 3 && long.toString().length > 3) {
        double distancia = 0;

        distancia = _distanciaMarker(obraReparo, widget.positionUser);

        if (distancia >= 10) {
          tipomarker = 100;
          iconSelected = BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueCyan,
          );
        }

        if (distancia < 10) {
          tipomarker = 10;
          iconSelected = BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          );
        }

        if (distancia < 5) {
          tipomarker = 5;
          iconSelected = BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange,
          );
        }

        if (distancia < 2) {
          tipomarker = 2;
          iconSelected = BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueYellow,
          );
        }

        for (ObrasReparo obraReparoAsignada in _obras) {
          if (obraReparoAsignada.nroregistro == obraReparo.nroregistro) {
            tipomarker = 0;
            iconSelected = BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            );
          }
        }

        Marker marker = Marker(
          markerId: MarkerId(obraReparo.nroregistro.toString()),
          position: LatLng(lat, long),
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
                              'Obra Nº: ${obraReparo.nroobra.toString()}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Domicilio: ${obraReparo.direccion.toString()} ${obraReparo.altura.toString()}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Tipo de vereda: ${obraReparo.tipoVereda.toString()}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Clase de vereda: ${obraReparo.clase.toString()}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Mt lin.: ${obraReparo.cantidadMTL.toString()} - Ancho[cm]: ${obraReparo.ancho.toString()} - Prof.[cm]: ${obraReparo.profundidad.toString()}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Distancia: ${(((distancia * 100).floor()) / 100).toString()} km',
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
                                  onPressed: () => _navegar(obraReparo),
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
                                  onPressed: () => _goObra(obraReparo),
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
          icon: iconSelected,
        );

        if (tipomarker <= 10) {
          _markers.add(marker);
        }
      }
    }
    // latcenter = (latmin + latmax) / 2;
    // longcenter = (longmin + longmax) / 2;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VeredasMapScreen(
          user: widget.user,
          positionUser: widget.positionUser,
          obraReparo: _obrasReparosTodas[0],
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

  //---------------------------------------------------
  //----------------- _distanciaMarker ----------------
  //---------------------------------------------------

  double _distanciaMarker(ObrasReparo obrareparo, Position positionUser) {
    double latitud1 = double.parse(obrareparo.latitud!);
    double longitud1 = double.parse(obrareparo.longitud!);
    double latitud2 = positionUser.latitude;
    double longitud2 = positionUser.longitude;

    double R = 6372.8; // In kilometers
    double dLat = _toRadians(latitud2 - latitud1);
    double dLon = _toRadians(longitud2 - longitud1);
    latitud1 = _toRadians(latitud1);
    latitud2 = _toRadians(latitud2);

    double a =
        pow(sin(dLat / 2), 2) +
        pow(sin(dLon / 2), 2) * cos(latitud1) * cos(latitud2);
    double c = 2 * asin(sqrt(a));

    return R * c;
  }

  //---------------------------------------------
  //----------------- _toRadians ----------------
  //---------------------------------------------

  static double _toRadians(double degree) {
    return degree * pi / 180;
  }

  //-------------------------------------------------------------------
  //-------------------------- _navegar -------------------------------
  //-------------------------------------------------------------------

  Future<void> _navegar(ObrasReparo obraReparo) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      var latt = double.tryParse(obraReparo.latitud.toString());
      var long = double.tryParse(obraReparo.longitud.toString());
      var uri = Uri.parse('google.navigation:q=$latt,$long&mode=d');
      if (await canLaunch(uri.toString())) {
        await launch(uri.toString());
      } else {
        throw 'Could not launch ${uri.toString()}';
      }
    } else {
      await showAlertDialog(
        context: context,
        title: 'Aviso!',
        message: 'Necesita estar conectado a Internet para acceder al mapa',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
    }
  }

  //------------------------------------------------------------
  //-------------------------- _goObra -------------------------
  //------------------------------------------------------------

  void _goObra(ObrasReparo obraReparo) async {
    _obraSeleccionada = obraSelected;
    int opcion = 0;

    for (ObrasReparo obra in _obras) {
      if (obra.nroregistro == obraReparo.nroregistro) {
        _obraSeleccionada = obra;
        opcion = 1;
      }
    }

    if (opcion == 1) {
      String? result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VeredaInfoScreen(
            user: widget.user,
            obra: _obraSeleccionada,
            positionUser: widget.positionUser,
          ),
        ),
      );
      if (result == 'Yes' || result != 'Yes') {
        _getObrasReparos();
        setState(() {});
        return;
      }
    }

    for (ObrasReparo obra in _obrasReparosTodas) {
      if (obra.nroregistro == obraReparo.nroregistro) {
        _obraSeleccionada = obra;
        opcion = 2;
      }
    }

    if (opcion == 2) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text('Esta Vereda no está asignada a su Usuario'),
            content: Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Obra Nº: ${obraReparo.nroobra.toString()}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Domicilio: ${obraReparo.direccion.toString()} ${obraReparo.altura.toString()}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Tipo de vereda: ${obraReparo.tipoVereda.toString()}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Clase de vereda: ${obraReparo.clase.toString()}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Mt lin.: ${obraReparo.cantidadMTL.toString()} - Ancho[cm]: ${obraReparo.ancho.toString()} - Prof.[cm]: ${obraReparo.profundidad.toString()}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FadeInImage(
                    fit: BoxFit.contain,
                    placeholder: const AssetImage('assets/loading.gif'),
                    image: NetworkImage(obraReparo.imageFullPath!),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
    }
  }

  //---------------------------------------------------
  //----------------- _getVeredas ---------------------
  //---------------------------------------------------

  Future<void> _getVeredas() async {
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

    Response response2 = await ApiHelper.getObrasReparosTodas();

    if (!response2.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'No hay Veredas',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );

      setState(() {});
      return;
    }
    _obrasReparosTodas = response2.result;

    for (ObrasReparo obra in _obrasReparosTodas) {
      for (StandardReparo clase in _clases) {
        if (obra.codtipostdrparo == clase.codigostd) {
          obra.clase = clase.descripciontarea;
        }
      }
    }

    setState(() {});
  }

  //--------------------------------------------------------------
  //-------------------------- _getClases ------------------------
  //--------------------------------------------------------------

  Future<void> _getClases() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      showMyDialog(
        'Error',
        'Verifica que estés conectado a Internet',
        'Aceptar',
      );
    }

    Response response = Response(isSuccess: false);
    response = await ApiHelper.getStandardReparos();

    if (response.isSuccess) {
      _clases = response.result;
    }

    setState(() {});

    await _getObrasReparos();
  }

  //------------------------------------------------------------------
  //-------------------------- isNullOrEmpty -------------------------
  //------------------------------------------------------------------

  bool isNullOrEmpty(dynamic obj) =>
      obj == null ||
      ((obj is String || obj is List || obj is Map) && obj.isEmpty);
}
