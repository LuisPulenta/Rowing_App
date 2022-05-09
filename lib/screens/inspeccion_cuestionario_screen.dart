import 'package:flutter/material.dart';
import 'package:rowing_app/models/models.dart';
import 'package:grouped_list/grouped_list.dart';

class InspeccionCuestionarioScreen extends StatefulWidget {
  final User user;
  final Causante causante;
  final List<DetallesFormularioCompleto> detallesFormulariosCompleto;

  const InspeccionCuestionarioScreen(
      {required this.user,
      required this.causante,
      required this.detallesFormulariosCompleto});

  @override
  State<InspeccionCuestionarioScreen> createState() =>
      _InspeccionCuestionarioScreenState();
}

class _InspeccionCuestionarioScreenState
    extends State<InspeccionCuestionarioScreen> {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

  List _elements = [];
  int puntos = 0;
  int respSI = 0;
  int respNO = 0;
  int respNA = 0;

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
      ),
      body: Center(
        child: _getContent(),
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
                  Text("Puntos: ",
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
        return Card(
          elevation: 8.0,
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            color: (element['cumple'] != "SI" &&
                    element['cumple'] != "NO" &&
                    element['cumple'] != "N/A")
                ? Colors.white
                : Colors.blue[400],
            child: Column(
              children: [
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
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
                    color: Colors.blue[200],
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('${element['ponderacionpuntos']} pts'),
                        element['cumple'] != "null"
                            ? Text(element['cumple'])
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.toggle_on),
                              SizedBox(
                                width: 5,
                              ),
                              Text('SI'),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 30, 120, 98),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.toggle_off),
                              Text('NO'),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 194, 24, 47),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.cancel),
                              Text('N/A'),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 210, 88, 22),
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
        );
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
                      //_guardar();
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
}
