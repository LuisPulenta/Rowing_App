import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../screens.dart';

class InspeccionesListaScreen extends StatefulWidget {
  final User user;
  final Position positionUser;
  const InspeccionesListaScreen({
    super.key,
    required this.user,
    required this.positionUser,
  });

  @override
  _InspeccionesListaScreenState createState() =>
      _InspeccionesListaScreenState();
}

class _InspeccionesListaScreenState extends State<InspeccionesListaScreen> {
  //--------------------------------------------------------------------
  //------------------------------ Variables ---------------------------
  //--------------------------------------------------------------------

  List<VistaInspeccion> _inspecciones = [];
  bool _showLoader = false;
  bool _isFiltered = false;
  String _search = '';

  //--------------------------------------------------------------------
  //------------------------------ initState ---------------------------
  //--------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _getInspecciones();
  }

  //--------------------------------------------------------------------
  //------------------------------ Pantalla ----------------------------
  //--------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: const Text('Inspecciones'),
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
        onPressed: () => _addInspeccion(),
        child: const Icon(Icons.add, size: 38),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  //--------------------------------------------------------------------
  //--------------------------- _getInspecciones -----------------------
  //--------------------------------------------------------------------

  Future<void> _getInspecciones() async {
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

    response = await ApiHelper.getInspecciones(
      widget.user.idUsuario.toString(),
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
      _inspecciones = response.result;
      _inspecciones.sort((a, b) {
        return a.fecha.toString().toLowerCase().compareTo(
          b.fecha.toString().toLowerCase(),
        );
      });
    });
  }

  //--------------------------------------------------------------------
  //--------------------------- _removeFilter --------------------------
  //--------------------------------------------------------------------

  void _removeFilter() {
    setState(() {
      _isFiltered = false;
    });
    _getInspecciones();
  }

  //--------------------------------------------------------------------
  //--------------------------- _showFilter ----------------------------
  //--------------------------------------------------------------------

  void _showFilter() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('Filtrar Inspecciones'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Escriba texto o números a buscar en Cliente o Tipo de Trabajo: ',
                style: TextStyle(fontSize: 12),
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

  //--------------------------------------------------------------------
  //--------------------------- _filter --------------------------------
  //--------------------------------------------------------------------

  void _filter() {
    if (_search.isEmpty) {
      return;
    }
    List<VistaInspeccion> filteredList = [];
    for (var inspeccion in _inspecciones) {
      if (inspeccion.cliente.toString().toLowerCase().contains(
            _search.toLowerCase(),
          ) ||
          inspeccion.tipoTrabajo.toString().toLowerCase().contains(
            _search.toLowerCase(),
          )) {
        filteredList.add(inspeccion);
      }
    }

    setState(() {
      _inspecciones = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
  }

  //--------------------------------------------------------------------
  //--------------------------- _getContent ----------------------------
  //--------------------------------------------------------------------

  Widget _getContent() {
    return Column(
      children: <Widget>[
        _showInspeccionesCount(),
        Expanded(child: _inspecciones.isEmpty ? _noContent() : _getListView()),
      ],
    );
  }

  //--------------------------------------------------------------------
  //--------------------------- _noContent -----------------------------
  //--------------------------------------------------------------------

  Widget _noContent() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          _isFiltered
              ? 'No hay Inspecciones con ese criterio de búsqueda'
              : 'No hay Inspecciones registradas',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //--------------------------------------------------------------------
  //--------------------------- _getListView ---------------------------
  //--------------------------------------------------------------------

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getInspecciones,
      child: ListView(
        children: _inspecciones.map((e) {
          int largo = 28;
          e.empleado = e.empleado.trim();
          if (e.empleado.length > 25) {
            e.empleado = e.empleado.substring(0, 25);
          }

          int finempleado = e.empleado.length >= largo
              ? largo
              : e.empleado.length;

          int fintipotrabajo = e.tipoTrabajo.length >= largo
              ? largo
              : e.tipoTrabajo.length;

          int finobra = e.obra.length >= largo ? largo : e.obra.length;

          return Card(
            color: const Color(0xFFC7C7C8),
            shadowColor: Colors.white,
            elevation: 10,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
            child: InkWell(
              onTap: () {},
              child: Container(
                height: 136,
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
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
                                      'Fecha-Id: ',
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
                                      'Empleado: ',
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
                                      'Cliente: ',
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
                                      'Tipo Trabajo: ',
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
                                      'Obra: ',
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
                                      'Total Preguntas: ',
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
                                      'Respuestas NO: ',
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
                                      'Total Puntos: ',
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
                                        '${DateFormat('dd/MM/yyyy').format(DateTime.parse(e.fecha))} - ${e.idInspeccion}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        e.empleado.toString().trim() ==
                                                'SIN REGISTRAR'
                                            ? e.nombreSR.toString().trim()
                                            : e.empleado.toString().substring(
                                                0,
                                                finempleado,
                                              ),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        e.cliente.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        e.tipoTrabajo.toString().substring(
                                          0,
                                          fintipotrabajo,
                                        ),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        e.obra.toString().substring(0, finobra),
                                        style: const TextStyle(fontSize: 11),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        e.totalPreguntas.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        e.totalNo.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        e.puntos.toString(),
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
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                        icon: const Icon(
                          Icons.looks_two_outlined,
                          size: 45,
                          color: Color(0xFF781f1e),
                        ),
                        onPressed: () {
                          _goInfoInspeccion(e);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  //--------------------------------------------------------------------
  //--------------------------- _goInfoInspeccion ----------------------
  //--------------------------------------------------------------------

  void _goInfoInspeccion(VistaInspeccion e) async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            InspeccionDuplicarScreen(user: widget.user, vistaInspeccion: e),
      ),
    );
    if (result == 'yes') {
      _getInspecciones();
    }
  }

  //--------------------------------------------------------------------
  //--------------------------- _showInspeccionesCount -----------------
  //--------------------------------------------------------------------

  Widget _showInspeccionesCount() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 40,
      child: Row(
        children: [
          const Text(
            'Cantidad de Inspecciones: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _inspecciones.length.toString(),
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

  //------------------------------------------------------------
  //--------------------------- _addInspeccion -----------------
  //------------------------------------------------------------

  void _addInspeccion() async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InspeccionesScreen(
          user: widget.user,
          positionUser: widget.positionUser,
        ),
      ),
    );
    if (result == 'yes') {
      _getInspecciones();
    }
  }
}
