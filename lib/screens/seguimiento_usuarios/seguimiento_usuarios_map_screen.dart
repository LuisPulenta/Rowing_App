import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../components/loader_component.dart';

class SeguimientoUsuariosMapScreen extends StatefulWidget {
  final LatLng posicion;
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final CustomInfoWindowController customInfoWindowController;

  const SeguimientoUsuariosMapScreen(
      {super.key,
      required this.posicion,
      required this.markers,
      required this.polylines,
      required this.customInfoWindowController});

  @override
  _SeguimientoUsuariosMapScreenState createState() =>
      _SeguimientoUsuariosMapScreenState();
}

class _SeguimientoUsuariosMapScreenState
    extends State<SeguimientoUsuariosMapScreen> {
//----------------------------------------------------------
//--------------------- Variables --------------------------
//----------------------------------------------------------
  bool ubicOk = false;

  bool myLocation = true;

  double latitud = 0;
  double longitud = 0;
  final bool _showLoader = false;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  MapType _defaultMapType = MapType.normal;
  String direccion = '';
  Position position =  Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
    altitudeAccuracy: 0,
    headingAccuracy: 0,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);
  CameraPosition _initialPosition =
      const CameraPosition(target: LatLng(31, 64), zoom: 14.0);

  @override
  void dispose() {
    widget.customInfoWindowController.dispose();
    super.dispose();
  }

//----------------------------------------------------------
//--------------------- initState --------------------------
//----------------------------------------------------------
  @override
  void initState() {
    super.initState();

    _initialPosition = CameraPosition(target: widget.posicion, zoom: 14.0);
    ubicOk = true;

    _markers = widget.markers;
    _polylines = widget.polylines;
  }

//----------------------------------------------------------
//--------------------- Pantalla ---------------------------
//----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(('Seguimiento Usuario')),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ubicOk == true
              ? Stack(children: <Widget>[
                  GoogleMap(
                    onTap: (position) {
                      widget.customInfoWindowController.hideInfoWindow!();
                    },
                    myLocationEnabled: myLocation,
                    initialCameraPosition: _initialPosition,
                    //onCameraMove: _onCameraMove,
                    markers: _markers,
                    polylines: _polylines,
                    mapType: _defaultMapType,
                    onMapCreated: (GoogleMapController controller) async {
                      widget.customInfoWindowController.googleMapController =
                          controller;
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 80, right: 10),
                    alignment: Alignment.topRight,
                    child: Column(children: <Widget>[
                      FloatingActionButton(
                          elevation: 5,
                          backgroundColor: const Color(0xfff4ab04),
                          onPressed: () {
                            _changeMapType();
                          },
                          child: const Icon(Icons.layers)),
                    ]),
                  ),
                ])
              : Container(),
          _showLoader
              ? const LoaderComponent(
                  text: 'Por favor espere...',
                )
              : Container(),
          CustomInfoWindow(
            controller: widget.customInfoWindowController,
            height: 140,
            width: 300,
            offset: 100,
          ),
        ],
      ),
    );
  }

//----------------------------------------------------------
//--------------------- _changeMapType ---------------------
//----------------------------------------------------------
  void _changeMapType() {
    _defaultMapType = _defaultMapType == MapType.normal
        ? MapType.satellite
        : _defaultMapType == MapType.satellite
            ? MapType.hybrid
            : MapType.normal;
    setState(() {});
  }
}
