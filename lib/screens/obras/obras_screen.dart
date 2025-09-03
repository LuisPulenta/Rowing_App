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

class ObrasScreen extends StatefulWidget {
  final User user;
  final int opcion;
  final Position positionUser;
  const ObrasScreen({
    super.key,
    required this.user,
    required this.opcion,
    required this.positionUser,
  });

  @override
  _ObrasScreenState createState() => _ObrasScreenState();
}

class _ObrasScreenState extends State<ObrasScreen> {
  //---------------------------------------------------------------
  //----------------------- Variables -----------------------------
  //---------------------------------------------------------------

  List<ObraEstado> _estados = [];
  List<ObraSubestado> _subestados = [];

  bool _todasLasObras = false;
  List<Obra> _obras = [];
  bool _showLoader = false;
  bool _isFiltered = false;
  String _search = '';
  Obra obraSelected = Obra(
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

  Obra _obraSeleccionada = Obra(
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

  List<ObrasReparo> _obrasReparosTodas = [];

  final Set<Marker> _markers = {};

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  //---------------------------------------------------------------
  //----------------------- initState -----------------------------
  //---------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _getObras();
  }

  //---------------------------------------------------------------
  //----------------------- Pantalla -----------------------------
  //---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: widget.user.habilitaSSHH == 0
            ? widget.user.modulo == 'ObrasTasa'
                  ? const Text('Obras Tasa')
                  : Text('Obras ${widget.user.modulo}')
            : const Text('Obras'),
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
          widget.user.habilitaVerObrasCerradas == 1
              ? Row(
                  children: [
                    const Text(
                      'Todas:',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    Switch(
                      value: _todasLasObras,
                      activeThumbColor: Colors.green,
                      inactiveThumbColor: Colors.grey,
                      onChanged: (value) async {
                        _todasLasObras = value;
                        _getObras();
                        setState(() {});
                      },
                    ),
                  ],
                )
              : Container(),
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
    List<Obra> filteredList = [];
    for (var obra in _obras) {
      if (obra.nombreObra.toLowerCase().contains(_search.toLowerCase()) ||
          obra.elempep.toLowerCase().contains(_search.toLowerCase()) ||
          obra.modulo!.toLowerCase().contains(_search.toLowerCase()) ||
          obra.nroObra.toString().toLowerCase().contains(
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
    _getObras();
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
          title: const Text('Filtrar Obras'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Escriba texto o números a buscar en Nombre o N° de Obra o en OP/N° de Fuga o en Módulo: ',
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
            'Cantidad de Obras: ',
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
              ? 'No hay Obras con ese criterio de búsqueda'
              : 'No hay Obras registradas',
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
      onRefresh: _getObras,
      child: ListView(
        children: _obras.map((e) {
          return Card(
            color: e.finalizada == 0
                ? const Color(0xFFC7C7C8)
                : const Color.fromARGB(255, 240, 202, 151),
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
                                  e.finalizada == 1
                                      ? const Text(
                                          'FINALIZADA',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : Container(),
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
                                          e.nroObra.toString(),
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
                                        child: e.fechaUltimoMovimiento != null
                                            ? Text(
                                                DateFormat('dd/MM/yyyy').format(
                                                  DateTime.parse(
                                                    e.fechaUltimoMovimiento
                                                        .toString(),
                                                  ),
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
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
                                          e.modulo.toString(),
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
                                        'OP/N° Fuga: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          e.elempep,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      e.photos > 0
                                          ? _IconInfo(
                                              icon: Icons.camera_alt,
                                              text: e.photos.toString(),
                                            )
                                          : Container(),
                                      e.audios > 0
                                          ? _IconInfo(
                                              icon: Icons.volume_down_rounded,
                                              text: e.audios.toString(),
                                            )
                                          : Container(),
                                      e.videos > 0
                                          ? _IconInfo(
                                              icon: Icons.video_call_rounded,
                                              text: e.videos.toString(),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                  SizedBox(
                                    height: e.fechaCierreElectrico != null
                                        ? 5
                                        : 0,
                                  ),
                                  e.fechaCierreElectrico != null
                                      ? Row(
                                          children: [
                                            const Text(
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
                                                    e.fechaCierreElectrico
                                                        .toString(),
                                                  ),
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
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

  //---------------------------------------------------------------
  //----------------------- _getObras -----------------------------
  //---------------------------------------------------------------

  Future<void> _getObras() async {
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

    //****** 23/8/2022 se vuelve atrás esto y se deja como estaba antes ******
    // if (widget.user.habilitaSSHH == 1) {
    //   response = await ApiHelper.getObrasTodas();
    // } else {
    //   response = await ApiHelper.getObras(widget.user.modulo);
    // }

    if (!_todasLasObras) {
      response = await ApiHelper.getObras(widget.user.modulo);
    } else {
      response = await ApiHelper.getObrasTodas(widget.user.modulo);
    }

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
        return a.nombreObra.toString().toLowerCase().compareTo(
          b.nombreObra.toString().toLowerCase(),
        );
      });
    });

    _getVeredas();
  }

  //---------------------------------------------------------------
  //----------------------- _goInfoObra ---------------------------
  //---------------------------------------------------------------

  void _goInfoObra(Obra obra) async {
    if (widget.opcion == 1) {
      String? result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ObraInfoScreen(
            user: widget.user,
            obra: obra,
            positionUser: widget.positionUser,
            estados: _estados,
            subestados: _subestados,
          ),
        ),
      );
      if (result == 'yes' || result != 'yes') {
        _getObras();
        setState(() {});
      }
    }
    if (widget.opcion == 2) {
      Navigator.pop(context, obra);
    }
  }

  //---------------------------------------------------------------
  //----------------------- _showMap ------------------------------
  //---------------------------------------------------------------

  void _showMap() {
    if (_obrasReparosTodas.isEmpty) {
      return;
    }

    _markers.clear();

    double latmin = 180.0;
    double latmax = -180.0;
    double longmin = 180.0;
    double longmax = -180.0;
    double latcenter = 0.0;
    double longcenter = 0.0;

    for (ObrasReparo obraReparo in _obrasReparosTodas) {
      var lat = double.tryParse(obraReparo.latitud.toString()) ?? 0;
      var long = double.tryParse(obraReparo.longitud.toString()) ?? 0;

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

        double distancia = 0;
        distancia = _distanciaMarker(obraReparo, widget.positionUser);

        Marker marker = Marker(
          markerId: MarkerId(obraReparo.nroregistro.toString()),
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
          icon: distancia < 2
              ? BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueYellow,
                )
              : distancia < 5
              ? BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueOrange,
                )
              : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        );

        if (distancia < 10 && obraReparo.modulo == widget.user.modulo) {
          _markers.add(marker);
        }
      }
    }
    latcenter = (latmin + latmax) / 2;
    longcenter = (longmin + longmax) / 2;

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

  //----------------------------------------------------------------
  //-------------------------- _getEstados -------------------------
  //----------------------------------------------------------------

  Future<void> _getEstados() async {
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

    response = await ApiHelper.getEstados();

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
      _estados = response.result;
    });

    _getSubestados();
  }

  //----------------------------------------------------------------
  //-------------------------- _getSubestados -------------------------
  //----------------------------------------------------------------

  Future<void> _getSubestados() async {
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

    response = await ApiHelper.getSubestados();

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
      _subestados = response.result;
    });
  }

  //---------------------------------------------
  //----------------- _toRadians ----------------
  //---------------------------------------------

  static double _toRadians(double degree) {
    return degree * pi / 180;
  }

  //-------------------------------------------------------------------------
  //-------------------------- _navegar -------------------------------------
  //-------------------------------------------------------------------------

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

  //-------------------------------------------------------------------
  //-------------------------- _goObra --------------------------------
  //-------------------------------------------------------------------

  void _goObra(ObrasReparo obraReparo) async {
    for (Obra obra in _obras) {
      if (obra.nroObra == obraReparo.nroobra) {
        _obraSeleccionada = obra;
      }
    }

    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ObraInfoScreen(
          user: widget.user,
          obra: _obraSeleccionada,
          positionUser: widget.positionUser,
          estados: _estados,
          subestados: _subestados,
        ),
      ),
    );
    if (result == 'Yes' || result != 'Yes') {
      _getObras();
      setState(() {});
    }
  }

  //-------------------------------------------------------------------
  //-------------------------- _getVeredas ----------------------------
  //-------------------------------------------------------------------

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

    setState(() {});

    _getEstados();
  }

  //-------------------------------------------------------------------------
  //-------------------------- isNullOrEmpty --------------------------------
  //-------------------------------------------------------------------------

  bool isNullOrEmpty(dynamic obj) =>
      obj == null ||
      ((obj is String || obj is List || obj is Map) && obj.isEmpty);
}

//-------------------------------------------------------------------------
//-------------------------- _IconInfo ------------------------------------
//-------------------------------------------------------------------------
class _IconInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const _IconInfo({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: Icon(icon, color: const Color(0xFF781f1e)),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: SizedBox(
              width: 15,
              height: 15,
              child: CircleAvatar(
                backgroundColor: Colors.red,
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
