import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../screens.dart';

class SeguimientoUsuarioScreen extends StatefulWidget {
  final User user;
  const SeguimientoUsuarioScreen({super.key, required this.user});

  @override
  State<SeguimientoUsuarioScreen> createState() =>
      _SeguimientoUsuarioScreenState();
}

class _SeguimientoUsuarioScreenState extends State<SeguimientoUsuarioScreen> {
  //---------------------------------------------------------------------
  //-------------------------- Variables --------------------------------
  //---------------------------------------------------------------------
  DateTime _fecha = DateTime.now();
  List<UsuarioGeo> _usuarios = [];
  List<UsuarioGeo> _usuariosAux = [];
  List<Punto> _puntos = [];

  final List<LatLng> _puntosPolyline = [];

  int _usuario = 0;
  int _puntosMenu = 0;
  int _puntosAutomaticos = 0;
  final String _usuarioError = '';
  final bool _usuarioShowError = false;
  double latcenter = 0.0;
  double longcenter = 0.0;

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  final Set<Marker> _markers = {};

  final Set<Polyline> _polylines = {};

  //---------------------------------------------------------------------
  //-------------------------- InitState --------------------------------
  //---------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _getUsuarios();
    setState(() {});
  }

  //---------------------------------------------------------------------
  //-------------------------- Pantalla ---------------------------------
  //---------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: const Text('Seguimiento Usuarios'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            _showFecha(),
            _usuarios.isEmpty ? Container() : _showUsuarios(),
            const SizedBox(height: 15),
            _usuario != 0 && _puntos.isNotEmpty ? DatosUsuario() : Container(),
            const Spacer(),
            _showButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- DatosUsuario ------------------------------
  //-----------------------------------------------------------------

  Widget DatosUsuario() {
    double? ancho = 140;
    return Card(
      color: Colors.white, //const Color(0xFFC7C7C8),
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
                              SizedBox(
                                width: ancho,
                                child: const Text(
                                  'Cantidad de Puntos: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF781f1e),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _puntos.length.toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              SizedBox(
                                width: ancho,
                                child: const Text(
                                  'Puntos por Menú: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF781f1e),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _puntosMenu.toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              SizedBox(
                                width: ancho,
                                child: const Text(
                                  'Puntos automáticos: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF781f1e),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _puntosAutomaticos.toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              SizedBox(
                                width: ancho,
                                child: const Text(
                                  'Hora Primer Punto: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF781f1e),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  DateFormat('HH:mm').format(
                                    DateTime.parse(
                                      _puntos.first.fecha.toString(),
                                    ),
                                  ),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              SizedBox(
                                width: ancho,
                                child: const Text(
                                  'Hora Ultimo Punto: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF781f1e),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  DateFormat('HH:mm').format(
                                    DateTime.parse(
                                      _puntos.last.fecha.toString(),
                                    ),
                                  ),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
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
          ],
        ),
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showFecha --------------------------------
  //-----------------------------------------------------------------

  Widget _showFecha() {
    double ancho = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [Expanded(flex: 2, child: Row(children: const []))],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: ancho * 0.75,
                      height: 60,
                      child: Text(
                        '  Fecha: ${_fecha.day}/${_fecha.month}/${_fecha.year}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF781f1e),
                          minimumSize: const Size(double.infinity, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () => _elegirFecha(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [Icon(Icons.calendar_month)],
                        ),
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
  //--------------------- _elegirFecha ------------------------------
  //-----------------------------------------------------------------

  Future<void> _elegirFecha() async {
    FocusScope.of(context).unfocus();
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().add(const Duration(days: -365)),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != _fecha) {
      _fecha = selected;
      _usuarios = [];
      await _getUsuarios();
    }
  }

  //-----------------------------------------------------------------
  //--------------------- _showUsuarios -----------------------------
  //-----------------------------------------------------------------

  Widget _showUsuarios() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
            child: _usuarios.isEmpty
                ? Row(
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(width: 10),
                      Text('Cargando Usuarios...'),
                    ],
                  )
                : DropdownButtonFormField(
                    initialValue: _usuario,
                    isExpanded: true,
                    isDense: true,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Seleccione un Usuario...',
                      labelText: 'Usuario',
                      errorText: _usuarioShowError ? _usuarioError : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: _getComboUsuarios(),
                    onChanged: (value) {
                      _usuario = value as int;
                      _getPuntos();
                    },
                  ),
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<int>> _getComboUsuarios() {
    List<DropdownMenuItem<int>> list = [];
    list.add(
      const DropdownMenuItem(value: 0, child: Text('Seleccione un Usuario...')),
    );

    for (var usuario in _usuarios) {
      list.add(
        DropdownMenuItem(
          value: usuario.idUsuario,
          child: Text(usuario.usuarioStr.toString()),
        ),
      );
    }

    return list;
  }

  //-----------------------------------------------------------------
  //--------------------- _showSaveButton ---------------------------
  //-----------------------------------------------------------------

  Widget _showButton() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF781f1e),
                minimumSize: const Size(double.infinity, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SeguimientoUsuariosMapScreen(
                      //posicion: LatLng(latcenter, longcenter),
                      posicion: LatLng(latcenter, longcenter),
                      markers: _markers,
                      polylines: _polylines,
                      customInfoWindowController: _customInfoWindowController,
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.map),
                  SizedBox(width: 20),
                  Text('Ver Mapa'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //---------------------------------------------------------------------
  //-------------------------- _getUsuarios -----------------------------
  //---------------------------------------------------------------------

  Future<void> _getUsuarios() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      showMyDialog(
        'Error',
        'Verifica que estés conectado a Internet',
        'Aceptar',
      );
    }

    Response response = Response(isSuccess: false);

    response = await ApiHelper.getUsuariosGeo(
      _fecha.year,
      _fecha.month,
      _fecha.day,
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

    _usuario = 0;
    _usuariosAux = response.result;

    for (var usuario in _usuariosAux) {
      usuario.usuarioStr = usuario.usuarioStr.toUpperCase();
    }

    if (widget.user.limitarGrupo == 0) {
      _usuarios = _usuariosAux;
    } else {
      for (var usuario in _usuariosAux) {
        if (usuario.modulo == widget.user.modulo) {
          usuario.modulo = '';
          _usuarios.add(usuario);
        }
      }
    }

    List<UsuarioGeo> usuarios2 = [];
    bool bandera = true;

    for (var usuario1 in _usuarios) {
      bandera = true;

      for (var usuario2 in usuarios2) {
        if (usuario1.usuarioStr == usuario2.usuarioStr) {
          bandera = false;
        }
      }
      if (bandera) {
        usuarios2.add(usuario1);
      }
    }

    _usuarios = usuarios2;

    _usuarios.sort((a, b) {
      return a.usuarioStr.toString().toLowerCase().compareTo(
        b.usuarioStr.toString().toLowerCase(),
      );
    });

    setState(() {});
  }

  //---------------------------------------------------------------------
  //-------------------------- _getPuntos -------------------------------
  //---------------------------------------------------------------------

  Future<void> _getPuntos() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      showMyDialog(
        'Error',
        'Verifica que estés conectado a Internet',
        'Aceptar',
      );
    }

    Response response = Response(isSuccess: false);

    response = await ApiHelper.getPuntos(
      _usuario,
      _fecha.year,
      _fecha.month,
      _fecha.day,
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
      _puntos = response.result;
      _puntosMenu = 0;
      _puntosAutomaticos = 0;

      _markers.clear();
      _puntosPolyline.clear();

      double latmin = 180.0;
      double latmax = -180.0;
      double longmin = 180.0;
      double longmax = -180.0;
      latcenter = 0.0;
      longcenter = 0.0;

      for (var punto in _puntos) {
        punto.origen == 0 ? _puntosAutomaticos++ : _puntosMenu++;

        var lat = double.tryParse(punto.latitud.toString()) ?? 0;
        var long = double.tryParse(punto.longitud.toString()) ?? 0;
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

        //------------ Voy construyendo las polylines -------------
        LatLng latlng = LatLng(lat, long);
        _puntosPolyline.add(latlng);

        Polyline pol = Polyline(
          polylineId: const PolylineId('myRoute'),
          color: const Color(0xFF781f1e),
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          points: _puntosPolyline,
        );

        _polylines.add(pol);

        //------------ Voy construyendo los markers ---------------
        Marker marker = Marker(
          markerId: MarkerId(punto.idgeo.toString()),
          position: LatLng(lat, long),
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                width: 300,
                height: 60,
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                width: 80,
                                child: Text(
                                  'Domicilio: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF781f1e),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  punto.posicionCalle.toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 80,
                                child: Text(
                                  'Hora: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF781f1e),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  DateFormat('HH:mm').format(
                                    DateTime.parse(punto.fecha.toString()),
                                  ),
                                  style: const TextStyle(fontSize: 12),
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
          icon: punto.origen == 0
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
              : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        );
        _markers.add(marker);
      }

      latcenter = (latmin + latmax) / 2;
      longcenter = (longmin + longmax) / 2;
    });
  }
}
