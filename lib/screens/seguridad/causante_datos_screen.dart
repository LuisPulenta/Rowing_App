import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';

class CausanteDatosScreen extends StatefulWidget {
  final Causante causante;

  const CausanteDatosScreen({super.key, required this.causante});

  @override
  State<CausanteDatosScreen> createState() => _CausanteDatosScreenState();
}

class _CausanteDatosScreenState extends State<CausanteDatosScreen> {
  //---------------------------------------------------------------
  //----------------------- Variables -----------------------------
  //---------------------------------------------------------------

  late Causante _causante;

  bool _showLoader = false;

  DateTime? fechaIngreso;

  List<DropdownMenuItem<String>> _items = [];
  List<Option2> _listoptions = [];

  String _phoneNumber = '';
  String _phoneNumberError = '';
  bool _phoneNumberShowError = false;
  final TextEditingController _phoneNumberController = TextEditingController();

  String _direccion = '';
  String _direccionError = '';
  bool _direccionShowError = false;
  final TextEditingController _direccionController = TextEditingController();

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

  String _optionContacto = 'Seleccione un Contacto...';
  String _contacto = '';
  String _optionContactoError = '';
  bool _optionContactoShowError = false;
  final TextEditingController _optionContactoController =
      TextEditingController();

  String _nombreContacto = '';
  String _nombreContactoError = '';
  bool _nombreContactoShowError = false;
  final TextEditingController _nombreContactoController =
      TextEditingController();

  String _telefonoContacto = '';
  String _telefonoContactoError = '';
  bool _telefonoContactoShowError = false;
  final TextEditingController _telefonoContactoController =
      TextEditingController();

  String _ceco = '';
  String _cecoError = '';
  bool _cecoShowError = false;
  final TextEditingController _cecoController = TextEditingController();

  //---------------------------------------------------------------
  //----------------------- initState -----------------------------
  //---------------------------------------------------------------

  @override
  void initState() {
    super.initState();

    _getlistOptions();

    _causante = widget.causante;

    _phoneNumber = (widget.causante.telefono ?? '');

    _phoneNumber = _phoneNumber.replaceAll(' ', '');

    _phoneNumberController.text = (widget.causante.telefono ?? '');

    _phoneNumberController.text = _phoneNumberController.text.replaceAll(
      ' ',
      '',
    );

    _direccion = (widget.causante.direccion ?? '');
    _direccion = _direccion.replaceAll('  ', '');
    _direccionController.text = (widget.causante.direccion ?? '');
    _direccionController.text = _direccionController.text.replaceAll('  ', '');

    _numero = (widget.causante.numero.toString());
    _numero = _numero.replaceAll(' ', '');
    _numeroController.text = (widget.causante.numero.toString());
    _numeroController.text = _numeroController.text.replaceAll(' ', '');

    _ciudad = (widget.causante.ciudad ?? '');
    _ciudad = _ciudad.replaceAll('  ', '');
    _ciudadController.text = (widget.causante.ciudad ?? '');
    _ciudadController.text = _ciudadController.text.replaceAll('  ', '');

    _provincia = (widget.causante.provincia ?? '');
    _provincia = _provincia.replaceAll('  ', '');
    _provinciaController.text = (widget.causante.provincia ?? '');
    _provinciaController.text = _provinciaController.text.replaceAll('  ', '');

    _optionContacto = _causante.telefonoContacto2 != null
        ? widget.causante.telefonoContacto2.toString()
        : 'Seleccione un Contacto...';

    _optionContactoController.text =
        widget.causante.telefonoContacto2.toString() != ''
        ? widget.causante.telefonoContacto2.toString()
        : 'Seleccione un Contacto...';

    _nombreContacto = widget.causante.telefonoContacto3 != null
        ? (widget.causante.telefonoContacto3.toString())
        : '';

    _nombreContacto = _nombreContacto.replaceAll('  ', '');
    _nombreContactoController.text = _nombreContacto;
    _nombreContactoController.text = _nombreContactoController.text.replaceAll(
      '  ',
      '',
    );

    _telefonoContacto = widget.causante.telefonoContacto1 != null
        ? (widget.causante.telefonoContacto1.toString())
        : '';
    _telefonoContacto = _telefonoContacto.replaceAll(' ', '');
    _telefonoContactoController.text = _telefonoContacto;
    _telefonoContactoController.text = _telefonoContactoController.text
        .replaceAll(' ', '');

    _ceco = (widget.causante.notasCausantes.toString());
    _ceco = _ceco.replaceAll('  ', '');
    _cecoController.text = (widget.causante.notasCausantes.toString());
    _cecoController.text = _cecoController.text.replaceAll('  ', '');

    fechaIngreso = (DateTime.parse(widget.causante.fecha!));

    setState(() {});
  }

  //---------------------------------------------------------------
  //----------------------- Pantalla ------------------------------
  //---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 192, 190, 190),
      appBar: AppBar(
        title: Text(
          'Datos de ${widget.causante.nombre}',
          style: const TextStyle(fontSize: 14),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF484848),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                _showPhoneNumber(),
                _showDireccion(),
                _showNumero(),
                _showCiudad(),
                _showProvincia(),
                _showContacto(),
                _showNombreContacto(),
                _showTelefonoContacto(),
                _showCentroCosto(),
                _showFecha(),
                _showButtons(),
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

  //---------------------------------------------------------------
  //----------------------- _showPhoneNumber ----------------------
  //---------------------------------------------------------------

  Widget _showPhoneNumber() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _phoneNumberController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingresa Teléfono...',
          labelText: 'Teléfono',
          errorText: _phoneNumberShowError ? _phoneNumberError : null,
          suffixIcon: const Icon(Icons.phone),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _phoneNumber = value;
        },
      ),
    );
  }

  //---------------------------------------------------------------
  //----------------------- _showDireccion ------------------------
  //---------------------------------------------------------------

  Widget _showDireccion() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _direccionController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingrese Calle...',
          labelText: 'Calle',
          errorText: _direccionShowError ? _direccionError : null,
          suffixIcon: const Icon(Icons.home),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _direccion = value;
        },
      ),
    );
  }

  //---------------------------------------------------------------
  //----------------------- _showNumero ---------------------------
  //---------------------------------------------------------------

  Widget _showNumero() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _numeroController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'N°...',
          labelText: 'N°',
          errorText: _numeroShowError ? _numeroError : null,
          suffixIcon: const Icon(Icons.numbers),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _numero = value;
        },
      ),
    );
  }

  //---------------------------------------------------------------
  //----------------------- _showCiudad ---------------------------
  //---------------------------------------------------------------

  Widget _showCiudad() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _ciudadController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingrese Ciudad...',
          labelText: 'Ciudad',
          errorText: _ciudadShowError ? _ciudadError : null,
          suffixIcon: const Icon(Icons.location_city),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _ciudad = value;
        },
      ),
    );
  }

  //---------------------------------------------------------------
  //----------------------- _showProvincia ------------------------
  //---------------------------------------------------------------

  Widget _showProvincia() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _provinciaController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingrese Provincia...',
          labelText: 'Provincia',
          errorText: _provinciaShowError ? _provinciaError : null,
          suffixIcon: const Icon(Icons.south_america),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _provincia = value;
        },
      ),
    );
  }

  //---------------------------------------------------------------
  //----------------------- _showContacto -------------------------
  //---------------------------------------------------------------

  Widget _showContacto() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonFormField(
        items: _items,
        initialValue: _optionContacto == ''
            ? 'Seleccione un Contacto...'
            : _optionContacto,
        onChanged: (option) {
          setState(() {
            _optionContacto = option as String;
            _contacto = option.toString();
          });
        },
        decoration: InputDecoration(
          hintText: 'Seleccione un Contacto...',
          labelText: '',
          fillColor: Colors.white,
          filled: true,
          errorText: _optionContactoShowError ? _optionContactoError : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  //---------------------------------------------------------------
  //----------------------- _showNombreContacto -------------------
  //---------------------------------------------------------------

  Widget _showNombreContacto() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _nombreContactoController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Nombre Contacto',
          labelText: 'Nombre Contacto',
          errorText: _nombreContactoShowError ? _nombreContactoError : null,
          suffixIcon: const Icon(Icons.person),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _nombreContacto = value;
        },
      ),
    );
  }

  //---------------------------------------------------------------
  //----------------------- _showTelefonoContacto -----------------
  //---------------------------------------------------------------

  Widget _showTelefonoContacto() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _telefonoContactoController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Telefono Contacto',
          labelText: 'Telefono Contacto',
          errorText: _telefonoContactoShowError ? _telefonoContactoError : null,
          suffixIcon: const Icon(Icons.phone),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _telefonoContacto = value;
        },
      ),
    );
  }

  //---------------------------------------------------------------
  //----------------------- _showCentroCosto ----------------------
  //---------------------------------------------------------------

  Widget _showCentroCosto() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _cecoController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Centro de Costo',
          labelText: 'Centro de Costo',
          errorText: _cecoShowError ? _cecoError : null,
          suffixIcon: const Icon(Icons.abc),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _ceco = value;
        },
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showFecha --------------------------------
  //-----------------------------------------------------------------

  Widget _showFecha() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [Expanded(flex: 2, child: Row(children: const []))],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      color: const Color(0xFF781f1e),
                      width: 140,
                      height: 30,
                      child: const Text(
                        '  Fecha Ingreso:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.center,
                        color: const Color(0xFF781f1e).withOpacity(0.2),
                        width: 140,
                        height: 30,
                        child: Text(
                          fechaIngreso != null
                              ? '    ${fechaIngreso!.day}/${fechaIngreso!.month}/${fechaIngreso!.year}'
                              : '',
                          style: const TextStyle(color: Color(0xFF781f1e)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF781f1e),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () => _fechaIngreso(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [Icon(Icons.calendar_month)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _fechaIngreso -----------------------------
  //-----------------------------------------------------------------

  Future<void> _fechaIngreso() async {
    FocusScope.of(context).unfocus();
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 2),
    );
    if (selected != null && selected != fechaIngreso) {
      setState(() {
        fechaIngreso = selected;
      });
    }
  }

  //-----------------------------------------------------------------
  //--------------------- _showButtons ------------------------------
  //-----------------------------------------------------------------

  Widget _showButtons() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF120E43),
                minimumSize: const Size(100, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () => _save(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.save),
                  SizedBox(width: 15),
                  Text('Guardar'),
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
      return;
    }
    _saveRecord();
  }

  //-----------------------------------------------------------------
  //--------------------- validateFields ----------------------------
  //-----------------------------------------------------------------

  bool validateFields() {
    bool isValid = true;

    if (_phoneNumber.isEmpty) {
      isValid = false;
      _phoneNumberShowError = true;
      _phoneNumberError = 'Debes ingresar un teléfono';
    } else {
      _phoneNumberShowError = false;
    }

    if (_direccion.isEmpty) {
      isValid = false;
      _direccionShowError = true;
      _direccionError = 'Debes ingresar una Calle';
    } else {
      _direccionShowError = false;
    }

    if (_numero.isEmpty) {
      isValid = false;
      _numeroShowError = true;
      _numeroError = 'Debes ingresar un N°';
    } else {
      _numeroShowError = false;
    }

    if (_ciudad.isEmpty) {
      isValid = false;
      _ciudadShowError = true;
      _ciudadError = 'Debes ingresar una Ciudad';
    } else {
      _ciudadShowError = false;
    }

    if (_provincia.isEmpty) {
      isValid = false;
      _provinciaShowError = true;
      _provinciaError = 'Debes ingresar una Provincia';
    } else {
      _provinciaShowError = false;
    }

    if (_contacto == 'Seleccione un Contacto...') {
      isValid = false;
      _optionContactoShowError = true;
      _optionContactoError = 'Debes ingresar un Contacto';
    } else {
      _optionContactoShowError = false;
    }

    if (_nombreContacto.isEmpty) {
      isValid = false;
      _nombreContactoShowError = true;
      _nombreContactoError = 'Debes ingresar un Nombre de Contacto';
    } else {
      _nombreContactoShowError = false;
    }

    if (_telefonoContacto.isEmpty) {
      isValid = false;
      _telefonoContactoShowError = true;
      _telefonoContactoError = 'Debes ingresar un Teléfono de Contacto';
    } else {
      _telefonoContactoShowError = false;
    }

    if (_ceco.isEmpty) {
      isValid = false;
      _cecoShowError = true;
      _cecoError = 'Debes ingresar un Centro de Costo';
    } else {
      _cecoShowError = false;
    }

    setState(() {});

    return isValid;
  }

  //-----------------------------------------------------------------
  //--------------------- _saveRecord -------------------------------
  //-----------------------------------------------------------------

  Future<void> _saveRecord() async {
    FocusScope.of(context).unfocus();
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
      'id': widget.causante.nroCausante,
      'telefono': _phoneNumber,
      'direccion': _direccion,
      'Numero': _numero,
      'TelefonoContacto1': _telefonoContacto,
      'TelefonoContacto2': _contacto,
      'TelefonoContacto3': _nombreContacto,
      'fecha': fechaIngreso.toString().substring(0, 10),
      'NotasCausantes': _ceco,
      'ciudad': _ciudad,
      'Provincia': _provincia,
      'ZonaTrabajo': widget.causante.zonaTrabajo,
      'NombreActividad': widget.causante.nombreActividad,
    };

    Response response = await ApiHelper.put(
      '/api/Causantes/',
      widget.causante.nroCausante.toString(),
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
    } else {
      await showAlertDialog(
        context: context,
        title: 'Aviso',
        message: 'Guardado con éxito!',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      Navigator.pop(context, 'yes');
    }
  }

  //-----------------------------------------------------------------
  //--------------------- _getlistOptions ---------------------------
  //-----------------------------------------------------------------

  void _getlistOptions() {
    _items = [];
    _listoptions = [];

    Option2 opt1 = Option2(id: 'Cónyuge', description: 'Cónyuge');
    Option2 opt2 = Option2(id: 'Padre', description: 'Padre');
    Option2 opt3 = Option2(id: 'Madre', description: 'Madre');
    Option2 opt4 = Option2(id: 'Hermano/a', description: 'Hermano/a');
    Option2 opt5 = Option2(id: 'Vecino/a', description: 'Vecino/a');
    _listoptions.add(opt1);
    _listoptions.add(opt2);
    _listoptions.add(opt3);
    _listoptions.add(opt4);
    _listoptions.add(opt5);

    _getComboContactos();
  }

  //-----------------------------------------------------------------
  //--------------------- _getComboContactos ------------------------
  //-----------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboContactos() {
    _items = [];

    List<DropdownMenuItem<String>> list = [];
    list.add(
      const DropdownMenuItem(
        value: 'Seleccione un Contacto...',
        child: Text('Seleccione un Contacto...'),
      ),
    );

    for (var _listoption in _listoptions) {
      list.add(
        DropdownMenuItem(
          value: _listoption.id,
          child: Text(_listoption.description),
        ),
      );
    }

    _items = list;

    return list;
  }
}
