import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:rowing_app/components/loader_component.dart';
import 'package:rowing_app/models/models.dart';
import 'package:rowing_app/screens/screens.dart';

import '../../helpers/api_helper.dart';

class Elementosencallelistado extends StatefulWidget {
  final User user;
  final Position positionUser;
  const Elementosencallelistado(
      {Key? key, required this.user, required this.positionUser})
      : super(key: key);

  @override
  State<Elementosencallelistado> createState() =>
      _ElementosencallelistadoState();
}

class _ElementosencallelistadoState extends State<Elementosencallelistado> {
//---------------------------------------------------------------------
//-------------------------- Variables --------------------------------
//---------------------------------------------------------------------

  bool _showLoader = false;
  List<ElemEnCalle> _elemEnCalle = [];

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
        title: const Text('Elementos en Calle'),
        centerTitle: true,
      ),
      body: Center(
        child: _showLoader
            ? const LoaderComponent(text: 'Por favor espere...')
            : _getContent(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          size: 38,
        ),
        backgroundColor: const Color(0xFF781f1e),
        onPressed: () => _addReporte(),
      ),
    );
  }

//---------------------------------------------------------------------
//------------------------------ _getContent --------------------------
//---------------------------------------------------------------------

  Widget _getContent() {
    return Column(
      children: <Widget>[
        _showElemEnCalleCount(),
        Expanded(
          child: _elemEnCalle.isEmpty ? _noContent() : _getListView(),
        )
      ],
    );
  }

//-----------------------------------------------------------------------
//------------------------------ _showObrasCount ------------------------
//-----------------------------------------------------------------------

  Widget _showElemEnCalleCount() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 40,
      child: Row(
        children: [
          const Text("Cantidad de Obras con Elementos en Calle: ",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
          Text(_elemEnCalle.length.toString(),
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
          'No hay Obras con Elementos en Calle',
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
        children: _elemEnCalle.map((e) {
          return Card(
            color: const Color(0xFFC7C7C8),
            shadowColor: Colors.white,
            elevation: 10,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: InkWell(
              onTap: () {
                //_goInfoObra(e);
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
                                      const Text("N° Obra: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF781f1e),
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Expanded(
                                        flex: 3,
                                        child: Text(e.nroobra.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            )),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      const Text("Nombre: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF781f1e),
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Expanded(
                                        child: Text(e.nombreObra,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            )),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      const Text("Domicilio: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF781f1e),
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Expanded(
                                        child: Text(e.domicilio,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            )),
                                      ),
                                      const SizedBox(
                                        width: 20,
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

//-----------------------------------------------------------------
//--------------------- _addReporte -------------------------------
//-----------------------------------------------------------------

  void _addReporte() async {
    String? result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Elementosencalle(
                  user: widget.user,
                  positionUser: widget.positionUser,
                )));
    if (result != 'xyz') {
      _getElemEnCalle();
    }
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
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estés conectado a Internet',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response = Response(isSuccess: false);

    response = await ApiHelper.getElemEnCalle();

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
      _elemEnCalle = response.result;
      _elemEnCalle.sort((a, b) {
        return a.id
            .toString()
            .toLowerCase()
            .compareTo(b.id.toString().toLowerCase());
      });
      _showLoader = false;
    });
  }
}
