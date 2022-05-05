import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:rowing_app/components/loader_component.dart';
import 'package:rowing_app/helpers/api_helper.dart';
import 'package:rowing_app/models/reclamo.dart';
import 'package:rowing_app/models/response.dart';
import 'package:rowing_app/models/user.dart';
import 'package:rowing_app/screens/reclamoagregar_screen.dart';
import 'package:rowing_app/screens/reclamoinfo_screen.dart';

class ReclamosScreen extends StatefulWidget {
  final User user;
  ReclamosScreen({required this.user});

  @override
  _ReclamosScreenState createState() => _ReclamosScreenState();
}

class _ReclamosScreenState extends State<ReclamosScreen> {
  List<Reclamo> _reclamos = [];
  bool _showLoader = false;
  bool _isFiltered = false;
  String _search = '';
  Reclamo _reclamoSelected = new Reclamo(
      nroregistro: 0,
      nroobra: 0,
      asticket: '',
      cliente: '',
      direccion: '',
      numeracion: '',
      localidad: '',
      telefono: '',
      tipoImput: '',
      certificado: '',
      serieMedidorColocado: '',
      precinto: '',
      cajaDAE: '',
      observaciones: '',
      lindero1: '',
      lindero2: '',
      zona: '',
      terminal: '',
      subcontratista: '',
      causanteC: '',
      grxx: '',
      gryy: '',
      idUsrIn: 0,
      observacionAdicional: '',
      fechaCarga: '',
      riesgoElectrico: '',
      fechaasignacion: '',
      mes: 0);

  @override
  void initState() {
    super.initState();
    _getReclamos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF484848),
      appBar: AppBar(
        title: Text('Reclamos'),
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
        onPressed: () => _addReclamo(),
      ),
    );
  }

  Future<Null> _getReclamos() async {
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
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    setState(() {
      _reclamos = response.result;
      _reclamos.sort((a, b) {
        return a.asticket
            .toString()
            .toLowerCase()
            .compareTo(b.asticket.toString().toLowerCase());
      });
    });
  }

  void _removeFilter() {
    setState(() {
      _isFiltered = false;
    });
    _getReclamos();
  }

  void _showFilter() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text('Filtrar Reclamos'),
            content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Text(
                'Escriba texto o números a buscar en Dirección o Número del Reclamo: ',
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
    List<Reclamo> filteredList = [];
    for (var reclamo in _reclamos) {
      if (reclamo.asticket
              .toString()
              .toLowerCase()
              .contains(_search.toLowerCase()) ||
          reclamo.direccion
              .toString()
              .toLowerCase()
              .contains(_search.toLowerCase())) {
        filteredList.add(reclamo);
      }
    }

    setState(() {
      _reclamos = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
  }

  Widget _getContent() {
    return Column(
      children: <Widget>[
        _showReclamosCount(),
        Expanded(
          child: _reclamos.length == 0 ? _noContent() : _getListView(),
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
              ? 'No hay Reclamos con ese criterio de búsqueda'
              : 'No hay Reclamos registrados',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getReclamos,
      child: ListView(
        children: _reclamos.map((e) {
          return Card(
            color: Color(0xFFC7C7C8),
            shadowColor: Colors.white,
            elevation: 10,
            margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
            child: InkWell(
              onTap: () {
                _reclamoSelected = e;
                _goInfoReclamo(e);
              },
              child: Container(
                height: 100,
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(5),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text("AS/N° Reclamo: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF781f1e),
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Zona: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF781f1e),
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Dirección: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF781f1e),
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("N°: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF781f1e),
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Descr./Nombre: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF781f1e),
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        Text(e.asticket.toString(),
                                            style: TextStyle(
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(e.zona.toString(),
                                            style: TextStyle(
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(e.direccion.toString(),
                                            style: TextStyle(
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(e.numeracion.toString(),
                                            style: TextStyle(
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(e.terminal.toString(),
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
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _goInfoReclamo(Reclamo reclamo) async {
    String? result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReclamoInfoScreen(
                  user: widget.user,
                  reclamo: reclamo,
                )));
    if (result == 'yes') {
      _getReclamos();
      setState(() {});
    }
  }

  Widget _showReclamosCount() {
    return Container(
      padding: EdgeInsets.all(10),
      height: 40,
      child: Row(
        children: [
          Text("Cantidad de Reclamos: ",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
          Text(_reclamos.length.toString(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }

  void _addReclamo() async {
    String? result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReclamoAgregarScreen(
                  user: widget.user,
                )));
    if (result == 'yes') {
      _getReclamos();
    }
  }
}
