import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:rowing_app/components/loader_component.dart';
import 'package:rowing_app/helpers/api_helper.dart';
import 'package:rowing_app/models/models.dart';

class CausanteDatosScreen extends StatefulWidget {
  final Causante causante;

  const CausanteDatosScreen({required this.causante});

  @override
  State<CausanteDatosScreen> createState() => _CausanteDatosScreenState();
}

class _CausanteDatosScreenState extends State<CausanteDatosScreen> {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

  bool _showLoader = false;

  String _phoneNumber = '';
  String _phoneNumberError = '';
  bool _phoneNumberShowError = false;
  TextEditingController _phoneNumberController = TextEditingController();

//*****************************************************************************
//************************** INIT STATE ***************************************
//*****************************************************************************

  void initState() {
    super.initState();
    _phoneNumber =
        (widget.causante.telefono != null ? widget.causante.telefono : '')!;

    _phoneNumber = _phoneNumber.replaceAll(" ", "");

    _phoneNumberController.text =
        (widget.causante.telefono != null ? widget.causante.telefono : '')!;

    _phoneNumberController.text =
        _phoneNumberController.text.replaceAll(" ", "");
    setState(() {});
  }

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 192, 190, 190),
      appBar: AppBar(
        title: Text('Datos de ' + widget.causante.nombre,
            style: TextStyle(fontSize: 14)),
        centerTitle: true,
        backgroundColor: Color(0xFF484848),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                _showPhoneNumber(),
                _showButtons(),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
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

//*****************************************************************************
//************************** _showPhoneNumber *********************************
//*****************************************************************************

  Widget _showPhoneNumber() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _phoneNumberController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Ingresa Teléfono...',
            labelText: 'Teléfono',
            errorText: _phoneNumberShowError ? _phoneNumberError : null,
            suffixIcon: Icon(Icons.phone),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _phoneNumber = value;
        },
      ),
    );
  }

//*****************************************************************************
//************************** _showButtons *************************************
//*****************************************************************************

  Widget _showButtons() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save),
                  SizedBox(
                    width: 15,
                  ),
                  Text('Guardar'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF120E43),
                minimumSize: Size(100, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () => _save(),
            ),
          ),
        ],
      ),
    );
  }

//*****************************************************************************
//************************** _save ********************************************
//*****************************************************************************

  void _save() {
    if (!validateFields()) {
      return;
    }
    _saveRecord();
  }

//*****************************************************************************
//************************** validateFields ***********************************
//*****************************************************************************

  bool validateFields() {
    bool isValid = true;

    if (_phoneNumber.isEmpty) {
      isValid = false;
      _phoneNumberShowError = true;
      _phoneNumberError = 'Debes ingresar un teléfono';
    } else {
      _phoneNumberShowError = false;
    }

    setState(() {});

    return isValid;
  }

//*****************************************************************************
//************************** _saveRecord ***********************************
//*****************************************************************************

  _saveRecord() async {
    FocusScope.of(context).unfocus();
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
      'id': widget.causante.nroCausante,
      'telefono': _phoneNumber,
    };

    Response response = await ApiHelper.put(
        '/api/Causantes/', widget.causante.nroCausante.toString(), request);

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
      await showAlertDialog(
          context: context,
          title: 'Aviso',
          message: 'Guardado con éxito!',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      Navigator.pop(context, 'yes');
    }
  }
}
