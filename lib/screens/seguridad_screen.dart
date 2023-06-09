import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:camera/camera.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rowing_app/components/loader_component.dart';
import 'package:rowing_app/helpers/api_helper.dart';
import 'package:rowing_app/models/causante.dart';
import 'package:rowing_app/models/response.dart';
import 'package:rowing_app/screens/causante_datos_screen.dart';
import 'package:rowing_app/screens/entregas_screen.dart';
import 'package:rowing_app/widgets/widgets.dart';

import 'take_pictured.dart';

class SeguridadScreen extends StatefulWidget {
  const SeguridadScreen({Key? key}) : super(key: key);

  @override
  _SeguridadScreenState createState() => _SeguridadScreenState();
}

class _SeguridadScreenState extends State<SeguridadScreen> {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

  String _codigo = '';
  final String _codigoError = '';
  final bool _codigoShowError = false;
  bool _enabled = false;
  bool _showLoader = false;
  late Causante _causante;
  bool _photoChanged = false;
  late XFile _image;

//*****************************************************************************
//************************** INIT STATE ***************************************
//*****************************************************************************

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
        imageFullPath:
            'http://190.111.249.225/RowingAppApi/images/Causantes/nouser.png',
        image: null,
        direccion: '',
        numero: 0,
        telefonoContacto1: '',
        telefonoContacto2: '',
        telefonoContacto3: '',
        fecha: '',
        notasCausantes: '',
        ciudad: '',
        provincia: '');
  }

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF484848),
        appBar: AppBar(
          title: const Text("Seguridad e Higiene"),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  _showLogo(),
                  const SizedBox(
                    height: 20,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 15,
                    margin: const EdgeInsets.all(5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _showLegajo(),
                                _showButton(),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: FadeInImage(
                              placeholder:
                                  const AssetImage('assets/loading.gif'),
                              image: NetworkImage(_causante.imageFullPath!),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  _showInfo(),
                  const SizedBox(
                    height: 5,
                  ),
                  _showButtons(),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            _showLoader
                ? const LoaderComponent(
                    text: 'Por favor espere...',
                  )
                : Container(),
          ],
        ));
  }

//-----------------------------------------------------------------------------
//--------------------------- SHOWLOGO ----------------------------------------
//-----------------------------------------------------------------------------

  Widget _showLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Image.asset(
          "assets/seg1.png",
          width: 70,
          height: 70,
        ),
        Image.asset(
          "assets/logo.png",
          height: 70,
          width: 200,
        ),
        Image.asset(
          "assets/seg2.png",
          width: 70,
          height: 70,
        ),
      ],
    );
  }

//-----------------------------------------------------------------------------
//--------------------------- SHOWLEGAJO --------------------------------------
//-----------------------------------------------------------------------------
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

//-----------------------------------------------------------------------------
//--------------------------- SHOWBUTTON --------------------------------------
//-----------------------------------------------------------------------------
  Widget _showButton() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
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
                    width: 20,
                  ),
                  Text('Consultar'),
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

//-----------------------------------------------------------------------------
//--------------------------- SHOWINFO ----------------------------------------
//-----------------------------------------------------------------------------

  Widget _showInfo() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 15,
      margin: const EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
            CustomRow(
              icon: Icons.home,
              nombredato: 'Domicilio:',
              dato: _causante.direccion != ""
                  ? _causante.direccion.toString().replaceAll("  ", "")
                  : "" + _causante.numero.toString() != "0"
                      ? _causante.numero.toString().replaceAll("  ", "")
                      : "",

              // _causante.numero.toString() != 0
              //     ? _causante.numero.toString()
              //     : "",
            ),
            CustomRow(
              icon: Icons.numbers,
              nombredato: 'N°:',
              dato: _causante.numero != 0 ? _causante.numero.toString() : "",

              // _causante.numero.toString() != 0
              //     ? _causante.numero.toString()
              //     : "",
            ),
            CustomRow(
              icon: Icons.location_city,
              nombredato: 'Ciudad:',
              dato: _causante.ciudad,
            ),
            CustomRow(
              icon: Icons.south_america,
              nombredato: 'Provincia:',
              dato: _causante.provincia,
            ),
            CustomRow(
              icon: Icons.contact_phone,
              nombredato: 'Contacto:',
              dato: _causante.telefonoContacto3,
            ),
            CustomRow(
              nombredato: '',
              dato: _causante.telefonoContacto2 != ""
                  ? '(${_causante.telefonoContacto2})'
                  : "",
            ),
            CustomRow(
              nombredato: '',
              dato: _causante.telefonoContacto1,
            ),
            CustomRow(
              icon: Icons.calendar_month,
              nombredato: 'Fecha Ingreso:',
              dato: _causante.fecha != ""
                  ? DateFormat('dd/MM/yyyy')
                      .format(DateTime.parse(_causante.fecha.toString()))
                  : '',
            ),
            CustomRow(
              icon: Icons.abc,
              nombredato: 'CECO:',
              dato: _causante.notasCausantes,
            ),
          ],
        ),
      ),
    );
  }

//-----------------------------------------------------------------------------
//--------------------------- SHOWBUTTONS LOGO --------------------------------
//-----------------------------------------------------------------------------

  Widget _showButtons() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Icon(Icons.checkroom),
                      SizedBox(
                        width: 2,
                      ),
                      Text('Entr. por ítem'),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF120E43),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: _enabled ? _entregas : null,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Icon(Icons.list),
                      Text('Informes'),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFFB4161B),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: _enabled ? _informes : null,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Icon(Icons.person),
                      SizedBox(
                        width: 2,
                      ),
                      Text('Actual. Datos'),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 180, 38, 236),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: _enabled ? _causanteDatos : null,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Icon(Icons.image),
                      Text('Foto'),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 235, 58, 27),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: _enabled ? _takePicture : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

//-----------------------------------------------------------------------------
//--------------------------- SHOWSEARCH --------------------------------------
//-----------------------------------------------------------------------------

  _search() async {
    FocusScope.of(context).unfocus();
    if (_codigo.isEmpty) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Ingrese un Legajo o Documento.',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
    await _getCausante();
  }

//-----------------------------------------------------------------------------
//--------------------------- ENTREGAS ----------------------------------------
//-----------------------------------------------------------------------------

  void _entregas() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EntregasScreen(codigo: _causante.codigo)));
  }

//-----------------------------------------------------------------------------
//--------------------------- CAUSANTEDATOS -----------------------------------
//-----------------------------------------------------------------------------

  void _causanteDatos() async {
    String? response = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CausanteDatosScreen(causante: _causante)));

    if (response == 'yes') {
      _getCausante();
      setState(() {});
    }
  }

//-----------------------------------------------------------------------------
//--------------------------- INFORMES ----------------------------------------
//-----------------------------------------------------------------------------

  _informes() {}

//-----------------------------------------------------------------------------
//--------------------------- GETCAUSANTE -------------------------------------
//-----------------------------------------------------------------------------

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
          ]);
      return;
    }

    Response response = await ApiHelper.getCausante(_codigo);

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: "Legajo o Documento no válido",
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);

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
  }

//-----------------------------------------------------------------------------
//--------------------------- _takePicture ------------------------------------
//-----------------------------------------------------------------------------

  void _takePicture() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    var firstCamera = cameras.first;
    var response1 = await showAlertDialog(
        context: context,
        title: 'Origen de la Foto',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: 'no', label: 'Cámara Trasera'),
          const AlertDialogAction(key: 'yes', label: 'Cámara Delantera'),
          const AlertDialogAction(key: 'gal', label: 'Galería de Fotos'),
          const AlertDialogAction(key: 'cancel', label: 'Cancelar'),
        ]);
    if (response1 == 'yes') {
      firstCamera = cameras.first;
    }
    if (response1 == 'no') {
      firstCamera = cameras.last;
    }

    if (response1 == 'gal') {
      _selectPicture();

      return;
    }

    if (response1 != 'cancel') {
      String? response = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TakePictureDScreen(
                    camera: firstCamera,
                    causante: _causante,
                  )));
      if (response == 'yes') {
        _getCausante();
        setState(() {});
      }
    }
  }

//*****************************************************************************
//************************** METODO SELECTPICTURE *****************************
//*****************************************************************************

  void _selectPicture() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _photoChanged = true;
        _image = image;
        _saveRecord();
      });
    }
  }

//*****************************************************************************
//************************** _saveRecord ***********************************
//*****************************************************************************

  _saveRecord() async {
    String base64image = '';
    if (_photoChanged) {
      List<int> imageBytes = await _image.readAsBytes();
      base64image = base64Encode(imageBytes);
    }

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
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
      'id': _causante.nroCausante,
      'telefono': _causante.telefono,
      'direccion': _causante.direccion,
      'Numero': _causante.numero,
      'TelefonoContacto1': _causante.telefonoContacto1,
      'TelefonoContacto2': _causante.telefonoContacto2,
      'TelefonoContacto3': _causante.telefonoContacto3,
      'fecha': _causante.fecha,
      'NotasCausantes': _causante.notasCausantes,
      'ciudad': _causante.ciudad,
      'Provincia': _causante.provincia,
      'image': base64image,
    };

    Response response = await ApiHelper.put(
        '/api/Causantes/', _causante.nroCausante.toString(), request);

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
          message: 'Guardado con éxito!',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      _getCausante();
      setState(() {});
    }
  }
}
