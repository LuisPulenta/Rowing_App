import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rowing_app/components/loader_component.dart';
import 'package:rowing_app/helpers/api_helper.dart';
import 'package:rowing_app/models/models.dart';
import 'package:rowing_app/screens/inspecciones_screen.dart';

class InspeccionesListaScreen extends StatefulWidget {
  final User user;
  InspeccionesListaScreen({required this.user});

  @override
  _InspeccionesListaScreenState createState() =>
      _InspeccionesListaScreenState();
}

class _InspeccionesListaScreenState extends State<InspeccionesListaScreen> {
  List<VistaInspeccion> _inspecciones = [];
  bool _showLoader = false;
  bool _isFiltered = false;
  String _search = '';
  VistaInspeccion _inspeccionSelected = new VistaInspeccion(
      usuarioAlta: 0,
      fecha: '',
      empleado: '',
      cliente: '',
      tipoTrabajo: '',
      obra: '',
      totalPreguntas: 0,
      totalNo: 0,
      puntos: 0,
      dniSR: '',
      nombreSR: '');

  @override
  void initState() {
    super.initState();
    _getInspecciones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF484848),
      appBar: AppBar(
        title: Text('Inspecciones'),
        centerTitle: true,
        actions: <Widget>[
          _isFiltered
              ? IconButton(
                  onPressed: _removeFilter, icon: Icon(Icons.filter_none))
              : IconButton(
                  onPressed: _showFilter, icon: Icon(Icons.filter_alt)),
          // IconButton(onPressed: _addReclamo, icon: Icon(Icons.add_circle))
        ],
      ),
      body: Center(
        child: _showLoader
            ? LoaderComponent(text: 'Por favor espere...')
            : _getContent(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 38,
        ),
        backgroundColor: Color(0xFF781f1e),
        onPressed: () => _addInspeccion(),
      ),
    );
  }

  Future<Null> _getInspecciones() async {
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
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response = Response(isSuccess: false);

    response =
        await ApiHelper.getInspecciones(widget.user.idUsuario.toString());

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    setState(() {
      _inspecciones = response.result;
      _inspecciones.sort((a, b) {
        return a.fecha
            .toString()
            .toLowerCase()
            .compareTo(b.fecha.toString().toLowerCase());
      });
    });
  }

  void _removeFilter() {
    setState(() {
      _isFiltered = false;
    });
    _getInspecciones();
  }

  void _showFilter() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text('Filtrar Inspecciones'),
            content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Text(
                'Escriba texto o números a buscar en Cliente o Tipo de Trabajo: ',
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                    hintText: 'Criterio de búsqueda...',
                    labelText: 'Buscar',
                    suffixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
                onChanged: (value) {
                  _search = value;
                },
              ),
            ]),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancelar')),
              TextButton(onPressed: () => _filter(), child: Text('Filtrar')),
            ],
          );
        });
  }

  _filter() {
    if (_search.isEmpty) {
      return;
    }
    List<VistaInspeccion> filteredList = [];
    for (var inspeccion in _inspecciones) {
      if (inspeccion.cliente
              .toString()
              .toLowerCase()
              .contains(_search.toLowerCase()) ||
          inspeccion.tipoTrabajo
              .toString()
              .toLowerCase()
              .contains(_search.toLowerCase())) {
        filteredList.add(inspeccion);
      }
    }

    setState(() {
      _inspecciones = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
  }

  Widget _getContent() {
    return Column(
      children: <Widget>[
        _showReclamosCount(),
        Expanded(
          child: _inspecciones.length == 0 ? _noContent() : _getListView(),
        )
      ],
    );
  }

  Widget _noContent() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Center(
        child: Text(
          _isFiltered
              ? 'No hay Inspecciones con ese criterio de búsqueda'
              : 'No hay Inspecciones registradas',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getInspecciones,
      child: ListView(
        children: _inspecciones.map((e) {
          int largo = 28;
          int fintipotrabajo =
              e.tipoTrabajo.length >= largo ? largo : e.tipoTrabajo.length;
          int finobra = e.obra.length >= largo ? largo : e.obra.length;

          return Card(
            color: Color(0xFFC7C7C8),
            shadowColor: Colors.white,
            elevation: 10,
            margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
            child: InkWell(
              onTap: () {
                _inspeccionSelected = e;
                _goInfoInspeccion();
              },
              child: Container(
                height: 136,
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(5),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text("Fecha: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Empleado: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Cliente: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Tipo Trabajo: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Obra: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Total Preguntas: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Respuestas NO: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Total Puntos: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        )),
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
                                            '${DateFormat('dd/MM/yyyy').format(DateTime.parse(e.fecha))}',
                                            style: TextStyle(
                                              fontSize: 12,
                                            ))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                            e.empleado.toString().trim() ==
                                                    'SIN REGISTRAR'
                                                ? e.nombreSR.toString().trim()
                                                : e.empleado.toString().trim(),
                                            style: TextStyle(
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(e.cliente.toString(),
                                            style: TextStyle(
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                            e.tipoTrabajo
                                                .toString()
                                                .substring(0, fintipotrabajo),
                                            style: TextStyle(
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                            e.obra
                                                .toString()
                                                .substring(1, finobra),
                                            style: TextStyle(
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(e.totalPreguntas.toString(),
                                            style: TextStyle(
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(e.totalNo.toString(),
                                            style: TextStyle(
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(e.puntos.toString(),
                                            style: TextStyle(
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                  ]),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                          icon: Icon(
                            Icons.looks_two_outlined,
                            size: 45,
                            color: Color(0xFF781f1e),
                          ),
                          onPressed: () {}),
                    )
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _goInfoInspeccion() {}

  Widget _showReclamosCount() {
    return Container(
      padding: EdgeInsets.all(10),
      height: 40,
      child: Row(
        children: [
          Text("Cantidad de Inspecciones: ",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
          Text(_inspecciones.length.toString(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }

  void _addInspeccion() async {
    String? result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InspeccionesScreen(
                  user: widget.user,
                )));
    if (result == 'yes') {
      _getInspecciones();
    }
  }
}
