// ignore_for_file: unnecessary_const

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/reclamo.dart';
import '../../models/response.dart';
import '../../models/user.dart';
import '../screens.dart';

class ReclamosScreen extends StatefulWidget {
  final User user;
  const ReclamosScreen({super.key, required this.user});

  @override
  _ReclamosScreenState createState() => _ReclamosScreenState();
}

class _ReclamosScreenState extends State<ReclamosScreen> {
  //-----------------------------------------------------------------
  //--------------------- Variables ---------------------------------
  //-----------------------------------------------------------------

  List<Reclamo> _reclamos = [];
  bool _showLoader = false;
  bool _isFiltered = false;
  String _search = '';

  //-----------------------------------------------------------------
  //--------------------- initState ---------------------------------
  //-----------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _getReclamos();
  }

  //-----------------------------------------------------------------
  //--------------------- Pantallas ---------------------------------
  //-----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: const Text('Reclamos'),
        centerTitle: true,
        actions: <Widget>[
          _isFiltered
              ? IconButton(
                  onPressed: _removeFilter,
                  icon: const Icon(Icons.filter_none),
                )
              : IconButton(
                  onPressed: _showFilter,
                  icon: const Icon(Icons.filter_alt),
                ),
          // IconButton(onPressed: _addReclamo, icon: Icon(Icons.add_circle))
        ],
      ),
      body: Center(
        child: _showLoader
            ? const LoaderComponent(text: 'Por favor espere...')
            : _getContent(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF781f1e),
        onPressed: () => _addReclamo(),
        child: const Icon(Icons.add, size: 38),
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _getReclamos ------------------------------
  //-----------------------------------------------------------------

  Future<void> _getReclamos() async {
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

    response = await ApiHelper.getReclamos(widget.user.idUsuario.toString());

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
      _reclamos = response.result;
      _reclamos.sort((a, b) {
        return a.asticket.toString().toLowerCase().compareTo(
          b.asticket.toString().toLowerCase(),
        );
      });
    });
  }

  //-----------------------------------------------------------------
  //--------------------- _removeFilter -----------------------------
  //-----------------------------------------------------------------

  void _removeFilter() {
    setState(() {
      _isFiltered = false;
    });
    _getReclamos();
  }

  //-----------------------------------------------------------------
  //--------------------- _showFilter -------------------------------
  //-----------------------------------------------------------------

  void _showFilter() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('Filtrar Reclamos'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Escriba texto o números a buscar en Dirección o Número del Reclamo: ',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 10),
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Criterio de búsqueda...',
                  labelText: 'Buscar',
                  suffixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  _search = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => _filter(),
              child: const Text('Filtrar'),
            ),
          ],
        );
      },
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _filter -----------------------------------
  //-----------------------------------------------------------------

  void _filter() {
    if (_search.isEmpty) {
      return;
    }
    List<Reclamo> filteredList = [];
    for (var reclamo in _reclamos) {
      if (reclamo.asticket.toString().toLowerCase().contains(
            _search.toLowerCase(),
          ) ||
          reclamo.direccion.toString().toLowerCase().contains(
            _search.toLowerCase(),
          )) {
        filteredList.add(reclamo);
      }
    }

    setState(() {
      _reclamos = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
  }

  //-----------------------------------------------------------------
  //--------------------- _getContent -------------------------------
  //-----------------------------------------------------------------

  Widget _getContent() {
    return Column(
      children: <Widget>[
        _showReclamosCount(),
        Expanded(child: _reclamos.isEmpty ? _noContent() : _getListView()),
      ],
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _noContent --------------------------------
  //-----------------------------------------------------------------

  Widget _noContent() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          _isFiltered
              ? 'No hay Reclamos con ese criterio de búsqueda'
              : 'No hay Reclamos registrados',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _getListView ------------------------------
  //-----------------------------------------------------------------

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getReclamos,
      child: ListView(
        children: _reclamos.map((e) {
          return Card(
            color: const Color(0xFFC7C7C8),
            shadowColor: Colors.white,
            elevation: 10,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
            child: InkWell(
              onTap: () {
                _goInfoReclamo(e);
              },
              child: Container(
                height: 100,
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: 100,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Text(
                                      'AS/N° Reclamo: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: const [
                                    Text(
                                      'Zona: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: const [
                                    Text(
                                      'Dirección: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: const [
                                    Text(
                                      'N°: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: const [
                                    Text(
                                      'Descr./Nombre: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Text(
                                        e.asticket.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        e.zona.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        e.direccion.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        e.numeracion.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        e.terminal.toString(),
                                        style: const TextStyle(fontSize: 12),
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
  //--------------------- _goInfoReclamo ----------------------------
  //-----------------------------------------------------------------

  void _goInfoReclamo(Reclamo reclamo) async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ReclamoInfoScreen(user: widget.user, reclamo: reclamo),
      ),
    );
    if (result == 'yes') {
      _getReclamos();
      setState(() {});
    }
  }

  //-----------------------------------------------------------------
  //--------------------- _showReclamosCount ------------------------
  //-----------------------------------------------------------------

  Widget _showReclamosCount() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 40,
      child: Row(
        children: [
          const Text(
            'Cantidad de Reclamos: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _reclamos.length.toString(),
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

  //-----------------------------------------------------------------
  //--------------------- _addReclamo -------------------------------
  //-----------------------------------------------------------------

  void _addReclamo() async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReclamoAgregarScreen(user: widget.user),
      ),
    );
    if (result == 'yes') {
      _getReclamos();
    }
  }
}
