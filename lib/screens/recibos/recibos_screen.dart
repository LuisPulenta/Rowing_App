import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:rowing_app/components/loader_component.dart';
import 'package:rowing_app/helpers/helpers.dart';
import 'package:rowing_app/models/models.dart';
import 'package:rowing_app/screens/screens.dart';

class RecibosScreen extends StatefulWidget {
  final User user;
  final Position positionUser;

  const RecibosScreen(
      {Key? key, required this.user, required this.positionUser})
      : super(key: key);

  @override
  State<RecibosScreen> createState() => _RecibosScreenState();
}

class _RecibosScreenState extends State<RecibosScreen> {
  //----------------------- Variables -----------------------------
  List<Recibo> _recibos = [];
  bool _showLoader = false;

//----------------------- initState -----------------------------
  @override
  void initState() {
    super.initState();
    _getRecibos();
  }

//----------------------- Pantalla -----------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: const Text('Mis Recibos'),
        centerTitle: true,
      ),
      body: Center(
        child: _showLoader
            ? const LoaderComponent(text: 'Por favor espere...')
            : _getContent(),
      ),
    );
  }

//------------------------------ _getContent --------------------------
  Widget _getContent() {
    return Column(
      children: <Widget>[
        _showRecibosCount(),
        Expanded(
          child: _recibos.isEmpty ? _noContent() : _getListView(),
        )
      ],
    );
  }

//------------------------------ _showRecibosCount ------------------------

  Widget _showRecibosCount() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 40,
      child: Row(
        children: [
          const Text("Cantidad de Recibos: ",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
          Text(_recibos.length.toString(),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
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
          'No hay Recibos',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

//-----------------------------------------------------------------------
//------------------------------ _getListView ---------------------------
//-----------------------------------------------------------------------

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getRecibos,
      child: ListView(
        children: _recibos.map((e) {
          return Card(
            color: e.firmado == 1
                ? Color.fromARGB(255, 216, 179, 227)
                : Color(0xFFC7C7C8),
            shadowColor: Colors.white,
            elevation: 10,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: InkWell(
              onTap: () {
                _goInfoRecibo(e);
              },
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
                                      const Text("N° Recibo: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF781f1e),
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Expanded(
                                        flex: 3,
                                        child: Text(e.idrecibo.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            )),
                                      ),
                                      const Text("Año: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF781f1e),
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Expanded(
                                        flex: 3,
                                        child: Text(e.anio.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            )),
                                      ),
                                      const Text("Mes: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF781f1e),
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Expanded(
                                        flex: 4,
                                        child: Text(e.mes.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            )),
                                      ),
                                      if (e.firmado == 1)
                                        const Text(
                                          "FIRMADO!!",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      const Text("Nª Secuencia: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF781f1e),
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Expanded(
                                        child: Text(e.nroSecuencia.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            )),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  e.fechaPagoExcel != null
                                      ? Row(
                                          children: [
                                            const Text("Fecha Pago: ",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF781f1e),
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            Expanded(
                                              child: Text(
                                                  DateFormat('dd/MM/yyyy')
                                                      .format(DateTime.parse(e
                                                          .fechaPagoExcel
                                                          .toString())),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  )),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  e.fechaIniExcel != null
                                      ? Row(
                                          children: [
                                            const Text("Fecha Inic.: ",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF781f1e),
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            Expanded(
                                              child: Text(
                                                  DateFormat('dd/MM/yyyy')
                                                      .format(DateTime.parse(e
                                                          .fechaIniExcel
                                                          .toString())),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  )),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  e.fechaFinExcel != null
                                      ? Row(
                                          children: [
                                            const Text("Fecha Fin: ",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF781f1e),
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            Expanded(
                                              child: Text(
                                                  DateFormat('dd/MM/yyyy')
                                                      .format(DateTime.parse(e
                                                          .fechaFinExcel
                                                          .toString())),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  )),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  Text(e.link ?? ''),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

//----------------------- _getRecibos -----------------------------
  Future<void> _getRecibos() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      showMyDialog(
          'Error', "Verifica que estés conectado a Internet", 'Aceptar');
    }

    Response response = Response(isSuccess: false);

    Map<String, dynamic> request = {
      'Grupo': widget.user.codigogrupo,
      'Codigo': widget.user.codigoCausante
    };

    response = await ApiHelper.post('/api/CausanteRecibos/GetRecibos', request);

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
          ]);
      return;
    }

    setState(() {
      List<Recibo> list = [];
      var decodedJson = jsonDecode(response.result);
      if (decodedJson != null) {
        for (var item in decodedJson) {
          list.add(Recibo.fromJson(item));
        }
      }
      _recibos = list;
    });
  }

//----------------------- _goInfoRecibo ---------------------------

  void _goInfoRecibo(Recibo recibo) async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewScreen(
          url:
              'http://190.111.249.225/RowingAppApi/images/Recibos/${recibo.link}',
          firma: widget.user.firmaUsuarioImageFullPath!,
          positionUser: widget.positionUser,
          recibo: recibo,
        ),
      ),
    );

    // String? result = await Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ReciboScreen(
    //       user: widget.user,
    //       recibo: recibo,
    //       positionUser: widget.positionUser,
    //     ),
    //   ),
    // );

    if (result == 'yes' || result != 'yes') {
      _getRecibos();
      setState(() {});
    }
  }
}
