import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';

class StocksMaximosScreen extends StatefulWidget {
  final User user;
  const StocksMaximosScreen({super.key, required this.user});

  @override
  State<StocksMaximosScreen> createState() => _StocksMaximosScreenState();
}

class _StocksMaximosScreenState extends State<StocksMaximosScreen> {
  //---------------------------------------------------------------
  //----------------------- Variables -----------------------------
  //---------------------------------------------------------------
  List<Grupo> _grupos = [];
  bool _isloading = false;
  String _grupo = 'Elija un Grupo...';
  final String _grupoError = '';
  final bool _grupoShowError = false;
  bool bandera = false;
  int intentos = 0;

  List<StockMaximo> _catalogos = [];
  List<StockMaximo> _catalogos2 = [];
  List<StockMaximo> filteredList = [];
  final String _cantidadError = '';
  final bool _cantidadShowError = false;
  final TextEditingController _cantidadController = TextEditingController();
  String _cantidad = '';
  bool _isFiltered = false;
  String _buscar = '';
  final bool _todas = false;

  String _codigo = '';
  final String _codigoError = '';
  final bool _codigoShowError = false;
  final bool _enabled = false;
  bool _showLoader = false;

  Causante _causante = Causante(
    nroCausante: 0,
    codigo: '',
    nombre: '',
    encargado: '',
    telefono: '',
    grupo: '',
    nroSAP: '',
    estado: false,
    razonSocial: '',
    linkFoto: '',
    imageFullPath: '',
    image: null,
    direccion: '',
    numero: 0,
    telefonoContacto1: '',
    telefonoContacto2: '',
    telefonoContacto3: '',
    fecha: '',
    notasCausantes: '',
    ciudad: '',
    provincia: '',
    codigoSupervisorObras: 0,
    zonaTrabajo: '',
    nombreActividad: '',
    notas: '',
    presentismo: '',
    perteneceCuadrilla: '',
    firma: null,
    firmaDigitalAPP: '',
    firmaFullPath: '',
  );

  late Causante _causanteVacio;

  //---------------------------------------------------------------
  //----------------------- initState -----------------------------
  //---------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _causanteVacio = _causante;
    _loadData();
  }

  //---------------------------------------------------------------
  //----------------------- Pantalla ------------------------------
  //---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 195, 191, 191),
      appBar: AppBar(
        title: const Text('Stocks Máximos'),
        centerTitle: true,
        actions: [
          Row(
            children: [
              _isFiltered
                  ? IconButton(
                      onPressed: _removeFilter,
                      icon: const Icon(Icons.filter_none),
                    )
                  : IconButton(
                      onPressed: _showFilter,
                      icon: const Icon(Icons.filter_alt),
                    ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 10),
              _showGrupos(),
              widget.user.habilitaRRHH == 1
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(flex: 7, child: _showLegajo()),
                            Expanded(flex: 2, child: _showButton()),
                          ],
                        ),
                      ],
                    )
                  : Container(),
              _showInfo(),
              const SizedBox(height: 15),
              _showCatalogosCount(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Text(
                    'Material         ',
                    style: TextStyle(color: Colors.black),
                  ),
                  Text('   ', style: TextStyle(color: Colors.black)),
                  Text(
                    'Cantidad                 ',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              Expanded(child: _getListView()),
            ],
          ),
          _showLoader
              ? const LoaderComponent(text: 'Por favor espere...')
              : Container(),
        ],
      ),
      floatingActionButton: _enabled
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF781f1e),
              onPressed: _enabled ? null : null,
              child: const Icon(Icons.add, size: 38),
            )
          : Container(),
    );
  }

  //--------------------- _getListView ------------------------------
  Widget _getListView() {
    return ListView(
      children: _catalogos2.map((e) {
        return Card(
          color: const Color(0xFFC7C7C8),
          shadowColor: Colors.white,
          elevation: 10,
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Container(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.symmetric(horizontal: 5),
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
                                    flex: 4,
                                    child: Text(
                                      '${e.codigosap} - ${e.catCatalogo}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      e.maximo.toString(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  IconButton(
                                    onPressed: () {
                                      _cantidadController.text = e.maximo == 0.0
                                          ? ''
                                          : e.maximo.toString();
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.grey[300],
                                            title: const Text(
                                              'Ingrese la cantidad',
                                            ),
                                            content: TextField(
                                              autofocus: true,
                                              controller: _cantidadController,
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                filled: true,
                                                hintText: '',
                                                labelText: '',
                                                errorText: _cantidadShowError
                                                    ? _cantidadError
                                                    : null,
                                                prefixIcon: const Icon(
                                                  Icons.tag,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              onChanged: (value) {
                                                _cantidad = value;
                                              },
                                            ),
                                            actions: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            const Color(
                                                              0xFFB4161B,
                                                            ),
                                                        minimumSize: const Size(
                                                          double.infinity,
                                                          50,
                                                        ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                5,
                                                              ),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: const [
                                                          Icon(Icons.cancel),
                                                          Text('Cancelar'),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            const Color(
                                                              0xFF120E43,
                                                            ),
                                                        minimumSize: const Size(
                                                          double.infinity,
                                                          50,
                                                        ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                5,
                                                              ),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        for (StockMaximo
                                                            catalogo
                                                            in _catalogos) {
                                                          if (catalogo
                                                                  .codigosiag ==
                                                              e.codigosiag) {
                                                            catalogo.maximo =
                                                                double.parse(
                                                                  _cantidad,
                                                                );
                                                            _actualizarStockMaximo(
                                                              e.codigosiag
                                                                  .toString(),
                                                              double.parse(
                                                                _cantidad,
                                                              ),
                                                            );
                                                          }
                                                        }

                                                        Navigator.pop(context);
                                                        setState(() {});
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: const [
                                                          Icon(Icons.save),
                                                          Text('Aceptar'),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          );
                                        },
                                        barrierDismissible: false,
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.loop,
                                      color: Colors.blue,
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
    );
  }

  //------------------------------ _showCatalogosCount --------------------
  Widget _showCatalogosCount() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 40,
      child: Row(
        children: [
          const Text(
            'Cantidad de Catálogos: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _catalogos2.length.toString(),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  //--------------------- _showGrupos ----------------------
  Widget _showGrupos() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
      child: _isloading
          ? Row(
              children: const [
                CircularProgressIndicator(),
                SizedBox(width: 10),
                Text('Cargando Grupos...'),
              ],
            )
          : _grupos.isEmpty
          ? Row(
              children: const [
                Text(
                  'No hay Grupos',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ],
            )
          : DropdownButtonFormField(
              initialValue: _grupo,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(8),
                isDense: true,
                fillColor: Colors.white,
                filled: true,
                hintText: 'Elija un Grupo...',
                labelText: 'Grupo',
                errorText: _grupoShowError ? _grupoError : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: _getComboGrupos(),
              onChanged: (value) {
                _grupo = value.toString();
              },
            ),
    );
  }

  //--------------------- _getComboGrupos ---------

  List<DropdownMenuItem<String>> _getComboGrupos() {
    List<DropdownMenuItem<String>> list = [];
    list.add(
      const DropdownMenuItem(
        value: 'Elija un Grupo...',
        child: Text('Elija un Grupo...'),
      ),
    );

    for (var grupo in _grupos) {
      list.add(
        DropdownMenuItem(
          value: grupo.codigo.toString(),
          child: Text(
            '${grupo.codigo.toString()}-${grupo.detalle.toString().trim()}',
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
      );
    }

    return list;
  }

  //--------------------- _loadData ------------------------
  void _loadData() async {
    await _getGrupos();
  }

  //--------------------- _actualizarStockMaximo -----------------------------
  Future<void> _actualizarStockMaximo(String catSiag, double cantidad) async {
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

    Map<String, dynamic> request = {
      'Grupo': _grupo,
      'Causante': _codigo,
      'Catalogo': catSiag,
      'Cantidad': cantidad,
    };

    response = await ApiHelper.put(
      '/api/StockMaximosSubcons/UpdateMaximo/',
      '$_grupo/$_codigo/$catSiag',
      request,
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

    setState(() {});
  }

  //--------------------- _getCatalogos -----------------------------
  Future<void> _getCatalogos() async {
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

    Map<String, dynamic> request = {'Grupo': _grupo, 'Codigo': _codigo};

    response = await ApiHelper.post(
      '/api/VistaStocksMaximo/GetVistaStocksMaximosByGrupoAndByCodigo',
      request,
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
      List<StockMaximo> list = [];
      var decodedJson = jsonDecode(response.result);
      if (decodedJson != null) {
        for (var item in decodedJson) {
          list.add(StockMaximo.fromJson(item));
        }
      }
      _catalogos = list;
    });
  }

  //--------------------- _getGrupos ------------

  Future<void> _getGrupos() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      showMyDialog(
        'Error',
        'Verifica que estés conectado a Internet',
        'Aceptar',
      );
      return;
    }

    _isloading = true;
    setState(() {});
    bandera = false;
    intentos = 0;

    do {
      Response response = Response(isSuccess: false);
      response = await ApiHelper.getGrupos();
      intentos++;
      if (response.isSuccess) {
        bandera = true;
        _grupos = response.result;
      }
    } while (bandera == false);

    _isloading = false;
    setState(() {});
  }

  //--------------------- _showLegajo -------------------------
  Widget _showLegajo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(8),
          isDense: true,
          iconColor: const Color(0xFF781f1e),
          prefixIconColor: const Color(0xFF781f1e),
          hoverColor: const Color(0xFF781f1e),
          focusColor: const Color(0xFF781f1e),
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingrese Código...',
          labelText: 'Código',
          errorText: _codigoShowError ? _codigoError : null,
          prefixIcon: const Icon(Icons.code_outlined),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF781f1e)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          _codigo = value;
        },
      ),
    );
  }

  //--------------------- _showButton -------------------------
  Widget _showButton() {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF781f1e),
                minimumSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () => _search(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Icon(Icons.search), SizedBox(width: 5)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //--------------------- _showInfo ---------------------------

  Widget _showInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        elevation: 15,
        margin: const EdgeInsets.all(5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: CustomRow(
            icon: Icons.person,
            nombredato: 'Usuario:',
            dato: _causante.nombre,
          ),
        ),
      ),
    );
  }

  //--------------------- _search -----------------------------

  Future<void> _search() async {
    FocusScope.of(context).unfocus();
    if (_codigo.isEmpty) {
      showMyDialog('Error', 'Ingrese Código.', 'Aceptar');

      return;
    }
    await _getCausante();
  }

  //--------------------- _getCausante -----------------------
  Future<void> _getCausante() async {
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
        'Verifica que estes conectado a internet.',
        'Aceptar',
      );

      return;
    }

    Map<String, dynamic> request = {'Codigo': _codigo, 'Grupo': _grupo};

    var url = Uri.parse(
      '${Constants.apiUrl}/Api/Causantes/GetCausanteByGrupoAndByCodigo2',
    );
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(request),
    );

    if (response.statusCode >= 400) {
      _catalogos = [];
      _catalogos2 = [];
      setState(() {
        _showLoader = false;
        _causante = _causanteVacio;
      });

      showMyDialog('Error', 'Código no válido.', 'Aceptar');

      return;
    }

    var body = response.body;
    var decodedJson = jsonDecode(body);
    _causante = Causante.fromJson(decodedJson);

    if (_causante.estado == 1) {
      setState(() {
        _showLoader = false;
      });

      showMyDialog('Error', 'Este Usuario está Activo', 'Aceptar');

      return;
    }

    await _getCatalogos();

    _catalogos2 = _catalogos;

    setState(() {
      _showLoader = false;
    });
  }

  //------------------------------ _removeFilter --------------------------
  void _removeFilter() async {
    _catalogos2 = _catalogos;

    setState(() {
      _isFiltered = false;
    });
  }

  //------------------------------ _showFilter --------------------------
  void _showFilter() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('Filtrar Catálogos'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Escriba texto o números a buscar en CatSAP o Descripción del Material: ',
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
                  _buscar = value;
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
  //------------------------------ _filter --------------------------
  //-----------------------------------------------------------------

  void _filter() {
    if (_buscar.isEmpty) {
      return;
    }
    filteredList = [];
    for (var catalogo in _catalogos2) {
      if (catalogo.codigosap!.toLowerCase().contains(_buscar.toLowerCase()) ||
          catalogo.catCatalogo!.toLowerCase().contains(_buscar.toLowerCase())) {
        filteredList.add(catalogo);
      }
    }

    setState(() {
      _catalogos2 = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
  }
}
