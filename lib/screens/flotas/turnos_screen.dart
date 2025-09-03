import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../screens.dart';

class TurnosScreen extends StatefulWidget {
  final User user;
  const TurnosScreen({super.key, required this.user});

  @override
  State<TurnosScreen> createState() => _TurnosScreenState();
}

class _TurnosScreenState extends State<TurnosScreen> {
  //---------------------------------------------------------------------
  //-------------------------- Variables --------------------------------
  //---------------------------------------------------------------------

  List<Turno> _turnos = [];
  bool _showLoader = false;
  List<Causante> _talleres = [];

  //---------------------------------------------------------------------
  //-------------------------- InitState --------------------------------
  //---------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _getTalleres();
  }

  //---------------------------------------------------------------------
  //-------------------------- Pantalla ---------------------------------
  //---------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(title: const Text('Turnos Taller'), centerTitle: true),
      body: Center(
        child: _showLoader
            ? const LoaderComponent(text: 'Por favor espere...')
            : _getContent(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF781f1e),
        child: const Icon(Icons.add),
        onPressed: () async {
          String? result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TurnosAgregarScreen(user: widget.user),
            ),
          );
          if (result == 'yes') {
            _getTurnos();
            setState(() {});
          }
        },
      ),
    );
  }

  //---------------------------------------------------------------------
  //------------------------------ _getContent --------------------------
  //---------------------------------------------------------------------

  Widget _getContent() {
    return Column(
      children: <Widget>[
        _showTurnosCount(),
        Expanded(child: _turnos.isEmpty ? _noContent() : _getListView()),
      ],
    );
  }

  //--------------------------------------------------------------------------
  //------------------------------  _showTurnosCount -------------------------
  //--------------------------------------------------------------------------

  Widget _showTurnosCount() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 40,
      child: Row(
        children: [
          const Text(
            'Cantidad de Turnos: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _turnos.length.toString(),
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
      child: const Center(
        child: Text(
          'No hay Turnos registrados',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //-----------------------------------------------------------------------
  //------------------------------ _getListView ---------------------------
  //-----------------------------------------------------------------------

  Widget _getListView() {
    double ancho = 80.0;
    return RefreshIndicator(
      onRefresh: _getTurnos,
      child: ListView(
        children: _turnos.map((e) {
          return Card(
            color: const Color(0xFFC7C7C8),
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
                                        'Turno: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.idTurno.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: ancho,
                                      child: const Text(
                                        'Patente: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.numcha.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: ancho,
                                      child: const Text(
                                        'Asignado a: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.asignadoActual.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: ancho,
                                      child: const Text(
                                        'Taller: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.taller.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(color: Color(0xFF781f1e)),
                                Row(
                                  children: const [
                                    Text(
                                      'SOLICITADO PARA: ',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.purple,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: ancho,
                                      child: const Text(
                                        'Fecha: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: e.fechaTurno != null
                                          ? Text(
                                              DateFormat('dd/MM/yyyy').format(
                                                DateTime.parse(
                                                  e.fechaTurno.toString(),
                                                ),
                                              ),
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            )
                                          : Container(),
                                    ),
                                    const Text(
                                      'Hora: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        _horaMinuto(e.horaTurno!),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(color: Color(0xFF781f1e)),
                                Row(
                                  children: const [
                                    Text(
                                      'CONFIRMADO PARA: ',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.purple,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: ancho,
                                      child: const Text(
                                        'Fecha: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: e.fechaTurnoConfirmado != null
                                          ? Text(
                                              DateFormat('dd/MM/yyyy').format(
                                                DateTime.parse(
                                                  e.fechaTurnoConfirmado
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
                                      'Hora: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: e.horaTurnoConfirmado != 0
                                          ? Text(
                                              _horaMinuto(
                                                e.horaTurnoConfirmado!,
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
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  //-------------------------------------------------------------
  //------------------------- _getTalleres ----------------------
  //-------------------------------------------------------------

  Future<void> _getTalleres() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      showMyDialog(
        'Error',
        'Verifica que estés conectado a Internet',
        'Aceptar',
      );
    }

    Response response = Response(isSuccess: false);
    response = await ApiHelper.getCausantesTalleres();

    if (response.isSuccess) {
      _talleres = response.result;
    }
    setState(() {});
    await _getTurnos();
  }

  //---------------------------------------------------------------------
  //-------------------------- _getTurnos -------------------------------
  //---------------------------------------------------------------------

  Future<void> _getTurnos() async {
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

    response = await ApiHelper.getTurnos(widget.user.idUsuario.toString());

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
      _turnos = response.result;
      _turnos.sort((b, a) {
        return a.idTurno.compareTo(b.idTurno);
      });
    });

    for (var turno in _turnos) {
      for (var taller in _talleres) {
        if (turno.causante == taller.codigo) {
          turno.taller = taller.nombre;
        }
      }
    }
  }

  //----------------------------------------------------------------------------
  //----------------------------- _HoraMinuto ----------------------------------
  //----------------------------------------------------------------------------

  String _horaMinuto(int valor) {
    String hora = (valor / 3600).floor().toString();
    String minutos = ((valor - ((valor / 3600).floor()) * 3600) / 60)
        .round()
        .toString();

    if (minutos.length == 1) {
      minutos = '0$minutos';
    }
    return '$hora:$minutos';
  }
}
