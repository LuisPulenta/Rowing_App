import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:rowing_app/components/loader_component.dart';
import 'package:rowing_app/helpers/api_helper.dart';
import 'package:rowing_app/models/causante.dart';
import 'package:rowing_app/models/response.dart';
import 'package:rowing_app/models/user.dart';

class SiniestroAgregarScreen extends StatefulWidget {
  final User user;
  final Causante causante;
  const SiniestroAgregarScreen(
      {Key? key, required this.user, required this.causante})
      : super(key: key);

  @override
  _SiniestroAgregarScreenState createState() => _SiniestroAgregarScreenState();
}

class _SiniestroAgregarScreenState extends State<SiniestroAgregarScreen> {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

  bool _showLoader = false;
  bool bandera = false;
  int intentos = 0;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  bool _huboLesionados = false;

  String _numlesionados = '';
  String _numlesionadosError = '';
  bool _numlesionadosShowError = false;
  TextEditingController _numlesionadosController = TextEditingController();

  bool _intervinoPolicia = false;
  bool _intervinoAmbulancia = false;

  //DateTime? fechaNovedad = null;

  String _observaciones = '';
  String _observacionesError = '';
  bool _observacionesShowError = false;
  TextEditingController _observacionesController = TextEditingController();

  String _numcha = '';
  String _numchaError = '';
  bool _numchaShowError = false;
  TextEditingController _numchaController = TextEditingController();

  String _calle = '';
  String _calleError = '';
  bool _calleShowError = false;
  TextEditingController _calleController = TextEditingController();

  String _numero = '';
  String _numeroError = '';
  bool _numeroShowError = false;
  TextEditingController _numeroController = TextEditingController();

  String _ciudad = '';
  String _ciudadError = '';
  bool _ciudadShowError = false;
  TextEditingController _ciudadController = TextEditingController();

  String _provincia = '';
  String _provinciaError = '';
  bool _provinciaShowError = false;
  TextEditingController _provinciaController = TextEditingController();

  String _tercero = '';
  String _terceroError = '';
  bool _terceroShowError = false;
  TextEditingController _terceroController = TextEditingController();

  String _companiaseguro = '';
  String _companiaseguroError = '';
  bool _companiaseguroShowError = false;
  TextEditingController _companiaseguroController = TextEditingController();

  String _nropoliza = '';
  String _nropolizaError = '';
  bool _nropolizaShowError = false;
  TextEditingController _nropolizaController = TextEditingController();

  String _telefonotercero = '';
  String _telefonoterceroError = '';
  bool _telefonoterceroShowError = false;
  TextEditingController _telefonoterceroController = TextEditingController();

  String _emailtercero = '';
  String _emailterceroError = '';
  bool _emailterceroShowError = false;
  TextEditingController _emailterceroController = TextEditingController();

//*****************************************************************************
//************************** INIT STATE ***************************************
//*****************************************************************************

  @override
  void initState() {
    super.initState();
  }

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Agregar Nuevo Siniestro'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 1,
                ),
                _showFecha(),
                const SizedBox(
                  height: 5,
                ),
                _showNumcha(),
                const Divider(
                  height: 5,
                  thickness: 2,
                  color: Color(0xFF781f1e),
                ),
                _showCalle(),
                _showNumero(),
                _showCiudad(),
                _showProvincia(),
                const Divider(
                  height: 5,
                  thickness: 2,
                  color: Color(0xFF781f1e),
                ),
                _showTercero(),
                _showTelefonoTercero(),
                _showEmailTercero(),
                _showCompaniaSeguro(),
                _showNroPoliza(),
                const Divider(
                  height: 5,
                  thickness: 2,
                  color: Color(0xFF781f1e),
                ),
                _showLesionados(),
                _showPolicia(),
                _showAmbulancia(),
                _showObservaciones(),
                const SizedBox(
                  height: 5,
                ),
                _showButton(),
                const SizedBox(
                  height: 10,
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
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO _showNumcha ------------------------
//-----------------------------------------------------------------

  Widget _showNumcha() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: TextField(
        controller: _numchaController,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Patente',
            labelText: 'Patente',
            errorText: _numchaShowError ? _numchaError : null,
            suffixIcon: const Icon(Icons.abc),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _numcha = value;
        },
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO _showCalle -------------------------
//-----------------------------------------------------------------

  Widget _showCalle() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 4),
      child: TextField(
        controller: _calleController,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Calle',
            labelText: 'Calle',
            errorText: _calleShowError ? _calleError : null,
            suffixIcon: const Icon(Icons.place),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _calle = value;
        },
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO _showNumero ------------------------
//-----------------------------------------------------------------

  Widget _showNumero() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: TextField(
        controller: _numeroController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'N°',
            labelText: 'N°',
            errorText: _numeroShowError ? _numeroError : null,
            suffixIcon: const Icon(Icons.pin),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _numero = value;
        },
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO _showCiudad ------------------------
//-----------------------------------------------------------------

  Widget _showCiudad() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: TextField(
        controller: _ciudadController,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Ciudad',
            labelText: 'Ciudad',
            errorText: _ciudadShowError ? _ciudadError : null,
            suffixIcon: const Icon(Icons.apartment),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _ciudad = value;
        },
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO _showProvincia ---------------------
//-----------------------------------------------------------------

  Widget _showProvincia() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: TextField(
        controller: _provinciaController,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Provincia',
            labelText: 'Provincia',
            errorText: _provinciaShowError ? _provinciaError : null,
            suffixIcon: const Icon(Icons.public),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _provincia = value;
        },
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO _showTercero -----------------------
//-----------------------------------------------------------------

  Widget _showTercero() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 4),
      child: TextField(
        controller: _terceroController,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Nombre y Apellido del Tercero',
            labelText: 'Nombre y Apellido del Tercero',
            errorText: _terceroShowError ? _terceroError : null,
            suffixIcon: const Icon(Icons.person),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _tercero = value;
        },
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO _showTelefonoTercero ---------------
//-----------------------------------------------------------------

  Widget _showTelefonoTercero() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: TextField(
        controller: _telefonoterceroController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Teléfono',
            labelText: 'Teléfono',
            errorText: _telefonoterceroShowError ? _telefonoterceroError : null,
            suffixIcon: const Icon(Icons.phone),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _telefonotercero = value;
        },
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO _showEmailTercero ------------------
//-----------------------------------------------------------------

  Widget _showEmailTercero() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: TextField(
        controller: _emailterceroController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Mail',
            labelText: 'Mail',
            errorText: _emailterceroShowError ? _emailterceroError : null,
            suffixIcon: const Icon(Icons.mail),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _emailtercero = value;
        },
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO _showCompaniaSeguro ----------------
//-----------------------------------------------------------------

  Widget _showCompaniaSeguro() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: TextField(
        controller: _companiaseguroController,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Compañía de Seguros',
            labelText: 'Compañía de Seguros',
            errorText: _companiaseguroShowError ? _companiaseguroError : null,
            suffixIcon: const Icon(Icons.factory),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _companiaseguro = value;
        },
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO _showNroPoliza ---------------------
//-----------------------------------------------------------------

  Widget _showNroPoliza() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: TextField(
        controller: _nropolizaController,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'N° de Póliza',
            labelText: 'N° de Póliza',
            errorText: _nropolizaShowError ? _nropolizaError : null,
            suffixIcon: const Icon(Icons.tag),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _nropoliza = value;
        },
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO _showLesionados --------------------
//-----------------------------------------------------------------

  Widget _showLesionados() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 10),
      child: Row(
        children: [
          const SizedBox(
            width: 160,
            child: Text("Hubo lesionados: ",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                )),
          ),
          Checkbox(
            value: _huboLesionados,
            onChanged: (value) {
              _huboLesionados = !_huboLesionados;
              value = _huboLesionados;
              setState(() {});
            },
            checkColor: Colors.white,
            materialTapTargetSize: MaterialTapTargetSize.padded,
            activeColor: const Color(0xFF781f1e),
          ),
          _huboLesionados
              ? SizedBox(
                  width: 160,
                  child: TextField(
                    controller: _numlesionadosController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'N° Lesion.',
                        labelText: 'N° Lesion.',
                        errorText: _numlesionadosShowError
                            ? _numlesionadosError
                            : null,
                        suffixIcon: const Icon(Icons.tag),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onChanged: (value) {
                      _numlesionados = value;
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO _showPolicia -----------------------
//-----------------------------------------------------------------

  Widget _showPolicia() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Row(
        children: [
          const SizedBox(
            width: 160,
            child: Text("Intervino la Policía: ",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                )),
          ),
          Checkbox(
            value: _intervinoPolicia,
            onChanged: (value) {
              _intervinoPolicia = !_intervinoPolicia;
              value = _intervinoPolicia;
              setState(() {});
            },
            checkColor: Colors.white,
            materialTapTargetSize: MaterialTapTargetSize.padded,
            activeColor: const Color(0xFF781f1e),
          ),
        ],
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO _showAmbulancia -----------------------
//-----------------------------------------------------------------

  Widget _showAmbulancia() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Row(
        children: [
          const SizedBox(
            width: 160,
            child: Text("Intervino Ambulancia: ",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                )),
          ),
          Checkbox(
            value: _intervinoAmbulancia,
            onChanged: (value) {
              _intervinoAmbulancia = !_intervinoAmbulancia;
              value = _intervinoAmbulancia;
              setState(() {});
            },
            checkColor: Colors.white,
            materialTapTargetSize: MaterialTapTargetSize.padded,
            activeColor: const Color(0xFF781f1e),
          ),
        ],
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWOBSERVACIONES ------------------
//-----------------------------------------------------------------

  Widget _showObservaciones() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: TextField(
        controller: _observacionesController,
        maxLines: 3,
        decoration: InputDecoration(
            hintText: 'Relato del Siniestro',
            labelText: 'Relato del Siniestro',
            errorText: _observacionesShowError ? _observacionesError : null,
            suffixIcon: const Icon(Icons.notes),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _observaciones = value;
        },
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWFECHA --------------------------
//-----------------------------------------------------------------

  Widget _showFecha() {
    return Stack(
      children: <Widget>[
        Container(
          height: 80,
        ),
        Positioned(
          bottom: 0,
          left: 20,
          child: Row(
            children: [
              const Icon(Icons.calendar_today),
              const SizedBox(
                width: 20,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: InkWell(
                        child: Text(
                            "    ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
                      ),
                    ),
                  ],
                ),
                width: 110,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: Colors.black, width: 1.0),
                ),
              ),
              const SizedBox(
                width: 40,
              ),
              const Icon(Icons.schedule),
              const SizedBox(
                width: 20,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _selectTime(context);
                      },
                      child: InkWell(
                        child: Text(
                            "        ${selectedTime.hour}:${selectedTime.minute}"),
                      ),
                    ),
                  ],
                ),
                width: 110,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: Colors.black, width: 1.0),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 70,
          bottom: 40,
          child: Container(
              color: Colors.white,
              child: const Text(
                ' Fecha: ',
                style: TextStyle(fontSize: 12),
              )),
        ),
        Positioned(
          left: 264,
          bottom: 40,
          child: Container(
              color: Colors.white,
              child: const Text(
                ' Hora: ',
                style: TextStyle(fontSize: 12),
              )),
        )
      ],
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2023),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? selected = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (selected != null && selected != selectedTime) {
      setState(() {
        selectedTime = selected;
      });
    }
  }

//-----------------------------------------------------------------
//--------------------- METODO SHOWBUTTON -------------------------
//-----------------------------------------------------------------

  Widget _showButton() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.save),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Guardar siniestro'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF781f1e),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: _save,
            ),
          ),
        ],
      ),
    );
  }

//*****************************************************************************
//************************** METODO SAVE **************************************
//*****************************************************************************

  _save() {
    if (!validateFields()) {
      setState(() {});
      return;
    }
    _addRecord();
  }

//*****************************************************************************
//************************** METODO VALIDATEFIELDS ****************************
//*****************************************************************************

  bool validateFields() {
    bool isValid = true;

    if (_numcha.isEmpty) {
      isValid = false;
      _numchaShowError = true;
      _numchaError = 'Debe ingresar una Patente';
    } else {
      _numchaShowError = false;
    }

    if (_calle.isEmpty) {
      isValid = false;
      _calleShowError = true;
      _calleError = 'Debe ingresar una Calle';
    } else {
      _calleShowError = false;
    }

    if (_numero.isEmpty) {
      isValid = false;
      _numeroShowError = true;
      _numeroError = 'Debe ingresar un N°';
    } else {
      _numeroShowError = false;
    }

    if (_ciudad.isEmpty) {
      isValid = false;
      _ciudadShowError = true;
      _ciudadError = 'Debe ingresar una Ciudad';
    } else {
      _ciudadShowError = false;
    }

    if (_provincia.isEmpty) {
      isValid = false;
      _provinciaShowError = true;
      _provinciaError = 'Debe ingresar una Provincia';
    } else {
      _provinciaShowError = false;
    }

    if (_tercero.isEmpty) {
      isValid = false;
      _terceroShowError = true;
      _terceroError = 'Debe ingresar Nombre y Apellido del tercero';
    } else {
      _terceroShowError = false;
    }

    if (_telefonotercero.isEmpty) {
      isValid = false;
      _telefonoterceroShowError = true;
      _telefonoterceroError = 'Debe ingresar un Teléfono';
    } else {
      _telefonoterceroShowError = false;
    }

    if (_emailtercero.isEmpty) {
      isValid = false;
      _emailterceroShowError = true;
      _emailterceroError = 'Debe ingresar Mail del tercero';
    } else {
      _emailterceroShowError = false;
    }

    if (_companiaseguro.isEmpty) {
      isValid = false;
      _companiaseguroShowError = true;
      _companiaseguroError = 'Debe ingresar Compañía de Seguros';
    } else {
      _companiaseguroShowError = false;
    }

    if (_nropoliza.isEmpty) {
      isValid = false;
      _nropolizaShowError = true;
      _nropolizaError = 'Debe ingresar N° de Póliza';
    } else {
      _nropolizaShowError = false;
    }

    if (_huboLesionados && (_numlesionados.isEmpty || _numlesionados == "0")) {
      isValid = false;
      _numlesionadosShowError = true;
      _numlesionadosError = 'Ingrese N° Lesion.';
    } else {
      _numlesionadosShowError = false;
    }

    if (_observaciones.isEmpty) {
      isValid = false;
      _observacionesShowError = true;
      _observacionesError = 'Debe ingresar Relato del Siniestro';
    } else {
      _observacionesShowError = false;
    }

    setState(() {});

    return isValid;
  }

//*****************************************************************************
//************************** METODO ADDRECORD *********************************
//*****************************************************************************

  void _addRecord() async {
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
      //'nroregistro': _ticket.nroregistro,
      'fechacarga': selectedDate.toString(),
      'grupo': widget.causante.grupo,
      'causante': widget.causante.codigo,
      'apellidonombretercero': PLMayusc(_tercero),
      'nropolizatercero': _nropoliza,
      'telefonocontactotercero': _telefonotercero,
      'emailtercero': _emailtercero,
      'notificadoempresa': "NO",
      'notificadoa': "",
      'direccionsiniestro': PLMayusc(_calle),
      'altura': _numero,
      'ciudad': PLMayusc(_ciudad),
      'provincia': PLMayusc(_provincia),
      'horasiniestro': selectedTime.hour * 3600 + selectedTime.minute * 60,
      'lesionados': _huboLesionados ? "SI" : "NO",
      'cantidadlesionados': _huboLesionados ? _numlesionados : 0,
      'intervinopolicia': _intervinoPolicia ? "SI" : "NO",
      'intervinoambulancia': _intervinoAmbulancia ? "SI" : "NO",
      'relatosiniestro': _observaciones,
      'numcha': _numcha.toUpperCase(),
      'companiasegurotercero': PLMayusc(_companiaseguro),
      'idUsuarioCarga': widget.user.idUsuario,
    };

    Response response = await ApiHelper.postNoToken(
        '/api/VehiculosSiniestros/PostSiniestros', request);

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
    }
    Navigator.pop(context, 'yes');
  }

//*****************************************************************************
//************************** METODO ADDRPLMayusc ******************************
//*****************************************************************************

  String PLMayusc(String string) {
    String name = '';
    bool isSpace = false;
    String letter = '';
    for (int i = 0; i < string.length; i++) {
      if (isSpace || i == 0) {
        letter = string[i].toUpperCase();
        isSpace = false;
      } else {
        letter = string[i].toLowerCase();
        isSpace = false;
      }

      if (string[i] == " ") {
        isSpace = true;
      } else {
        isSpace = false;
      }

      name = name + letter;
    }
    return name;
  }
}
