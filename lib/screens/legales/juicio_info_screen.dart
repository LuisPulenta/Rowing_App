import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../screens.dart';

class JuicioInfoScreen extends StatefulWidget {
  final User user;
  final Juicio juicio;
  const JuicioInfoScreen({super.key, required this.user, required this.juicio});

  @override
  State<JuicioInfoScreen> createState() => _JuicioInfoScreenState();
}

class _JuicioInfoScreenState extends State<JuicioInfoScreen> {
  //---------------------------------------------------------------------
  //-------------------------- Variables --------------------------------
  //---------------------------------------------------------------------
  List<Contraparte> _contrapartes = [];
  bool _showLoader = false;

  //---------------------------------------------------------------------
  //-------------------------- InitState --------------------------------
  //---------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _getContrapartes();
  }

  //---------------------------------------------------------------------
  //-------------------------- Pantalla ---------------------------------
  //---------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: Text('Caso N°: ${widget.juicio.iDCASO.toString()}'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          _getInfoJuicio(),
          _showTelefonos(),
          const Spacer(),
          _showButtons(),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  //---------------------------------------------------------------------
  //-------------------------- _getInfoJuicio ---------------------------
  //---------------------------------------------------------------------
  Widget _getInfoJuicio() {
    return Card(
      color: Colors.white, //const Color(0xFFC7C7C8),
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
                              const SizedBox(
                                width: 70,
                                child: Text(
                                  'N° Caso: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF781f1e),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  widget.juicio.iDCASO.toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              const Text(
                                'N° Expediente: ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF781f1e),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  widget.juicio.nroExpediente.toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const SizedBox(
                                width: 70,
                                child: Text(
                                  'Tipo Caso: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF781f1e),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  widget.juicio.tipocaso.toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const SizedBox(
                                width: 70,
                                child: Text(
                                  'Estado: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF781f1e),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  widget.juicio.estado.toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const SizedBox(
                                width: 70,
                                child: Text(
                                  'Ult. mov.: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF781f1e),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: widget.juicio.fEULTMOV != null
                                    ? Text(
                                        DateFormat('dd/MM/yyyy').format(
                                          DateTime.parse(
                                            widget.juicio.fEULTMOV.toString(),
                                          ),
                                        ),
                                        style: const TextStyle(fontSize: 12),
                                      )
                                    : Container(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const SizedBox(
                                width: 70,
                                child: Text(
                                  'Carátula: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF781f1e),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  widget.juicio.caratula.toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const SizedBox(
                                width: 70,
                                child: Text(
                                  'Abogado: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF781f1e),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  widget.juicio.abogado != null
                                      ? widget.juicio.abogado.toString()
                                      : '',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.black),
                          Row(
                            children: [
                              const SizedBox(
                                width: 110,
                                child: Text(
                                  'Importe Juicio: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF781f1e),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  widget.juicio.importejuicio != null
                                      ? NumberFormat.currency(
                                          symbol: '\$',
                                        ).format(widget.juicio.importejuicio)
                                      : '',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const SizedBox(
                                width: 110,
                                child: Text(
                                  'Importe Interés: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF781f1e),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  widget.juicio.importeinteres != null
                                      ? NumberFormat.currency(symbol: '\$')
                                            .format(
                                              widget.juicio.importeinteres,
                                            )
                                            .toString()
                                      : '',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const SizedBox(
                                width: 110,
                                child: Text(
                                  'Moneda: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF781f1e),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  widget.juicio.moneda != null
                                      ? widget.juicio.moneda.toString()
                                      : '',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
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
  //--------------------- _showTelefonos ----------------------------
  //-----------------------------------------------------------------

  Widget _showTelefonos() {
    return _contrapartes.isNotEmpty
        ? Card(
            color: Colors.white,
            //color: Color(0xFFC7C7C8),
            shadowColor: Colors.white,
            elevation: 10,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                    const SizedBox(
                                      width: 86,
                                      child: Text(
                                        'Contraparte: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF0e4888),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        _contrapartes[0].apellidonombre,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 1),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 86,
                                      child: Text(
                                        'Domicilio: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF0e4888),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        _contrapartes[0].domicilioestudio !=
                                                null
                                            ? _contrapartes[0].domicilioestudio!
                                            : '',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(color: Colors.black),
                                const SizedBox(height: 10),
                                _contrapartes[0].telefono.toString().isNotEmpty
                                    ? Row(
                                        children: [
                                          const SizedBox(
                                            width: 90,
                                            child: Text(
                                              'Teléfono fijo: ',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF0e4888),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              _contrapartes[0].telefono
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.phone_forwarded,
                                              size: 34,
                                            ),
                                            color: Colors.green,
                                            onPressed: () {
                                              if (_contrapartes[0].telefono
                                                          .toString() !=
                                                      'Sin Dato' &&
                                                  _contrapartes[0].telefono
                                                          .toString() !=
                                                      'xxx' &&
                                                  _contrapartes[0].telefono
                                                          .toString() !=
                                                      'XXX') {
                                                launch(
                                                  'tel://${_contrapartes[0].telefono.toString()}',
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      )
                                    : Container(),
                                _contrapartes[0].telefono.toString().isNotEmpty
                                    ? const Divider(color: Colors.black)
                                    : Container(),
                                _contrapartes[0].celular.toString().isNotEmpty
                                    ? Row(
                                        children: [
                                          const SizedBox(
                                            width: 90,
                                            child: Text(
                                              'Celular: ',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF0e4888),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              _contrapartes[0].celular
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              color: Colors.green,
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.insert_comment,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () => _sendMessage(
                                                  _contrapartes[0].celular
                                                      .toString(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.phone_forwarded,
                                              size: 34,
                                            ),
                                            color: Colors.green,
                                            onPressed: () {
                                              if (_contrapartes[0].celular
                                                          .toString() !=
                                                      'Sin Dato' &&
                                                  _contrapartes[0].celular
                                                          .toString() !=
                                                      'xxx' &&
                                                  _contrapartes[0].celular
                                                          .toString() !=
                                                      'XXX') {
                                                launch(
                                                  'tel://${_contrapartes[0].celular.toString()}',
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      )
                                    : Container(),
                                _contrapartes[0].celular.toString().isNotEmpty
                                    ? const Divider(color: Colors.black)
                                    : Container(),
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
          )
        : Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            color: Colors.white,
            height: 50,
            child: const Center(
              child: Text(
                'No hay datos de Contraparte',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
  }

  //-----------------------------------------------------------------
  //--------------------- _showButtons ------------------------------
  //-----------------------------------------------------------------

  Widget _showButtons() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF781f1e),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificacionesScreen(
                      user: widget.user,
                      juicio: widget.juicio,
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.notifications),
                  SizedBox(width: 10),
                  Text('Notificaciones'),
                ],
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF781f1e),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MediacionesScreen(
                      user: widget.user,
                      juicio: widget.juicio,
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.hourglass_bottom),
                  SizedBox(width: 10),
                  Text('Mediaciones'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //---------------------------------------------------------------------
  //-------------------------- _getContrapartes -------------------------
  //---------------------------------------------------------------------

  Future<void> _getContrapartes() async {
    if (widget.juicio.idContraparte == null) return;

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

    response = await ApiHelper.getContrapartes(widget.juicio.idContraparte!);

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
      _contrapartes = response.result;
    });
  }

  //------------------------------------------------------------------------
  //------------------------ _sendMessage ----------------------------------
  //------------------------------------------------------------------------

  void _sendMessage(String number) async {
    String number2 = number;
    TextEditingController phoneController = TextEditingController();
    phoneController.text = number;

    if (number == 'xxx' || number == 'XXX') return;

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Text(
                    'Atención!!',
                    style: TextStyle(color: Colors.green, fontSize: 20),
                  ),
                ],
              ),
              content: SizedBox(
                height: 170,
                child: Column(
                  children: [
                    const Text(
                      'Verifique si el N° de teléfono tiene el formato correcto para WhatsApp',
                      style: TextStyle(fontSize: 14),
                    ),
                    const Text(''),
                    TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Teléfono...',
                        labelText: 'Teléfono',
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                        number2 = value;
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        child: const Text('+549'),
                        onPressed: () async {
                          phoneController.text = '549${phoneController.text}';
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () async {
                    final link = WhatsAppUnilink(
                      phoneNumber: number2,
                      //***** MENSAJE DE CONTACTO *****
                      text:
                          'Hola mi nombre es ${widget.user.fullName} de la Empresa Rowing. ',
                    );
                    await launch('$link');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.insert_comment),
                      SizedBox(width: 15),
                      Text('Continuar'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    return;
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.cancel),
                      SizedBox(width: 15),
                      Text('Cancelar'),
                    ],
                  ),
                ),
              ],
              shape: Border.all(
                color: Colors.green,
                width: 5,
                style: BorderStyle.solid,
              ),
              backgroundColor: Colors.white,
            );
          },
        );
      },
    );
  }
}
