import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';

class SiniestroAgregarScreen extends StatefulWidget {
  final User user;
  final Causante causante;
  const SiniestroAgregarScreen({
    super.key,
    required this.user,
    required this.causante,
  });

  @override
  _SiniestroAgregarScreenState createState() => _SiniestroAgregarScreenState();
}

class _SiniestroAgregarScreenState extends State<SiniestroAgregarScreen> {
  //---------------------------------------------------------------
  //----------------------- Variables -----------------------------
  //---------------------------------------------------------------

  bool _showLoader = false;
  bool bandera = false;
  int intentos = 0;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  bool _huboLesionados = false;

  String _numlesionados = '';
  String _numlesionadosError = '';
  bool _numlesionadosShowError = false;
  final TextEditingController _numlesionadosController =
      TextEditingController();

  bool _intervinoPolicia = false;
  bool _intervinoAmbulancia = false;
  bool _notifico = false;

  String _observaciones = '';
  String _observacionesError = '';
  bool _observacionesShowError = false;
  final TextEditingController _observacionesController =
      TextEditingController();

  String _detalleDanosTercero = '';
  String _detalleDanosTerceroError = '';
  bool _detalleDanosTerceroShowError = false;
  final TextEditingController _detalleDanosTerceroController =
      TextEditingController();

  String _detalleDanosPropio = '';
  String _detalleDanosPropioError = '';
  bool _detalleDanosPropioShowError = false;
  final TextEditingController _detalleDanosPropioController =
      TextEditingController();

  String _numcha = '';
  String _numchaError = '';
  bool _numchaShowError = false;
  final TextEditingController _numchaController = TextEditingController();

  String _numchatercero = '';
  String _numchaterceroError = '';
  bool _numchaterceroShowError = false;
  final TextEditingController _numchaterceroController =
      TextEditingController();

  String _calle = '';
  String _calleError = '';
  bool _calleShowError = false;
  final TextEditingController _calleController = TextEditingController();

  String _numero = '';
  String _numeroError = '';
  bool _numeroShowError = false;
  final TextEditingController _numeroController = TextEditingController();

  String _ciudad = '';
  String _ciudadError = '';
  bool _ciudadShowError = false;
  final TextEditingController _ciudadController = TextEditingController();

  String _provincia = '';
  String _provinciaError = '';
  bool _provinciaShowError = false;
  final TextEditingController _provinciaController = TextEditingController();

  String _tercero = '';
  String _terceroError = '';
  bool _terceroShowError = false;
  final TextEditingController _terceroController = TextEditingController();

  String _companiaseguro = '';
  String _companiaseguroError = '';
  bool _companiaseguroShowError = false;
  final TextEditingController _companiaseguroController =
      TextEditingController();

  String _nropoliza = '';
  String _nropolizaError = '';
  bool _nropolizaShowError = false;
  final TextEditingController _nropolizaController = TextEditingController();

  String _telefonotercero = '';
  String _telefonoterceroError = '';
  bool _telefonoterceroShowError = false;
  final TextEditingController _telefonoterceroController =
      TextEditingController();

  String _emailtercero = '';
  String _emailterceroError = '';
  bool _emailterceroShowError = false;
  final TextEditingController _emailterceroController = TextEditingController();

  String _notificadoa = '';
  String _notificadoaError = '';
  bool _notificadoaShowError = false;
  final TextEditingController _notificadoaController = TextEditingController();

  //---------------------------------------------------------------
  //----------------------- initState -----------------------------
  //---------------------------------------------------------------

  @override
  void initState() {
    super.initState();
  }

  //---------------------------------------------------------------
  //----------------------- Pantalla ------------------------------
  //---------------------------------------------------------------

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
                const SizedBox(height: 1),
                _showFecha(),
                const SizedBox(height: 5),
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
                _showNumchaTercero(),
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
                _showDetallesDanosTercero(),
                _showDetallesDanosPropio(),
                _showNotificado(),
                _showNotificadoa(),
                const SizedBox(height: 5),
                _showButton(),
                const SizedBox(height: 10),
              ],
            ),
          ),
          _showLoader
              ? const LoaderComponent(text: 'Por favor espere...')
              : Container(),
        ],
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showNumcha -------------------------------
  //-----------------------------------------------------------------

  Widget _showNumcha() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: TextField(
        controller: _numchaController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Patente Propia',
          labelText: 'Patente Propia',
          errorText: _numchaShowError ? _numchaError : null,
          suffixIcon: const Icon(Icons.abc),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _numcha = value;
        },
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showNumchaTercero ------------------------
  //-----------------------------------------------------------------

  Widget _showNumchaTercero() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: TextField(
        controller: _numchaterceroController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Patente Tercero',
          labelText: 'Patente Tercero',
          errorText: _numchaterceroShowError ? _numchaterceroError : null,
          suffixIcon: const Icon(Icons.abc),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _numchatercero = value;
        },
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showCalle --------------------------------
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _calle = value;
        },
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showNumero -------------------------------
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _numero = value;
        },
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showCiudad -------------------------------
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _ciudad = value;
        },
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showProvincia ----------------------------
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _provincia = value;
        },
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showTercero ------------------------------
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _tercero = value;
        },
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showTelefonoTercero ----------------------
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _telefonotercero = value;
        },
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showEmailTercero -------------------------
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _emailtercero = value;
        },
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showCompaniaSeguro -----------------------
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _companiaseguro = value;
        },
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showNroPoliza ----------------------------
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _nropoliza = value;
        },
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showLesionados ---------------------------
  //-----------------------------------------------------------------

  Widget _showLesionados() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 10),
      child: Row(
        children: [
          const SizedBox(
            width: 160,
            child: Text(
              'Hubo lesionados: ',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
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
  //--------------------- _showPolicia ------------------------------
  //-----------------------------------------------------------------

  Widget _showPolicia() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Row(
        children: [
          const SizedBox(
            width: 160,
            child: Text(
              'Intervino la Policía: ',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
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
  //--------------------- _showAmbulancia ---------------------------
  //-----------------------------------------------------------------

  Widget _showAmbulancia() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Row(
        children: [
          const SizedBox(
            width: 160,
            child: Text(
              'Intervino Ambulancia: ',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
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
  //--------------------- _showObservaciones ------------------------
  //-----------------------------------------------------------------

  Widget _showObservaciones() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: TextField(
        controller: _observacionesController,
        maxLines: 3,

        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Relato del Siniestro',
          labelText: 'Relato del Siniestro',
          errorText: _observacionesShowError ? _observacionesError : null,
          suffixIcon: const Icon(Icons.notes),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _observaciones = value;
        },
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showDetallesDanosTercero -----------------
  //-----------------------------------------------------------------

  Widget _showDetallesDanosTercero() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: TextField(
        controller: _detalleDanosTerceroController,
        maxLines: 3,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Detalle daños Tercero',
          labelText: 'Detalle daños Tercero',
          errorText: _detalleDanosTerceroShowError
              ? _detalleDanosTerceroError
              : null,
          suffixIcon: const Icon(Icons.notes),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _detalleDanosTercero = value;
        },
      ),
    );
  }

  //---------------------------------------------------------------
  //--------------------- _showDetallesDanosPropio ------------------
  //-----------------------------------------------------------------

  Widget _showDetallesDanosPropio() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: TextField(
        controller: _detalleDanosPropioController,
        maxLines: 3,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Detalle daños Propios',
          labelText: 'Detalle daños Propio',
          errorText: _detalleDanosPropioShowError
              ? _detalleDanosPropioError
              : null,
          suffixIcon: const Icon(Icons.notes),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _detalleDanosPropio = value;
        },
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showNotificado ---------------------------
  //-----------------------------------------------------------------

  Widget _showNotificado() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Row(
        children: [
          const SizedBox(
            width: 160,
            child: Text(
              'Notif. a la Empresa: ',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
          ),
          Checkbox(
            value: _notifico,
            onChanged: (value) {
              _notifico = !_notifico;
              value = _notifico;
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
  //--------------------- _showNotificadoa --------------------------
  //-----------------------------------------------------------------

  Widget _showNotificadoa() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 4),
      child: TextField(
        controller: _notificadoaController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Notificado a...',
          labelText: 'Notificado a...',
          errorText: _notificadoaShowError ? _notificadoaError : null,
          suffixIcon: const Icon(Icons.support_agent),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _notificadoa = value;
        },
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showFecha --------------------------------
  //-----------------------------------------------------------------

  Widget _showFecha() {
    return Stack(
      children: <Widget>[
        Container(height: 80),
        Positioned(
          bottom: 0,
          left: 20,
          child: Row(
            children: [
              const Icon(Icons.calendar_today),
              const SizedBox(width: 20),
              Container(
                width: 110,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: Colors.black, width: 1.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: InkWell(
                        child: Text(
                          '    ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              const Icon(Icons.schedule),
              const SizedBox(width: 20),
              Container(
                width: 110,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: Colors.black, width: 1.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _selectTime(context);
                      },
                      child: InkWell(
                        child: Text(
                          '        ${selectedTime.hour}:${selectedTime.minute}',
                        ),
                      ),
                    ),
                  ],
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
            child: const Text(' Fecha: ', style: TextStyle(fontSize: 12)),
          ),
        ),
        Positioned(
          left: 264,
          bottom: 40,
          child: Container(
            color: Colors.white,
            child: const Text(' Hora: ', style: TextStyle(fontSize: 12)),
          ),
        ),
      ],
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _selectDate -------------------------------
  //-----------------------------------------------------------------

  void _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().add(const Duration(days: -60)),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
  }

  //-----------------------------------------------------------------
  //--------------------- _selectTime -------------------------------
  //-----------------------------------------------------------------

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
  //--------------------- _showButton -------------------------------
  //-----------------------------------------------------------------

  Widget _showButton() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
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
              onPressed: _save,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.save),
                  SizedBox(width: 20),
                  Text('Guardar siniestro'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _save -------------------------------------
  //-----------------------------------------------------------------

  void _save() {
    if (!validateFields()) {
      setState(() {});
      return;
    }
    _addRecord();
  }

  //-----------------------------------------------------------------
  //--------------------- validateFields ----------------------------
  //-----------------------------------------------------------------

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

    if (_numchatercero.isEmpty) {
      isValid = false;
      _numchaterceroShowError = true;
      _numchaterceroError = 'Debe ingresar una Patente';
    } else {
      _numchaterceroShowError = false;
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

    if (_huboLesionados && (_numlesionados.isEmpty || _numlesionados == '0')) {
      isValid = false;
      _numlesionadosShowError = true;
      _numlesionadosError = 'Ingrese N° Lesion.';
    } else {
      _numlesionadosShowError = false;
    }

    if (_observaciones.isEmpty || _observaciones == '') {
      isValid = false;
      _observacionesShowError = true;
      _observacionesError = 'Debe ingresar Relato del Siniestro';
    } else {
      _observacionesShowError = false;
    }

    if (_detalleDanosTercero.isEmpty || _detalleDanosTercero == '') {
      isValid = false;
      _detalleDanosTerceroShowError = true;
      _detalleDanosTerceroError = 'Debe ingresar detalle de daños del Tercero';
    } else {
      _detalleDanosTerceroShowError = false;
    }

    if (_detalleDanosPropio.isEmpty || _detalleDanosPropio == '') {
      isValid = false;
      _detalleDanosPropioShowError = true;
      _detalleDanosPropioError = 'Debe ingresar detalle de daños propios';
    } else {
      _detalleDanosPropioShowError = false;
    }

    if (_observaciones.isNotEmpty && _observaciones.length > 249) {
      isValid = false;
      _observacionesShowError = true;
      _observacionesError =
          'La cantidad máxima de caracteres es de 249. Ha puesto ${_observaciones.length}';
    }

    if (_detalleDanosTercero.isNotEmpty && _detalleDanosTercero.length > 200) {
      isValid = false;
      _detalleDanosTerceroShowError = true;
      _detalleDanosTerceroError =
          'La cantidad máxima de caracteres es de 200. Ha puesto ${_detalleDanosTercero.length}';
    }

    if (_detalleDanosPropio.isNotEmpty && _detalleDanosPropio.length > 200) {
      isValid = false;
      _detalleDanosPropioShowError = true;
      _detalleDanosPropioError =
          'La cantidad máxima de caracteres es de 200. Ha puesto ${_detalleDanosPropio.length}';
    }

    if (_notifico) {
      if (_notificadoa.isEmpty) {
        isValid = false;
        _notificadoaShowError = true;
        _notificadoaError = 'Debe ingresar a quién notificó';
      } else {
        _notificadoaShowError = false;
      }
    } else {
      _notificadoaShowError = false;
    }

    setState(() {});

    return isValid;
  }

  //-----------------------------------------------------------------
  //--------------------- _addRecord --------------------------------
  //-----------------------------------------------------------------

  void _addRecord() async {
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
      'fechacarga': selectedDate.toString().substring(0, 10),
      'grupo': widget.causante.grupo,
      'causante': widget.causante.codigo,
      'apellidonombretercero': pLMayusc(_tercero),
      'nropolizatercero': _nropoliza,
      'telefonocontactotercero': _telefonotercero,
      'emailtercero': _emailtercero,
      'notificadoempresa': _notifico ? 'SI' : 'NO',
      'notificadoa': _notificadoa,
      'direccionsiniestro': pLMayusc(_calle),
      'altura': _numero,
      'ciudad': pLMayusc(_ciudad),
      'provincia': pLMayusc(_provincia),
      'horasiniestro': selectedTime.hour * 3600 + selectedTime.minute * 60,
      'lesionados': _huboLesionados ? 'SI' : 'NO',
      'cantidadlesionados': _huboLesionados ? _numlesionados : 0,
      'intervinopolicia': _intervinoPolicia ? 'SI' : 'NO',
      'intervinoambulancia': _intervinoAmbulancia ? 'SI' : 'NO',
      'relatosiniestro': _observaciones,
      'numcha': _numcha.toUpperCase(),
      'companiasegurotercero': pLMayusc(_companiaseguro),
      'idUsuarioCarga': widget.user.idUsuario,
      'detalledanostercero': _detalleDanosTercero,
      'detalledanospropio': _detalleDanosPropio,
      'numchatercero': _numchatercero,
      'modulo': widget.user.modulo,
      'TipoDeSiniestro': 'Sin Datos',
    };

    Response response = await ApiHelper.postNoToken(
      '/api/VehiculosSiniestros/PostSiniestros',
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
    Navigator.pop(context, 'yes');
  }

  //-----------------------------------------------------------------
  //--------------------- pLMayusc ----------------------------------
  //-----------------------------------------------------------------

  String pLMayusc(String string) {
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

      if (string[i] == ' ') {
        isSpace = true;
      } else {
        isSpace = false;
      }

      name = name + letter;
    }
    return name;
  }
}
