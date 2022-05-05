import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rowing_app/components/loader_component.dart';
import 'package:rowing_app/helpers/api_helper.dart';
import 'package:rowing_app/models/entrega.dart';
import 'package:rowing_app/models/response.dart';

class EntregasScreen extends StatefulWidget {
  final String codigo;

  EntregasScreen({required this.codigo});

  @override
  _EntregasScreenState createState() => _EntregasScreenState();
}

class _EntregasScreenState extends State<EntregasScreen> {
  List<Entrega> _entregas = [];
  bool _showLoader = false;
  bool _isFiltered = false;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _getEntregas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF484848),
      appBar: AppBar(
        title: Text('Entregas'),
        centerTitle: true,
        actions: <Widget>[
          _isFiltered
              ? IconButton(
                  onPressed: _removeFilter, icon: Icon(Icons.filter_none))
              : IconButton(onPressed: _showFilter, icon: Icon(Icons.filter_alt))
        ],
      ),
      body: Center(
        child: _showLoader
            ? LoaderComponent(text: 'Por favor espere...')
            : _getContent(),
      ),
    );
  }

  Future<Null> _getEntregas() async {
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

    response = await ApiHelper.getEntregas(widget.codigo);

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
      _entregas = response.result;
      _entregas.sort((a, b) {
        return a.denominacion
            .toString()
            .toLowerCase()
            .compareTo(b.denominacion.toString().toLowerCase());
      });
    });
  }

  Widget _getContent() {
    return Column(
      children: <Widget>[
        _showEntregasCount(),
        Expanded(
          child: _entregas.length == 0 ? _noContent() : _getListView(),
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
              ? 'No hay Entregas con ese criterio de búsqueda'
              : 'No hay Entregas registradas',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getEntregas,
      child: ListView(
        children: _entregas.map((e) {
          return Card(
            color: Color(0xFFC7C7C8),
            shadowColor: Colors.white,
            elevation: 10,
            margin: EdgeInsets.fromLTRB(10, 0, 5, 10),
            child: InkWell(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(e.codigo.toString(),
                                              style: TextStyle(
                                                fontSize: 10,
                                              )),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(e.codigosap,
                                              style: TextStyle(
                                                fontSize: 10,
                                              )),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            child: Text(e.denominacion,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                )),
                                          ),
                                          Text(e.stockAct.toString(),
                                              style: TextStyle(
                                                fontSize: 10,
                                              )),
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
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5),
                      child: Row(
                        children: [
                          Text("Fecha últ. entr.:",
                              style: TextStyle(
                                fontSize: 10,
                              )),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            '${DateFormat('dd/MM/yyyy').format(DateTime.parse(e.fecha))}',
                            style: TextStyle(fontSize: 10),
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

  void _showFilter() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text('Filtrar Entregas'),
            content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Text(
                'Escriba texto a buscar en Descripción: ',
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

  void _removeFilter() {
    setState(() {
      _isFiltered = false;
    });
    _getEntregas();
  }

  _filter() {
    if (_search.isEmpty) {
      return;
    }
    List<Entrega> filteredList = [];

    for (var entrega in _entregas) {
      if (entrega.denominacion.toLowerCase().contains(_search.toLowerCase())) {
        filteredList.add(entrega);
      }
    }

    setState(() {
      _entregas = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
  }

  Widget _showEntregasCount() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          height: 40,
          child: Row(
            children: [
              Text("Cantidad de Items entregados: ",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
              Text(_entregas.length.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ),
        Divider(
          height: 3,
          color: Colors.white,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Row(
            children: [
              Text("Código",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  )),
              SizedBox(
                width: 15,
              ),
              Text("Cod. SAP",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  )),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Text("Descripción",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    )),
              ),
              Text("Cantidad",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  )),
            ],
          ),
        ),
        Divider(
          height: 6,
          color: Colors.white,
        ),
      ],
    );
  }

  _showTitle() {}
}
