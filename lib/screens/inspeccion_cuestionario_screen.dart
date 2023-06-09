import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rowing_app/components/loader_component.dart';
import 'package:rowing_app/helpers/api_helper.dart';
import 'package:rowing_app/models/models.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:rowing_app/screens/screens.dart';

class InspeccionCuestionarioScreen extends StatefulWidget {
  final User user;
  final Causante causante;
  final String observaciones;
  final Obra obra;
  final int cliente;
  final int tipotrabajo;
  final bool esContratista;
  final String nombreSR;
  final String dniSR;
  final List<DetallesFormularioCompleto> detallesFormulariosCompleto;
  final Position positionUser;

  const InspeccionCuestionarioScreen(
      {Key? key,
      required this.user,
      required this.causante,
      required this.observaciones,
      required this.obra,
      required this.cliente,
      required this.tipotrabajo,
      required this.esContratista,
      required this.nombreSR,
      required this.dniSR,
      required this.detallesFormulariosCompleto,
      required this.positionUser})
      : super(key: key);

  @override
  State<InspeccionCuestionarioScreen> createState() =>
      _InspeccionCuestionarioScreenState();
}

class _InspeccionCuestionarioScreenState
    extends State<InspeccionCuestionarioScreen> {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

  Color colorVerde = const Color.fromARGB(255, 22, 175, 22);
  Color colorRojo = const Color.fromARGB(255, 243, 6, 38);
  Color colorNaranja = const Color.fromARGB(255, 244, 104, 28);
  Color colorCeleste = const Color.fromARGB(255, 123, 220, 247);

  final List _elements = [];
  int puntos = 0;
  int respSI = 0;
  int respNO = 0;
  int respNA = 0;

  int _idCab = 0;

  bool _showLoader = false;
  bool _todas = true;

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
          'photoChanged': false,
          'image': '',
        },
      );
      if (element.cumple == 'SI') {
        respSI++;
      }
      if (element.cumple == 'NO') {
        respNO++;
        puntos = puntos + element.ponderacionpuntos;
      }
      if (element.cumple == 'N/A') {
        respNA++;
      }
    });
  }

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 195, 191, 191),
      appBar: AppBar(
        title: const Text('Cuestionario'),
        centerTitle: true,
        actions: [
          Row(
            children: [
              const Text(
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
              ? const LoaderComponent(
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
      padding: const EdgeInsets.all(10),
      height: 80,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text("Preguntas: ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(widget.detallesFormulariosCompleto.length.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.normal,
                      )),
                ],
              ),
              Row(
                children: [
                  const Text("Resp SI: ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(respSI.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.normal,
                      )),
                ],
              ),
              Row(
                children: [
                  const Text("Faltan Responder: ",
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
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.normal,
                      )),
                ],
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
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
                  const Text("Resp. NO: ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(respNO.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.normal,
                      )),
                ],
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
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
                  const Text("Resp. N/A: ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(respNA.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.normal,
                      )),
                ],
              ),
              Row(
                children: [
                  const Text("Total Puntos: ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(puntos.toString(),
                      style: const TextStyle(
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
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      itemBuilder: (c, element) {
        return _todas
            ? Card(
                elevation: 8.0,
                margin:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: Container(
                  color: (element['cumple'] != "SI" &&
                          element['cumple'] != "NO" &&
                          element['cumple'] != "N/A")
                      ? Colors.white
                      : colorCeleste,
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 5.0),
                        leading: CircleAvatar(
                            child: Text(
                          element['detallef'],
                          style: const TextStyle(fontSize: 10),
                        )),
                        title: Text(
                          element['descripcion'],
                          style: const TextStyle(fontSize: 12),
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
                                  : const Text(''),
                            ],
                          )),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                              child: ElevatedButton(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: const [
                                    Icon(Icons.toggle_on),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('SI'),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: colorVerde,
                                  minimumSize: const Size(double.infinity, 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                onPressed: () {
                                  if (element['cumple'] == "NO") {
                                    respNO--;
                                    respSI++;
                                    puntos = puntos -
                                        int.parse(element['ponderacionpuntos']);
                                  }
                                  if (element['cumple'] == "N/A") {
                                    respNA--;
                                    respSI++;
                                  }
                                  if (element['cumple'] != "SI" &&
                                      element['cumple'] != "NO" &&
                                      element['cumple'] != "N/A") {
                                    respSI++;
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
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: const [
                                    Icon(Icons.toggle_off),
                                    Text('NO'),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: colorRojo,
                                  minimumSize: const Size(double.infinity, 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                onPressed: () {
                                  if (element['cumple'] == "SI") {
                                    respSI--;
                                    respNO++;
                                    puntos = puntos +
                                        int.parse(element['ponderacionpuntos']);
                                  }
                                  if (element['cumple'] == "N/A") {
                                    respNA--;
                                    respNO++;
                                    puntos = puntos +
                                        int.parse(element['ponderacionpuntos']);
                                  }
                                  if (element['cumple'] != "SI" &&
                                      element['cumple'] != "NO" &&
                                      element['cumple'] != "N/A") {
                                    respNO++;
                                    puntos = puntos +
                                        int.parse(element['ponderacionpuntos']);
                                  }
                                  element['cumple'] = "NO";
                                  setState(() {});
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: const [
                                    Icon(Icons.cancel),
                                    Text('N/A'),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: colorNaranja,
                                  minimumSize: const Size(double.infinity, 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                onPressed: () {
                                  if (element['cumple'] == "SI") {
                                    respSI--;
                                    respNA++;
                                  }
                                  if (element['cumple'] == "NO") {
                                    respNO--;
                                    respNA++;
                                    puntos = puntos -
                                        int.parse(element['ponderacionpuntos']);
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
                            const SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () => _takePicture(element),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  color: const Color(0xFF282886),
                                  width: 40,
                                  height: 40,
                                  child: const Icon(
                                    Icons.photo_camera,
                                    size: 30,
                                    color: Color(0xFFf6faf8),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: !element['photoChanged']
                            ? Container()
                            : Image.file(
                                File(element['image'].path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.contain,
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
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    child: Container(
                      color: (element['cumple'] != "SI" &&
                              element['cumple'] != "NO" &&
                              element['cumple'] != "N/A")
                          ? Colors.white
                          : Colors.blue[400],
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 5.0),
                            leading: CircleAvatar(
                                child: Text(
                              element['detallef'],
                              style: const TextStyle(fontSize: 10),
                            )),
                            title: Text(
                              element['descripcion'],
                              style: const TextStyle(fontSize: 12),
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
                                  child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    '${element['ponderacionpuntos']} pts',
                                  ),
                                  element['cumple'] != "null"
                                      ? Text(
                                          element['cumple'],
                                        )
                                      : const Text(''),
                                ],
                              )),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Expanded(
                                  child: ElevatedButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: const [
                                        Icon(Icons.toggle_on),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text('SI'),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: colorVerde,
                                      minimumSize:
                                          const Size(double.infinity, 40),
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
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: const [
                                        Icon(Icons.toggle_off),
                                        Text('NO'),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: colorRojo,
                                      minimumSize:
                                          const Size(double.infinity, 40),
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
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: const [
                                        Icon(Icons.cancel),
                                        Text('N/A'),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: colorNaranja,
                                      minimumSize:
                                          const Size(double.infinity, 40),
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
                                const SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                  onTap: () => _takePicture(element),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Container(
                                      color: const Color(0xFF282886),
                                      width: 40,
                                      height: 40,
                                      child: const Icon(
                                        Icons.photo_camera,
                                        size: 30,
                                        color: Color(0xFFf6faf8),
                                      ),
                                    ),
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
                      children: const [
                        Icon(Icons.save),
                        SizedBox(
                          width: 2,
                        ),
                        Text('Guardar', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF282886),
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      _guardar();
                    }),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.cancel),
                      SizedBox(
                        width: 2,
                      ),
                      Text('Cancelar', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xffdf281e),
                    minimumSize: const Size(double.infinity, 40),
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
              title: const Text('Aviso!'),
              content:
                  Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text(
                    'Todavía no puede guardar el Cuestionario. Quedan ${widget.detallesFormulariosCompleto.length - respSI - respNO - respNA} preguntas sin responder.'),
                const SizedBox(
                  height: 10,
                ),
              ]),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Ok')),
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
            const AlertDialogAction(key: null, label: 'Aceptar'),
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
      'nrolegajo': widget.esContratista == true ? 0 : widget.causante.codigo,
      'grupoc': widget.esContratista == true ? 'PPR' : widget.causante.grupo,
      'causantec':
          widget.esContratista == true ? '000000' : widget.causante.codigo,
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
      'dniSr': widget.esContratista == true ? widget.dniSR : '',
      'nombreSr': widget.esContratista == true ? widget.nombreSR : '',
      'idTipoTrabajo': widget.tipotrabajo,
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
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    } else {
      var body = response.result;
      var decodedJson = jsonDecode(body);
      var inspeccionCab = Inspeccion.fromJson(decodedJson);
      _idCab = inspeccionCab.idInspeccion;
    }

    _elements.forEach((element) async {
      String base64image = '';
      if (element['photoChanged']) {
        List<int> imageBytes = await element['image'].readAsBytes();
        base64image = base64Encode(imageBytes);
      }

      Map<String, dynamic> request2 = {
        'iDRegistro': 0,
        'inspeccionCab': _idCab,
        'idCliente': widget.cliente.toString(),
        'iDGrupoFormulario': element['idgrupoformulario'],
        'detalleF': element['detallef'],
        'descripcion': element['descripcion'],
        'ponderacionPuntos': element['ponderacionpuntos'],
        'cumple': element['cumple'],
        'imagearray': base64image,
      };

      await ApiHelper.post('/api/Inspecciones/PostInspeccionDetalle', request2);
    });

    await showAlertDialog(
        context: context,
        title: 'Aviso',
        message: 'Cuestionario grabado con éxito!',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Ok'),
        ]);
    Navigator.pop(context, 'yes');
    Navigator.pop(context, 'yes');
  }

//*****************************************************************************
//************************** TAKEPICTURE **************************************
//*****************************************************************************

  void _takePicture(dynamic element) async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    var firstCamera = cameras.first;
    var response1 = await showAlertDialog(
        context: context,
        title: 'Seleccionar cámara',
        message: '¿Qué cámara desea utilizar?',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: 'no', label: 'Trasera'),
          const AlertDialogAction(key: 'yes', label: 'Delantera'),
          const AlertDialogAction(key: 'cancel', label: 'Cancelar'),
        ]);
    if (response1 == 'yes') {
      firstCamera = cameras.first;
    }
    if (response1 == 'no') {
      firstCamera = cameras.last;
    }

    if (response1 != 'cancel') {
      Response? response = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TakePictureCScreen(
                    camera: firstCamera,
                  )));
      if (response != null) {
        setState(() {
          element['photoChanged'] = true;
          element['image'] = response.result;
        });
      }
    }
  }
}
