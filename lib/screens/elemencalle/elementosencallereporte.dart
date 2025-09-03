import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';

class Elementosencallereporte extends StatefulWidget {
  final User user;
  const Elementosencallereporte({super.key, required this.user});

  @override
  State<Elementosencallereporte> createState() =>
      _ElementosencallereporteState();
}

class _ElementosencallereporteState extends State<Elementosencallereporte> {
  //---------------------------------------------------------------------
  //-------------------------- Variables --------------------------------
  //---------------------------------------------------------------------

  bool _showLoader = false;
  List<ElemEnCalleTotales> _elemEnCalleTotales = [];

  //---------------------------------------------------------------------
  //-------------------------- initState --------------------------------
  //---------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _getElemEnCalle();
  }

  //---------------------------------------------------------------------
  //-------------------------- Pantalla --------------------------------
  //---------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: const Text('Elementos en calle reporte'),
        centerTitle: true,
      ),
      body: Center(
        child: _showLoader
            ? const LoaderComponent(text: 'Por favor espere...')
            : _getContent(),
      ),
    );
  }

  //---------------------------------------------------------------------
  //------------------------------ _getContent --------------------------
  //---------------------------------------------------------------------

  Widget _getContent() {
    return Column(
      children: <Widget>[
        _showItemsCount(),
        Expanded(
          child: _elemEnCalleTotales.isEmpty
              ? _noContent()
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Text(
                          'Catálogos         ',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Elemento   ',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Cantidad                 ',
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Expanded(child: _getListView()),
                  ],
                ),
        ),
      ],
    );
  }

  //-----------------------------------------------------------------------
  //------------------------------ _showItemsCount ------------------------
  //-----------------------------------------------------------------------

  Widget _showItemsCount() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 40,
      child: Row(
        children: [
          const Text(
            'Cantidad de Items: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _elemEnCalleTotales.length.toString(),
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
          'No hay Elementos en Calle',
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
      onRefresh: _getElemEnCalle,
      child: ListView(
        children: _elemEnCalleTotales.map((e) {
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
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        '${e.catsiag}/${e.catsap}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        e.elemento.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        e.cantdejada.toString(),
                                        textAlign: TextAlign.end,
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

  //---------------------------------------------------------------
  //----------------------- _getElemEnCalle -----------------------
  //---------------------------------------------------------------

  Future<void> _getElemEnCalle() async {
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

    response = await ApiHelper.getElemEnCalleTotales();

    if (!response.isSuccess) {
      final _ = await showAlertDialog(
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
      _elemEnCalleTotales = response.result;
      _elemEnCalleTotales.sort((a, b) {
        return a.elemento.toString().toLowerCase().compareTo(
          b.elemento.toString().toLowerCase(),
        );
      });
    });

    setState(() {
      _showLoader = false;
    });
  }
}
