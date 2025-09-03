import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';

enum OptionTwo { SI, NO }

enum Option4 { Bien, Regular, Malo, NoAplica }

class GruasCheckListAgregarScreen extends StatefulWidget {
  final User user;
  final bool editMode;
  final VehiculosCheckList checkList;
  const GruasCheckListAgregarScreen({
    super.key,
    required this.user,
    required this.editMode,
    required this.checkList,
  });

  @override
  State<GruasCheckListAgregarScreen> createState() =>
      _GruasCheckListAgregarScreenState();
}

class _GruasCheckListAgregarScreenState
    extends State<GruasCheckListAgregarScreen> {
  //--------------------------------------------------------------------
  //------------------------- Variables --------------------------------
  //--------------------------------------------------------------------

  OptionTwo? _vtv;
  DateTime? _fechaVencVtv;
  OptionTwo? _vth;
  DateTime? _fechaVencVth;
  OptionTwo? _seguro;
  DateTime? _fechaVencSeguro;

  Option4? _cubiertas;
  Option4? _correasCinturon;
  Option4? _apoyaCabezas;
  Option4? _limpiaVidrios;
  Option4? _espejos;
  Option4? _indicadoresDeGiro;
  Option4? _bocina;
  Option4? _dispositivoPAT;
  Option4? _ganchos;
  Option4? _alarmaRetroceso;
  Option4? _manguerasCircuitoHidraulico;
  Option4? _farosDelanteros;
  Option4? _farosTraseros;
  Option4? _luzDePosicion;
  Option4? _luzDeFreno;
  Option4? _luzDeRetroceso;
  Option4? _luzDeEmergencia;
  Option4? _balizaPortatil;
  Option4? _matafuegos;
  Option4? _identificadorEmpresa;
  Option4? _sobresalientesPeligro;
  Option4? _diagramaDeCarga;
  Option4? _fajas;
  Option4? _grilletes;
  Option4? _cintaSujecionCarga;

  String _nombreApellido = '';
  final String _nombreApellidoError = '';
  final bool _nombreApellidoShowError = false;

  String _documento = '';
  final String _documentoError = '';
  final bool _documentoShowError = false;

  String _jefeDirecto = '';
  final String _jefeDirectoError = '';
  final bool _jefeDirectoShowError = false;
  final TextEditingController _jefeDirectoController = TextEditingController();

  String _responsableVehiculo = '';
  final String _responsableVehiculoError = '';
  final bool _responsableVehiculoShowError = false;
  final TextEditingController _responsableVehiculoController =
      TextEditingController();

  String _observaciones = '';
  final String _observacionesError = '';
  final bool _observacionesShowError = false;
  final TextEditingController _observacionesController =
      TextEditingController();

  bool _showLoader = false;

  List<Cliente> _clientes = [];
  int _cliente = 0;
  final String _clienteError = '';
  final bool _clienteShowError = false;

  String _codigo = '';
  final String _codigoError = '';
  final bool _codigoShowError = false;
  final TextEditingController _codigoController = TextEditingController();

  String _codigo2 = '';
  final String _codigo2Error = '';
  final bool _codigo2ShowError = false;
  final TextEditingController _codigo2Controller = TextEditingController();

  final TextEditingController _nombreApellidoController =
      TextEditingController();
  final TextEditingController _documentoController = TextEditingController();

  late Vehiculo _vehiculoAux;
  late Vehiculo _vehiculoVacio;
  late Vehiculo _vehiculo;
  late Causante _causante;
  late Causante _causanteVacio;

  //--------------------------------------------------------------------
  //------------------------- Init State -------------------------------
  //--------------------------------------------------------------------

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

    _vehiculoVacio = Vehiculo(
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

    _causanteVacio = _causante;

    _getClientes();

    if (widget.editMode) {
      _loadFields();
    }
  }

  //--------------------------------------------------------------------
  //------------------------- Pantalla ---------------------------------
  //--------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff8c8c94),
      appBar: AppBar(title: const Text('Nuevo Check List'), centerTitle: true),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _showClientes(),
                const Divider(color: Colors.white),
                Row(
                  children: [
                    Expanded(flex: 10, child: _showChapa()),
                    Expanded(flex: 7, child: _showSearchButton()),
                  ],
                ),
                const SizedBox(height: 5),
                _showInfo(),
                const Divider(color: Colors.white),
                const SizedBox(height: 0),

                Row(
                  children: [
                    Expanded(flex: 7, child: _showLegajo()),
                    Expanded(flex: 2, child: _showSearch2Button()),
                  ],
                ),

                _vehiculo.numcha == '000000  '
                    ? _showNombreApellido()
                    : Container(),
                _vehiculo.numcha == '000000  ' ? _showDocumento() : Container(),
                _vehiculo.numcha == '000000  '
                    ? const Divider(color: Colors.white)
                    : Container(),
                _vehiculo.numcha == '000000  '
                    ? const SizedBox(height: 0)
                    : Container(),
                const SizedBox(height: 5),
                _showInfo2(),
                const Divider(color: Colors.white),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    color: Colors.white,
                    child: Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: const {
                        0: FractionColumnWidth(0.2),
                        1: FractionColumnWidth(0.16),
                        2: FractionColumnWidth(0.16),
                        3: FractionColumnWidth(0.48),
                      },
                      border: TableBorder.all(),
                      children: [
                        //---------------- Título -----------------------------
                        TableRow(
                          children: [
                            Container(
                              color: const Color.fromARGB(255, 33, 172, 236),
                              child: const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Concepto',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              color: const Color.fromARGB(255, 33, 172, 236),
                              child: const Text(
                                'SI',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              color: const Color.fromARGB(255, 33, 172, 236),
                              child: const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'NO',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              color: const Color.fromARGB(255, 33, 172, 236),
                              child: const Text(
                                'Fecha Venc.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        //---------------- VTV -----------------------------
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  (_vtv != null
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : Container()),
                                  const Text(
                                    'VTV',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Radio<OptionTwo>(
                              value: OptionTwo.SI,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _vtv,
                              onChanged: (OptionTwo? value) {
                                setState(() {
                                  _vtv = value;
                                });
                              },
                            ),
                            Radio<OptionTwo>(
                              value: OptionTwo.NO,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _vtv,
                              onChanged: (OptionTwo? value) {
                                setState(() {
                                  _vtv = value;
                                  _fechaVencVtv = null;
                                });
                              },
                            ),
                            _showFechaVTV(),
                          ],
                        ),
                        //---------------- VTH -----------------------------
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  (_vth != null
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : Container()),
                                  const Text(
                                    'VTH',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Radio<OptionTwo>(
                              value: OptionTwo.SI,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _vth,
                              onChanged: (OptionTwo? value) {
                                setState(() {
                                  _vth = value;
                                });
                              },
                            ),
                            Radio<OptionTwo>(
                              value: OptionTwo.NO,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _vth,
                              onChanged: (OptionTwo? value) {
                                setState(() {
                                  _vth = value;
                                  _fechaVencVth = null;
                                });
                              },
                            ),
                            _showFechaVTH(),
                          ],
                        ),
                        //---------------- SEGURO -----------------------------
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  (_seguro != null
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : Container()),
                                  const Text(
                                    'Seguro',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Radio<OptionTwo>(
                              value: OptionTwo.SI,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _seguro,
                              onChanged: (OptionTwo? value) {
                                setState(() {
                                  _seguro = value;
                                });
                              },
                            ),
                            Radio<OptionTwo>(
                              value: OptionTwo.NO,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _seguro,
                              onChanged: (OptionTwo? value) {
                                setState(() {
                                  _seguro = value;
                                  _fechaVencSeguro = null;
                                });
                              },
                            ),
                            _showFechaSeguro(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                //--------------------------------------------------------------------
                //------------------------- Primera Tabla ----------------------------
                //--------------------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    color: Colors.white,
                    child: Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: const {
                        0: FractionColumnWidth(0.36),
                        1: FractionColumnWidth(0.16),
                        2: FractionColumnWidth(0.16),
                        3: FractionColumnWidth(0.16),
                        4: FractionColumnWidth(0.16),
                      },
                      border: TableBorder.all(),
                      children: [
                        //---------------- Título -----------------------------
                        TableRow(
                          children: [
                            Container(
                              color: const Color.fromARGB(255, 33, 172, 236),
                              child: const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Concepto',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              color: const Color.fromARGB(255, 33, 172, 236),
                              child: const Text(
                                'Bien',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              color: const Color.fromARGB(255, 33, 172, 236),
                              child: const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Regular',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              color: const Color.fromARGB(255, 33, 172, 236),
                              child: const Text(
                                'Malo',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              color: const Color.fromARGB(255, 33, 172, 236),
                              child: const Text(
                                'No Aplica',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        //---------------- Cubiertas -----------------------------
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  (_cubiertas != null
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : Container()),
                                  const Text(
                                    'Cubiertas',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Radio<Option4>(
                              value: Option4.Bien,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _cubiertas,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _cubiertas = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Regular,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _cubiertas,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _cubiertas = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Malo,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _cubiertas,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _cubiertas = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.NoAplica,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _cubiertas,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _cubiertas = value;
                                });
                              },
                            ),
                          ],
                        ),

                        //---------------- CorreasCinturon -----------------------------
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  (_correasCinturon != null
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : Container()),
                                  const Text(
                                    'Correas/Cinturón',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Radio<Option4>(
                              value: Option4.Bien,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _correasCinturon,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _correasCinturon = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Regular,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _correasCinturon,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _correasCinturon = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Malo,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _correasCinturon,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _correasCinturon = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.NoAplica,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _correasCinturon,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _correasCinturon = value;
                                });
                              },
                            ),
                          ],
                        ),

                        //---------------- ApoyaCabezas -----------------------------
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  (_apoyaCabezas != null
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : Container()),
                                  const Text(
                                    'Apoya cabezas',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Radio<Option4>(
                              value: Option4.Bien,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _apoyaCabezas,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _apoyaCabezas = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Regular,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _apoyaCabezas,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _apoyaCabezas = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Malo,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _apoyaCabezas,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _apoyaCabezas = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.NoAplica,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _apoyaCabezas,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _apoyaCabezas = value;
                                });
                              },
                            ),
                          ],
                        ),
                        //---------------- LimpiaVidrios -----------------------------
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  (_limpiaVidrios != null
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : Container()),
                                  const Text(
                                    'Limpiavidrios',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Radio<Option4>(
                              value: Option4.Bien,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _limpiaVidrios,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _limpiaVidrios = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Regular,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _limpiaVidrios,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _limpiaVidrios = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Malo,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _limpiaVidrios,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _limpiaVidrios = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.NoAplica,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _limpiaVidrios,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _limpiaVidrios = value;
                                });
                              },
                            ),
                          ],
                        ),
                        //---------------- Espejos -----------------------------
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  (_espejos != null
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : Container()),
                                  const Text(
                                    'Espejos',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Radio<Option4>(
                              value: Option4.Bien,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _espejos,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _espejos = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Regular,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _espejos,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _espejos = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Malo,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _espejos,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _espejos = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.NoAplica,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _espejos,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _espejos = value;
                                });
                              },
                            ),
                          ],
                        ),
                        //---------------- IndicadoresDeGiro -----------------------------
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  (_indicadoresDeGiro != null
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : Container()),
                                  const Text(
                                    'Indicad. de giro',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Radio<Option4>(
                              value: Option4.Bien,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _indicadoresDeGiro,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _indicadoresDeGiro = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Regular,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _indicadoresDeGiro,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _indicadoresDeGiro = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Malo,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _indicadoresDeGiro,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _indicadoresDeGiro = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.NoAplica,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _indicadoresDeGiro,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _indicadoresDeGiro = value;
                                });
                              },
                            ),
                          ],
                        ),
                        //---------------- Bocina -----------------------------
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  (_bocina != null
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : Container()),
                                  const Text(
                                    'Bocina',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Radio<Option4>(
                              value: Option4.Bien,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _bocina,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _bocina = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Regular,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _bocina,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _bocina = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Malo,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _bocina,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _bocina = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.NoAplica,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _bocina,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _bocina = value;
                                });
                              },
                            ),
                          ],
                        ),
                        //---------------- DispositivoPAT -----------------------------
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  (_dispositivoPAT != null
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : Container()),
                                  const Text(
                                    'Dispositivo PAT',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Radio<Option4>(
                              value: Option4.Bien,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _dispositivoPAT,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _dispositivoPAT = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Regular,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _dispositivoPAT,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _dispositivoPAT = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Malo,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _dispositivoPAT,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _dispositivoPAT = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.NoAplica,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _dispositivoPAT,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _dispositivoPAT = value;
                                });
                              },
                            ),
                          ],
                        ),
                        //---------------- Ganchos -----------------------------
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  (_ganchos != null
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : Container()),
                                  const Text(
                                    'Ganchos',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Radio<Option4>(
                              value: Option4.Bien,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _ganchos,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _ganchos = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Regular,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _ganchos,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _ganchos = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Malo,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _ganchos,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _ganchos = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.NoAplica,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _ganchos,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _ganchos = value;
                                });
                              },
                            ),
                          ],
                        ),
                        //---------------- Alarma de Retroceso -----------------------------
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  (_alarmaRetroceso != null
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : Container()),
                                  const Text(
                                    'Alarma de retroc.',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Radio<Option4>(
                              value: Option4.Bien,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _alarmaRetroceso,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _alarmaRetroceso = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Regular,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _alarmaRetroceso,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _alarmaRetroceso = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Malo,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _alarmaRetroceso,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _alarmaRetroceso = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.NoAplica,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _alarmaRetroceso,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _alarmaRetroceso = value;
                                });
                              },
                            ),
                          ],
                        ),
                        //---------------- Mangueras Circuito Hidraulico -----------------------------
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  (_manguerasCircuitoHidraulico != null
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : Container()),
                                  const Text(
                                    'Mang. circ. hidr.',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Radio<Option4>(
                              value: Option4.Bien,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _manguerasCircuitoHidraulico,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _manguerasCircuitoHidraulico = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Regular,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _manguerasCircuitoHidraulico,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _manguerasCircuitoHidraulico = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Malo,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _manguerasCircuitoHidraulico,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _manguerasCircuitoHidraulico = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.NoAplica,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _manguerasCircuitoHidraulico,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _manguerasCircuitoHidraulico = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                //--------------------------------------------------------------------
                //------------------------- Segunda Tabla ----------------------------
                //--------------------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    color: Colors.white,
                    child: Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: const {
                        0: FractionColumnWidth(0.36),
                        1: FractionColumnWidth(0.16),
                        2: FractionColumnWidth(0.16),
                        3: FractionColumnWidth(0.16),
                        4: FractionColumnWidth(0.16),
                      },
                      border: TableBorder.all(),
                      children: [
                        //---------------- Título -----------------------------
                        TableRow(
                          children: [
                            Container(
                              color: const Color.fromARGB(255, 33, 172, 236),
                              child: const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Concepto',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              color: const Color.fromARGB(255, 33, 172, 236),
                              child: const Text(
                                'Bien',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              color: const Color.fromARGB(255, 33, 172, 236),
                              child: const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Regular',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              color: const Color.fromARGB(255, 33, 172, 236),
                              child: const Text(
                                'Malo',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              color: const Color.fromARGB(255, 33, 172, 236),
                              child: const Text(
                                'No Aplica',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        //---------------- FarosDelanteros -----------------------------
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  (_farosDelanteros != null
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : Container()),
                                  const Text(
                                    'Faros delanteros',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Radio<Option4>(
                              value: Option4.Bien,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _farosDelanteros,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _farosDelanteros = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Regular,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _farosDelanteros,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _farosDelanteros = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Malo,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _farosDelanteros,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _farosDelanteros = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.NoAplica,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _farosDelanteros,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _farosDelanteros = value;
                                });
                              },
                            ),
                          ],
                        ),

                        //---------------- FarosTraseros -----------------------------
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  (_farosTraseros != null
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : Container()),
                                  const Text(
                                    'Faros traseros',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Radio<Option4>(
                              value: Option4.Bien,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _farosTraseros,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _farosTraseros = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Regular,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _farosTraseros,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _farosTraseros = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Malo,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _farosTraseros,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _farosTraseros = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.NoAplica,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _farosTraseros,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _farosTraseros = value;
                                });
                              },
                            ),
                          ],
                        ),
                        //---------------- Luz de Posicion -----------------------------
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  (_luzDePosicion != null
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : Container()),
                                  const Text(
                                    'Luz de posición',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Radio<Option4>(
                              value: Option4.Bien,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _luzDePosicion,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _luzDePosicion = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Regular,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _luzDePosicion,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _luzDePosicion = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Malo,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _luzDePosicion,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _luzDePosicion = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.NoAplica,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _luzDePosicion,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _luzDePosicion = value;
                                });
                              },
                            ),
                          ],
                        ),
                        //---------------- Luz de Freno -----------------------------
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  (_luzDeFreno != null
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : Container()),
                                  const Text(
                                    'Luz de freno',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Radio<Option4>(
                              value: Option4.Bien,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _luzDeFreno,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _luzDeFreno = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Regular,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _luzDeFreno,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _luzDeFreno = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Malo,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _luzDeFreno,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _luzDeFreno = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.NoAplica,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _luzDeFreno,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _luzDeFreno = value;
                                });
                              },
                            ),
                          ],
                        ),
                        //---------------- Luz de retroceso -----------------------------
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  (_luzDeRetroceso != null
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : Container()),
                                  const Text(
                                    'Luz de retroceso',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Radio<Option4>(
                              value: Option4.Bien,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _luzDeRetroceso,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _luzDeRetroceso = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Regular,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _luzDeRetroceso,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _luzDeRetroceso = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Malo,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _luzDeRetroceso,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _luzDeRetroceso = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.NoAplica,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _luzDeRetroceso,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _luzDeRetroceso = value;
                                });
                              },
                            ),
                          ],
                        ),
                        //---------------- Luz Emergencia -----------------------------
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  (_luzDeEmergencia != null
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : Container()),
                                  const Text(
                                    'Luz de emergencia',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Radio<Option4>(
                              value: Option4.Bien,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _luzDeEmergencia,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _luzDeEmergencia = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Regular,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _luzDeEmergencia,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _luzDeEmergencia = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Malo,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _luzDeEmergencia,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _luzDeEmergencia = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.NoAplica,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _luzDeEmergencia,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _luzDeEmergencia = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                //--------------------------------------------------------------------
                //------------------------- Tercera Tabla ----------------------------
                //--------------------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    color: Colors.white,
                    child: Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: const {
                        0: FractionColumnWidth(0.36),
                        1: FractionColumnWidth(0.16),
                        2: FractionColumnWidth(0.16),
                        3: FractionColumnWidth(0.16),
                        4: FractionColumnWidth(0.16),
                      },
                      border: TableBorder.all(),
                      children: [
                        //---------------- Título -----------------------------
                        TableRow(
                          children: [
                            Container(
                              color: const Color.fromARGB(255, 33, 172, 236),
                              child: const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Concepto',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              color: const Color.fromARGB(255, 33, 172, 236),
                              child: const Text(
                                'Bien',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              color: const Color.fromARGB(255, 33, 172, 236),
                              child: const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Regular',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              color: const Color.fromARGB(255, 33, 172, 236),
                              child: const Text(
                                'Malo',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              color: const Color.fromARGB(255, 33, 172, 236),
                              child: const Text(
                                'No Aplica',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        //---------------- BalizaPortatil -----------------------------
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  (_balizaPortatil != null
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : Container()),
                                  const Text(
                                    'Baliza portátil',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Radio<Option4>(
                              value: Option4.Bien,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _balizaPortatil,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _balizaPortatil = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Regular,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _balizaPortatil,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _balizaPortatil = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Malo,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _balizaPortatil,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _balizaPortatil = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.NoAplica,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _balizaPortatil,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _balizaPortatil = value;
                                });
                              },
                            ),
                          ],
                        ),
                        //---------------- Matafuegos -----------------------------
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  (_matafuegos != null
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : Container()),
                                  const Text(
                                    'Matafuegos',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Radio<Option4>(
                              value: Option4.Bien,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _matafuegos,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _matafuegos = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Regular,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _matafuegos,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _matafuegos = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Malo,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _matafuegos,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _matafuegos = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.NoAplica,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _matafuegos,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _matafuegos = value;
                                });
                              },
                            ),
                          ],
                        ),
                        //---------------- IdentificadorEmpresa -----------------------------
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  (_identificadorEmpresa != null
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : Container()),
                                  const Text(
                                    'Identif. de Empresa',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Radio<Option4>(
                              value: Option4.Bien,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _identificadorEmpresa,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _identificadorEmpresa = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Regular,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _identificadorEmpresa,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _identificadorEmpresa = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Malo,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _identificadorEmpresa,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _identificadorEmpresa = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.NoAplica,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _identificadorEmpresa,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _identificadorEmpresa = value;
                                });
                              },
                            ),
                          ],
                        ),
                        //---------------- SobresalientesPeligro -----------------------------
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  (_sobresalientesPeligro != null
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : Container()),
                                  const Text(
                                    'Sobresal. Peligro',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Radio<Option4>(
                              value: Option4.Bien,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _sobresalientesPeligro,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _sobresalientesPeligro = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Regular,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _sobresalientesPeligro,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _sobresalientesPeligro = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Malo,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _sobresalientesPeligro,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _sobresalientesPeligro = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.NoAplica,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _sobresalientesPeligro,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _sobresalientesPeligro = value;
                                });
                              },
                            ),
                          ],
                        ),
                        //---------------- Diagrama De Carga -----------------------------
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  (_diagramaDeCarga != null
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : Container()),
                                  const Text(
                                    'Diagrama de carga',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Radio<Option4>(
                              value: Option4.Bien,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _diagramaDeCarga,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _diagramaDeCarga = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Regular,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _diagramaDeCarga,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _diagramaDeCarga = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Malo,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _diagramaDeCarga,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _diagramaDeCarga = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.NoAplica,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _diagramaDeCarga,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _diagramaDeCarga = value;
                                });
                              },
                            ),
                          ],
                        ),

                        //---------------- Fajas -----------------------------
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  (_fajas != null
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : Container()),
                                  const Text(
                                    'Fajas',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Radio<Option4>(
                              value: Option4.Bien,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _fajas,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _fajas = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Regular,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _fajas,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _fajas = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Malo,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _fajas,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _fajas = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.NoAplica,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _fajas,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _fajas = value;
                                });
                              },
                            ),
                          ],
                        ),

                        //---------------- Grilletes -----------------------------
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  (_grilletes != null
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : Container()),
                                  const Text(
                                    'Grilletes',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Radio<Option4>(
                              value: Option4.Bien,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _grilletes,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _grilletes = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Regular,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _grilletes,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _grilletes = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Malo,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _grilletes,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _grilletes = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.NoAplica,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _grilletes,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _grilletes = value;
                                });
                              },
                            ),
                          ],
                        ),

                        //---------------- Cinta Sujecion Carga -----------------------------
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  (_cintaSujecionCarga != null
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.green,
                                        )
                                      : Container()),
                                  const Text(
                                    'Cinta suj. de carga',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Radio<Option4>(
                              value: Option4.Bien,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _cintaSujecionCarga,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _cintaSujecionCarga = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Regular,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _cintaSujecionCarga,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _cintaSujecionCarga = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.Malo,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _cintaSujecionCarga,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _cintaSujecionCarga = value;
                                });
                              },
                            ),
                            Radio<Option4>(
                              value: Option4.NoAplica,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              groupValue: _cintaSujecionCarga,
                              onChanged: (Option4? value) {
                                setState(() {
                                  _cintaSujecionCarga = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const Divider(color: Colors.white),
                _showJefeDirecto(),
                _showResponsableVehiculo(),
                _showObservaciones(),
                const Divider(color: Colors.white),
                const SizedBox(height: 5),
                _showButton(),
                const SizedBox(height: 15),
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
  //--------------------- _showNombreApellido -----------------------
  //-----------------------------------------------------------------

  Widget _showNombreApellido() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: TextField(
        controller: _nombreApellidoController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Nombre y Apellido...',
          labelText: 'Nombre y Apellido',
          errorText: _nombreApellidoShowError ? _nombreApellidoError : null,
          prefixIcon: const Icon(Icons.person),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _nombreApellido = value;
        },
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showDocumento ----------------------------
  //-----------------------------------------------------------------

  Widget _showDocumento() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: TextField(
        controller: _documentoController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Documento...',
          labelText: 'Documento',
          errorText: _documentoShowError ? _documentoError : null,
          prefixIcon: const Icon(Icons.person),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _documento = value;
        },
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showJefeDirecto --------------------------
  //-----------------------------------------------------------------

  Widget _showJefeDirecto() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: TextField(
        controller: _jefeDirectoController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Jefe Directo...',
          labelText: 'Jefe Directo',
          errorText: _jefeDirectoShowError ? _jefeDirectoError : null,
          prefixIcon: const Icon(Icons.person),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _jefeDirecto = value;
        },
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showResponsableVehiculo ------------------
  //-----------------------------------------------------------------

  Widget _showResponsableVehiculo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _responsableVehiculoController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Responsable Vehículo...',
          labelText: 'Responsable Vehículo',
          errorText: _responsableVehiculoShowError
              ? _responsableVehiculoError
              : null,
          prefixIcon: const Icon(Icons.person),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _responsableVehiculo = value;
        },
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
          hintText: 'Observaciones',
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
                  Text('Guardar Check List'),
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

    if (_cliente == 0) {
      isValid = false;
      final _ = showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Debe seleccionar un Cliente',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return isValid;
    }

    if (_codigo == '' || _vehiculo.numcha == '') {
      isValid = false;
      showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Debe seleccionar un Vehículo',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return isValid;
    }

    if (_vehiculo.numcha == '000000  ' && _nombreApellido == '') {
      isValid = false;
      showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Debe completar Nombre y Apellido',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return isValid;
    }

    if (_vehiculo.numcha == '000000  ' && _documento == '') {
      isValid = false;
      showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Debe completar Documento',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return isValid;
    }

    if (_vtv == OptionTwo.SI &&
        (_fechaVencVtv == null || _fechaVencVtv == '')) {
      isValid = false;
      showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Debe completar Fecha Vencimiento Vtv',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return isValid;
    }

    if (_vth == OptionTwo.SI &&
        (_fechaVencVth == null || _fechaVencVth == '')) {
      isValid = false;
      showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Debe completar Fecha Vencimiento Vth',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return isValid;
    }

    if (_seguro == OptionTwo.SI &&
        (_fechaVencSeguro == null || _fechaVencSeguro == '')) {
      isValid = false;
      showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Debe completar Fecha Vencimiento Seguro',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return isValid;
    }

    if (_jefeDirecto == '') {
      isValid = false;
      showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Debe completar Jefe Directo',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return isValid;
    }

    if (_jefeDirecto.length > 30) {
      isValid = false;
      showAlertDialog(
        context: context,
        title: 'Error',
        message:
            'Jefe Directo no puede superar los 30 caracteres. Ha escrito ${_jefeDirecto.length}.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return isValid;
    }

    if (_responsableVehiculo == '') {
      isValid = false;
      showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Debe completar Responsable Vehículo',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return isValid;
    }

    if (_responsableVehiculo.length > 30) {
      isValid = false;
      showAlertDialog(
        context: context,
        title: 'Error',
        message:
            'Responsable Vehiculo no puede superar los 30 caracteres. Ha escrito ${_responsableVehiculo.length}.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return isValid;
    }

    if (_observaciones.length > 200) {
      isValid = false;
      showAlertDialog(
        context: context,
        title: 'Error',
        message:
            'Observaciones no puede superar los 200 caracteres. Ha escrito ${_observaciones.length}.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return isValid;
    }

    if (_vtv == null ||
        _vth == null ||
        _seguro == null ||
        _cubiertas == null ||
        _correasCinturon == null ||
        _apoyaCabezas == null ||
        _limpiaVidrios == null ||
        _espejos == null ||
        _indicadoresDeGiro == null ||
        _bocina == null ||
        _dispositivoPAT == null ||
        _ganchos == null ||
        _alarmaRetroceso == null ||
        _manguerasCircuitoHidraulico == null ||
        _farosDelanteros == null ||
        _luzDePosicion == null ||
        _luzDeFreno == null ||
        _luzDeRetroceso == null ||
        _luzDeEmergencia == null ||
        _balizaPortatil == null ||
        _matafuegos == null ||
        _identificadorEmpresa == null ||
        _sobresalientesPeligro == null ||
        _diagramaDeCarga == null ||
        _fajas == null ||
        _grilletes == null ||
        _cintaSujecionCarga == null) {
      isValid = false;
      showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Debe seleccionar una opción en cada Concepto',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return isValid;
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
      'IDCheckList': widget.editMode == true ? widget.checkList.idCheckList : 0,
      'Fecha': DateTime.now().toString().substring(0, 10),
      'IDUser': widget.user.idUsuario,
      'IdCliente': _cliente,
      'IDVehiculo': _vehiculo.codveh,
      'VTV': _vtv.toString().substring(10, _vtv.toString().length),
      'FechaVencVTV': _fechaVencVtv != null
          ? _fechaVencVtv.toString().substring(0, 10)
          : '',
      'VTH': _vth.toString().substring(10, _vth.toString().length),
      'FechaVencVTH': _fechaVencVth != null
          ? _fechaVencVth.toString().substring(0, 10)
          : '',
      'Cubiertas': _cubiertas.toString().substring(
        8,
        _cubiertas.toString().length,
      ),
      'CorreaCinturon': _correasCinturon.toString().substring(
        8,
        _correasCinturon.toString().length,
      ),
      'ApoyaCabezas': _apoyaCabezas.toString().substring(
        8,
        _apoyaCabezas.toString().length,
      ),
      'Limpiavidrios': _limpiaVidrios.toString().substring(
        8,
        _limpiaVidrios.toString().length,
      ),
      'Espejos': _espejos.toString().substring(8, _espejos.toString().length),
      'IndicadoresDeGiro': _indicadoresDeGiro.toString().substring(
        8,
        _indicadoresDeGiro.toString().length,
      ),
      'Bocina': _bocina.toString().substring(8, _bocina.toString().length),
      'DispositivoPAT': _dispositivoPAT.toString().substring(
        8,
        _dispositivoPAT.toString().length,
      ),
      'Ganchos': _ganchos.toString().substring(8, _ganchos.toString().length),
      'AlarmaRetroceso': _alarmaRetroceso.toString().substring(
        8,
        _alarmaRetroceso.toString().length,
      ),
      'ManguerasCircuitoHidraulico': _manguerasCircuitoHidraulico
          .toString()
          .substring(8, _manguerasCircuitoHidraulico.toString().length),
      'FarosDelanteros': _farosDelanteros.toString().substring(
        8,
        _farosDelanteros.toString().length,
      ),
      'FarosTraseros': _farosTraseros.toString().substring(
        8,
        _farosTraseros.toString().length,
      ),
      'LuzPosicion': _luzDePosicion.toString().substring(
        8,
        _luzDePosicion.toString().length,
      ),
      'LuzFreno': _luzDeFreno.toString().substring(
        8,
        _luzDeFreno.toString().length,
      ),
      'LuzRetroceso': _luzDeRetroceso.toString().substring(
        8,
        _luzDeRetroceso.toString().length,
      ),
      'LuzEmergencia': _luzDeEmergencia.toString().substring(
        8,
        _luzDeEmergencia.toString().length,
      ),
      'BalizaPortatil': _balizaPortatil.toString().substring(
        8,
        _balizaPortatil.toString().length,
      ),
      'Matafuegos': _matafuegos.toString().substring(
        8,
        _matafuegos.toString().length,
      ),
      'IdentificadorEmpresa': _identificadorEmpresa.toString().substring(
        8,
        _identificadorEmpresa.toString().length,
      ),
      'SobreSalientesPeligro': _sobresalientesPeligro.toString().substring(
        8,
        _sobresalientesPeligro.toString().length,
      ),
      'DiagramaDeCarga': _diagramaDeCarga.toString().substring(
        8,
        _diagramaDeCarga.toString().length,
      ),
      'Fajas': _fajas.toString().substring(8, _fajas.toString().length),
      'Grilletes': _grilletes.toString().substring(
        8,
        _grilletes.toString().length,
      ),
      'CintaSujecionCarga': _cintaSujecionCarga.toString().substring(
        8,
        _cintaSujecionCarga.toString().length,
      ),
      'JefeDirecto': _jefeDirecto,
      'ResponsableVehiculo': _responsableVehiculo,
      'Observaciones': _observaciones,
      'GrupoC': _causante.grupo,
      'CausanteC': _causante.codigo,
      'DNI': _documento,
      'ApellidoNombre': _nombreApellido,
      'Seguro': _seguro.toString().substring(10, _seguro.toString().length),
      'FechaVencSeguro': _fechaVencSeguro != null
          ? _fechaVencSeguro.toString().substring(0, 10)
          : '',
    };

    Response? response;

    if (widget.editMode == false) {
      response = await ApiHelper.postNoToken(
        '/api/VehiculosCheckLists/PostVehiculosCheckLists',
        request,
      );
    }

    if (widget.editMode == true) {
      response = await ApiHelper.put(
        '/api/VehiculosCheckLists/',
        widget.checkList.idCheckList.toString(),
        request,
      );
    }

    setState(() {
      _showLoader = false;
    });

    if (!response!.isSuccess) {
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
  //--------------------- PLMayusc ----------------------------------
  //-----------------------------------------------------------------

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

      if (string[i] == ' ') {
        isSpace = true;
      } else {
        isSpace = false;
      }

      name = name + letter;
    }
    return name;
  }

  //-----------------------------------------------------------------
  //--------------------- _showFechaVTV -----------------------------
  //-----------------------------------------------------------------

  Widget _showFechaVTV() {
    return InkWell(
      onTap: _elegirFechaVencVtv,
      child: Container(
        alignment: Alignment.center,
        color: Colors.white,
        width: 100,
        height: 30,
        child: Text(
          _fechaVencVtv != null
              ? '    ${_fechaVencVtv!.day}/${_fechaVencVtv!.month}/${_fechaVencVtv!.year}'
              : '',
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showFechaVTH -----------------------------
  //-----------------------------------------------------------------

  Widget _showFechaVTH() {
    return InkWell(
      onTap: _elegirFechaVencVth,
      child: Container(
        alignment: Alignment.center,
        color: Colors.white,
        width: 100,
        height: 30,
        child: Text(
          _fechaVencVth != null
              ? '    ${_fechaVencVth!.day}/${_fechaVencVth!.month}/${_fechaVencVth!.year}'
              : '',
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showFechaSeguro --------------------------
  //-----------------------------------------------------------------

  Widget _showFechaSeguro() {
    return InkWell(
      onTap: _elegirFechaVencSeguro,
      child: Container(
        alignment: Alignment.center,
        color: Colors.white,
        width: 100,
        height: 30,
        child: Text(
          _fechaVencSeguro != null
              ? '    ${_fechaVencSeguro!.day}/${_fechaVencSeguro!.month}/${_fechaVencSeguro!.year}'
              : '',
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _elegirFechaVencVtv -----------------------
  //-----------------------------------------------------------------

  Future<void> _elegirFechaVencVtv() async {
    FocusScope.of(context).unfocus();
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      lastDate: DateTime(
        DateTime.now().year + 5,
        DateTime.now().month,
        DateTime.now().day,
      ),
    );
    if (selected != null && selected != _fechaVencVtv) {
      setState(() {
        _fechaVencVtv = selected;
      });
    }
  }

  //-----------------------------------------------------------------
  //--------------------- _elegirFechaVencVth -----------------------
  //-----------------------------------------------------------------

  Future<void> _elegirFechaVencVth() async {
    FocusScope.of(context).unfocus();
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      lastDate: DateTime(
        DateTime.now().year + 5,
        DateTime.now().month,
        DateTime.now().day,
      ),
    );
    if (selected != null && selected != _fechaVencVth) {
      setState(() {
        _fechaVencVth = selected;
      });
    }
  }

  //-----------------------------------------------------------------
  //--------------------- _elegirFechaVencSeguro --------------------
  //-----------------------------------------------------------------

  Future<void> _elegirFechaVencSeguro() async {
    FocusScope.of(context).unfocus();
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      lastDate: DateTime(
        DateTime.now().year + 5,
        DateTime.now().month,
        DateTime.now().day,
      ),
    );
    if (selected != null && selected != _fechaVencVth) {
      setState(() {
        _fechaVencSeguro = selected;
      });
    }
  }

  //-----------------------------------------------------------------------------
  //----------------------------- _getClientes ----------------------------------
  //-----------------------------------------------------------------------------

  Future<void> _getClientes() async {
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

    Response response = Response(isSuccess: false);

    response = await ApiHelper.getClientes2();

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

    setState(() {
      _clientes = response.result;
      _clientes.sort((a, b) {
        return a.nombre.toString().toLowerCase().compareTo(
          b.nombre.toString().toLowerCase(),
        );
      });
    });
  }

  //----------------------------------------------------------------------
  //------------------------------ _showClientes--------------------------
  //----------------------------------------------------------------------

  Widget _showClientes() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 0, right: 0, top: 5),
            child: _clientes.isEmpty
                ? Row(
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(width: 10),
                      Text('Cargando Clientes...'),
                    ],
                  )
                : Container(
                    width: 200,
                    padding: const EdgeInsets.all(10),
                    child: DropdownButtonFormField(
                      initialValue: _cliente,
                      isExpanded: true,
                      isDense: true,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Elija un Cliente...',
                        labelText: 'Cliente',
                        errorText: _clienteShowError ? _clienteError : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: _getComboClientes(),
                      onChanged: (value) {
                        _cliente = value as int;
                      },
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  //----------------------------------------------------------------------
  //------------------------------ _getComboClientes----------------------
  //----------------------------------------------------------------------

  List<DropdownMenuItem<int>> _getComboClientes() {
    List<DropdownMenuItem<int>> list = [];
    list.add(
      const DropdownMenuItem(value: 0, child: Text('Elija un Cliente...')),
    );

    for (var cliente in _clientes) {
      list.add(
        DropdownMenuItem(
          value: cliente.nrocliente,
          child: Text(cliente.nombre.toString()),
        ),
      );
    }

    return list;
  }

  //-----------------------------------------------------------------
  //--------------------- _showChapa --------------------------------
  //-----------------------------------------------------------------

  Widget _showChapa() {
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
  //--------------------- _showSearchButton -------------------------
  //-----------------------------------------------------------------

  Widget _showSearchButton() {
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

  //-----------------------------------------------------------------------------
  //--------------------------------- _search -----------------------------------
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

    _getVehiculo();
  }

  //-----------------------------------------------------------------------------
  //------------------------------- _getVehiculo --------------------------------
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
        message: 'Patente no existe en la BD',
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
      _vehiculoAux = response.result;
      if (_vehiculoAux.numcha != '000000  ') {
        _nombreApellido = '';
        _documento = '';
      }
    });

    if (_vehiculoAux.habilitado == 0) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Vehículo no habilitado',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      setState(() {
        _vehiculoAux = _vehiculoVacio;
        _vehiculo = _vehiculoVacio;
        _showLoader = false;
      });
      return;
    }
    if (_vehiculoAux.habilitaChecklist == 0) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Vehículo no habilitado para CheckList',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      setState(() {
        _vehiculoAux = _vehiculoVacio;
        _vehiculo = _vehiculoVacio;
        _showLoader = false;
      });
      return;
    }
    _vehiculo = _vehiculoAux;
  }

  //-----------------------------------------------------------------
  //--------------------- _showInfo ---------------------------------
  //-----------------------------------------------------------------

  Widget _showInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Card(
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
                icon: Icons.numbers_outlined,
                nombredato: 'Modelo:',
                dato: _vehiculo.aniofa != 0
                    ? _gato(_vehiculo.aniofa.toString())
                    : '',
              ),
              CustomRow(
                icon: Icons.description,
                nombredato: 'Descripción:',
                dato: _gato(_vehiculo.descripcion),
              ),
              CustomRow(
                icon: Icons.filter_1,
                nombredato: 'N° Motor:',
                dato: _gato(_vehiculo.nmotor),
              ),
              CustomRow(
                icon: Icons.filter_2,
                nombredato: 'N° Chásis:',
                dato: _gato(_vehiculo.chasis),
              ),
              CustomRow(
                icon: Icons.date_range,
                nombredato: 'Venc. VTV:',
                dato: _vehiculo.fechaVencITV != 0
                    ? _gato(
                        DateFormat('dd/MM/yyyy').format(
                          DateTime(2022, 01, 01).add(
                            Duration(days: (_vehiculo.fechaVencITV! - 80723)),
                          ),
                        ),
                      )
                    : '',
                alert: _vehiculo.fechaVencITV != 0
                    ? DateTime(2022, 01, 01)
                                  .add(
                                    Duration(
                                      days: (_vehiculo.fechaVencITV! - 80723),
                                    ),
                                  )
                                  .difference(DateTime.now()) >=
                              const Duration(days: 50)
                          ? false
                          : true
                    : false,
              ),
              CustomRow(
                icon: Icons.date_range,
                nombredato: 'Venc. Oblea Gas:',
                dato: _vehiculo.fechaVencObleaGAS != 0
                    ? _gato(
                        DateFormat('dd/MM/yyyy').format(
                          DateTime(2022, 01, 01).add(
                            Duration(
                              days: (_vehiculo.fechaVencObleaGAS! - 80723),
                            ),
                          ),
                        ),
                      )
                    : '',
                alert: _vehiculo.fechaVencObleaGAS != 0
                    ? DateTime(2022, 01, 01)
                                  .add(
                                    Duration(
                                      days:
                                          (_vehiculo.fechaVencObleaGAS! -
                                          80723),
                                    ),
                                  )
                                  .difference(DateTime.now()) >=
                              const Duration(days: 30)
                          ? false
                          : true
                    : false,
              ),
              CustomRow(
                icon: Icons.security,
                nombredato: 'N° Póliza Seguro:',
                dato: _gato(_vehiculo.nroPolizaSeguro),
              ),
              CustomRow(
                icon: Icons.request_quote,
                nombredato: 'Centro de Costo:',
                dato: _gato(_vehiculo.centroCosto),
              ),
              CustomRow(
                icon: Icons.factory,
                nombredato: 'Propiedad de:',
                dato: _gato(_vehiculo.propiedadDe),
              ),
              CustomRow(
                icon: Icons.code,
                nombredato: 'Telepase:',
                dato: _gato(_vehiculo.telepase),
              ),
              CustomRow(
                icon: Icons.ac_unit,
                nombredato: _vehiculo.usaHoras == 1 ? 'Horas:' : 'Kilómetros',
                dato: _vehiculo.kmhsactual != 0
                    ? _gato(
                        _vehiculo.kmhsactual != null
                            ? _vehiculo.kmhsactual.toString()
                            : '',
                      )
                    : '',
              ),
              CustomRow(
                icon: Icons.circle,
                nombredato: 'Habilitado:',
                dato: _vehiculo.numcha != ''
                    ? (_vehiculo.habilitado == 1 ? 'Si' : 'No')
                    : '',
              ),
              CustomRow(
                icon: Icons.code,
                nombredato: 'Módulo:',
                dato: _gato(_vehiculo.modulo),
              ),
              CustomRow(
                icon: Icons.person,
                nombredato: 'Asignado a:',
                dato: _gato(_vehiculo.campomemo),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //-----------------------------------------------------------------------------
  //---------------------------------- _gato ------------------------------------
  //-----------------------------------------------------------------------------

  String _gato(String? dato) {
    return dato != null ? dato.toString() : '';
  }

  //-----------------------------------------------------------------
  //--------------------- _showLegajo -------------------------------
  //-----------------------------------------------------------------

  Widget _showLegajo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _codigo2Controller,
        decoration: InputDecoration(
          iconColor: const Color(0xFF781f1e),
          prefixIconColor: const Color(0xFF781f1e),
          hoverColor: const Color(0xFF781f1e),
          focusColor: const Color(0xFF781f1e),
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingrese Legajo o Documento del empleado...',
          labelText: 'Legajo o Documento:',
          errorText: _codigo2ShowError ? _codigo2Error : null,
          prefixIcon: const Icon(Icons.badge),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF781f1e)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          _codigo2 = value;
        },
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showSearch2Button ------------------------
  //-----------------------------------------------------------------

  Widget _showSearch2Button() {
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
              onPressed: () => _searchLegajo(),
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
  //--------------------- _searchLegajo -----------------------------
  //-----------------------------------------------------------------

  Future<void> _searchLegajo() async {
    FocusScope.of(context).unfocus();
    if (_codigo2.isEmpty) {
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

    Response response = await ApiHelper.getCausante(_codigo2);

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
        _causante = _causanteVacio;
        _showLoader = false;
      });
      return;
    }

    setState(() {
      _showLoader = false;
      _causante = response.result;
      _nombreApellido = _causante.nombre;
      _nombreApellidoController.text = _causante.nombre;
      _documento = _causante.nroSAP.toString();
      _documentoController.text = _causante.nroSAP.toString();
    });
  }

  //-----------------------------------------------------------------
  //--------------------- _showInfo2 --------------------------------
  //-----------------------------------------------------------------

  Widget _showInfo2() {
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

  //-------------------------------------------------------------
  //-------------------- _loadFields ----------------------------
  //-------------------------------------------------------------

  void _loadFields() async {
    _cliente = widget.checkList.idCliente as int;
    _codigo = widget.checkList.numcha.toString();
    _codigoController.text = widget.checkList.numcha.toString();

    _codigo2 = widget.checkList.causanteC.toString();
    _codigo2Controller.text = widget.checkList.causanteC.toString();

    _vtv = widget.checkList.vtv == 'SI' ? OptionTwo.SI : OptionTwo.NO;

    _fechaVencVtv = widget.checkList.fechaVencVTV == null
        ? null
        : DateTime.parse(widget.checkList.fechaVencVTV.toString());

    _vth = widget.checkList.vth == 'SI' ? OptionTwo.SI : OptionTwo.NO;
    _fechaVencVth = widget.checkList.fechaVencVTH == null
        ? null
        : DateTime.parse(widget.checkList.fechaVencVTH.toString());

    _seguro = widget.checkList.seguro == 'SI' ? OptionTwo.SI : OptionTwo.NO;
    _fechaVencSeguro = widget.checkList.fechaVencSeguro == null
        ? null
        : DateTime.parse(widget.checkList.fechaVencSeguro.toString());

    _cubiertas = _option4(widget.checkList.cubiertas.toString());
    _correasCinturon = _option4(widget.checkList.correaCinturon.toString());
    _apoyaCabezas = _option4(widget.checkList.apoyaCabezas.toString());
    _limpiaVidrios = _option4(widget.checkList.limpiavidrios.toString());
    _espejos = _option4(widget.checkList.espejos.toString());
    _indicadoresDeGiro = _option4(
      widget.checkList.indicadoresDeGiro.toString(),
    );
    _bocina = _option4(widget.checkList.bocina.toString());
    _dispositivoPAT = _option4(widget.checkList.dispositivoPAT.toString());
    _ganchos = _option4(widget.checkList.ganchos.toString());
    _alarmaRetroceso = _option4(widget.checkList.alarmaRetroceso.toString());
    _manguerasCircuitoHidraulico = _option4(
      widget.checkList.manguerasCircuitoHidraulico.toString(),
    );

    _farosDelanteros = _option4(widget.checkList.farosDelanteros.toString());
    _farosTraseros = _option4(widget.checkList.farosTraseros.toString());
    _luzDePosicion = _option4(widget.checkList.luzPosicion.toString());
    _luzDeFreno = _option4(widget.checkList.luzFreno.toString());
    _luzDeRetroceso = _option4(widget.checkList.luzRetroceso.toString());
    _luzDeEmergencia = _option4(widget.checkList.luzEmergencia.toString());

    _balizaPortatil = _option4(widget.checkList.balizaPortatil.toString());
    _matafuegos = _option4(widget.checkList.matafuegos.toString());
    _identificadorEmpresa = _option4(
      widget.checkList.identificadorEmpresa.toString(),
    );
    _sobresalientesPeligro = _option4(
      widget.checkList.sobreSalientesPeligro.toString(),
    );
    _diagramaDeCarga = _option4(widget.checkList.diagramaDeCarga.toString());
    _fajas = _option4(widget.checkList.fajas.toString());
    _grilletes = _option4(widget.checkList.grilletes.toString());
    _cintaSujecionCarga = _option4(
      widget.checkList.cintaSujecionCarga.toString(),
    );

    _jefeDirecto = widget.checkList.jefeDirecto.toString();
    _jefeDirectoController.text = widget.checkList.jefeDirecto.toString();
    _responsableVehiculo = widget.checkList.responsableVehiculo.toString();
    _responsableVehiculoController.text = widget.checkList.responsableVehiculo
        .toString();
    _observaciones = widget.checkList.observaciones.toString();
    _observacionesController.text = widget.checkList.observaciones.toString();

    _getVehiculo();
    _getCausante();
    setState(() {});
  }

  //-------------------------------------------------------------
  //-------------------- _option4 -------------------------------
  //-------------------------------------------------------------

  Option4 _option4(String dato) {
    Option4 option4 = Option4.Bien;

    if (dato == 'Bien') {
      option4 = Option4.Bien;
    }

    if (dato == 'Regular') {
      option4 = Option4.Regular;
    }

    if (dato == 'Malo') {
      option4 = Option4.Malo;
    }

    if (dato == 'NoAplica') {
      option4 = Option4.NoAplica;
      var a = 1;
    }

    return option4;
  }
}
