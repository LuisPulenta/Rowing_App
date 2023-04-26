import 'package:custom_info_window/custom_info_window.dart';
import 'package:rowing_app/components/loader_component.dart';
import 'package:rowing_app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VeredasMapScreen extends StatefulWidget {
  final User user;
  final Position positionUser;
  final ObrasReparo obraReparo;
  final LatLng posicion;
  final Set<Marker> markers;
  final CustomInfoWindowController customInfoWindowController;

  const VeredasMapScreen(
      {Key? key,
      required this.user,
      required this.positionUser,
      required this.obraReparo,
      required this.posicion,
      required this.markers,
      required this.customInfoWindowController})
      : super(key: key);

  @override
  _VeredasMapScreenState createState() => _VeredasMapScreenState();
}

class _VeredasMapScreenState extends State<VeredasMapScreen> {
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
      const CameraPosition(target: LatLng(31, 64), zoom: 16.0);
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
        title: const Text(('Veredas cercanas')),
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
          Positioned(
            bottom: 10,
            left: 10,
            child: Container(
              width: 200,
              height: 120,
              color: Colors.white,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            color: const Color(0xff3635eb),
                          ),
                          const SizedBox(width: 10),
                          const Text('Veredas asignadas')
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            color: Colors.yellow,
                          ),
                          const SizedBox(width: 10),
                          const Text('Veredas de 0 a 2 km.')
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 10),
                          const Text('Veredas de 2 a 5 km.')
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 10),
                          const Text('Veredas de 5 a 10 km.')
                        ],
                      ),
                    )
                  ]),
            ),
          ),
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
