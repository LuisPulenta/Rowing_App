import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../blocs/blocs.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../screens.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  final int nroConexion;
  final String imei;

  const HomeScreen(
      {Key? key,
      required this.user,
      required this.nroConexion,
      required this.imei})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
//---------------------------------------------------------------
//----------------------- Variables -----------------------------
//---------------------------------------------------------------

  late LocationBloc locationBloc;

  final Battery _battery = Battery();
  BatteryState? _batteryState;
  StreamSubscription<BatteryState>? _batteryStateSubscription;

  List<Novedad> _novedadesAux = [];
  List<Novedad> _novedades = [];
  late Causante _causante;
  String _codigo = '';
  int? _nroConexion = 0;

  String direccion = '';

  Position _positionUser = const Position(
      longitude: 0,
      latitude: 0,
      timestamp: null,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);

//---------------------------------------------------------------
//----------------------- initState -----------------------------
//---------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    locationBloc = BlocProvider.of<LocationBloc>(context);
    //locationBloc.getCurrentPosition();
    if (Constants.grabarCoord) {
      locationBloc.startFollowingUser();
    }

    _causante = Causante(
        nroCausante: 0,
        codigo: '',
        nombre: '',
        encargado: '',
        telefono: '',
        grupo: '',
        nroSAP: '',
        estado: false,
        razonSocial: '',
        linkFoto: '',
        image: null,
        imageFullPath: '',
        direccion: '',
        numero: 0,
        telefonoContacto1: '',
        telefonoContacto2: '',
        telefonoContacto3: '',
        fecha: '',
        notasCausantes: '',
        ciudad: '',
        provincia: '',
        codigoSupervisorObras: 0,
        zonaTrabajo: '',
        nombreActividad: '',
        notas: '',
        presentismo: '',
        perteneceCuadrilla: '',
        firma: null,
        firmaDigitalAPP: '',
        firmaFullPath: '');

    if (widget.user.habilitaRRHH != 1) {
      _codigo = widget.user.codigoCausante;
      _getCausante();
    }

    _battery.batteryState.then(_updateBatteryState);
    _batteryStateSubscription =
        _battery.onBatteryStateChanged.listen(_updateBatteryState);

    guardarHoraLocalizacion();
    handleTimeout(widget.user);
  }

//---------------------------------------------------------------
//----------------------- Pantalla ------------------------------
//---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rowing App'),
        centerTitle: true,
      ),
      body: _getBody(),
      drawer: _getMenu(),
    );
  }

  Widget _getBody() {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 60),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff242424),
              Color(0xff8c8c94),
            ],
          ),
        ),
        child: Column(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 200,
            ),

            // Image.asset(
            //   "assets/${widget.user.modulo.toLowerCase()}.png",
            //   height: 200,
            // ),
            Text(
              'Bienvenido/a ${widget.user.fullName}',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ));
  }

  Widget _getMenu() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff8c8c94),
              Color(0xff8c8c94),
            ],
          ),
        ),
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff242424),
                    Color(0xff8c8c94),
                  ],
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Image(
                    image: AssetImage('assets/logo.png'),
                    // image: AssetImage(
                    //     'assets/${widget.user.modulo.toLowerCase()}.png'),
                    width: 180,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Usuario: ',
                        style: (TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      Text(
                        widget.user.fullName,
                        style: (const TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.white,
              height: 1,
            ),

            //****************************************************************************************************
            //****************************************************************************************************
            //****************************************************************************************************

            Row(
              children: [
                Expanded(
                  child: ExpansionTile(
                    collapsedIconColor: Colors.white,
                    iconColor: Colors.white,
                    leading: const Icon(
                      Icons.construction,
                      color: Colors.white,
                    ),
                    title: const Text('Obras',
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: ListTile(
                          leading: const Icon(
                            Icons.handyman,
                            color: Colors.white,
                          ),
                          tileColor: const Color(0xff8c8c94),
                          title: const Text('Obras en curso',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          onTap: () async {
                            guardarLocalizacion();
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ObrasScreen(
                                  user: widget.user,
                                  positionUser: _positionUser,
                                  opcion: 1,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: ListTile(
                          leading: const Icon(
                            Icons.engineering,
                            color: Colors.white,
                          ),
                          tileColor: const Color(0xff8c8c94),
                          title: const Text('Mis Obras Asignadas',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          onTap: () async {
                            guardarLocalizacion();
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ObrasAsignadasScreen(
                                  user: widget.user,
                                  positionUser: _positionUser,
                                  opcion: 1,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            widget.user.habilitaMedidores == 1
                ? Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: const Icon(
                            Icons.schedule,
                            color: Colors.white,
                          ),
                          tileColor: const Color(0xff8c8c94),
                          title: const Text('Medidores',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          onTap: () async {
                            guardarLocalizacion();
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MedidoresScreen(
                                  user: widget.user,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : Container(),
            widget.user.habilitaReclamos == 1
                ? Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: const Icon(
                            Icons.border_color,
                            color: Colors.white,
                          ),
                          tileColor: const Color(0xff8c8c94),
                          title: const Text('Reclamos',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          onTap: () async {
                            guardarLocalizacion();
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReclamosScreen(
                                  user: widget.user,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : Container(),
            widget.user.habilitaVeredas == 1
                ? Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: const Icon(
                            Icons.auto_awesome_mosaic,
                            color: Colors.white,
                          ),
                          tileColor: const Color(0xff8c8c94),
                          title: const Text('Veredas',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          onTap: () async {
                            guardarLocalizacion();
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ObrasReparosScreen(
                                  user: widget.user,
                                  positionUser: _positionUser,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : Container(),

            widget.user.habilitaCertificacion == 1
                ? Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: const Icon(
                            Icons.approval,
                            color: Colors.white,
                          ),
                          tileColor: const Color(0xff8c8c94),
                          title: const Text('Certificaciones',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          onTap: () async {
                            guardarLocalizacion();
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CertificacionesScreen(
                                  user: widget.user,
                                  positionUser: _positionUser,
                                  imei: widget.imei,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : Container(),

            widget.user.habilitaNuevoSuministro == 1
                ? Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: const Icon(
                            Icons.electrical_services,
                            color: Colors.white,
                          ),
                          tileColor: const Color(0xff8c8c94),
                          title: const Text('Suministros',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          onTap: () async {
                            guardarLocalizacion();
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ObrasNuevosSuministrosScreen(
                                  user: widget.user,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : Container(),

//****************************************************************************************************
//****************************************************************************************************
//****************************************************************************************************

            widget.user.habilitaElementosCalle == 1
                ? Row(
                    children: [
                      Expanded(
                        child: ExpansionTile(
                          collapsedIconColor: Colors.white,
                          iconColor: Colors.white,
                          leading: const Icon(
                            Icons.fence,
                            color: Colors.white,
                          ),
                          title: const Text('Elem. en Calle',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.report,
                                  color: Colors.white,
                                ),
                                tileColor: const Color(0xff8c8c94),
                                title: const Text('Reportes en Obra',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white)),
                                onTap: () async {
                                  guardarLocalizacion();
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Elementosencallelistado(
                                        user: widget.user,
                                        positionUser: _positionUser,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.summarize,
                                  color: Colors.white,
                                ),
                                tileColor: const Color(0xff8c8c94),
                                title: const Text('Reporte General por Item',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white)),
                                onTap: () async {
                                  guardarLocalizacion();
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Elementosencallereporte(
                                        user: widget.user,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(),

//****************************************************************************************************
//****************************************************************************************************
//****************************************************************************************************

            widget.user.habilitaSSHH == 1
                ? Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: const Icon(
                            Icons.engineering,
                            color: Colors.white,
                          ),
                          tileColor: const Color(0xff8c8c94),
                          title: const Text('Seguridad e Higiene',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          onTap: () async {
                            guardarLocalizacion();
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SeguridadScreen(
                                  user: widget.user,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : Container(),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    leading: const Icon(
                      Icons.warning,
                      color: Colors.white,
                    ),
                    tileColor: const Color(0xff8c8c94),
                    title: Text(
                        widget.user.habilitaSSHH == 1
                            ? 'Siniestros'
                            : 'Mis Siniestros',
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white)),
                    onTap: () async {
                      guardarLocalizacion();
                      String? result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SiniestrosScreen(
                            user: widget.user,
                          ),
                        ),
                      );
                      if (result != 'zzz') {
                        if (widget.user.habilitaRRHH != 1) {
                          _getCausante();
                        }
                      }
                    },
                  ),
                ),
                _novedades.isNotEmpty
                    ? SizedBox(
                        height: 30,
                        width: 30,
                        child: CircleAvatar(
                          child: Text(_novedades.length.toString()),
                          backgroundColor: Colors.red,
                        ),
                      )
                    : Container(),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    leading: const Icon(
                      Icons.newspaper,
                      color: Colors.white,
                    ),
                    tileColor: const Color(0xff8c8c94),
                    title: Text(
                        widget.user.habilitaRRHH == 1
                            ? 'Novedades RRHH'
                            : 'Mis Novedades RRHH',
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white)),
                    onTap: () async {
                      guardarLocalizacion();
                      String? result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NovedadesScreen(
                            user: widget.user,
                          ),
                        ),
                      );
                      if (result != 'zzz') {
                        if (widget.user.habilitaRRHH != 1) {
                          _getCausante();
                        }
                      }
                    },
                  ),
                ),
                _novedades.isNotEmpty
                    ? SizedBox(
                        height: 30,
                        width: 30,
                        child: CircleAvatar(
                          child: Text(_novedades.length.toString()),
                          backgroundColor: Colors.red,
                        ),
                      )
                    : Container(),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
            widget.user.habilitaPresentismo == 1
                ? Row(
                    children: [
                      Expanded(
                        child: ExpansionTile(
                          collapsedIconColor: Colors.white,
                          iconColor: Colors.white,
                          leading: const Icon(
                            Icons.group_outlined,
                            color: Colors.white,
                          ),
                          title: const Text('Presentismo',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.light_mode,
                                  color: Colors.white,
                                ),
                                tileColor: const Color(0xff8c8c94),
                                title: const Text('Presentismo Hoy',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white)),
                                onTap: () async {
                                  guardarLocalizacion();
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PresentismoScreen(
                                        user: widget.user,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.dark_mode,
                                  color: Colors.white,
                                ),
                                tileColor: const Color(0xff8c8c94),
                                title: const Text('Presentismo Turno Noche',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white)),
                                onTap: () async {
                                  guardarLocalizacion();
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PresentismoTurnoNocheScreen(
                                        user: widget.user,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(),
            widget.user.habilitaSSHH == 1
                ? Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: const Icon(
                            Icons.format_list_bulleted,
                            color: Colors.white,
                          ),
                          tileColor: const Color(0xff8c8c94),
                          title: const Text('Inspecciones S&H',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          onTap: () async {
                            guardarLocalizacion();
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InspeccionesMenuScreen(
                                  user: widget.user,
                                  positionUser: _positionUser,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : Container(),
            widget.user.habilitaFlotas.toLowerCase() != 'no'
                ? Row(
                    children: [
                      Expanded(
                        child: ExpansionTile(
                          collapsedIconColor: Colors.white,
                          iconColor: Colors.white,
                          leading: const Icon(
                            Icons.directions_car,
                            color: Colors.white,
                          ),
                          title: const Text('Flotas',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.taxi_alert,
                                  color: Colors.white,
                                ),
                                tileColor: const Color(0xff8c8c94),
                                title: Text(
                                    widget.user.habilitaFlotas.toLowerCase() ==
                                            'admin'
                                        ? 'Km y Preventivos'
                                        : 'Mis Vehículos',
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.white)),
                                onTap: () async {
                                  guardarLocalizacion();
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FlotaScreen(
                                        user: widget.user,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.precision_manufacturing,
                                  color: Colors.white,
                                ),
                                tileColor: const Color(0xff8c8c94),
                                title: const Text('Check List',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white)),
                                onTap: () async {
                                  guardarLocalizacion();
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          GruasCheckListScreen(
                                        user: widget.user,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                ),
                                tileColor: const Color(0xff8c8c94),
                                title: const Text('Turnos Taller',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white)),
                                onTap: () async {
                                  guardarLocalizacion();
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TurnosScreen(
                                        user: widget.user,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(),
            Row(
              children: [
                Expanded(
                  child: ExpansionTile(
                    collapsedIconColor: Colors.white,
                    iconColor: Colors.white,
                    leading: const Icon(
                      Icons.inventory,
                      color: Colors.white,
                    ),
                    title: const Text('Inventarios',
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: ListTile(
                          leading: const Icon(
                            Icons.inventory_outlined,
                            color: Colors.white,
                          ),
                          tileColor: const Color(0xff8c8c94),
                          title: const Text('Conteos Cíclicos',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          onTap: () async {
                            guardarLocalizacion();
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConteosScreen(
                                  user: widget.user,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            widget.user.habilitaJuicios == 1
                ? Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: const Icon(
                            Icons.gavel,
                            color: Colors.white,
                          ),
                          tileColor: const Color(0xff8c8c94),
                          title: const Text('Legales',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LegalesScreen(
                                  user: widget.user,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : Container(),

            widget.user.conceptomov == 1
                ? Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: const Icon(
                            Icons.description,
                            color: Colors.white,
                          ),
                          tileColor: const Color(0xff8c8c94),
                          title: const Text('Movimientos',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          onTap: () async {
                            guardarLocalizacion();
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovimientosScreen(
                                  user: widget.user,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : Container(),

            const Divider(
              color: Colors.white,
              height: 1,
            ),
            widget.user.reHabilitaUsuarios == 1
                ? Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: const Icon(
                            Icons.admin_panel_settings,
                            color: Colors.white,
                          ),
                          tileColor: const Color(0xff8c8c94),
                          title: const Text('Administrador',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminScreen(
                                  user: widget.user,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : Container(),
            widget.user.habilitaSeguimientoUsuarios == 1
                ? Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: const Icon(
                            Icons.person_search_outlined,
                            color: Colors.white,
                          ),
                          tileColor: const Color(0xff8c8c94),
                          title: const Text('Seguimiento Usuarios',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SeguimientoUsuarioScreen(
                                  user: widget.user,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : Container(),
            const Divider(
              color: Colors.white,
              height: 1,
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              tileColor: const Color(0xff8c8c94),
              title: const Text('Cerrar Sesión',
                  style: TextStyle(fontSize: 15, color: Colors.white)),
              onTap: () {
                guardarLocalizacion();
                _logOut();
              },
            ),
          ],
        ),
      ),
    );
  }

//---------------------------------------------------------------
//----------------------- _logOut -------------------------------
//---------------------------------------------------------------

  void _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRemembered', false);
    await prefs.setString('userBody', '');
    await prefs.setString('date', '');

    //------------ Guarda en WebSesion la fecha y hora de salida ----------
    _nroConexion = prefs.getInt('nroConexion');

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      await ApiHelper.putWebSesion(_nroConexion!);
    }

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

//-----------------------------------------------------------------
//--------------------- _getCausante ------------------------------
//-----------------------------------------------------------------

  Future<void> _getCausante() async {
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
          ]);
      return;
    }

    Response response = await ApiHelper.getCausante(_codigo);

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Legajo o Documento no válido',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);

      setState(() {});
      return;
    }

    setState(() {
      _causante = response.result;
    });

    await _getNovedades();
  }

//-----------------------------------------------------------------
//--------------------- _getNovedades -----------------------------
//-----------------------------------------------------------------

  Future<void> _getNovedades() async {
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
          ]);
      return;
    }

    Response response2 = await ApiHelper.getNovedades(
        _causante.grupo, _causante.codigo.toString());

    if (!response2.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Legajo o Documento no válido',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);

      setState(() {});
      return;
    }

    _novedades = [];
    _novedadesAux = response2.result;
    for (var novedad in _novedadesAux) {
      if (novedad.estado != 'Pendiente' && novedad.confirmaLeido != 1) {
        _novedades.add(novedad);
      }
    }
    setState(() {});
  }

//-----------------------------------------------------------------
//--------------------- handleTimeout -----------------------------
//-----------------------------------------------------------------

  handleTimeout(User user) async {
    var connectivityResult = Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return;
    }

    await _getPosition();

    _battery.batteryState.then(_updateBatteryState);
    int batnivel = await _battery.batteryLevel;

    if (_positionUser.latitude == 0 || _positionUser.longitude == 0) {
      return;
    }

    Map<String, dynamic> request1 = {
      'IdUsuario': user.idUsuario,
      'UsuarioStr': user.fullName,
      'LATITUD': _positionUser.latitude,
      'LONGITUD': _positionUser.longitude,
      'PIN': 'mapinred.ico',
      'PosicionCalle': direccion,
      'Velocidad': 0,
      'Bateria': batnivel,
      'Fecha': DateTime.now().toString().substring(0, 10),
      'Modulo': user.modulo,
      'Origen': 1,
    };

    ApiHelper.post('/api/UsuariosGeos', request1);

    return;
  }

//-----------------------------------------------------------------
//--------------------- guardarHoraLocalizacion -------------------
//-----------------------------------------------------------------

  guardarHoraLocalizacion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('horaLocalizacion', DateTime.now().toString());
    return;
  }

//-----------------------------------------------------------------
//--------------------- guardarLocalizacion -----------------------
//-----------------------------------------------------------------

  guardarLocalizacion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String horaLocalizacion = prefs.getString('horaLocalizacion') ?? '';

    if (horaLocalizacion != '') {
      DateTime dateAlmacenada = DateTime.parse(horaLocalizacion);
      if (dateAlmacenada
          .isBefore(DateTime.now().add(const Duration(minutes: -15)))) {
        handleTimeout(widget.user);
        guardarHoraLocalizacion();
      }
    }
    return;
  }

//-----------------------------------------------------------------
//--------------------- _getPosition ------------------------------
//-----------------------------------------------------------------

  Future _getPosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: const Text('Aviso'),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Text('El permiso de localización está negado.'),
                      SizedBox(
                        height: 10,
                      ),
                    ]),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Ok')),
                ],
              );
            });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: const Text('Aviso'),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Text(
                        'El permiso de localización está negado permanentemente. No se puede requerir este permiso.'),
                    SizedBox(
                      height: 10,
                    ),
                  ]),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Ok')),
              ],
            );
          });
      return;
    }

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      _positionUser = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks = await placemarkFromCoordinates(
          _positionUser.latitude, _positionUser.longitude);
      direccion = placemarks[0].street.toString() +
          ' - ' +
          placemarks[0].locality.toString() +
          ' - ' +
          placemarks[0].country.toString();
    }
  }

//-----------------------------------------------------------------
//--------------------- _getPosition ------------------------------
//-----------------------------------------------------------------

  void _updateBatteryState(BatteryState state) {
    if (_batteryState == state) return;
    setState(() {
      _batteryState = state;
    });
  }
}
