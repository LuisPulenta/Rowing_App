import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../screens.dart';

class NotificacionesScreen extends StatefulWidget {
  final User user;
  final Juicio juicio;

  const NotificacionesScreen({
    Key? key,
    required this.user,
    required this.juicio,
  }) : super(key: key);

  @override
  State<NotificacionesScreen> createState() => _NotificacionesScreenState();
}

class _NotificacionesScreenState extends State<NotificacionesScreen> {
  //---------------------------------------------------------------------
  //-------------------------- Variables --------------------------------
  //---------------------------------------------------------------------
  List<Notificacion> _notificaciones = [];
  bool _showLoader = false;

  //---------------------------------------------------------------------
  //-------------------------- InitState --------------------------------
  //---------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _getNotificaciones();
  }

  //---------------------------------------------------------------------
  //-------------------------- Pantalla ---------------------------------
  //---------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(title: const Text('Notificaciones'), centerTitle: true),
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
              builder: (context) => NotificacionAgregarScreen(
                user: widget.user,
                juicio: widget.juicio,
              ),
            ),
          );
          if (result == 'yes' || result != 'yes') {
            _getNotificaciones();
            setState(() {});
          }
        },
      ),
    );
  }

  //----------------------------------------------------------
  //------------------- _getContent --------------------------
  //----------------------------------------------------------

  Widget _getContent() {
    return Column(
      children: <Widget>[
        _showNotificacionesCount(),
        Expanded(
          child: _notificaciones.isEmpty ? _noContent() : _getListView(),
        ),
      ],
    );
  }

  //----------------------------------------------------------------
  //--------------------  _showNotificacionesCount -----------------
  //----------------------------------------------------------------

  Widget _showNotificacionesCount() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 40,
      child: Row(
        children: [
          const Text(
            'Cantidad de Notificaciones: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _notificaciones.length.toString(),
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
          'No hay Notificaciones registradas',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //-----------------------------------------------------------------------
  //------------------------------ _getListView ---------------------------
  //-----------------------------------------------------------------------

  Widget _getListView() {
    double ancho = 130.0;
    return RefreshIndicator(
      onRefresh: _getNotificaciones,
      child: ListView(
        children: _notificaciones.map((e) {
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
                                        'N° Notificación: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        e.idnotificacion.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    const Text(
                                      'Fecha Carga: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: e.fechacarga != null
                                          ? Text(
                                              DateFormat('dd/MM/yyyy').format(
                                                DateTime.parse(
                                                  e.fechacarga.toString(),
                                                ),
                                              ),
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            )
                                          : Container(),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: ancho,
                                      child: const Text(
                                        'Tipo: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.tipo != null ? e.tipo.toString() : '',
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
                                        'Título: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.titulo != null
                                            ? e.titulo.toString()
                                            : '',
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
                                        'Observaciones: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.observaciones != null
                                            ? e.observaciones.toString()
                                            : '',
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
                                        'Moneda: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.moneda != null
                                            ? e.moneda.toString()
                                            : '',
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
                                        'Monto: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.monto != null
                                            ? NumberFormat.currency(
                                                symbol: '\$',
                                              ).format(e.monto)
                                            : '',
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
                                        'Tipo transacción: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.tipotransaccion != null
                                            ? e.tipotransaccion.toString()
                                            : '',
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
                                        'Condición pago: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.condicionpago != null
                                            ? e.condicionpago.toString()
                                            : '',
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
                                        'N° Factura: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.nrofactura != null
                                            ? e.nrofactura.toString()
                                            : '',
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
                                        'Lugar: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.lugar != null
                                            ? e.lugar.toString()
                                            : '',
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
                                        'Participantes: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.participantes != null
                                            ? e.participantes.toString()
                                            : '',
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
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  //---------------------------------------------------------------------
  //-------------------------- _getNotificaciones -----------------------
  //---------------------------------------------------------------------

  Future<void> _getNotificaciones() async {
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

    response = await ApiHelper.getNotificaciones(
      widget.juicio.iDCASO.toString(),
    );

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
      _notificaciones = response.result;
      _notificaciones.sort((b, a) {
        return a.idnotificacion.compareTo(b.idnotificacion);
      });
    });
  }
}
