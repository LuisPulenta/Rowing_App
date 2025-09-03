import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rowing_app/components/loader_component.dart';
import 'package:rowing_app/models/models.dart';

class ElemenEnCalleMapScreen extends StatefulWidget {
  final User user;
  final Position positionUser;
  final LatLng posicion;
  final Set<Marker> markers;
  final CustomInfoWindowController customInfoWindowController;

  const ElemenEnCalleMapScreen({
    super.key,
    required this.user,
    required this.positionUser,
    required this.posicion,
    required this.markers,
    required this.customInfoWindowController,
  });

  @override
  _ElemenEnCalleMapScreenState createState() => _ElemenEnCalleMapScreenState();
}

class _ElemenEnCalleMapScreenState extends State<ElemenEnCalleMapScreen> {
  //----------------------------------------------------------
  //--------------------- Variables --------------------------
  //----------------------------------------------------------
  bool ubicOk = false;

  bool myLocation = true;

  double latitud = 0;
  double longitud = 0;
  final bool _showLoader = false;
  Set<Marker> _markers = {};
  MapType _defaultMapType = MapType.normal;
  String direccion = '';
  final double _sliderValue = 20;
  Position position = Position(
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
  CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(31, 64),
    zoom: 16.0,
  );
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

    _initialPosition = CameraPosition(target: widget.posicion, zoom: 11.0);
    ubicOk = true;

    _markers = widget.markers;
  }

  //----------------------------------------------------------
  //--------------------- Pantalla ---------------------------
  //----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(('Elementos en Calle')),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ubicOk == true
              ? Stack(
                  children: <Widget>[
                    GoogleMap(
                      onTap: (position) {
                        widget.customInfoWindowController.hideInfoWindow!();
                      },
                      myLocationEnabled: myLocation,
                      initialCameraPosition: _initialPosition,
                      //onCameraMove: _onCameraMove,
                      markers: _markers,
                      mapType: _defaultMapType,
                      onMapCreated: (GoogleMapController controller) async {
                        widget.customInfoWindowController.googleMapController =
                            controller;
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 80, right: 10),
                      alignment: Alignment.topRight,
                      child: Column(
                        children: <Widget>[
                          FloatingActionButton(
                            elevation: 5,
                            backgroundColor: const Color(0xfff4ab04),
                            onPressed: () {
                              _changeMapType();
                            },
                            child: const Icon(Icons.layers),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Container(),
          _showLoader
              ? const LoaderComponent(text: 'Por favor espere...')
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
