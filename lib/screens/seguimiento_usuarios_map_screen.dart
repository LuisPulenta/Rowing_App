import 'package:custom_info_window/custom_info_window.dart';
import 'package:rowing_app/components/loader_component.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SeguimientoUsuariosMapScreen extends StatefulWidget {
  final LatLng posicion;
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final CustomInfoWindowController customInfoWindowController;

  const SeguimientoUsuariosMapScreen(
      {Key? key,
      required this.posicion,
      required this.markers,
      required this.polylines,
      required this.customInfoWindowController})
      : super(key: key);

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
  double _sliderValue = 20;
  Position position = const Position(
      longitude: 0,
      latitude: 0,
      timestamp: null,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);
  CameraPosition _initialPosition =
      const CameraPosition(target: LatLng(31, 64), zoom: 14.0);
  //static const LatLng _center = const LatLng(-31.4332373, -64.226344);

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
                          child: const Icon(Icons.layers),
                          elevation: 5,
                          backgroundColor: const Color(0xfff4ab04),
                          onPressed: () {
                            _changeMapType();
                          }),
                    ]),
                  ),
                  // Positioned(
                  //   top: 10,
                  //   left: 10,
                  //   child: Container(
                  //     width: MediaQuery.of(context).size.width * 0.8,
                  //     child: Slider(
                  //       min: 0,
                  //       max: 20,
                  //       activeColor: Color(0xFF781f1e),
                  //       inactiveColor: Colors.grey,
                  //       thumbColor: Color(0xFF781f1e),
                  //       value: _sliderValue,
                  //       onChanged: (value) {
                  //         _sliderValue = value;
                  //         myLocation = false;
                  //         _getMarkers();
                  //         myLocation = true;
                  //         setState(() {});
                  //       },
                  //       divisions: 10,
                  //     ),
                  //   ),
                  // ),
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
//--------------------- _onCameraMove ----------------------
//----------------------------------------------------------
  void _onCameraMove(CameraPosition position) {}

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
