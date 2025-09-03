import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';

class ReactivarLegajoScreen extends StatefulWidget {
  final User user;
  const ReactivarLegajoScreen({super.key, required this.user});

  @override
  State<ReactivarLegajoScreen> createState() => _ReactivarLegajoScreenState();
}

class _ReactivarLegajoScreenState extends State<ReactivarLegajoScreen> {
  //---------------------------------------------------------------
  //----------------------- Variables -----------------------------
  //---------------------------------------------------------------
  List<Grupo> _grupos = [];
  bool _isloading = false;
  String _grupo = 'Elija un Grupo...';
  final String _grupoError = '';
  final bool _grupoShowError = false;
  bool bandera = false;
  int intentos = 0;

  String _codigo = '';
  final String _codigoError = '';
  final bool _codigoShowError = false;
  final bool _enabled = false;
  bool _showLoader = false;

  Causante _causante = Causante(
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

  late Causante _causanteVacio;

  //---------------------------------------------------------------
  //----------------------- initState -----------------------------
  //---------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _causanteVacio = _causante;
    _loadData();
  }

  //---------------------------------------------------------------
  //----------------------- Pantalla ------------------------------
  //---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 195, 191, 191),
      appBar: AppBar(title: const Text('Reactivar Legajo'), centerTitle: true),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 10),
              _showGrupos(),
              const SizedBox(height: 10),
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
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF120E43),
                    minimumSize: const Size(100, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: _causante.estado == 1 ? null : _reactivarLegajo,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.password),
                      SizedBox(width: 35),
                      Text('Reactivar Legajo'),
                    ],
                  ),
                ),
              ),
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
              onPressed: _enabled ? null : null,
              child: const Icon(Icons.add, size: 38),
            )
          : Container(),
    );
  }

  //--------------------------------------------------------
  //--------------------- _showGrupos ----------------------
  //--------------------------------------------------------

  Widget _showGrupos() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
      child: _isloading
          ? Row(
              children: const [
                CircularProgressIndicator(),
                SizedBox(width: 10),
                Text('Cargando Grupos...'),
              ],
            )
          : _grupos.isEmpty
          ? Row(
              children: const [
                Text(
                  'No hay Grupos',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ],
            )
          : DropdownButtonFormField(
              initialValue: _grupo,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Elija un Grupo...',
                labelText: 'Grupo',
                errorText: _grupoShowError ? _grupoError : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: _getComboGrupos(),
              onChanged: (value) {
                _grupo = value.toString();
              },
            ),
    );
  }

  //--------------------- _getComboGrupos ---------

  List<DropdownMenuItem<String>> _getComboGrupos() {
    List<DropdownMenuItem<String>> list = [];
    list.add(
      const DropdownMenuItem(
        value: 'Elija un Grupo...',
        child: Text('Elija un Grupo...'),
      ),
    );

    for (var grupo in _grupos) {
      list.add(
        DropdownMenuItem(
          value: grupo.codigo.toString(),
          child: Text(
            '${grupo.codigo.toString()}-${grupo.detalle.toString().trim()}',
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
      );
    }

    return list;
  }

  //--------------------- _loadData ------------------------
  void _loadData() async {
    await _getGrupos();
  }

  //--------------------- _getGrupos ------------

  Future<void> _getGrupos() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      showMyDialog(
        'Error',
        'Verifica que estés conectado a Internet',
        'Aceptar',
      );
      return;
    }

    _isloading = true;
    setState(() {});
    bandera = false;
    intentos = 0;

    do {
      Response response = Response(isSuccess: false);
      response = await ApiHelper.getGrupos();
      intentos++;
      if (response.isSuccess) {
        bandera = true;
        _grupos = response.result;
      }
    } while (bandera == false);

    _isloading = false;
    setState(() {});
  }

  //-----------------------------------------------------------
  //--------------------- _showLegajo -------------------------
  //-----------------------------------------------------------

  Widget _showLegajo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        //keyboardType: TextInputType.number,
        decoration: InputDecoration(
          iconColor: const Color(0xFF781f1e),
          prefixIconColor: const Color(0xFF781f1e),
          hoverColor: const Color(0xFF781f1e),
          focusColor: const Color(0xFF781f1e),
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingrese Código...',
          labelText: 'Código',
          errorText: _codigoShowError ? _codigoError : null,
          prefixIcon: const Icon(Icons.person),
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

  //-----------------------------------------------------------
  //--------------------- _showButton -------------------------
  //-----------------------------------------------------------

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

  //-----------------------------------------------------------
  //--------------------- _showInfo ---------------------------
  //-----------------------------------------------------------

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
              nombredato: 'Usuario:',
              dato: _causante.nombre,
            ),
            CustomRow(
              icon: Icons.code_rounded,
              nombredato: 'Código:',
              dato: _causante.codigo,
            ),
          ],
        ),
      ),
    );
  }

  //-----------------------------------------------------------
  //--------------------- _search -----------------------------
  //-----------------------------------------------------------

  Future<void> _search() async {
    FocusScope.of(context).unfocus();
    if (_codigo.isEmpty) {
      showMyDialog('Error', 'Ingrese Código.', 'Aceptar');

      return;
    }
    await _getCausante();
  }

  //----------------------------------------------------------
  //--------------------- _getCausante -----------------------
  //----------------------------------------------------------

  Future<void> _getCausante() async {
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
        'Verifica que estes conectado a internet.',
        'Aceptar',
      );

      return;
    }

    Map<String, dynamic> request = {'Codigo': _codigo, 'Grupo': _grupo};

    var url = Uri.parse(
      '${Constants.apiUrl}/Api/Causantes/GetCausanteByGrupoAndByCodigo',
    );
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(request),
    );

    if (response.statusCode >= 400) {
      setState(() {
        _showLoader = false;
        _causante = _causanteVacio;
      });

      showMyDialog('Error', 'Código no válido.', 'Aceptar');

      return;
    }

    var body = response.body;
    var decodedJson = jsonDecode(body);
    _causante = Causante.fromJson(decodedJson);

    if (_causante.estado == 1) {
      setState(() {
        _showLoader = false;
      });

      showMyDialog('Error', 'Este Usuario está Activo', 'Aceptar');

      return;
    }

    setState(() {
      _showLoader = false;
    });
  }

  //----------------------------------------------------------
  //--------------------- _reactivarLegajo ------------------
  //----------------------------------------------------------

  Future<void> _reactivarLegajo() async {
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
        'Verifica que estes conectado a internet.',
        'Aceptar',
      );

      return;
    }

    if (_grupo == 'Elija un Grupo...') {
      showMyDialog('Error', 'Debe seleccionar un Grupo.', 'Aceptar');
      setState(() {
        _showLoader = false;
      });
      return;
    }

    if (_codigo == '') {
      showMyDialog('Error', 'Debe poner un Código.', 'Aceptar');
      setState(() {
        _showLoader = false;
      });
      return;
    }

    Map<String, dynamic> request = {'Codigo': _codigo, 'Grupo': _grupo};

    Response response = await ApiHelper.put(
      '/api/Causantes/ReactivarLegajo/',
      _codigo.toString(),
      request,
    );

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      showMyDialog('Error', response.message, 'Aceptar');
      return;
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text('Aviso'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Text('Legajo reactivado con éxito!'),
                SizedBox(height: 10),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );

      Navigator.pop(context, 'yes');
    }
  }
}
