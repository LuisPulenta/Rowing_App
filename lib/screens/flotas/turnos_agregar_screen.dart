import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';

class TurnosAgregarScreen extends StatefulWidget {
  final User user;
  const TurnosAgregarScreen({super.key, required this.user});

  @override
  State<TurnosAgregarScreen> createState() => _TurnosAgregarScreenState();
}

class _TurnosAgregarScreenState extends State<TurnosAgregarScreen> {
  //---------------------------------------------------------------------
  //-------------------------- Variables --------------------------------
  //---------------------------------------------------------------------

  bool _showLoader = false;

  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay selectedTime = TimeOfDay.now();

  String _codigo = '';
  String _codigoError = '';
  bool _codigoShowError = false;
  final TextEditingController _codigoController = TextEditingController();

  late Vehiculo _vehiculo;

  String _observaciones = '';
  String _observacionesError = '';
  bool _observacionesShowError = false;
  final TextEditingController _observacionesController =
      TextEditingController();

  List<Causante> _talleres = [];

  String _taller = 'Elija un taller...';
  String _tallerError = '';
  bool _tallerShowError = false;

  //---------------------------------------------------------------------
  //-------------------------- InitState --------------------------------
  //---------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _vehiculo = Vehiculo(
      codveh: 0,
      numcha: '',
      nrotar: '',
      codProducto: '',
      aniofa: 0,
      descripcion: '',
      nmotor: '',
      chasis: '',
      fechaVencITV: 0,
      nroPolizaSeguro: '',
      centroCosto: '',
      propiedadDe: '',
      telepase: '',
      kmhsactual: 0,
      usaHoras: 0,
      habilitado: 0,
      fechaVencObleaGAS: 0,
      modulo: '',
      campomemo: '',
      habilitaChecklist: 0,
    );
    _loadData();
  }

  //---------------------------------------------------------------------
  //-------------------------- Pantalla ---------------------------------
  //---------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xFF484848),
      backgroundColor: const Color(0xff8c8c94),
      appBar: AppBar(
        title: const Text('Nuevo Turno Taller'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 15,
              margin: const EdgeInsets.all(5),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(flex: 10, child: _showLegajo()),
                        Expanded(flex: 7, child: _showButtonConsultar()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            _showInfo(),
            _showObservaciones(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: _getFecha(context),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: _showTalleres(),
            ),
            const SizedBox(height: 30),
            _showButton(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showLegajo -------------------------------
  //-----------------------------------------------------------------

  Widget _showLegajo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        controller: _codigoController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingrese Patente...',
          labelText: 'Patente:',
          errorText: _codigoShowError ? _codigoError : null,
          prefixIcon: const Icon(Icons.badge),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _codigo = value;
        },
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showButtonConsultar ----------------------
  //-----------------------------------------------------------------

  Widget _showButtonConsultar() {
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
                children: const [
                  Icon(Icons.search),
                  SizedBox(width: 5),
                  Text('Consultar'),
                ],
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
              icon: Icons.abc_outlined,
              nombredato: 'Cód. Inventario:',
              dato: _gato(_vehiculo.codProducto),
            ),
            CustomRow(
              icon: Icons.person,
              nombredato: 'Asignado a:',
              dato: _gato(_vehiculo.campomemo),
            ),
          ],
        ),
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showObservaciones ------------------------
  //-----------------------------------------------------------------

  Widget _showObservaciones() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _observacionesController,
        maxLines: 3,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingrese una breve descripción del problema...',
          labelText: 'Observaciones',
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
  //--------------------- _showTalleres -----------------------------
  //-----------------------------------------------------------------

  Widget _showTalleres() {
    return Container(
      padding: const EdgeInsets.all(00),
      child: _talleres.isEmpty
          ? const Text('Cargando talleres...')
          : DropdownButtonFormField(
              initialValue: _taller,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Elija un taller...',
                labelText: 'Taller',
                errorText: _tallerShowError ? _tallerError : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: _getComboTalleres(),
              onChanged: (value) {
                _taller = value.toString();
              },
            ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _getComboTalleres -------------------------
  //-----------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboTalleres() {
    List<DropdownMenuItem<String>> list = [];
    list.add(
      const DropdownMenuItem(
        value: 'Elija un taller...',
        child: Text('Elija un taller...'),
      ),
    );

    for (var taller in _talleres) {
      list.add(
        DropdownMenuItem(
          value: taller.codigo,
          child: Text(taller.nombre.replaceAll('  ', '')),
        ),
      );
    }

    return list;
  }

  //----------------------------------------------------------------------------
  //------------------------------- _getFecha ----------------------------------
  //----------------------------------------------------------------------------

  Widget _getFecha(context) {
    return Stack(
      children: <Widget>[
        Container(height: 80),
        Positioned(
          bottom: 0,
          child: Row(
            children: [
              const Icon(Icons.calendar_today),
              const SizedBox(width: 20),
              Container(
                width: 110,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
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
                  color: Colors.white,
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
        const Positioned(
          left: 50,
          bottom: 50,
          child: Text(' Fecha Turno: ', style: TextStyle(fontSize: 12)),
        ),
        const Positioned(
          left: 244,
          bottom: 50,
          child: Text(' Hora Turno: ', style: TextStyle(fontSize: 12)),
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
      initialDate: DateTime.now(),
      firstDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      lastDate: DateTime(
        DateTime.now().add(const Duration(days: 30)).year,
        DateTime.now().add(const Duration(days: 30)).month,
        DateTime.now().add(const Duration(days: 30)).day,
      ),
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
                  Text('Guardar Turno'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //-----------------------------------------------------------------------------
  //-------------------------------- _search ------------------------------------
  //-----------------------------------------------------------------------------

  Future<void> _search() async {
    FocusScope.of(context).unfocus();
    _codigoController.text = _codigo.toUpperCase();
    if (_codigo.isEmpty) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Ingrese una Patente.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    await _getVehiculo();
  }

  //-----------------------------------------------------------------------------
  //-------------------------------- _getVehiculo -------------------------------
  //-----------------------------------------------------------------------------

  Future<void> _getVehiculo() async {
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

    Response response = await ApiHelper.getVehiculoByChapa(_codigo);

    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Patente no válida',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );

      setState(() {
        _showLoader = false;
      });
      return;
    }
    setState(() {
      _showLoader = false;
      _vehiculo = response.result;
    });

    setState(() {});
  }

  //-----------------------------------------------------------------------------
  //-------------------------------- _save --------------------------------------
  //-----------------------------------------------------------------------------

  void _save() {
    if (!validateFields()) {
      setState(() {});
      return;
    }
    _addRecord();
  }

  //-----------------------------------------------------------------------------
  //-------------------------------- validateFields -----------------------------
  //-----------------------------------------------------------------------------

  bool validateFields() {
    bool isValid = true;

    //--------- N° Chapa ----------
    if (_codigo == '') {
      isValid = false;
      _codigoShowError = true;
      _codigoError = 'Debe completar Patente';

      setState(() {});
      return isValid;
    } else if (_codigo.length > 10) {
      isValid = false;
      _codigoShowError = true;
      _codigoError =
          'No debe superar los 10 caracteres. Escribió ${_codigo.length}.';
      setState(() {});
      return isValid;
    } else {
      _codigoShowError = false;
    }

    if (_vehiculo.numcha == '') {
      isValid = false;
      _codigoShowError = true;
      _codigoError = 'Ingrese una Patente válida';

      setState(() {});
      return isValid;
    } else {
      _codigoShowError = false;
    }

    //--------- Observaciones ----------
    if (_observaciones == '') {
      isValid = false;
      _observacionesShowError = true;
      _observacionesError = 'Debe completar Observaciones';

      setState(() {});
      return isValid;
    } else if (_observaciones.length > 150) {
      isValid = false;
      _observacionesShowError = true;
      _observacionesError =
          'No debe superar los 150 caracteres. Escribió ${_observaciones.length}.';
      setState(() {});
      return isValid;
    } else {
      _observacionesShowError = false;
    }

    //--------- Taller ----------
    if (_taller == 'Elija un taller...') {
      isValid = false;
      _tallerShowError = true;
      _tallerError = 'Debe elegir un taller';

      setState(() {});
      return isValid;
    } else {
      _tallerShowError = false;
    }

    setState(() {});

    return isValid;
  }

  //--------------------------------------------------------------------------
  //---------------------------- _addRecord ----------------------------------
  //--------------------------------------------------------------------------

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

    String ahora = DateTime.now().toString().substring(0, 10);

    Map<String, dynamic> request = {
      'IDTurno': 0,
      'IdUser': widget.user.idUsuario,
      'FechaCarga': ahora,
      'Numcha': _codigo.toUpperCase(),
      'CodVehiculo': _vehiculo.codProducto,
      'AsignadoActual': _vehiculo.campomemo,
      'FechaTurno': selectedDate.toString().substring(0, 10),
      'HoraTurno': selectedTime.hour * 3600 + selectedTime.minute * 60,
      'TextoBreve': _observaciones,
      'FechaConfirmaTurno': null,
      'IDUserConfirma': 0,
      'FechaTurnoConfirmado': null,
      'HoraTurnoConfirmado': 0,
      'Grupo': 'TAL',
      'Causante': _taller,
      'VehiculoRetirado': 0,
      'IdVehiculoParteTaller': 0,
    };

    Response response = await ApiHelper.postNoToken(
      '/api/Vehiculos/PostTurno',
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
    setState(() {});
  }

  //-------------------------------------------------------------
  //------------------------- _gato -----------------------------
  //-------------------------------------------------------------

  String _gato(String? dato) {
    return dato != null ? dato.toString() : '';
  }

  //-------------------------------------------------------------
  //------------------------- _loadData -------------------------
  //-------------------------------------------------------------

  void _loadData() async {
    await _getTalleres();
  }

  //-------------------------------------------------------------
  //------------------------- _getTalleres ----------------------
  //-------------------------------------------------------------

  Future<void> _getTalleres() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      showMyDialog(
        'Error',
        'Verifica que estés conectado a Internet',
        'Aceptar',
      );
    }

    Response response = Response(isSuccess: false);
    response = await ApiHelper.getCausantesTalleres();

    if (response.isSuccess) {
      _talleres = response.result;
    }
    setState(() {});
  }
}
