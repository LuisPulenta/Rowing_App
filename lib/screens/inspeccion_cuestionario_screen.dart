import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rowing_app/components/loader_component.dart';
import 'package:rowing_app/helpers/api_helper.dart';
import 'package:rowing_app/models/models.dart';
import 'package:grouped_list/grouped_list.dart';

class InspeccionCuestionarioScreen extends StatefulWidget {
  final User user;
  final Causante causante;
  final String observaciones;
  final Obra obra;
  final int cliente;
  final List<DetallesFormularioCompleto> detallesFormulariosCompleto;
  final Position positionUser;

  const InspeccionCuestionarioScreen(
      {required this.user,
      required this.causante,
      required this.observaciones,
      required this.obra,
      required this.cliente,
      required this.detallesFormulariosCompleto,
      required this.positionUser});

  @override
  State<InspeccionCuestionarioScreen> createState() =>
      _InspeccionCuestionarioScreenState();
}

class _InspeccionCuestionarioScreenState
    extends State<InspeccionCuestionarioScreen> {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

  Color colorVerde = Color.fromARGB(255, 22, 175, 22);
  Color colorRojo = Color.fromARGB(255, 243, 6, 38);
  Color colorNaranja = Color.fromARGB(255, 244, 104, 28);
  Color colorCeleste = Color.fromARGB(255, 123, 220, 247);

  List _elements = [];
  int puntos = 0;
  int respSI = 0;
  int respNO = 0;
  int respNA = 0;

  int _idCab = 0;

  bool _showLoader = false;
  bool _todas = true;

  Position _positionUser = Position(
      longitude: 0,
      latitude: 0,
      timestamp: null,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);

//*****************************************************************************
//************************** INIT STATE ***************************************
//*****************************************************************************

  @override
  void initState() {
    super.initState();

    widget.detallesFormulariosCompleto.forEach((element) {
      _elements.add(
        {
          'idcliente': element.idcliente,
          'idgrupoformulario': element.idgrupoformulario.toString(),
          'descgrupoformulario': element.descgrupoformulario,
          'descripcion': element.descripcion,
          'detallef': element.detallef,
          'ponderacionpuntos': element.ponderacionpuntos.toString(),
          'cumple': element.cumple.toString(),
        },
      );
    });
  }

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 195, 191, 191),
      appBar: AppBar(
        title: Text('Cuestionario'),
        centerTitle: true,
        actions: [
          Row(
            children: [
              Text(
                "Todas:",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              Switch(
                  value: _todas,
                  activeColor: Colors.green,
                  inactiveThumbColor: Colors.grey,
                  onChanged: (value) {
                    _todas = value;
                    setState(() {});
                  }),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: _getContent(),
          ),
          _showLoader
              ? LoaderComponent(
                  text: 'Por favor espere...',
                )
              : Container(),
        ],
      ),
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ METODO GETCONTENT --------------------------
//-----------------------------------------------------------------------------

  Widget _getContent() {
    return Column(
      children: <Widget>[
        _showResultado(),
        Expanded(
          child: _getListView(),
        ),
        _showButtonsGuardarCancelar(),
      ],
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ METODO SHOWRESULTADO ------------------------
//-----------------------------------------------------------------------------

  Widget _showResultado() {
    return Container(
      padding: EdgeInsets.all(10),
      height: 80,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Preguntas: ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(widget.detallesFormulariosCompleto.length.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.normal,
                      )),
                ],
              ),
              Row(
                children: [
                  Text("Resp SI: ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(respSI.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.normal,
                      )),
                ],
              ),
              Row(
                children: [
                  Text("Faltan Responder: ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(
                      (widget.detallesFormulariosCompleto.length -
                              respSI -
                              respNO -
                              respNA)
                          .toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.normal,
                      )),
                ],
              ),
            ],
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  Text("",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.normal,
                      )),
                ],
              ),
              Row(
                children: [
                  Text("Resp. NO: ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(respNO.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.normal,
                      )),
                ],
              ),
            ],
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  Text("",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.normal,
                      )),
                ],
              ),
              Row(
                children: [
                  Text("Resp. N/A: ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(respNA.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.normal,
                      )),
                ],
              ),
              Row(
                children: [
                  Text("Total Puntos: ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(puntos.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.normal,
                      )),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ METODO GETLISTVIEW ---------------------------
//-----------------------------------------------------------------------------

  Widget _getListView() {
    return GroupedListView<dynamic, String>(
      elements: _elements,
      groupBy: (element) => element['descgrupoformulario'],
      groupComparator: (value1, value2) => value1.compareTo(value2),
      itemComparator: (item1, item2) =>
          item1['detallef'].compareTo(item2['detallef']),
      order: GroupedListOrder.ASC,
      useStickyGroupSeparators: true,
      groupSeparatorBuilder: (String value) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      itemBuilder: (c, element) {
        return _todas
            ? Card(
                elevation: 8.0,
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: Container(
                  color: (element['cumple'] != "SI" &&
                          element['cumple'] != "NO" &&
                          element['cumple'] != "N/A")
                      ? Colors.white
                      : colorCeleste,
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 5.0),
                        leading: CircleAvatar(
                            child: Text(
                          element['detallef'],
                          style: TextStyle(fontSize: 10),
                        )),
                        title: Text(
                          element['descripcion'],
                          style: TextStyle(fontSize: 12),
                        ),
                        trailing: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: element['cumple'] == "SI"
                                  ? colorVerde
                                  : element['cumple'] == "NO"
                                      ? colorRojo
                                      : element['cumple'] == "N/A"
                                          ? colorNaranja
                                          : colorCeleste,
                              width: 4,
                            ),
                          ),
                          width: 60,
                          height: 60,
                          //****************** */
                          child: Center(
                              child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  '${element['ponderacionpuntos']} pts',
                                ),
                                element['cumple'] != "null"
                                    ? Text(
                                        element['cumple'],
                                      )
                                    : Text(''),
                              ],
                            ),
                          )),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                              child: ElevatedButton(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(Icons.toggle_on),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('SI'),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: colorVerde,
                                  minimumSize: Size(double.infinity, 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                onPressed: () {
                                  if (element['cumple'] == "NO") {
                                    respNO--;
                                    respSI++;
                                    puntos = puntos +
                                        int.parse(element['ponderacionpuntos']);
                                  }
                                  if (element['cumple'] == "N/A") {
                                    respNA--;
                                    respSI++;
                                    puntos = puntos +
                                        int.parse(element['ponderacionpuntos']);
                                  }
                                  if (element['cumple'] != "SI" &&
                                      element['cumple'] != "NO" &&
                                      element['cumple'] != "N/A") {
                                    respSI++;
                                    puntos = puntos +
                                        int.parse(element['ponderacionpuntos']);
                                  }

                                  _elements.forEach((e) {
                                    if (e == element) {
                                      e['cumple'] = "SI";
                                    }
                                  });

                                  setState(() {});
                                },
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(Icons.toggle_off),
                                    Text('NO'),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: colorRojo,
                                  minimumSize: Size(double.infinity, 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                onPressed: () {
                                  if (element['cumple'] == "SI") {
                                    respSI--;
                                    respNO++;
                                    puntos = puntos -
                                        int.parse(element['ponderacionpuntos']);
                                  }
                                  if (element['cumple'] == "N/A") {
                                    respNA--;
                                    respNO++;
                                  }
                                  if (element['cumple'] != "SI" &&
                                      element['cumple'] != "NO" &&
                                      element['cumple'] != "N/A") {
                                    respNO++;
                                  }
                                  element['cumple'] = "NO";
                                  setState(() {});
                                },
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(Icons.cancel),
                                    Text('N/A'),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: colorNaranja,
                                  minimumSize: Size(double.infinity, 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                onPressed: () {
                                  if (element['cumple'] == "SI") {
                                    respSI--;
                                    respNA++;
                                    puntos = puntos -
                                        int.parse(element['ponderacionpuntos']);
                                  }
                                  if (element['cumple'] == "NO") {
                                    respNO--;
                                    respNA++;
                                  }
                                  if (element['cumple'] != "SI" &&
                                      element['cumple'] != "NO" &&
                                      element['cumple'] != "N/A") {
                                    respNA++;
                                  }
                                  element['cumple'] = "N/A";
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : (element['cumple'] != "SI" &&
                    element['cumple'] != "NO" &&
                    element['cumple'] != "N/A")
                ? Card(
                    elevation: 8.0,
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                    child: Container(
                      color: (element['cumple'] != "SI" &&
                              element['cumple'] != "NO" &&
                              element['cumple'] != "N/A")
                          ? Colors.white
                          : Colors.blue[400],
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 5.0),
                            leading: CircleAvatar(
                                child: Text(
                              element['detallef'],
                              style: TextStyle(fontSize: 10),
                            )),
                            title: Text(
                              element['descripcion'],
                              style: TextStyle(fontSize: 12),
                            ),
                            trailing: Container(
                              width: 60,
                              height: 60,
                              color: element['cumple'] == "SI"
                                  ? colorVerde
                                  : element['cumple'] == "NO"
                                      ? colorRojo
                                      : element['cumple'] == "N/A"
                                          ? colorNaranja
                                          : colorCeleste,
                              child: Center(
                                  child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    '${element['ponderacionpuntos']} pts',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  element['cumple'] != "null"
                                      ? Text(
                                          element['cumple'],
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : Text(''),
                                ],
                              )),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Expanded(
                                  child: ElevatedButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(Icons.toggle_on),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text('SI'),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: colorVerde,
                                      minimumSize: Size(double.infinity, 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (element['cumple'] == "NO") {
                                        respNO--;
                                        respSI++;
                                        puntos = puntos +
                                            int.parse(
                                                element['ponderacionpuntos']);
                                      }
                                      if (element['cumple'] == "N/A") {
                                        respNA--;
                                        respSI++;
                                        puntos = puntos +
                                            int.parse(
                                                element['ponderacionpuntos']);
                                      }
                                      if (element['cumple'] != "SI" &&
                                          element['cumple'] != "NO" &&
                                          element['cumple'] != "N/A") {
                                        respSI++;
                                        puntos = puntos +
                                            int.parse(
                                                element['ponderacionpuntos']);
                                      }

                                      _elements.forEach((e) {
                                        if (e == element) {
                                          e['cumple'] = "SI";
                                        }
                                      });

                                      setState(() {});
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.toggle_off),
                                        Text('NO'),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: colorRojo,
                                      minimumSize: Size(double.infinity, 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (element['cumple'] == "SI") {
                                        respSI--;
                                        respNO++;
                                        puntos = puntos -
                                            int.parse(
                                                element['ponderacionpuntos']);
                                      }
                                      if (element['cumple'] == "N/A") {
                                        respNA--;
                                        respNO++;
                                      }
                                      if (element['cumple'] != "SI" &&
                                          element['cumple'] != "NO" &&
                                          element['cumple'] != "N/A") {
                                        respNO++;
                                      }
                                      element['cumple'] = "NO";
                                      setState(() {});
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.cancel),
                                        Text('N/A'),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: colorNaranja,
                                      minimumSize: Size(double.infinity, 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (element['cumple'] == "SI") {
                                        respSI--;
                                        respNA++;
                                        puntos = puntos -
                                            int.parse(
                                                element['ponderacionpuntos']);
                                      }
                                      if (element['cumple'] == "NO") {
                                        respNO--;
                                        respNA++;
                                      }
                                      if (element['cumple'] != "SI" &&
                                          element['cumple'] != "NO" &&
                                          element['cumple'] != "N/A") {
                                        respNA++;
                                      }
                                      element['cumple'] = "N/A";
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container();
      },
    );
  }

//*****************************************************************************
//************************** SHOWBUTTONSGUARDARCANCELAR ***********************
//*****************************************************************************

  Widget _showButtonsGuardarCancelar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.save),
                        SizedBox(
                          width: 2,
                        ),
                        Text('Guardar', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF282886),
                      minimumSize: Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      _guardar();
                    }),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cancel),
                      SizedBox(
                        width: 2,
                      ),
                      Text('Cancelar', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xffdf281e),
                    minimumSize: Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, "No");
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

//*****************************************************************************
//************************** METODO GUARDAR ***********************************
//*****************************************************************************

  _guardar() async {
    if (widget.detallesFormulariosCompleto.length - respSI - respNO - respNA !=
        0) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text('Aviso!'),
              content:
                  Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text(
                    'Todavía no puede guardar el Cuestionario. Quedan ${widget.detallesFormulariosCompleto.length - respSI - respNO - respNA} preguntas sin responder.'),
                SizedBox(
                  height: 10,
                ),
              ]),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Ok')),
              ],
            );
          });
      setState(() {});
      return;
    }

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

    Map<String, dynamic> request = {
      'idinspeccion': 0,
      'idcliente': widget.detallesFormulariosCompleto[0].idcliente,
      'fecha': DateTime.now().toString(),
      'usuarioalta': widget.user.idUsuario,
      'latitud': widget.positionUser.latitude.toString(),
      'longitud': widget.positionUser.longitude.toString(),
      'idobra': widget.obra.nroObra,
      'supervisor': widget.obra.supervisore,
      'vehiculo': '',
      'nrolegajo': widget.causante.codigo,
      'grupoc': widget.causante.grupo,
      'causantec': widget.causante.nroCausante,
      'dni': widget.causante.nroSAP,
      'estado': '0',
      'observacionesinspeccion': widget.observaciones,
      'aviso': 'NO',
      'emailenviado': 0,
      'requiereinspeccion': 0,
      'totalpreguntas': widget.detallesFormulariosCompleto.length,
      'respsi': respSI,
      'respno': respNO,
      'respna': respNA,
      'totalpuntos': puntos,
    };

    Response response =
        await ApiHelper.post('/api/Inspecciones/PostInspeccion', request);

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
    } else {
      var body = response.result;
      var decodedJson = jsonDecode(body);
      var inspeccionCab = Inspeccion.fromJson(decodedJson);
      _idCab = inspeccionCab.idInspeccion;
    }

    _elements.forEach((element) async {
      Map<String, dynamic> request2 = {
        'iDRegistro': 0,
        'inspeccionCab': _idCab,
        'idCliente': widget.cliente.toString(),
        'iDGrupoFormulario': element['idgrupoformulario'],
        'detalleF': element['detallef'],
        'descripcion': element['descripcion'],
        'ponderacionPuntos': element['ponderacionpuntos'],
        'cumple': element['cumple'],
      };

      await ApiHelper.post('/api/Inspecciones/PostInspeccionDetalle', request2);
    });

    await showAlertDialog(
        context: context,
        title: 'Aviso',
        message: 'Cuestionario grabado con éxito!',
        actions: <AlertDialogAction>[
          AlertDialogAction(key: null, label: 'Ok'),
        ]);
    Navigator.pop(context, 'yes');
    Navigator.pop(context, 'yes');
  }
}
