import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/entrega.dart';
import '../../models/response.dart';

class EntregasScreen extends StatefulWidget {
  final String codigo;

  const EntregasScreen({Key? key, required this.codigo}) : super(key: key);

  @override
  _EntregasScreenState createState() => _EntregasScreenState();
}

class _EntregasScreenState extends State<EntregasScreen> {
//---------------------------------------------------------------
//----------------------- Variables -----------------------------
//---------------------------------------------------------------

  List<Entrega> _entregas = [];
  bool _showLoader = false;
  bool _isFiltered = false;
  String _search = '';

//---------------------------------------------------------------
//----------------------- initState -----------------------------
//---------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _getEntregas();
  }

//---------------------------------------------------------------
//----------------------- Pantalla ------------------------------
//---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: const Text('Entregas'),
        centerTitle: true,
        actions: <Widget>[
          _isFiltered
              ? IconButton(
                  onPressed: _removeFilter, icon: const Icon(Icons.filter_none))
              : IconButton(
                  onPressed: _showFilter, icon: const Icon(Icons.filter_alt))
        ],
      ),
      body: Center(
        child: _showLoader
            ? const LoaderComponent(text: 'Por favor espere...')
            : _getContent(),
      ),
    );
  }

//---------------------------------------------------------------
//----------------------- _getEntregas --------------------------
//---------------------------------------------------------------

  Future<void> _getEntregas() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      showMyDialog(
          'Error', 'Verifica que estés conectado a Internet', 'Aceptar');
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
            const AlertDialogAction(key: null, label: 'Aceptar'),
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

//---------------------------------------------------------------
//----------------------- _getContent ---------------------------
//---------------------------------------------------------------

  Widget _getContent() {
    return Column(
      children: <Widget>[
        _showEntregasCount(),
        Expanded(
          child: _entregas.isEmpty ? _noContent() : _getListView(),
        )
      ],
    );
  }

//---------------------------------------------------------------
//----------------------- _noContent ----------------------------
//---------------------------------------------------------------

  Widget _noContent() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          _isFiltered
              ? 'No hay Entregas con ese criterio de búsqueda'
              : 'No hay Entregas registradas',
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

//---------------------------------------------------------------
//----------------------- _getListView --------------------------
//---------------------------------------------------------------

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getEntregas,
      child: ListView(
        children: _entregas.map((e) {
          return Card(
            color: const Color(0xFFC7C7C8),
            shadowColor: Colors.white,
            elevation: 10,
            margin: const EdgeInsets.fromLTRB(10, 0, 5, 10),
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
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(e.codigo.toString(),
                                              style: const TextStyle(
                                                fontSize: 10,
                                              )),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Text(e.codigosap,
                                              style: const TextStyle(
                                                fontSize: 10,
                                              )),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            child: Text(e.denominacion,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                )),
                                          ),
                                          Text(e.stockAct.toString(),
                                              style: const TextStyle(
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
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5),
                      child: Row(
                        children: [
                          const Text('Fecha últ. entr.:',
                              style: TextStyle(
                                fontSize: 10,
                              )),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy')
                                .format(DateTime.parse(e.fecha)),
                            style: const TextStyle(fontSize: 10),
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
//----------------------- _showFilter ---------------------------
//---------------------------------------------------------------

  void _showFilter() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text('Filtrar Entregas'),
            content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              const Text(
                'Escriba texto a buscar en Descripción: ',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                    hintText: 'Criterio de búsqueda...',
                    labelText: 'Buscar',
                    suffixIcon: const Icon(Icons.search),
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
                  child: const Text('Cancelar')),
              TextButton(
                  onPressed: () => _filter(), child: const Text('Filtrar')),
            ],
          );
        });
  }

//---------------------------------------------------------------
//----------------------- _removeFilter -------------------------
//---------------------------------------------------------------

  void _removeFilter() {
    setState(() {
      _isFiltered = false;
    });
    _getEntregas();
  }

//---------------------------------------------------------
//----------------------- _filter -------------------------
//---------------------------------------------------------

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

//---------------------------------------------------------
//----------------------- _showEntregasCount --------------
//---------------------------------------------------------

  Widget _showEntregasCount() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          height: 40,
          child: Row(
            children: [
              const Text('Cantidad de Items entregados: ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
              Text(_entregas.length.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ),
        const Divider(
          height: 3,
          color: Colors.white,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Row(
            children: const [
              Text('Código',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  )),
              SizedBox(
                width: 15,
              ),
              Text('Cod. SAP',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  )),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Text('Descripción',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    )),
              ),
              Text('Cantidad',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  )),
            ],
          ),
        ),
        const Divider(
          height: 6,
          color: Colors.white,
        ),
      ],
    );
  }
}
