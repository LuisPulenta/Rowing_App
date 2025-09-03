import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:battery_plus/battery_plus.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/api_helper.dart';
import '../../helpers/constants.dart';
import '../../models/models.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription? positionStream;
  final LatLng? lastSavedLocation;
  final DateTime? lastSavedDateLocation;
  final Battery _battery = Battery();
  double latitudActual;
  double longitudActual;
  double latitudUltima;
  double longitudUltima;
  DateTime ultimaFechaGrabada = DateTime.now();

  BatteryState? _batteryState;

  User _user = User(
    idUsuario: 0,
    codigoCausante: '',
    login: '',
    contrasena: '',
    nombre: '',
    apellido: '',
    autorWOM: 0,
    estado: 0,
    habilitaAPP: 0,
    habilitaFotos: 0,
    habilitaReclamos: 0,
    habilitaSSHH: 0,
    habilitaRRHH: 0,
    modulo: '',
    habilitaMedidores: 0,
    habilitaFlotas: '',
    reHabilitaUsuarios: 0,
    codigogrupo: '',
    codigocausante: '',
    fullName: '',
    fechaCaduca: 0,
    intentosInvDiario: 0,
    opeAutorizo: 0,
    habilitaNuevoSuministro: 0,
    habilitaVeredas: 0,
    habilitaJuicios: 0,
    habilitaPresentismo: 0,
    habilitaSeguimientoUsuarios: 0,
    habilitaVerObrasCerradas: 0,
    habilitaElementosCalle: 0,
    habilitaCertificacion: 0,
    conceptomov: 0,
    conceptomova: 0,
    limitarGrupo: 0,
    rubro: 0,
    firmaUsuario: '',
    firmaUsuarioImageFullPath: '',
    appIMEI: '',
  );

  Parametro parametro = Parametro(
    id: 0,
    bloqueaactas: 0,
    ipServ: '',
    metros: 0,
    tiempo: 0,
    appBloqueada: 0,
  );

  Future<void> _init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userBody = prefs.getString('userBody');
    if (userBody != null && userBody != '') {
      var decodedJson = jsonDecode(userBody);
      _user = User.fromJson(decodedJson);
    }

    var url = Uri.parse('${Constants.apiUrl}/Api/UsuariosGeos/GetParametro');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      return;
    }

    parametro = Parametro.fromJson(jsonDecode(response.body));
  }

  LocationBloc(
    this.lastSavedLocation,
    this.lastSavedDateLocation,
    this.latitudActual,
    this.longitudActual,
    this.latitudUltima,
    this.longitudUltima,
  ) : super(const LocationState()) {
    on<OnStartFollowingUser>(
      (event, emit) => emit(state.copyWith(followingUser: true)),
    );

    on<OnStopFollowingUser>(
      (event, emit) => emit(state.copyWith(followingUser: false)),
    );

    on<OnNewUserLocationEvent>((event, emit) async {
      emit(state.copyWith(lastKnownLocation: event.newLocation));

      latitudActual = event.newLocation.latitude;
      longitudActual = event.newLocation.longitude;

      bool diff =
          DateTime.now().difference(ultimaFechaGrabada) >
          Duration(seconds: parametro.tiempo);

      double distancia = _distanciaEntrePuntos(
        latitudActual,
        longitudActual,
        latitudUltima,
        longitudUltima,
      );
      //+Random().nextInt(50).toDouble();

      //print("Distancia: $distancia - Diferencia: ${DateTime.now().difference(ultimaFechaGrabada)}");

      if (parametro.metros > 0 &&
          _user.login.isNotEmpty &&
          diff &&
          distancia > parametro.metros) {
        await handleTimeout(latitudActual, longitudActual, distancia);
      }
    });
  }

  Future getCurrentPostion() async {
    final position = await Geolocator.getCurrentPosition();
    latitudUltima = position.latitude;
    longitudUltima = position.longitude;

    add(OnNewUserLocationEvent(LatLng(position.latitude, position.longitude)));
  }

  void startFollowingUser() {
    add(OnStartFollowingUser());
    positionStream = Geolocator.getPositionStream().listen((event) {
      final position = event;
      add(
        OnNewUserLocationEvent(LatLng(position.latitude, position.longitude)),
      );
      _init();
    });
  }

  void stopFollowingUser() {
    add(OnStopFollowingUser());
    positionStream?.cancel();
  }

  @override
  Future<void> close() {
    stopFollowingUser();
    return super.close();
  }

  //-----------------------------------------------------------------
  //--------------------- METODO handleTimeout ----------------------
  //-----------------------------------------------------------------

  Future<void> handleTimeout(
    double latitud,
    double longitud,
    double distancia,
  ) async {
    var connectivityResult = Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return;
    }

    if (latitud == 0 || longitud == 0) {
      return;
    }

    List<Placemark> placemarks = await placemarkFromCoordinates(
      latitud,
      longitud,
    );
    String direccion =
        '${placemarks[0].street} - ${placemarks[0].locality} - ${placemarks[0].country}';

    _battery.batteryState.then(_updateBatteryState);
    int batnivel = await _battery.batteryLevel;

    // print("latitudActual: ${latitud} - longitudActual: ${longitud}");
    // print("latitudUltima: ${latitudUltima} - longitudUltima: ${longitudUltima}");

    Map<String, dynamic> request1 = {
      'IdUsuario': _user.idUsuario,
      'UsuarioStr': _user.fullName,
      'latitud': latitud,
      'longitud': longitud,
      'PIN': 'mapinred.ico', //distancia.toString(),
      'PosicionCalle': direccion,
      'Velocidad': 0,
      'Bateria': batnivel,
      'Fecha': DateTime.now().toString().substring(0, 10),
      'Modulo': _user.modulo,
      'Origen': 0,
    };

    ApiHelper.post('/api/UsuariosGeos', request1);
    ultimaFechaGrabada = DateTime.now();
    latitudUltima = latitud;
    longitudUltima = longitud;
    // print('Grabado');

    return;
  }

  //------------------------------------------------------------------
  //----------------------- _updateBatteryState ----------------------
  //------------------------------------------------------------------
  void _updateBatteryState(BatteryState state) {
    if (_batteryState == state) return;
    _batteryState = state;
  }

  //--------------------------------------------------------
  //----------------- _distanciaEntrePuntos ----------------
  //--------------------------------------------------------

  double _distanciaEntrePuntos(
    double latitudUltima,
    double longitudUltima,
    double latitudActual,
    double longitudActual,
  ) {
    double R = 6372000.8; // In meters
    double dLat = _toRadians(latitudActual - latitudUltima);
    double dLon = _toRadians(longitudActual - longitudUltima);
    latitudUltima = _toRadians(latitudUltima);
    latitudActual = _toRadians(latitudActual);

    double a =
        pow(sin(dLat / 2), 2) +
        pow(sin(dLon / 2), 2) * cos(latitudActual) * cos(latitudUltima);
    double c = 2 * asin(sqrt(a));

    return R * c;
  }

  //---------------------------------------------
  //----------------- _toRadians ----------------
  //---------------------------------------------

  static double _toRadians(double degree) {
    return degree * pi / 180;
  }
}
