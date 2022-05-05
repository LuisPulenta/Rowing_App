// ignore_for_file: prefer_collection_literals

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:rowing_app/components/loader_component.dart';
import 'package:rowing_app/helpers/api_helper.dart';
import 'package:rowing_app/models/catalogo.dart';
import 'package:rowing_app/models/reclamo.dart';
import 'package:rowing_app/models/response.dart';
import 'package:rowing_app/models/user.dart';

class ReclamoInfoScreen extends StatefulWidget {
  final User user;
  final Reclamo reclamo;
  ReclamoInfoScreen({required this.user, required this.reclamo});

  @override
  _ReclamoInfoScreenState createState() => _ReclamoInfoScreenState();
}

class _ReclamoInfoScreenState extends State<ReclamoInfoScreen> {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

  bool _showLoader = false;
  List<Catalogo> _catalogos = [];

  String _cantidad = '';
  String _cantidadError = '';
  bool _cantidadShowError = false;
  TextEditingController _cantidadController = TextEditingController();

  List<TextEditingController> controllers = [];

//*****************************************************************************
//************************** INIT STATE ***************************************
//*****************************************************************************

  @override
  void initState() {
    super.initState();
    _loadData();
  }

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF484848),
      appBar: AppBar(
        title: Text('Reclamo Materiales'),
        centerTitle: true,
      ),
      body: Center(
        child: _showLoader
            ? LoaderComponent(
                text: 'Por favor espere...',
              )
            : _getContent(),
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO GETCONTENT -------------------------
//-----------------------------------------------------------------
  Widget _getContent() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        _showReclamoInfo(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Material         ",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "   ",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Cantidad                 ",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        Expanded(
          child: _getListView(),
        ),
        _showButtons(),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWRECLAMOINFO --------------------
//-----------------------------------------------------------------

  Widget _showReclamoInfo() {
    return Card(
      color: Color(0xFFC7C7C8),
      shadowColor: Colors.white,
      elevation: 10,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
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
                                Text(widget.reclamo.asticket.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                              ],
                            ),
                            Row(
                              children: [
                                Text(widget.reclamo.zona.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                              ],
                            ),
                            Row(
                              children: [
                                Text(widget.reclamo.direccion.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                              ],
                            ),
                            Row(
                              children: [
                                Text(widget.reclamo.numeracion.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                              ],
                            ),
                            Row(
                              children: [
                                Text(widget.reclamo.terminal.toString(),
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
          ],
        ),
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO GETLISTVIEW ------------------------
//-----------------------------------------------------------------

  Widget _getListView() {
    return ListView(
      children: _catalogos.map((e) {
        return Card(
          color: Color(0xFFC7C7C8),
          shadowColor: Colors.white,
          elevation: 10,
          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Container(
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.all(5),
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
                                  Expanded(
                                    flex: 4,
                                    child: Text(e.catCatalogo.toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                        )),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(e.cantidad.toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
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
                                                backgroundColor:
                                                    Colors.grey[300],
                                                title:
                                                    Text("Ingrese la cantidad"),
                                                content: TextField(
                                                  autofocus: true,
                                                  controller:
                                                      _cantidadController,
                                                  decoration: InputDecoration(
                                                      fillColor: Colors.white,
                                                      filled: true,
                                                      hintText: '',
                                                      labelText: '',
                                                      errorText:
                                                          _cantidadShowError
                                                              ? _cantidadError
                                                              : null,
                                                      prefixIcon:
                                                          Icon(Icons.tag),
                                                      border:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10))),
                                                  onChanged: (value) {
                                                    _cantidad = value;
                                                  },
                                                ),
                                                actions: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Icon(
                                                                  Icons.cancel),
                                                              Text('Cancelar'),
                                                            ],
                                                          ),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            primary: Color(
                                                                0xFFB4161B),
                                                            minimumSize: Size(
                                                                double.infinity,
                                                                50),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Icon(Icons.save),
                                                              Text('Aceptar'),
                                                            ],
                                                          ),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            primary: Color(
                                                                0xFF120E43),
                                                            minimumSize: Size(
                                                                double.infinity,
                                                                50),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
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
                                                                        _cantidad);
                                                              }
                                                            }

                                                            Navigator.pop(
                                                                context);
                                                            setState(() {});
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              );
                                            },
                                            barrierDismissible: false);
                                      },
                                      icon:
                                          Icon(Icons.loop, color: Colors.blue)),
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
//--------------------- METODO SHOWBUTTONS ------------------------
//-----------------------------------------------------------------

  Widget _showButtons() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _showSaveButton(),
        ],
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWSAVEBUTTON ---------------------
//-----------------------------------------------------------------

  Widget _showSaveButton() {
    return Expanded(
      child: ElevatedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save),
            SizedBox(
              width: 15,
            ),
            Text('Guardar'),
          ],
        ),
        style: ElevatedButton.styleFrom(
          primary: Color(0xFF781f1e),
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: () => _save(),
      ),
    );
  }

//*****************************************************************************
//************************** METODO LOADDATA **********************************
//*****************************************************************************

  void _loadData() async {
    await _getCatalogos();
    for (Catalogo catalogo in _catalogos) {
      catalogo.cantidad = 0;
    }
  }

//*****************************************************************************
//************************** METODO GETCATALOGOS ******************************
//*****************************************************************************

  Future<Null> _getCatalogos() async {
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

    if (widget.user.modulo == 'Rowing') {
      response = await ApiHelper.getCatalogosRowing();
    } else if (widget.user.modulo == 'Energia') {
      response = await ApiHelper.getCatalogosEnergia();
    } else if (widget.user.modulo == 'ObrasTasa') {
      response = await ApiHelper.getCatalogosObrasTasa();
    } else {
      return;
    }

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
      _catalogos = response.result;
    });
  }

//*****************************************************************************
//************************** METODO SAVE **************************************
//*****************************************************************************
  _save() async {
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
            request);

        if (!response.isSuccess) {
          await showAlertDialog(
              context: context,
              title: 'Error',
              message: response.message,
              actions: <AlertDialogAction>[
                AlertDialogAction(key: null, label: 'Aceptar'),
              ]);
        }
      }
    }
    if (bandera == false) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'No hay materiales que tengan cantidades',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
    await showAlertDialog(
        context: context,
        title: 'Aviso',
        message: 'Materiales guardados con éxito!',
        actions: <AlertDialogAction>[
          AlertDialogAction(key: null, label: 'Aceptar'),
        ]);
    Navigator.pop(context);
  }

  void _changeCantidad(Catalogo e, double value) {
    for (Catalogo catalogo in _catalogos) {
      if (catalogo.catCodigo == e.catCodigo) {
        catalogo.cantidad = value;
      } else {
        (catalogo.catCodigo = catalogo.catCodigo);
      }
    }
    setState(() {});
  }
}
