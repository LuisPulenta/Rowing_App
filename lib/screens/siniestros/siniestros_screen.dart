import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class SiniestrosScreen extends StatefulWidget {
  final User user;
  const SiniestrosScreen({super.key, required this.user});

  @override
  _SiniestrosScreenState createState() => _SiniestrosScreenState();
}

class _SiniestrosScreenState extends State<SiniestrosScreen> {
  //---------------------------------------------------------------
  //----------------------- Variables -----------------------------
  //---------------------------------------------------------------

  String _codigo = '';
  final String _codigoError = '';
  final bool _codigoShowError = false;
  bool _enabled = false;
  bool _showLoader = false;

  late Causante _causante;
  List<VehiculosSiniestro> _siniestros = [];

  VehiculosSiniestro siniestroSelected = VehiculosSiniestro(
    nrosiniestro: 0,
    fechacarga: '',
    grupo: '',
    causante: '',
    apellidonombretercero: '',
    nropolizatercero: '',
    telefonocontactotercero: '',
    emailtercero: '',
    notificadoempresa: '',
    notificadoa: '',
    direccionsiniestro: '',
    altura: '',
    ciudad: '',
    provincia: '',
    horasiniestro: 0,
    lesionados: '',
    cantidadlesionados: 0,
    intervinopolicia: '',
    intervinoambulancia: '',
    relatosiniestro: '',
    numcha: '',
    companiasegurotercero: '',
    idusuariocarga: 0,
    detalledanospropio: '',
    detalledanostercero: '',
    numchatercero: '',
    fechacargaapp: '',
    tipoDeSiniestro: '',
  );

  //---------------------------------------------------------------
  //----------------------- initState -----------------------------
  //---------------------------------------------------------------

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

    if (widget.user.habilitaSSHH != 1) {
      _codigo = widget.user.codigoCausante;
      _getCausante();
    }
  }

  //---------------------------------------------------------------
  //----------------------- Pantalla ------------------------------
  //---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: Text(
          widget.user.habilitaSSHH == 0 ? 'Mis Siniestros' : 'Siniestros',
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
              widget.user.habilitaSSHH == 1
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
                  ? _siniestros.isEmpty
                        ? Container()
                        : Row(
                            children: [
                              const SizedBox(width: 5),
                              const Text(
                                'Cant. Siniestros: ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _siniestros.length.toString(),
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
                    ? _siniestros.isEmpty
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _enabled
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF781f1e),
              onPressed: _enabled ? _addSiniestro : null,
              child: const Icon(Icons.add, size: 38),
            )
          : Container(),
    );
  }

  //---------------------------------------------------------------------
  //------------------------------ _noContent ---------------------------
  //---------------------------------------------------------------------

  Widget _noContent() {
    return Container(
      height: 200,
      width: 300,
      margin: const EdgeInsets.all(20),
      child: const Center(
        child: Text(
          'Este empleado no tiene Siniestros en los últimos 30 días.',
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
      physics: const BouncingScrollPhysics(),
      children: _siniestros.map((e) {
        return Card(
          color: Colors.white,
          //color: Color(0xFFC7C7C8),
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
                                    width: 100,
                                    child: Text(
                                      'Fecha: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF0e4888),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      DateFormat('dd/MM/yyyy').format(
                                        DateTime.parse(e.fechacarga.toString()),
                                      ),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 40,
                                    child: Text(
                                      'Hora: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF0e4888),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      _horaMinuto(e.horasiniestro),
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
                                      'Patente: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF0e4888),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      e.numcha,
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
                                      'Tercero: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF0e4888),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      e.apellidonombretercero,
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
                                      'Dirección: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF0e4888),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${e.direccionsiniestro} ${e.altura}',
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
                                      'Ciudad: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF0e4888),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      e.ciudad,
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
                                      'Provincia: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF0e4888),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      e.provincia,
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
                                      'Notificó: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF0e4888),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      e.notificadoempresa,
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
                                      'Notificado a: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF0e4888),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      e.notificadoa,
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
                                      'Tipo Siniestro: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF0e4888),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  e.tipoDeSiniestro != null
                                      ? Expanded(
                                          child: Text(
                                            e.tipoDeSiniestro!,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        )
                                      : const Expanded(
                                          child: Text(
                                            '',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                ],
                              ),
                              const SizedBox(height: 1),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    DateTime.parse(
                          e.fechacargaapp,
                        ).isAfter(DateTime.now().add(const Duration(days: -2)))
                        ? IconButton(
                            icon: const CircleAvatar(
                              backgroundColor: Color(0xFF781f1e),
                              child: Icon(
                                Icons.edit,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              siniestroSelected = e;
                              String? result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SiniestroEditarScreen(
                                    user: widget.user,
                                    siniestro: e,
                                  ),
                                ),
                              );

                              if (result == 'yes') {
                                _getSiniestros();
                              }
                            },
                          )
                        : Container(),
                    DateTime.parse(
                          e.fechacargaapp,
                        ).isAfter(DateTime.now().add(const Duration(days: -2)))
                        ? const SizedBox(height: 20)
                        : Container(),
                    IconButton(
                      icon: const CircleAvatar(
                        backgroundColor: Color(0xFF781f1e),
                        child: Icon(
                          Icons.camera_alt,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        siniestroSelected = e;
                        _goInfoSiniestro(e);
                      },
                    ),
                  ],
                ),
              ],
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
        Image.asset('assets/danger.png', width: 70, height: 70),
        getImage(user: widget.user, height: 70, width: 200),
        // Image.asset(
        //   "assets/logo.png",
        //   height: 70,
        //   width: 200,
        // ),
        Transform.rotate(
          angle: 0,
          child: Image.asset('assets/danger.png', width: 70, height: 70),
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

    await _getSiniestros();
  }

  //-----------------------------------------------------------------
  //--------------------- _getSiniestros ----------------------------
  //-----------------------------------------------------------------

  Future<void> _getSiniestros() async {
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

    Response response2 = await ApiHelper.getSiniestros(
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
      _siniestros = response2.result;
      _enabled = true;
    });
  }

  //-----------------------------------------------------------------
  //--------------------- _addSiniestro -----------------------------
  //-----------------------------------------------------------------

  void _addSiniestro() async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SiniestroAgregarScreen(user: widget.user, causante: _causante),
      ),
    );
    if (result == 'yes') {
      _getSiniestros();
    }
  }

  //-----------------------------------------------------------------
  //--------------------- _horaMinuto -------------------------------
  //-----------------------------------------------------------------

  String _horaMinuto(int valor) {
    String hora = (valor / 3600).floor().toString();
    String minutos = ((valor - ((valor / 3600).floor()) * 3600) / 60)
        .round()
        .toString();

    if (minutos.length == 1) {
      minutos = '0$minutos';
    }
    return '$hora:$minutos';
  }

  //-----------------------------------------------------------------
  //--------------------- _goInfoSiniestro --------------------------
  //-----------------------------------------------------------------

  void _goInfoSiniestro(VehiculosSiniestro siniestro) async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SiniestroInfoScreen(user: widget.user, siniestro: siniestro),
      ),
    );
  }
}
