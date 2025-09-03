import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';

class ReqEppScreen extends StatefulWidget {
  final User user;
  final Causante causante;
  const ReqEppScreen({super.key, required this.user, required this.causante});

  @override
  _ReqEppScreenState createState() => _ReqEppScreenState();
}

class _ReqEppScreenState extends State<ReqEppScreen> {
  //---------------------------------------------------------------
  //----------------------- Variables -----------------------------
  //---------------------------------------------------------------

  bool _isFiltered = false;
  String _search = '';

  bool _showLoader = false;
  List<Catalogo> _catalogos = [];
  List<Catalogo> _catalogos2 = [];
  List<Catalogo> filteredList = [];
  final List<Option2> _listoptions = [];
  final List<DropdownMenuItem<String>> _items = [];
  bool _todas = false;
  List<Obra> _obras = [];
  String _obra = 'Seleccione una Obra...';
  String _obraError = '';
  bool _obraShowError = false;
  int _nroReg = 0;
  String _cantidad = '';
  final String _cantidadError = '';
  final bool _cantidadShowError = false;
  final TextEditingController _cantidadController = TextEditingController();

  List<TextEditingController> controllers = [];

  //---------------------------------------------------------------
  //----------------------- initState -----------------------------
  //---------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  //---------------------------------------------------------------
  //----------------------- Pantalla ------------------------------
  //---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 218, 218),
      appBar: AppBar(
        title: const Text('Req. de EPP'),
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
              const Text(
                'C/N°:',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              Switch(
                value: _todas,
                activeThumbColor: Colors.green,
                inactiveThumbColor: Colors.grey,
                onChanged: (value) {
                  _todas = value;
                  _mostrarCatalogos();
                  setState(() {});
                },
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Stack(
          children: [
            _getContent(),
            _showLoader
                ? const LoaderComponent(text: 'Grabando...')
                : Container(),
          ],
        ),
      ),
    );
  }

  //-----------------------------------------------------------------------
  //------------------------------ _showCatalogosCount --------------------
  //-----------------------------------------------------------------------

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

  //-----------------------------------------------------------------
  //--------------------- _getContent -------------------------------
  //-----------------------------------------------------------------

  Widget _getContent() {
    return Column(
      children: <Widget>[
        const SizedBox(height: 10),
        _showObras(),
        _showCatalogosCount(),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Text('Material         ', style: TextStyle(color: Colors.black)),
            Text('   ', style: TextStyle(color: Colors.black)),
            Text(
              'Cantidad                 ',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Expanded(child: _getListView()),
        _showButtons(),
        const SizedBox(height: 10),
      ],
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showObras --------------------------------
  //-----------------------------------------------------------------

  Widget _showObras() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
            child: _obras.isEmpty
                ? Row(
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(width: 10),
                      Text('Cargando Obras...'),
                    ],
                  )
                : DropdownButtonFormField(
                    initialValue: _obra,
                    isExpanded: true,
                    isDense: true,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Seleccione una Obra...',
                      labelText: 'Obra',
                      errorText: _obraShowError ? _obraError : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: _getComboObras(),
                    onChanged: (value) {
                      _obra = value.toString();
                    },
                  ),
          ),
        ),
      ],
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _getComboObras ----------------------------
  //-----------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboObras() {
    List<DropdownMenuItem<String>> list = [];
    list.add(
      const DropdownMenuItem(
        value: 'Seleccione una Obra...',
        child: Text('Seleccione una Obra...'),
      ),
    );

    for (var obra in _obras) {
      list.add(
        DropdownMenuItem(
          value: obra.nroObra.toString(),
          child: Text(obra.nombreObra.toString()),
        ),
      );
    }

    return list;
  }

  //-----------------------------------------------------------------
  //--------------------- _getListView ------------------------------
  //-----------------------------------------------------------------

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
                                      e.catCatalogo.toString(),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      e.cantidad.toString(),
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
                                      _cantidadController.text =
                                          e.cantidad == 0.0
                                          ? ''
                                          : e.cantidad.toString();
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
                                                        for (Catalogo catalogo
                                                            in _catalogos) {
                                                          if (catalogo
                                                                  .catCodigo ==
                                                              e.catCodigo) {
                                                            catalogo.cantidad =
                                                                double.parse(
                                                                  _cantidad,
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

  //-----------------------------------------------------------------
  //--------------------- _showButtons ------------------------------
  //-----------------------------------------------------------------

  Widget _showButtons() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[_showSaveButton()],
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showSaveButton ---------------------------
  //-----------------------------------------------------------------

  Widget _showSaveButton() {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF781f1e),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        onPressed: () => _save(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.save),
            SizedBox(width: 15),
            Text('Guardar'),
          ],
        ),
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _loadData ---------------------------------
  //-----------------------------------------------------------------

  void _loadData() async {
    await _getCatalogos();
    for (Catalogo catalogo in _catalogos) {
      catalogo.cantidad = 0;
    }
    _catalogos2 = _catalogos;
    _getObras();
  }

  //-----------------------------------------------------------------
  //--------------------- _getCatalogos -----------------------------
  //-----------------------------------------------------------------

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

    response = await ApiHelper.getCatalogosEPP(widget.user.modulo);

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
      _catalogos = response.result;
    });
  }

  //-----------------------------------------------------------------
  //--------------------- _getObras ---------------------------------
  //-----------------------------------------------------------------

  Future<void> _getObras() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      showMyDialog(
        'Error',
        'Verifica que estés conectado a Internet',
        'Aceptar',
      );
    }
    Response response = Response(isSuccess: false);
    response = await ApiHelper.getObrasEPP(widget.user.modulo);
    if (response.isSuccess) {
      _obras = response.result;
    }
    setState(() {});
  }

  //-----------------------------------------------------------------
  //--------------------- _save -------------------------------------
  //-----------------------------------------------------------------

  void _save() {
    if (!validateFields()) {
      return;
    }
    _addRecord();
  }

  //-----------------------------------------------------------------
  //--------------------- validateFields ----------------------------
  //-----------------------------------------------------------------

  bool validateFields() {
    bool isValid = true;

    if (_obra == 'Seleccione una Obra...') {
      isValid = false;
      _obraShowError = true;
      _obraError = 'Debes seleccionar una Obra';
    } else {
      _obraShowError = false;
    }
    setState(() {});
    return isValid;
  }

  //-----------------------------------------------------------------
  //--------------------- _addRecord --------------------------------
  //-----------------------------------------------------------------

  Future<void> _addRecord() async {
    //-----------------Controlo que haya catálogos con cantidades--------------
    bool bandera = false;
    for (Catalogo catalogo in _catalogos) {
      if (catalogo.cantidad != 0) {
        bandera = true;
      }
    }

    //-----------------Grabar Cabecera y Detalle--------------
    if (bandera) {
      //-----------------Chequea Internet--------------
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
          ],
        );
        return;
      }

      //-----------------Graba Cabecera--------------
      Map<String, dynamic> request = {
        'NROOBRA': _obra,
        'CONTRATISTA': 'PPR',
        'IDUSUARIO': widget.user.idUsuario,
        'CODGRUPOREC': widget.causante.grupo,
        'CODCAUSANTEREC': widget.causante.codigo,
        'CODCONCEPTO': '502',
        'PRIORIDAD': 'Baja',
        'FALTAMATERIAL': 0,
        'DESPACHADO': 0,
        'PORDIFERENCIA': 0,
        'ENTREGADOCONTRATISTA': '',
        'MODULO': widget.user.modulo,
        'COBRADO602': 0,
        'NROOP': 0,
        'VALORIZACION': 0,
      };

      Response response = await ApiHelper.post(
        '/api/WRemitosCab/PostWRemitosCab',
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
      }

      Response response2 = await ApiHelper.getNroRemitoMax();
      if (response2.isSuccess) {
        _nroReg = int.parse(response2.result.toString());
      }

      //-----------------Graba Detalle--------------
      for (Catalogo catalogo in _catalogos) {
        if (catalogo.cantidad != 0) {
          bandera = true;
          Map<String, dynamic> request = {
            'NROREMITOCAB': _nroReg,
            'NROOBRA': _obra,
            'catcodigo': catalogo.catCodigo,
            'catCatalogo': catalogo.catCatalogo,
            'codigosap': catalogo.codigoSap,
            'cantidad': catalogo.cantidad,
            'TAG': 0,
            'COSTOUNIT': 0,
            'COSTOTOTAL': 0,
          };

          Response response = await ApiHelper.post(
            '/api/WRemitosCab/PostWRemitosDet',
            request,
          );

          if (!response.isSuccess) {
            await showAlertDialog(
              context: context,
              title: 'Error',
              message: response.message,
              actions: <AlertDialogAction>[
                const AlertDialogAction(key: null, label: 'Aceptar'),
              ],
            );
          }
        }
      }

      await showAlertDialog(
        context: context,
        title: 'Aviso',
        message: 'Requerimiento guardado con éxito!',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      Navigator.pop(context);
    } else {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'No hay materiales que tengan cantidades',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    } //Termina Bandera
  }

  //-----------------------------------------------------------------
  //--------------------- _mostrarCatalogos -------------------------
  //-----------------------------------------------------------------

  Future<void> _mostrarCatalogos() async {
    if (!_todas) {
      _catalogos2 = _catalogos;
    } else {
      _catalogos2 = [];
      for (var catalogo in _catalogos) {
        if (catalogo.cantidad! > 0) {
          _catalogos2.add(catalogo);
        }
      }
      _catalogos2.sort((a, b) {
        return a.catCatalogo.toString().toLowerCase().compareTo(
          b.catCatalogo.toString().toLowerCase(),
        );
      });
      setState(() {});
    }
  }

  //-----------------------------------------------------------------------
  //------------------------------ _removeFilter --------------------------
  //-----------------------------------------------------------------------

  void _removeFilter() async {
    _catalogos2 = _catalogos;

    setState(() {
      _isFiltered = false;
    });
  }

  //---------------------------------------------------------------------
  //------------------------------ _showFilter --------------------------
  //---------------------------------------------------------------------

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
  //------------------------------ _filter --------------------------
  //-----------------------------------------------------------------

  void _filter() {
    if (_search.isEmpty) {
      return;
    }
    filteredList = [];
    for (var catalogo in _catalogos2) {
      if (catalogo.codigoSap!.toLowerCase().contains(_search.toLowerCase()) ||
          catalogo.catCatalogo!.toLowerCase().contains(_search.toLowerCase())) {
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
