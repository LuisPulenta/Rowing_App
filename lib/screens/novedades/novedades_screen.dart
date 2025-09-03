import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class NovedadesScreen extends StatefulWidget {
  final User user;
  const NovedadesScreen({super.key, required this.user});

  @override
  _NovedadesScreenState createState() => _NovedadesScreenState();
}

class _NovedadesScreenState extends State<NovedadesScreen> {
  //-----------------------------------------------------------------
  //--------------------- Variables ---------------------------------
  //-----------------------------------------------------------------

  String _codigo = '';
  final String _codigoError = '';
  final bool _codigoShowError = false;
  bool _enabled = false;
  bool _showLoader = false;

  late Causante _causante;
  List<Novedad> _novedades = [];
  List<Novedad> _novedadesSinLeer = [];

  //-----------------------------------------------------------------
  //--------------------- initState ---------------------------------
  //-----------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _causante = Causante(
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

    if (widget.user.habilitaRRHH != 1) {
      _codigo = widget.user.codigoCausante;
      _getCausante();
    }
  }

  //-----------------------------------------------------------------
  //--------------------- Pantalla ----------------------------------
  //-----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: Text(
          widget.user.habilitaRRHH == 0 ? 'Mis Novedades' : 'Novedades',
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 0),
              _showLogo(),
              const SizedBox(height: 0),
              widget.user.habilitaRRHH == 1
                  ? Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 15,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: [
                                Expanded(flex: 7, child: _showLegajo()),
                                Expanded(flex: 2, child: _showButton()),
                              ],
                            ),
                            const SizedBox(height: 0),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              const SizedBox(height: 5),
              _showInfo(),
              const SizedBox(height: 3),
              _causante.nroCausante != 0
                  ? _novedades.isEmpty
                        ? Container()
                        : Row(
                            children: [
                              const SizedBox(width: 5),
                              const Text(
                                'Cant. Novedades: ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _novedades.length.toString(),
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                  : Container(),
              const SizedBox(height: 5),
              Expanded(
                child: _causante.nroCausante != 0
                    ? _novedades.isEmpty
                          ? _noContent()
                          : _getListView()
                    : Container(),
              ),
              const SizedBox(height: 20),
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
              onPressed: _enabled ? _addNovedad : null,
              child: const Icon(Icons.add, size: 38),
            )
          : Container(),
    );
  }

  //-------------------------------------------------------------------
  //------------------------------ _noContent -------------------------
  //-------------------------------------------------------------------

  Widget _noContent() {
    return Container(
      height: 200,
      width: 300,
      margin: const EdgeInsets.all(20),
      child: const Center(
        child: Text(
          'Este empleado no tiene novedades en los últimos 30 días.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  //-----------------------------------------------------------------------
  //------------------------------ _getListView ---------------------------
  //-----------------------------------------------------------------------

  Widget _getListView() {
    return ListView(
      children: _novedades.map((e) {
        return Card(
          color: Colors.white,
          //color: Color(0xFFC7C7C8),
          shadowColor: Colors.white,
          elevation: 10,
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: InkWell(
            onTap: () {
              // asignacionSelected = e;
              // _goInfoAsignacion(e);
            },
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
                                      width: 100,
                                      child: Text(
                                        'Tipo Novedad: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF0e4888),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.tiponovedad.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 100,
                                      child: Text(
                                        'Vista RRHH: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF0e4888),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Checkbox(
                                      value: e.vistaRRHH == 1 ? true : false,
                                      checkColor: const Color(0xFF781f1e),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.padded,
                                      onChanged: null,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 1),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 100,
                                      child: Text(
                                        'Fecha Novedad: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF0e4888),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        DateFormat('dd/MM/yyyy').format(
                                          DateTime.parse(
                                            e.fechanovedad.toString(),
                                          ),
                                        ),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 1),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 100,
                                      child: Text(
                                        'Fecha Inicio: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF0e4888),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        DateFormat('dd/MM/yyyy').format(
                                          DateTime.parse(
                                            e.fechainicio.toString(),
                                          ),
                                        ),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 1),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 100,
                                      child: Text(
                                        'Fecha Fin: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF0e4888),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        DateFormat('dd/MM/yyyy').format(
                                          DateTime.parse(e.fechafin.toString()),
                                        ),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 1),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 100,
                                      child: Text(
                                        'Observaciones: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF0e4888),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.observaciones.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 1, color: Colors.black),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 100,
                                      child: Text(
                                        'Estado: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF0e4888),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.estado.toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: e.estado == 'Rechazado'
                                              ? Colors.red
                                              : e.estado == 'Aprobado'
                                              ? Colors.green
                                              : Colors.black,
                                          fontWeight:
                                              e.estado == 'Rechazado' ||
                                                  e.estado == 'Aprobado'
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 1),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 100,
                                      child: Text(
                                        'Fecha RRHH: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF0e4888),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: e.fechaEstado != null
                                          ? Text(
                                              DateFormat('dd/MM/yyyy').format(
                                                DateTime.parse(
                                                  e.fechaEstado.toString(),
                                                ),
                                              ),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: e.estado == 'Rechazado'
                                                    ? Colors.red
                                                    : e.estado == 'Aprobado'
                                                    ? Colors.green
                                                    : Colors.black,
                                              ),
                                            )
                                          : const Text(''),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 1),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 100,
                                      child: Text(
                                        'Obs RRHH: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF0e4888),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.observacionEstado != null
                                            ? e.observacionEstado.toString()
                                            : '',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: e.estado == 'Rechazado'
                                              ? Colors.red
                                              : e.estado == 'Aprobado'
                                              ? Colors.green
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 1, color: Colors.black),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    e.confirmaLeido == 1
                                        ? const SizedBox(
                                            width: 110,
                                            child: Text(
                                              'Leído/Notificado:',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF0e4888),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    e.confirmaLeido == 1
                                        ? Checkbox(
                                            value: e.confirmaLeido == 1
                                                ? true
                                                : false,
                                            checkColor: const Color(0xFF781f1e),
                                            materialTapTargetSize:
                                                MaterialTapTargetSize.padded,
                                            onChanged: null,
                                          )
                                        : Container(),
                                    e.estado != 'Pendiente' &&
                                            e.confirmaLeido != 1
                                        ? Container(
                                            width: 200,
                                            height: 40,
                                            color: Colors.red,
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(
                                                    0xFF781f1e,
                                                  ),
                                                  minimumSize: const Size(
                                                    80,
                                                    40,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          5,
                                                        ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                          'Atencion!!',
                                                        ),
                                                        elevation: 5,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                15,
                                                              ),
                                                        ),
                                                        content: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: const [
                                                            Text(
                                                              '¿Confirma Ud. que marca la Novedad como Leida/Notificada?',
                                                            ),
                                                            Text(
                                                              'Esto no es posible deshacer',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              for (var novedad
                                                                  in _novedades) {
                                                                if (novedad
                                                                        .idnovedad ==
                                                                    e.idnovedad) {
                                                                  _grabarNovedad(
                                                                    novedad,
                                                                  );
                                                                }
                                                              }
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                            },
                                                            child: const Text(
                                                              'SI',
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                  context,
                                                                ),
                                                            child: const Text(
                                                              'NO',
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Icon(Icons.done),
                                                    SizedBox(width: 5),
                                                    Text('Leído/Notificado'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(),
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
          ),
        );
      }).toList(),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showLogo ---------------------------------
  //-----------------------------------------------------------------

  Widget _showLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Image.asset('assets/novedad.png', width: 70, height: 70),
        Image.asset('assets/logo.png', height: 70, width: 200),
        Transform.rotate(
          angle: 45,
          child: Image.asset('assets/novedad.png', width: 70, height: 70),
        ),
      ],
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showLegajo -------------------------------
  //-----------------------------------------------------------------

  Widget _showLegajo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          iconColor: const Color(0xFF781f1e),
          prefixIconColor: const Color(0xFF781f1e),
          hoverColor: const Color(0xFF781f1e),
          focusColor: const Color(0xFF781f1e),
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingrese Legajo o Documento del empleado...',
          labelText: 'Legajo o Documento:',
          errorText: _codigoShowError ? _codigoError : null,
          prefixIcon: const Icon(Icons.badge),
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

  //-----------------------------------------------------------------
  //--------------------- _showButton -------------------------------
  //-----------------------------------------------------------------

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
                minimumSize: const Size(double.infinity, 50),
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

  //-----------------------------------------------------------------
  //--------------------- _showInfo ---------------------------------
  //-----------------------------------------------------------------

  Widget _showInfo() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 15,
      margin: const EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomRow(
              icon: Icons.person,
              nombredato: 'Nombre:',
              dato: _causante.nombre,
            ),
            CustomRow(
              icon: Icons.engineering,
              nombredato: 'ENC/Puesto:',
              dato: _causante.encargado,
            ),
            CustomRow(
              icon: Icons.phone,
              nombredato: 'Teléfono:',
              dato: _causante.telefono,
            ),
            CustomRow(
              icon: Icons.badge,
              nombredato: 'Legajo:',
              dato: _causante.codigo,
            ),
            CustomRow(
              icon: Icons.assignment_ind,
              nombredato: 'Documento:',
              dato: _causante.nroSAP,
            ),
          ],
        ),
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _search -----------------------------------
  //-----------------------------------------------------------------

  Future<void> _search() async {
    FocusScope.of(context).unfocus();
    if (_codigo.isEmpty) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Ingrese un Legajo o Documento.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }
    await _getCausante();
  }

  //-----------------------------------------------------------------
  //--------------------- _getCausante ------------------------------
  //-----------------------------------------------------------------

  Future<void> _getCausante() async {
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
        message: 'Verifica que estes conectado a internet.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    Response response = await ApiHelper.getCausante(_codigo);

    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Legajo o Documento no válido',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );

      setState(() {
        _showLoader = false;
        _enabled = false;
      });
      return;
    }

    setState(() {
      _showLoader = false;
      _causante = response.result;
      _enabled = true;
    });

    await _getNovedades();
  }

  //-----------------------------------------------------------------
  //--------------------- _getNovedades -----------------------------
  //-----------------------------------------------------------------

  Future<void> _getNovedades() async {
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
        message: 'Verifica que estes conectado a internet.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    Response response2 = await ApiHelper.getNovedades(
      _causante.grupo,
      _causante.codigo.toString(),
    );

    if (!response2.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Legajo o Documento no válido',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );

      setState(() {
        _showLoader = false;
        _enabled = false;
      });
      return;
    }
    setState(() {
      _showLoader = false;
      _novedades = response2.result;
      _enabled = true;
    });

    for (var novedad in _novedades) {
      if (novedad.estado != 'Pendiente' && novedad.confirmaLeido != 1) {
        _novedadesSinLeer.add(novedad);
      }
    }
  }

  //-----------------------------------------------------------------
  //--------------------- _addNovedad -------------------------------
  //-----------------------------------------------------------------

  void _addNovedad() async {
    if (_novedadesSinLeer.isNotEmpty) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message:
            'No puede agregar nuevas novedades si tiene novedades aprobadas / rechazadas sin leer.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            NovedadAgregarScreen(user: widget.user, causante: _causante),
      ),
    );
    if (result == 'yes') {
      _getNovedades();
    }
  }

  //-----------------------------------------------------------------
  //--------------------- _grabarNovedad ----------------------------
  //-----------------------------------------------------------------

  void _grabarNovedad(Novedad novedad) async {
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

    Map<String, dynamic> request = {
      //'nroregistro': _ticket.nroregistro,
      'iDNOVEDAD': novedad.idnovedad,
    };

    Response response = await ApiHelper.put(
      '/api/CausantesNovedades/',
      novedad.idnovedad.toString(),
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
    // if (widget.user.codigoCausante != widget.user.login) {
    //   Navigator.pop(context, 'yes');
    // }
    await _getNovedades();
    _novedadesSinLeer = [];
    for (var novedad in _novedades) {
      if (novedad.estado != 'Pendiente' && novedad.confirmaLeido != 1) {
        _novedadesSinLeer.add(novedad);
      }
    }

    if (mounted) {
      setState(() {});
    }
  }
}
