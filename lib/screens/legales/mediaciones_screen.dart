import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../screens.dart';

class MediacionesScreen extends StatefulWidget {
  final User user;
  final Juicio juicio;

  const MediacionesScreen({Key? key, required this.user, required this.juicio})
    : super(key: key);

  @override
  State<MediacionesScreen> createState() => _MediacionesScreenState();
}

class _MediacionesScreenState extends State<MediacionesScreen> {
  //---------------------------------------------------------------------
  //-------------------------- Variables --------------------------------
  //---------------------------------------------------------------------
  List<Mediacion> _mediaciones = [];
  bool _showLoader = false;

  //---------------------------------------------------------------------
  //-------------------------- InitState --------------------------------
  //---------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _getMediaciones();
  }

  //---------------------------------------------------------------------
  //-------------------------- Pantalla ---------------------------------
  //---------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(title: const Text('Mediaciones'), centerTitle: true),
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
              builder: (context) => MediacionAgregarScreen(
                user: widget.user,
                juicio: widget.juicio,
              ),
            ),
          );
          if (result == 'yes' || result != 'yes') {
            _getMediaciones();
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
        _showMediacionesCount(),
        Expanded(child: _mediaciones.isEmpty ? _noContent() : _getListView()),
      ],
    );
  }

  //----------------------------------------------------------------
  //--------------------  _showMediacionesCount --------------------
  //----------------------------------------------------------------

  Widget _showMediacionesCount() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 40,
      child: Row(
        children: [
          const Text(
            'Cantidad de Mediaciones: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _mediaciones.length.toString(),
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

  //---------------------------------------------------------------
  //---------------------- _noContent -----------------------------
  //---------------------------------------------------------------

  Widget _noContent() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: const Center(
        child: Text(
          'No hay Mediaciones registradas',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //----------------------------------------------------------------
  //----------------------- _getListView ---------------------------
  //----------------------------------------------------------------

  Widget _getListView() {
    double ancho = 130.0;
    return RefreshIndicator(
      onRefresh: _getMediaciones,
      child: ListView(
        children: _mediaciones.map((e) {
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
                                        'N° Mediación: ',
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
                                        e.idmediacion.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    const Text(
                                      'Fecha: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: e.fecha != null
                                          ? Text(
                                              DateFormat('dd/MM/yyyy').format(
                                                DateTime.parse(
                                                  e.fecha.toString(),
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
                                        e.moneda.toString(),
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
                                        'Ofrecimiento: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.ofrecimiento != null
                                            ? NumberFormat.currency(
                                                symbol: '\$',
                                              ).format(e.ofrecimiento)
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
                                        e.tipotransaccion.toString(),
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
                                        'Condición de pago: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.condicionpago.toString(),
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
                                        'Vencimiento oferta: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: e.vencimientooferta != null
                                          ? Text(
                                              DateFormat('dd/MM/yyyy').format(
                                                DateTime.parse(
                                                  e.vencimientooferta
                                                      .toString(),
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
                                        'Resultado oferta: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.resultadooferta.toString(),
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
                                        'Monto contra oferta: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.montocontraoferta != null
                                            ? NumberFormat.currency(
                                                symbol: '\$',
                                              ).format(e.montocontraoferta)
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
                                        'Acept. contra oferta: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.aceptacioncontraoferta.toString(),
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
  //-------------------------- _getMediaciones --------------------------
  //---------------------------------------------------------------------

  Future<void> _getMediaciones() async {
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

    response = await ApiHelper.getMediaciones(widget.juicio.iDCASO.toString());

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
      _mediaciones = response.result;
      _mediaciones.sort((b, a) {
        return a.idmediacion.compareTo(b.idmediacion);
      });
    });
  }
}
