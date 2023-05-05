import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:battery_plus/battery_plus.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:rowing_app/helpers/api_helper.dart';
import 'package:rowing_app/helpers/constants.dart';
import 'package:rowing_app/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription? positionStream;
  final LatLng? lastSavedLocation;
  final DateTime? lastSavedDateLocation;
  final Battery _battery = Battery();
  double LatitudActual;
  double LongitudActual;
  double LatitudUltima;
  double LongitudUltima;
  DateTime ultimaFechaGrabada = DateTime.now();

  BatteryState? _batteryState;
  StreamSubscription<BatteryState>? _batteryStateSubscription;

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
      firmaUsuario: '',
      firmaUsuarioImageFullPath: '');

  Parametro parametro =
      Parametro(id: 0, bloqueaactas: 0, ipServ: '', metros: 0, tiempo: 0);

  Future<void> _init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userBody = prefs.getString('userBody');
    if (userBody != null && userBody != "") {
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

    var a = 1;
  }

  LocationBloc(
      this.lastSavedLocation,
      this.lastSavedDateLocation,
      this.LatitudActual,
      this.LongitudActual,
      this.LatitudUltima,
      this.LongitudUltima)
      : super(const LocationState()) {
    on<OnStartFollowingUser>(
      (event, emit) => emit(
        state.copyWith(followingUser: true),
      ),
    );

    on<OnStopFollowingUser>(
      (event, emit) => emit(
        state.copyWith(followingUser: false),
      ),
    );

    on<OnNewUserLocationEvent>((event, emit) async {
      emit(state.copyWith(
        lastKnownLocation: event.newLocation,
      ));

      LatitudActual = event.newLocation.latitude;
      LongitudActual = event.newLocation.longitude;

      bool diff = DateTime.now().difference(ultimaFechaGrabada) >
          Duration(seconds: parametro.tiempo);

      double distancia = _distanciaEntrePuntos(
          LatitudActual, LongitudActual, LatitudUltima, LongitudUltima);
      //+Random().nextInt(50).toDouble();

      //print("Distancia: $distancia - Diferencia: ${DateTime.now().difference(ultimaFechaGrabada)}");

      if (parametro.metros > 0 &&
          _user.login.isNotEmpty &&
          diff &&
          distancia > parametro.metros) {
        await handleTimeout(LatitudActual, LongitudActual, distancia);
      }
    });
  }

  Future getCurrentPostion() async {
    final position = await Geolocator.getCurrentPosition();
    LatitudUltima = position.latitude;
    LongitudUltima = position.longitude;

    add(
      OnNewUserLocationEvent(
        LatLng(position.latitude, position.longitude),
      ),
    );
  }

  void startFollowingUser() {
    add(OnStartFollowingUser());
    positionStream = Geolocator.getPositionStream().listen((event) {
      final position = event;
      add(
        OnNewUserLocationEvent(
          LatLng(position.latitude, position.longitude),
        ),
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

  handleTimeout(double Latitud, double Longitud, double distancia) async {
    var connectivityResult = Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return;
    }

    if (Latitud == 0 || Longitud == 0) {
      return;
    }

    List<Placemark> placemarks =
        await placemarkFromCoordinates(Latitud, Longitud);
    String direccion = placemarks[0].street.toString() +
        " - " +
        placemarks[0].locality.toString() +
        " - " +
        placemarks[0].country.toString();
    ;

    _battery.batteryState.then(_updateBatteryState);
    int batnivel = await _battery.batteryLevel;

    // print("LatitudActual: ${Latitud} - LongitudActual: ${Longitud}");
    // print("LatitudUltima: ${LatitudUltima} - LongitudUltima: ${LongitudUltima}");

    Map<String, dynamic> request1 = {
      'IdUsuario': _user.idUsuario,
      'UsuarioStr': _user.fullName,
      'LATITUD': Latitud,
      'LONGITUD': Longitud,
      'PIN': "mapinred.ico", //distancia.toString(),
      'PosicionCalle': direccion,
      'Velocidad': 0,
      'Bateria': batnivel,
      'Fecha': DateTime.now().toString(),
      'Modulo': _user.modulo,
      'Origen': 0,
    };

    ApiHelper.post('/api/UsuariosGeos', request1);
    ultimaFechaGrabada = DateTime.now();
    LatitudUltima = Latitud;
    LongitudUltima = Longitud;
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
    double LatitudUltima,
    double LongitudUltima,
    double LatitudActual,
    double LongitudActual,
  ) {
    double R = 6372000.8; // In meters
    double dLat = _toRadians(LatitudActual - LatitudUltima);
    double dLon = _toRadians(LongitudActual - LongitudUltima);
    LatitudUltima = _toRadians(LatitudUltima);
    LatitudActual = _toRadians(LatitudActual);

    double a = pow(sin(dLat / 2), 2) +
        pow(sin(dLon / 2), 2) * cos(LatitudActual) * cos(LatitudUltima);
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
