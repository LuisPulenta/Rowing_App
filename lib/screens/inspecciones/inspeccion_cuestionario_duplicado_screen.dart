import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rowing_app/components/loader_component.dart';
import 'package:rowing_app/helpers/helpers.dart';
import 'package:rowing_app/models/models.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:rowing_app/screens/screens.dart';
import 'package:rowing_app/helpers/helpers.dart';

class InspeccionCuestionarioDuplicadoScreen extends StatefulWidget {
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

  const InspeccionCuestionarioDuplicadoScreen(
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
  State<InspeccionCuestionarioDuplicadoScreen> createState() =>
      _InspeccionCuestionarioDuplicadoScreenState();
}

class _InspeccionCuestionarioDuplicadoScreenState
    extends State<InspeccionCuestionarioDuplicadoScreen> {
//---------------------------------------------------------------
//----------------------- Variables -----------------------------
//---------------------------------------------------------------

  Color colorVerde = const Color.fromARGB(255, 22, 175, 22);
  Color colorRojo = const Color.fromARGB(255, 243, 6, 38);
  Color colorNaranja = const Color.fromARGB(255, 244, 104, 28);
  Color colorCeleste = const Color.fromARGB(255, 123, 220, 247);

  final List _elements = [];
  int puntos = 0;
  int respSI = 0;
  int respNO = 0;
  int respNA = 0;
  int respTXT = 0;

  int _idCab = 0;

  bool _showLoader = false;
  bool _todas = true;

  String _texto = '';
  final String _textoError = '';
  final bool _textoShowError = false;
  final TextEditingController _textoController = TextEditingController();

//---------------------------------------------------------------
//----------------------- initState -----------------------------
//---------------------------------------------------------------

  @override
  void initState() {
    super.initState();

    for (var element in widget.detallesFormulariosCompleto) {
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
          'imagedesdeweb': element.foto,
          'fotodesdeweb': element.foto !=
              "http://190.111.249.225/RowingAppApi/images/Inspecciones/noimage.png",
          'soloTexto': element.soloTexto,
          'obsApp': element.obsApp,
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
      if (element.obsApp != 'N/A') {
        respTXT++;
      }
    }
  }

//---------------------------------------------------------------
//----------------------- Pantalla ------------------------------
//---------------------------------------------------------------

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

//---------------------------------------------------------------------
//------------------------------ _getContent --------------------------
//---------------------------------------------------------------------

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

//----------------------------------------------------------------------
//------------------------------ _showResultado ------------------------
//----------------------------------------------------------------------

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
                              respNA -
                              respTXT)
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
                children: [
                  const Text("Resp. TXT: ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(respTXT.toString(),
                      style: const TextStyle(
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

//-----------------------------------------------------------------------
//------------------------------ _getListView ---------------------------
//-----------------------------------------------------------------------

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
                        trailing: element['soloTexto'] == 0
                            ? Container(
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
                              )
                            : const SizedBox(
                                width: 2,
                                height: 60,
                              ),
                      ),

                      //-------------------------------------------------------------------------

                      element['soloTexto'] == 0
                          ? Container(
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                        backgroundColor: colorVerde,
                                        minimumSize:
                                            const Size(double.infinity, 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (element['cumple'] == "NO") {
                                          respNO--;
                                          respSI++;
                                          puntos = puntos -
                                              int.parse(
                                                  element['ponderacionpuntos']);
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
                                        backgroundColor: colorRojo,
                                        minimumSize:
                                            const Size(double.infinity, 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (element['cumple'] == "SI") {
                                          respSI--;
                                          respNO++;
                                          puntos = puntos +
                                              int.parse(
                                                  element['ponderacionpuntos']);
                                        }
                                        if (element['cumple'] == "N/A") {
                                          respNA--;
                                          respNO++;
                                          puntos = puntos +
                                              int.parse(
                                                  element['ponderacionpuntos']);
                                        }
                                        if (element['cumple'] != "SI" &&
                                            element['cumple'] != "NO" &&
                                            element['cumple'] != "N/A") {
                                          respNO++;
                                          puntos = puntos +
                                              int.parse(
                                                  element['ponderacionpuntos']);
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
                                        backgroundColor: colorNaranja,
                                        minimumSize:
                                            const Size(double.infinity, 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                              int.parse(
                                                  element['ponderacionpuntos']);
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
                            )
                          : Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(element['obsApp'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 12,
                                        )),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                    onPressed: () {
                                      _textoController.text =
                                          element['obsApp'] != null
                                              ? ''
                                              : element['obsApp'].toString();
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor: Colors.grey[300],
                                              title: const Text(
                                                  "Ingrese al menos 3 caracteres"),
                                              content: TextField(
                                                autofocus: true,
                                                controller: _textoController,
                                                decoration: InputDecoration(
                                                    fillColor: Colors.white,
                                                    filled: true,
                                                    hintText: '',
                                                    labelText: '',
                                                    errorText: _textoShowError
                                                        ? _textoError
                                                        : null,
                                                    prefixIcon:
                                                        const Icon(Icons.abc),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10))),
                                                onChanged: (value) {
                                                  _texto = value;
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
                                                          children: const [
                                                            Icon(Icons.cancel),
                                                            Text('Cancelar'),
                                                          ],
                                                        ),
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              const Color(
                                                                  0xFFB4161B),
                                                          minimumSize:
                                                              const Size(
                                                                  double
                                                                      .infinity,
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
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: ElevatedButton(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: const [
                                                            Icon(Icons.save),
                                                            Text('Aceptar'),
                                                          ],
                                                        ),
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              const Color(
                                                                  0xFF120E43),
                                                          minimumSize:
                                                              const Size(
                                                                  double
                                                                      .infinity,
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
                                                          if (_texto.length <
                                                              3) {
                                                            showAlertDialog(
                                                                context:
                                                                    context,
                                                                title: 'Error',
                                                                message:
                                                                    'Debe ingresar al menos 3 caracteres',
                                                                actions: <
                                                                    AlertDialogAction>[
                                                                  const AlertDialogAction(
                                                                      key: null,
                                                                      label:
                                                                          'Aceptar'),
                                                                ]);
                                                            return;
                                                          } else {
                                                            for (var e
                                                                in _elements) {
                                                              if (e['descripcion'] ==
                                                                  element[
                                                                      'descripcion']) {
                                                                if (e['obsApp'] ==
                                                                    "") {
                                                                  respTXT++;
                                                                }

                                                                e['obsApp'] =
                                                                    _texto;
                                                              }
                                                            }

                                                            Navigator.pop(
                                                                context);
                                                            setState(() {});
                                                          }
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
                                    icon: const Icon(Icons.loop,
                                        color: Colors.blue)),
                              ],
                            ),

                      !element['photoChanged']
                          ? element['imagedesdeweb'] !=
                                  "http://190.111.249.225/RowingAppApi/images/Inspecciones/noimage.png"
                              ? CachedNetworkImage(
                                  imageUrl: element['imagedesdeweb'],
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  fit: BoxFit.contain,
                                  height: 100,
                                  width: 100,
                                  placeholder: (context, url) => const Image(
                                    image: AssetImage('assets/loading.gif'),
                                    fit: BoxFit.cover,
                                    height: 200,
                                    width: 200,
                                  ),
                                )
                              : Container()
                          : Container(),
                      const SizedBox(
                        height: 5,
                      ),
                      element['soloTexto'] == 0
                          ? Container(
                              child: !element['photoChanged']
                                  ? Container()
                                  : Image.file(
                                      File(element['image'].path),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.contain,
                                    ),
                            )
                          : const SizedBox(
                              width: 2,
                              height: 5,
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
                              element['cumple'] != "N/A" &&
                              element['obsApp'] != "")
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
                            trailing: element['soloTexto'] == 0
                                ? Container(
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
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        element['cumple'] != "null"
                                            ? Text(
                                                element['cumple'],
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              )
                                            : const Text(''),
                                      ],
                                    )),
                                  )
                                : const SizedBox(
                                    width: 60,
                                    height: 60,
                                  ),
                          ),
                          element['soloTexto'] == 0
                              ? Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
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
                                            backgroundColor: colorVerde,
                                            minimumSize:
                                                const Size(double.infinity, 40),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          onPressed: () {
                                            if (element['cumple'] == "NO") {
                                              respNO--;
                                              respSI++;
                                              puntos = puntos +
                                                  int.parse(element[
                                                      'ponderacionpuntos']);
                                            }
                                            if (element['cumple'] == "N/A") {
                                              respNA--;
                                              respSI++;
                                              puntos = puntos +
                                                  int.parse(element[
                                                      'ponderacionpuntos']);
                                            }
                                            if (element['cumple'] != "SI" &&
                                                element['cumple'] != "NO" &&
                                                element['cumple'] != "N/A") {
                                              respSI++;
                                              puntos = puntos +
                                                  int.parse(element[
                                                      'ponderacionpuntos']);
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
                                            backgroundColor: colorRojo,
                                            minimumSize:
                                                const Size(double.infinity, 40),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          onPressed: () {
                                            if (element['cumple'] == "SI") {
                                              respSI--;
                                              respNO++;
                                              puntos = puntos -
                                                  int.parse(element[
                                                      'ponderacionpuntos']);
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
                                            backgroundColor: colorNaranja,
                                            minimumSize:
                                                const Size(double.infinity, 40),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          onPressed: () {
                                            if (element['cumple'] == "SI") {
                                              respSI--;
                                              respNA++;
                                              puntos = puntos -
                                                  int.parse(element[
                                                      'ponderacionpuntos']);
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
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(element['obsApp'] ?? '',
                                            style: const TextStyle(
                                              fontSize: 12,
                                            )),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          _textoController.text =
                                              element['obsApp'] != null
                                                  ? ''
                                                  : element['obsApp']
                                                      .toString();
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  backgroundColor:
                                                      Colors.grey[300],
                                                  title: const Text(
                                                      "Ingrese al menos 3 caracteres"),
                                                  content: TextField(
                                                    autofocus: true,
                                                    controller:
                                                        _textoController,
                                                    decoration: InputDecoration(
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                        hintText: '',
                                                        labelText: '',
                                                        errorText:
                                                            _textoShowError
                                                                ? _textoError
                                                                : null,
                                                        prefixIcon: const Icon(
                                                            Icons.abc),
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10))),
                                                    onChanged: (value) {
                                                      _texto = value;
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
                                                              children: const [
                                                                Icon(Icons
                                                                    .cancel),
                                                                Text(
                                                                    'Cancelar'),
                                                              ],
                                                            ),
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  const Color(
                                                                      0xFFB4161B),
                                                              minimumSize:
                                                                  const Size(
                                                                      double
                                                                          .infinity,
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
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          child: ElevatedButton(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: const [
                                                                Icon(
                                                                    Icons.save),
                                                                Text('Aceptar'),
                                                              ],
                                                            ),
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  const Color(
                                                                      0xFF120E43),
                                                              minimumSize:
                                                                  const Size(
                                                                      double
                                                                          .infinity,
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
                                                              if (_texto
                                                                      .length <
                                                                  3) {
                                                                showAlertDialog(
                                                                    context:
                                                                        context,
                                                                    title:
                                                                        'Error',
                                                                    message:
                                                                        'Debe ingresar al menos 3 caracteres',
                                                                    actions: <
                                                                        AlertDialogAction>[
                                                                      const AlertDialogAction(
                                                                          key:
                                                                              null,
                                                                          label:
                                                                              'Aceptar'),
                                                                    ]);
                                                                return;
                                                              } else {
                                                                for (var e
                                                                    in _elements) {
                                                                  if (e['descripcion'] ==
                                                                      element[
                                                                          'descripcion']) {
                                                                    e['obsApp'] =
                                                                        _texto;
                                                                  }
                                                                }

                                                                Navigator.pop(
                                                                    context);
                                                                setState(() {});
                                                              }
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
                                        icon: const Icon(Icons.loop,
                                            color: Colors.blue)),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  )
                : Container();
      },
    );
  }

//-----------------------------------------------------------------
//---------------------- _showButtonsGuardarCancelar --------------
//-----------------------------------------------------------------

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
                      backgroundColor: const Color(0xFF282886),
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
                    backgroundColor: const Color(0xffdf281e),
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

//-----------------------------------------------------------------
//---------------------- _guardar ---------------------------------
//-----------------------------------------------------------------

  _guardar() async {
    if (widget.detallesFormulariosCompleto.length -
            respSI -
            respNO -
            respNA -
            respTXT !=
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
      showMyDialog(
          'Error', "Verifica que estés conectado a Internet", 'Aceptar');
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

    Response response = await ApiHelper.postInspeccionDetalle(
        '/api/Inspecciones/PostInspeccion', request);

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
          'obsApp': element['obsApp'] != "" ? element['obsApp'] : "N/A",
          'soloTexto': element['soloTexto'],
        };

        await ApiHelper.post(
            '/api/Inspecciones/PostInspeccionDetalle', request2);
      } else {
        String foto = '';

        if (element['fotodesdeweb'] == true) {
          foto = '~' + element['imagedesdeweb'].substring(35);
        }

        Map<String, dynamic> request3 = {
          'iDRegistro': 0,
          'inspeccionCab': _idCab,
          'idCliente': widget.cliente.toString(),
          'iDGrupoFormulario': element['idgrupoformulario'],
          'detalleF': element['detallef'],
          'descripcion': element['descripcion'],
          'ponderacionPuntos': element['ponderacionpuntos'],
          'cumple': element['cumple'],
          'linkFoto': foto,
          'obsApp': element['obsApp'] != "" ? element['obsApp'] : "N/A",
          'soloTexto': element['soloTexto'],
        };

        await ApiHelper.post(
            '/api/Inspecciones/PostInspeccionDetalleConFotoExistente',
            request3);
      }
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

//-----------------------------------------------------------------
//---------------------- _takePicture -----------------------------
//-----------------------------------------------------------------

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
