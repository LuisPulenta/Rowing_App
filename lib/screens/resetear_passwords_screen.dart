import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rowing_app/components/loader_component.dart';
import 'package:http/http.dart' as http;
import 'package:rowing_app/helpers/api_helper.dart';
import 'package:rowing_app/helpers/constants.dart';
import 'package:rowing_app/models/models.dart';
import 'package:rowing_app/widgets/widgets.dart';

class ResetearPasswordsScreen extends StatefulWidget {
  final User user;
  const ResetearPasswordsScreen({Key? key, required this.user})
      : super(key: key);

  @override
  State<ResetearPasswordsScreen> createState() =>
      _ResetearPasswordsScreenState();
}

class _ResetearPasswordsScreenState extends State<ResetearPasswordsScreen> {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************
  String _codigo = '';
  final String _codigoError = '';
  final bool _codigoShowError = false;
  bool _enabled = false;
  bool _showLoader = false;

  bool _isRunning = false;

  User _user = User(
      idUsuario: 0,
      codigoCausante: '',
      login: '',
      contrasena: '',
      nombre: '',
      apellido: '',
      autorWOM: 0,
      estado: 0,
      habilitaAPP: 0,
      habilitaFotos: 0,
      habilitaReclamos: 0,
      habilitaSSHH: 0,
      habilitaRRHH: 0,
      modulo: '',
      habilitaMedidores: 0,
      habilitaFlotas: '',
      reHabilitaUsuarios: 0,
      codigogrupo: '',
      codigocausante: '',
      fullName: '',
      fechaCaduca: 0,
      intentosInvDiario: 0,
      opeAutorizo: 0,
      habilitaNuevoSuministro: 0,
      habilitaVeredas: 0,
      habilitaJuicios: 0,
      habilitaPresentismo: 0,
      firmaUsuario: '',
      firmaUsuarioImageFullPath: '');

  late User _userVacio;

//*****************************************************************************
//************************** INITSTATE *****************************************
//*****************************************************************************

  @override
  void initState() {
    super.initState();
    _userVacio = _user;
  }

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: const Text("Reactivar Usuario"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 0,
              ),
              _showLogo(),
              const SizedBox(
                height: 0,
              ),
              widget.user.habilitaRRHH == 1
                  ? Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 15,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 0),
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
                            const SizedBox(
                              height: 0,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              const SizedBox(
                height: 5,
              ),
              _showInfo(),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.password),
                      SizedBox(
                        width: 35,
                      ),
                      Text('Reactivar Usuario'),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF120E43),
                    minimumSize: const Size(100, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: _user.login == "" || _user.estado == 1
                      ? null
                      : _reactivarUsuario,
                ),
              ),
            ],
          ),
          _showLoader
              ? const LoaderComponent(
                  text: 'Por favor espere...',
                )
              : Container(),
        ],
      ),
      floatingActionButton: _enabled
          ? FloatingActionButton(
              child: const Icon(
                Icons.add,
                size: 38,
              ),
              backgroundColor: const Color(0xFF781f1e),
              onPressed: _enabled ? null : null,
            )
          : Container(),
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ METODO NOCONTENT -----------------------------
//-----------------------------------------------------------------------------

  Widget _noContent() {
    return Container(
      height: 200,
      width: 300,
      margin: const EdgeInsets.all(20),
      child: const Center(
        child: Text(
          'Este empleado no tiene novedades en los últimos 30 días.',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white),
        ),
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWLOGO ---------------------------
//-----------------------------------------------------------------

  Widget _showLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Image.asset(
          "assets/reset.png",
          width: 70,
          height: 70,
        ),
        Image.asset(
          "assets/logo.png",
          height: 70,
          width: 200,
        ),
        Transform.rotate(
          angle: 0,
          child: Image.asset(
            "assets/resetpassword.png",
            width: 70,
            height: 70,
          ),
        ),
      ],
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWLEGAJO -------------------------
//-----------------------------------------------------------------

  Widget _showLegajo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        decoration: InputDecoration(
          iconColor: const Color(0xFF781f1e),
          prefixIconColor: const Color(0xFF781f1e),
          hoverColor: const Color(0xFF781f1e),
          focusColor: const Color(0xFF781f1e),
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingrese LOGIN...',
          labelText: 'LOGIN',
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

//-----------------------------------------------------------------
//--------------------- METODO SHOWBUTTON -------------------------
//-----------------------------------------------------------------

  Widget _showButton() {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.search),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF781f1e),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () => _search(),
            ),
          ),
        ],
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWINFO ---------------------------
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
              nombredato: 'Usuario:',
              dato: _user.fullName,
            ),
            CustomRow(
              icon: Icons.phone,
              nombredato: 'Código:',
              dato: _user.codigoCausante,
            ),
            _user.estado == 0
                ? CustomRow(
                    icon: Icons.password,
                    nombredato: 'Password:',
                    dato: _user.contrasena,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SEARCH -----------------------------
//-----------------------------------------------------------------

  _search() async {
    FocusScope.of(context).unfocus();
    if (_codigo.isEmpty) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Ingrese LOGIN.',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
    await _getUsuario();
  }

//-----------------------------------------------------------------
//--------------------- METODO _getUsuario ------------------------
//-----------------------------------------------------------------

  Future<void> _getUsuario() async {
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
          ]);
      return;
    }

    Map<String, dynamic> request = {
      'Email': _codigo,
      'password': '123456',
    };

    var url = Uri.parse('${Constants.apiUrl}/Api/Account/GetUserByLogin');
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
        _user = _userVacio;
      });
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'LOGIN no válido.',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    var body = response.body;
    var decodedJson = jsonDecode(body);
    _user = User.fromJson(decodedJson);

    if (_user.estado == 1) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Este Usuario está Activo',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    setState(() {
      _showLoader = false;
    });
  }

//-----------------------------------------------------------------
//--------------------- METODO _reactivarUsuario ------------------
//-----------------------------------------------------------------

  Future<void> _reactivarUsuario() async {
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
          ]);
      return;
    }

    Map<String, dynamic> request = {
      'Login': _codigo,
      'IdUsuarioAutoriza': widget.user.idUsuario,
      'FechaCaduca':
          DateTime.now().difference(DateTime(2022, 01, 01)).inDays + 80723 + 70,
      //Calculo dif entre hoy y el 1 de Enero de 2022 que es el 80723 y le sump el 80723 y 70 días más
    };

    Response response =
        await ApiHelper.put('/api/Account/', _codigo.toString(), request);

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
      await showAlertDialog(
          context: context,
          title: 'Aviso',
          message: 'Usuario reactivado con éxito!',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      Navigator.pop(context, 'yes');
    }
  }
}
