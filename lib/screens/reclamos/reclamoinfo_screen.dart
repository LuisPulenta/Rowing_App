// ignore_for_file: prefer_collection_literals

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/catalogo.dart';
import '../../models/reclamo.dart';
import '../../models/response.dart';
import '../../models/user.dart';

class ReclamoInfoScreen extends StatefulWidget {
  final User user;
  final Reclamo reclamo;
  const ReclamoInfoScreen({
    super.key,
    required this.user,
    required this.reclamo,
  });

  @override
  _ReclamoInfoScreenState createState() => _ReclamoInfoScreenState();
}

class _ReclamoInfoScreenState extends State<ReclamoInfoScreen> {
  //---------------------------------------------------------------
  //----------------------- Variables -----------------------------
  //---------------------------------------------------------------

  bool _showLoader = false;
  List<Catalogo> _catalogos = [];

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
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: const Text('Reclamo Materiales'),
        centerTitle: true,
      ),
      body: Center(
        child: _showLoader
            ? const LoaderComponent(text: 'Por favor espere...')
            : _getContent(),
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
        _showReclamoInfo(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Text('Material         ', style: TextStyle(color: Colors.white)),
            Text('   ', style: TextStyle(color: Colors.white)),
            Text(
              'Cantidad                 ',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        Expanded(child: _getListView()),
        _showButtons(),
        const SizedBox(height: 10),
      ],
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showReclamoInfo --------------------------
  //-----------------------------------------------------------------

  Widget _showReclamoInfo() {
    return Card(
      color: const Color(0xFFC7C7C8),
      shadowColor: Colors.white,
      elevation: 10,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
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
                                widget.reclamo.asticket.toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                widget.reclamo.zona.toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                widget.reclamo.direccion.toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                widget.reclamo.numeracion.toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                widget.reclamo.terminal.toString(),
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
          ],
        ),
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _getListView ------------------------------
  //-----------------------------------------------------------------

  Widget _getListView() {
    return ListView(
      children: _catalogos.map((e) {
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

    response = await ApiHelper.getCatalogos(widget.user.modulo);

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
  //--------------------- _save -------------------------------------
  //-----------------------------------------------------------------

  Future<void> _save() async {
    bool bandera = false;
    for (Catalogo catalogo in _catalogos) {
      if (catalogo.cantidad != 0) {
        bandera = true;
        Map<String, dynamic> request = {
          'nroregistrocab': widget.reclamo.nroregistro,
          'catcodigo': catalogo.catCodigo,
          'codigosap': catalogo.codigoSap,
          'cantidad': catalogo.cantidad,
        };

        Response response = await ApiHelper.post(
          '/api/ObrasPostesCajasDetalle/PostObrasPostesCajasDetalle',
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
    if (bandera == false) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'No hay materiales que tengan cantidades',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }
    await showAlertDialog(
      context: context,
      title: 'Aviso',
      message: 'Materiales guardados con éxito!',
      actions: <AlertDialogAction>[
        const AlertDialogAction(key: null, label: 'Aceptar'),
      ],
    );
    Navigator.pop(context);
  }
}
