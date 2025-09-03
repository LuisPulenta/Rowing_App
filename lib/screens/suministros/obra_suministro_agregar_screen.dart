import 'dart:convert';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:camera/camera.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rowing_app/helpers/helpers.dart';

import '../../components/loader_component.dart';
import '../../helpers/resize_image.dart';
import '../../models/models.dart';
import '../screens.dart';

class ObraSuministroAgregarScreen extends StatefulWidget {
  final User user;
  final bool editMode;

  final ObrasNuevoSuministro suministro;
  const ObraSuministroAgregarScreen({
    super.key,
    required this.user,
    required this.editMode,
    required this.suministro,
  });

  @override
  State<ObraSuministroAgregarScreen> createState() =>
      _ObraSuministroAgregarScreenState();
}

class _ObraSuministroAgregarScreenState
    extends State<ObraSuministroAgregarScreen>
    with SingleTickerProviderStateMixin {
  //--------------------------------------------------------------
  //-------------------------- Variables -------------------------
  //--------------------------------------------------------------

  List<ObrasNuevoSuministro> _suministros = [];

  String dniAntesEditar = '';

  bool _photoChangedDNIFrente = false;
  bool _photoChangedDNIDorso = false;
  bool _photoChangedAntes1 = false;
  bool _photoChangedAntes2 = false;
  bool _photoChangedDespues1 = false;
  bool _photoChangedDespues2 = false;
  bool _signatureChanged = false;
  int _enviado = 1;

  List<DropdownMenuItem<String>> _itemsTipoRed = [];
  String _tipoRed = 'Seleccione Tipo de Red...';
  String _optionTipoRed = 'Seleccione Tipo de Red...';
  final String _optionTipoRedError = '';
  final bool _optionTipoRedShowError = false;
  List<Option2> _listoptionsTipoRed = [];

  List<DropdownMenuItem<String>> _itemsConexionDirecta = [];
  String _conexionDirecta = 'Seleccione Conexión Directa...';
  String _optionConexionDirecta = 'Seleccione Conexión Directa...';
  final String _optionConexionDirectaError = '';
  final bool _optionConexionDirectaShowError = false;
  List<Option2> _listoptionsConexionDirecta = [];

  List<DropdownMenuItem<String>> _itemsRetiroConexion = [];
  String _retiroConexion = 'Seleccione Retiro Conexión...';
  String _optionRetiroConexion = 'Seleccione Retiro Conexión...';
  final String _optionRetiroConexionError = '';
  final bool _optionRetiroConexionShowError = false;
  List<Option2> _listoptionsRetiroConexion = [];

  late XFile _imageFrente;
  late XFile _imageDorso;
  late XFile _imageAntes1;
  late XFile _imageAntes2;
  late XFile _imageDespues1;
  late XFile _imageDespues2;
  late ByteData? _signature;

  TabController? _tabController;
  bool _showLoader = false;
  final String _textComponent = 'Por favor espere...';
  int paraSincronizar = 0;

  bool _corte = false;
  bool _denuncia = false;
  bool _retirocrucecalle = false;
  bool _trabajoconhidro = false;
  bool _postepodrido = false;

  String _name = '';
  String _nameError = '';
  bool _nameShowError = false;
  final TextEditingController _nameController = TextEditingController();

  String _document = '';
  String _documentError = '';
  bool _documentShowError = false;
  final TextEditingController _documentController = TextEditingController();

  String? _domicilio = '';
  final String _domicilioError = '';
  final bool _domicilioShowError = false;
  final TextEditingController _domicilioController = TextEditingController();

  String? _barrio = '';
  final String _barrioError = '';
  final bool _barrioShowError = false;
  final TextEditingController _barrioController = TextEditingController();

  String? _localidad = '';
  final String _localidadError = '';
  final bool _localidadShowError = false;
  final TextEditingController _localidadController = TextEditingController();

  String? _partido = '';
  final String _partidoError = '';
  final bool _partidoShowError = false;
  final TextEditingController _partidoController = TextEditingController();

  String? _entrecalles1 = '';
  final String _entrecalles1Error = '';
  final bool _entrecalles1ShowError = false;
  final TextEditingController _entrecalles1Controller = TextEditingController();

  String? _entrecalles2 = '';
  final String _entrecalles2Error = '';
  final bool _entrecalles2ShowError = false;
  final TextEditingController _entrecalles2Controller = TextEditingController();

  String _telefono = '';
  final String _telefonoError = '';
  final bool _telefonoShowError = false;
  final TextEditingController _telefonoController = TextEditingController();

  String _email = '';
  final String _emailError = '';
  final bool _emailShowError = false;
  final TextEditingController _emailController = TextEditingController();

  final String _direccion = '';
  final String _option2 = '';

  String? _enre = '';
  final String _enreError = '';
  final bool _enreShowError = false;
  final TextEditingController _enreController = TextEditingController();

  String? _otro = '';
  final String _otroError = '';
  final bool _otroShowError = false;
  final TextEditingController _otroController = TextEditingController();

  String? _medidorcolocado = '';
  final String _medidorcolocadoError = '';
  final bool _medidorcolocadoShowError = false;
  final TextEditingController _medidorcolocadoController =
      TextEditingController();

  String? _medidorvecino = '';
  final String _medidorvecinoError = '';
  final bool _medidorvecinoShowError = false;
  final TextEditingController _medidorvecinoController =
      TextEditingController();

  String? _tensionContratada = '';
  final String _tensionContratadaError = '';
  final bool _tensionContratadaShowError = false;
  final TextEditingController _tensionContratadaController =
      TextEditingController();

  String? _potenciaContratada = '';
  final String _potenciaContratadaError = '';
  final bool _potenciaContratadaShowError = false;
  final TextEditingController _potenciaContratadaController =
      TextEditingController();

  String? _mtsCableRetirado = '';
  final String _mtsCableRetiradoError = '';
  final bool _mtsCableRetiradoShowError = false;
  final TextEditingController _mtsCableRetiradoController =
      TextEditingController();

  String? _observaciones = '';
  final String _observacionesError = '';
  final bool _observacionesShowError = false;
  final TextEditingController _observacionesController =
      TextEditingController();

  //--------------------------------------------------------------
  //-------------------------- initState -------------------------
  //--------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _getlistOptionsTipoRed();
    _tabController = TabController(length: 3, vsync: this);
    if (widget.editMode) {
      dniAntesEditar = widget.suministro.dni.toString();
      _loadFields();
    }
  }

  //--------------------------------------------------------------
  //-------------------------- Pantalla --------------------------
  //--------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    double ancho = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: widget.editMode
            ? const Text('Editar Suministro')
            : const Text('Nuevo Suministro'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: _guardar, icon: const Icon(Icons.save)),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff8c8c94), Color(0xff8c8c94)],
              ),
            ),
            child: TabBarView(
              controller: _tabController,
              physics: const AlwaysScrollableScrollPhysics(),
              dragStartBehavior: DragStartBehavior.start,
              children: <Widget>[
                //-------------------------------------------------------------------------
                //-------------------------- 1° TABBAR ------------------------------------
                //-------------------------------------------------------------------------
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      _showDocument(),
                      _showName(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Text(
                            'DNI Frente',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'DNI Dorso',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      _showButtonsDNI(ancho),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Text(
                            'Firma Cliente',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      _showButtonsFirma(ancho),
                      _showDomicilio(),
                      _showBarrio(),
                      _showLocalidad(),
                      _showPartido(),
                      _showEntrecalles1(),
                      _showEntrecalles2(),
                      _showTelefono(),
                      _showEmail(),
                      Center(
                        child: _showLoader
                            ? LoaderComponent(text: _textComponent)
                            : Container(),
                      ),
                    ],
                  ),
                ),

                //-------------------------------------------------------------------------
                //-------------------------- 2° TABBAR ------------------------------------
                //-------------------------------------------------------------------------
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: SwitchListTile.adaptive(
                              title: const Text('Corte:'),
                              activeColor: const Color(0xFF781f1e),
                              value: _corte,
                              onChanged: (value) {
                                _corte = value;
                                setState(() {});
                              },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: SwitchListTile.adaptive(
                              title: const Text('Denuncia:'),
                              activeColor: const Color(0xFF781f1e),
                              value: _denuncia,
                              onChanged: (value) {
                                _denuncia = value;
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: SwitchListTile.adaptive(
                              title: const Text('Retiro Cruce Calle:'),
                              activeColor: const Color(0xFF781f1e),
                              value: _retirocrucecalle,
                              onChanged: (value) {
                                _retirocrucecalle = value;
                                setState(() {});
                              },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: SwitchListTile.adaptive(
                              title: const Text('Trabajo con Hidro:'),
                              activeColor: const Color(0xFF781f1e),
                              value: _trabajoconhidro,
                              onChanged: (value) {
                                _trabajoconhidro = value;
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: SwitchListTile.adaptive(
                              title: const Text('Poste podrido:'),
                              activeColor: const Color(0xFF781f1e),
                              value: _postepodrido,
                              onChanged: (value) {
                                _postepodrido = value;
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 0,
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 70,
                              child: Text('Tipo de Red: '),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: DropdownButtonFormField(
                                  items: _itemsTipoRed,
                                  initialValue: _optionTipoRed,
                                  onChanged: (option2) {
                                    setState(() {
                                      _optionTipoRed = option2.toString();
                                      _tipoRed = option2.toString();
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Seleccione Tipo de Red...',
                                    labelText: '',
                                    fillColor:
                                        _tipoRed == 'Seleccione Tipo de Red...'
                                        ? Colors.yellow[200]
                                        : Colors.white,
                                    filled: true,
                                    errorText: _optionTipoRedShowError
                                        ? _optionTipoRedError
                                        : null,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 0,
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 70,
                              child: Text('Conexión Directa: '),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: DropdownButtonFormField(
                                  items: _itemsConexionDirecta,
                                  initialValue: _optionConexionDirecta,
                                  onChanged: (option2) {
                                    setState(() {
                                      _optionConexionDirecta = option2
                                          .toString();
                                      _conexionDirecta = option2.toString();
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Seleccione Conexión Directa...',
                                    labelText: '',
                                    fillColor:
                                        _conexionDirecta ==
                                            'Seleccione Conexión Directa...'
                                        ? Colors.yellow[200]
                                        : Colors.white,
                                    filled: true,
                                    errorText: _optionConexionDirectaShowError
                                        ? _optionConexionDirectaError
                                        : null,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 0,
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 70,
                              child: Text('Retiro Conexión: '),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: DropdownButtonFormField(
                                  items: _itemsRetiroConexion,
                                  initialValue: _optionRetiroConexion,
                                  onChanged: (option2) {
                                    setState(() {
                                      _optionRetiroConexion = option2
                                          .toString();
                                      _retiroConexion = option2.toString();
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Seleccione Retiro Conexión...',
                                    labelText: '',
                                    fillColor:
                                        _retiroConexion ==
                                            'Seleccione Retiro Conexión...'
                                        ? Colors.yellow[200]
                                        : Colors.white,
                                    filled: true,
                                    errorText: _optionRetiroConexionShowError
                                        ? _optionRetiroConexionError
                                        : null,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _showEnre(),
                      _showOtro(),
                      _showMedidorColocado(),
                      _showMedidorVecino(),
                      _showTensionContratada(),
                      _showPotenciaContratada(),
                      _showMtsCableRetirado(),
                      _showObservaciones(),
                      Center(
                        child: _showLoader
                            ? LoaderComponent(text: _textComponent)
                            : Container(),
                      ),
                    ],
                  ),
                ),

                //-------------------------------------------------------------------------
                //-------------------------- 3° TABBAR ------------------------------------
                //-------------------------------------------------------------------------
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(children: <Widget>[_showFotos(ancho)]),
                ),
              ],
            ),
          ),
          Center(
            child: _showLoader
                ? LoaderComponent(text: _textComponent)
                : Container(),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: paraSincronizar > 0
            ? const Color.fromARGB(255, 219, 8, 5)
            : Colors.white,
        child: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF781f1e),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 5,
          labelColor: const Color(0xFF781f1e),
          unselectedLabelColor: paraSincronizar > 0
              ? Colors.white
              : Colors.grey,
          labelPadding: const EdgeInsets.symmetric(horizontal: 5),
          tabs: <Widget>[
            Tab(
              child: Column(
                children: const [
                  Icon(Icons.person),
                  SizedBox(width: 5),
                  Text('Cliente', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            Tab(
              child: Column(
                children: const [
                  Icon(Icons.electrical_services),
                  SizedBox(width: 5),
                  Text('Suministro', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            Tab(
              child: Column(
                children: const [
                  Icon(Icons.photo),
                  SizedBox(width: 5),
                  Text('Fotos', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //--------------------------------------------------------------
  //-------------------------- _showName -------------------------
  //--------------------------------------------------------------

  Widget _showName() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextField(
        controller: _nameController,
        decoration: InputDecoration(
          fillColor: _name == '' ? Colors.yellow : Colors.white,
          filled: true,
          hintText: 'Ingrese apellido y nombre...',
          labelText: 'Apellido y Nombre',
          errorText: _nameShowError ? _nameError : null,
          suffixIcon: const Icon(Icons.person),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _name = value;
        },
      ),
    );
  }

  //--------------------------------------------------------------
  //-------------------------- _showDocument ---------------------
  //--------------------------------------------------------------

  Widget _showDocument() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _documentController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                fillColor: _document == '' ? Colors.yellow : Colors.white,
                filled: true,
                enabled: true,
                hintText: 'Ingresa documento...',
                labelText: 'Documento',
                errorText: _documentShowError ? _documentError : null,
                suffixIcon: const Icon(Icons.assignment_ind),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                _document = value;
              },
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF781f1e),
              minimumSize: const Size(50, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () async {
              String barcodeScanRes;
              try {
                String? barcodeScanResAux = await Navigator.of(context)
                    .push<String>(
                      MaterialPageRoute(
                        builder: (context) => const BarCodeReader(),
                      ),
                    );
                barcodeScanRes = barcodeScanResAux ?? '-1';
              } on PlatformException {
                barcodeScanRes = 'Error';
              }
              if (barcodeScanRes == '-1') {
                return;
              }

              int cantArrobas = 0;
              int arroba1 = 0;
              int arroba2 = 0;
              int arroba3 = 0;
              int arroba4 = 0;
              int arroba5 = 0;

              for (int c = 0; c <= barcodeScanRes.length - 1; c++) {
                if (barcodeScanRes[c] == '@') {
                  cantArrobas++;

                  if (arroba4 != 0 && arroba5 == 0) {
                    arroba5 = c;
                  }
                  if (arroba3 != 0 && arroba4 == 0) {
                    arroba4 = c;
                  }
                  if (arroba2 != 0 && arroba3 == 0) {
                    arroba3 = c;
                  }

                  if (arroba1 != 0 && arroba2 == 0) {
                    arroba2 = c;
                  }
                  if (arroba1 == 0) {
                    arroba1 = c;
                  }
                }
              }

              if (cantArrobas < 6) {
                _documentController.text = '';
                _nameController.text = '';
              } else {
                _documentController.text = barcodeScanRes.substring(
                  arroba4 + 1,
                  arroba5,
                );

                _document = barcodeScanRes.substring(arroba4 + 1, arroba5);

                _nameController.text =
                    '${barcodeScanRes.substring(arroba1 + 1, arroba2)} ${barcodeScanRes.substring(arroba2 + 1, arroba3)}';

                _name =
                    '${barcodeScanRes.substring(arroba1 + 1, arroba2)} ${barcodeScanRes.substring(arroba2 + 1, arroba3)}';
              }
            },
            child: const Icon(Icons.qr_code_2),
          ),
        ],
      ),
    );
  }

  //--------------------------------------------------------------
  //-------------------------- _showButtonsDNI -------------------
  //--------------------------------------------------------------

  Widget _showButtonsDNI(double ancho) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: InkWell(
              child: Stack(
                children: <Widget>[
                  Container(
                    child: !_photoChangedDNIFrente
                        ? Center(
                            child: Image(
                              image: const AssetImage('assets/dnifrente.jpg'),
                              width: ancho * 0.3,
                              height: 60,
                              fit: BoxFit.contain,
                            ),
                          )
                        : Center(
                            child: Image.file(
                              File(_imageFrente.path),
                              width: 80,
                              height: 60,
                              fit: BoxFit.contain,
                            ),
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: ancho * 0.34,
                    child: InkWell(
                      onTap: () => _takePicture(1),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          color: const Color(0xFF781f1e),
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.photo_camera,
                            size: 30,
                            color: Color(0xFFf6faf8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: InkWell(
                      onTap: () => _selectPicture(1),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          color: const Color(0xFF781f1e),
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.image,
                            size: 30,
                            color: Color(0xFFf6faf8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: InkWell(
              child: Stack(
                children: <Widget>[
                  Container(
                    child: !_photoChangedDNIDorso
                        ? Center(
                            child: Image(
                              image: const AssetImage('assets/dnidorso.jpg'),
                              width: ancho * 0.3,
                              height: 60,
                              fit: BoxFit.contain,
                            ),
                          )
                        : Center(
                            child: Image.file(
                              File(_imageDorso.path),
                              width: 80,
                              height: 60,
                              fit: BoxFit.contain,
                            ),
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: ancho * 0.34,
                    child: InkWell(
                      onTap: () => _takePicture(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          color: const Color(0xFF781f1e),
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.photo_camera,
                            size: 30,
                            color: Color(0xFFf6faf8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: InkWell(
                      onTap: () => _selectPicture(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          color: const Color(0xFF781f1e),
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.image,
                            size: 30,
                            color: Color(0xFFf6faf8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //--------------------------------------------------------------
  //-------------------------- _showFotos ------------------------
  //--------------------------------------------------------------

  Widget _showFotos(double ancho) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text(
                'Foto Antes 1',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: InkWell(
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: !_photoChangedAntes1
                          ? Center(
                              child: Image(
                                image: const AssetImage('assets/noimage.png'),
                                width: ancho * 0.6,
                                height: ancho * 0.6,
                                fit: BoxFit.contain,
                              ),
                            )
                          : Center(
                              child: Image.file(
                                File(_imageAntes1.path),
                                width: ancho * 0.6,
                                height: ancho * 0.6,
                                fit: BoxFit.contain,
                              ),
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: ancho * 0.8,
                      child: InkWell(
                        onTap: () => _takePicture(3),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            color: const Color(0xFF781f1e),
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.photo_camera,
                              size: 30,
                              color: Color(0xFFf6faf8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: ancho * 0.1,
                      child: InkWell(
                        onTap: () => _selectPicture(3),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            color: const Color(0xFF781f1e),
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.image,
                              size: 30,
                              color: Color(0xFFf6faf8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const Divider(height: 10, color: Colors.white),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text(
                'Foto Antes 2',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: InkWell(
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: !_photoChangedAntes2
                          ? Center(
                              child: Image(
                                image: const AssetImage('assets/noimage.png'),
                                width: ancho * 0.6,
                                height: ancho * 0.6,
                                fit: BoxFit.contain,
                              ),
                            )
                          : Center(
                              child: Image.file(
                                File(_imageAntes2.path),
                                width: ancho * 0.6,
                                height: ancho * 0.6,
                                fit: BoxFit.contain,
                              ),
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: ancho * 0.8,
                      child: InkWell(
                        onTap: () => _takePicture(4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            color: const Color(0xFF781f1e),
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.photo_camera,
                              size: 30,
                              color: Color(0xFFf6faf8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: ancho * 0.1,
                      child: InkWell(
                        onTap: () => _selectPicture(4),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            color: const Color(0xFF781f1e),
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.image,
                              size: 30,
                              color: Color(0xFFf6faf8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const Divider(height: 10, color: Colors.white),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text(
                'Foto Después 1',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: InkWell(
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: !_photoChangedDespues1
                          ? Center(
                              child: Image(
                                image: const AssetImage('assets/noimage.png'),
                                width: ancho * 0.6,
                                height: ancho * 0.6,
                                fit: BoxFit.contain,
                              ),
                            )
                          : Center(
                              child: Image.file(
                                File(_imageDespues1.path),
                                width: ancho * 0.6,
                                height: ancho * 0.6,
                                fit: BoxFit.contain,
                              ),
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: ancho * 0.8,
                      child: InkWell(
                        onTap: () => _takePicture(5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            color: const Color(0xFF781f1e),
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.photo_camera,
                              size: 30,
                              color: Color(0xFFf6faf8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: ancho * 0.1,
                      child: InkWell(
                        onTap: () => _selectPicture(5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            color: const Color(0xFF781f1e),
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.image,
                              size: 30,
                              color: Color(0xFFf6faf8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const Divider(height: 10, color: Colors.white),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text(
                'Foto Después 2',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: InkWell(
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: !_photoChangedDespues2
                          ? Center(
                              child: Image(
                                image: const AssetImage('assets/noimage.png'),
                                width: ancho * 0.6,
                                height: ancho * 0.6,
                                fit: BoxFit.contain,
                              ),
                            )
                          : Center(
                              child: Image.file(
                                File(_imageDespues2.path),
                                width: ancho * 0.6,
                                height: ancho * 0.6,
                                fit: BoxFit.contain,
                              ),
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: ancho * 0.8,
                      child: InkWell(
                        onTap: () => _takePicture(6),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            color: const Color(0xFF781f1e),
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.photo_camera,
                              size: 30,
                              color: Color(0xFFf6faf8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: ancho * 0.1,
                      child: InkWell(
                        onTap: () => _selectPicture(6),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            color: const Color(0xFF781f1e),
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.image,
                              size: 30,
                              color: Color(0xFFf6faf8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const Divider(height: 10, color: Colors.white),
      ],
    );
  }

  //--------------------------------------------------------------
  //-------------------------- _showDomicilio --------------------
  //--------------------------------------------------------------

  Widget _showDomicilio() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _domicilioController,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                fillColor: _domicilio == '' ? Colors.yellow[200] : Colors.white,
                filled: true,
                hintText: 'Ingresa domicilio...',
                labelText: 'Domicilio',
                errorText: _domicilioShowError ? _domicilioError : null,
                suffixIcon: const Icon(Icons.home),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                _domicilio = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  //--------------------------------------------------------------
  //-------------------------- _showBarrio --------------------
  //--------------------------------------------------------------

  Widget _showBarrio() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _barrioController,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                fillColor: _barrio == '' ? Colors.yellow[200] : Colors.white,
                filled: true,
                hintText: 'Ingresa barrio...',
                labelText: 'Barrio',
                errorText: _barrioShowError ? _barrioError : null,
                suffixIcon: const Icon(Icons.apartment),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                _barrio = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  //--------------------------------------------------------------
  //-------------------------- _showLocalidad --------------------
  //--------------------------------------------------------------

  Widget _showLocalidad() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _localidadController,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                fillColor: _localidad == '' ? Colors.yellow[200] : Colors.white,
                filled: true,
                hintText: 'Ingresa localidad...',
                labelText: 'Localidad',
                errorText: _localidadShowError ? _localidadError : null,
                suffixIcon: const Icon(Icons.location_city),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                _localidad = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  //--------------------------------------------------------------
  //-------------------------- _showPartido --------------------
  //--------------------------------------------------------------

  Widget _showPartido() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _partidoController,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                fillColor: _partido == '' ? Colors.yellow[200] : Colors.white,
                filled: true,
                hintText: 'Ingresa partido...',
                labelText: 'Partido',
                errorText: _partidoShowError ? _partidoError : null,
                suffixIcon: const Icon(Icons.public),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                _partido = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  //--------------------------------------------------------------
  //-------------------------- _showEntrecalles1 -----------------
  //--------------------------------------------------------------

  Widget _showEntrecalles1() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _entrecalles1Controller,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                fillColor: _entrecalles1 == ''
                    ? Colors.yellow[200]
                    : Colors.white,
                filled: true,
                hintText: 'Ingresa entrecalle 1...',
                labelText: 'Entrecalle 1',
                errorText: _entrecalles1ShowError ? _entrecalles1Error : null,
                suffixIcon: const Icon(Icons.add_road),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                _entrecalles1 = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  //--------------------------------------------------------------
  //-------------------------- _showEntrecalles2 -----------------
  //--------------------------------------------------------------

  Widget _showEntrecalles2() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _entrecalles2Controller,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                fillColor: _entrecalles2 == ''
                    ? Colors.yellow[200]
                    : Colors.white,
                filled: true,
                hintText: 'Ingresa entrecalle 2...',
                labelText: 'Entrecalle 2',
                errorText: _entrecalles2ShowError ? _entrecalles2Error : null,
                suffixIcon: const Icon(Icons.edit_road),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                _entrecalles2 = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  //--------------------------------------------------------------
  //-------------------------- _showTelefono ---------------------
  //--------------------------------------------------------------

  Widget _showTelefono() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _telefonoController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          fillColor: _telefono == '' ? Colors.yellow[200] : Colors.white,
          filled: true,
          hintText: 'Ingresa Teléfono...',
          labelText: 'Teléfono',
          errorText: _telefonoShowError ? _telefonoError : null,
          suffixIcon: const Icon(Icons.phone),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _telefono = value;
        },
      ),
    );
  }

  //--------------------------------------------------------------
  //-------------------------- _showEmail ------------------------
  //--------------------------------------------------------------

  Widget _showEmail() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        enabled: true,
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          fillColor: _email == '' ? Colors.yellow[200] : Colors.white,
          filled: true,
          enabled: false,
          hintText: 'Ingresa Email...',
          labelText: 'Email',
          errorText: _emailShowError ? _emailError : null,
          suffixIcon: const Icon(Icons.email),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _email = value;
        },
      ),
    );
  }

  //--------------------------------------------------------------
  //-------------------------- _takePicture ----------------------
  //--------------------------------------------------------------

  void _takePicture(int opcion) async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    var firstCamera = cameras.first;
    var response1 = await showAlertDialog(
      context: context,
      title: 'Seleccionar cámara',
      message: '¿Qué cámara desea utilizar?',
      actions: <AlertDialogAction>[
        const AlertDialogAction(key: 'no', label: 'Trasera'),
        const AlertDialogAction(key: 'yes', label: 'Delantera'),
        const AlertDialogAction(key: 'cancel', label: 'Cancelar'),
      ],
    );
    if (response1 == 'yes') {
      firstCamera = cameras.first;
    }
    if (response1 == 'no') {
      firstCamera = cameras.last;
    }

    if (response1 != 'cancel') {
      Response? response = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SacarFotoScreen(camera: firstCamera),
        ),
      );
      if (response != null) {
        if (opcion == 1) {
          _photoChangedDNIFrente = true;
          _imageFrente = response.result;
        }
        if (opcion == 2) {
          _photoChangedDNIDorso = true;
          _imageDorso = response.result;
        }
        if (opcion == 3) {
          _photoChangedAntes1 = true;
          _imageAntes1 = response.result;
        }
        if (opcion == 4) {
          _photoChangedAntes2 = true;
          _imageAntes2 = response.result;
        }
        if (opcion == 5) {
          _photoChangedDespues1 = true;
          _imageDespues1 = response.result;
        }
        if (opcion == 6) {
          _photoChangedDespues2 = true;
          _imageDespues2 = response.result;
        }
        setState(() {});
      }
    }
  }

  //--------------------------------------------------------------
  //-------------------------- _selectPicture --------------------
  //--------------------------------------------------------------

  void _selectPicture(int opcion) async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (opcion == 1) {
        _photoChangedDNIFrente = true;
        _imageFrente = image;
      }
      if (opcion == 2) {
        _photoChangedDNIDorso = true;
        _imageDorso = image;
      }
      if (opcion == 3) {
        _photoChangedAntes1 = true;
        _imageAntes1 = image;
      }
      if (opcion == 4) {
        _photoChangedAntes2 = true;
        _imageAntes2 = image;
      }
      if (opcion == 5) {
        _photoChangedDespues1 = true;
        _imageDespues1 = image;
      }
      if (opcion == 6) {
        _photoChangedDespues2 = true;
        _imageDespues2 = image;
      }
      setState(() {});
    }
  }

  //--------------------------------------------------------------
  //-------------------------- _showButtonsFirma -----------------
  //--------------------------------------------------------------

  Widget _showButtonsFirma(ancho) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: [
              Container(
                child: !_signatureChanged
                    ? const Image(
                        image: AssetImage('assets/firma.png'),
                        width: 80,
                        height: 60,
                        fit: BoxFit.contain,
                      )
                    : Image.memory(
                        _signature!.buffer.asUint8List(),
                        width: 80,
                        height: 60,
                      ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () => _takeSignature(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    color: const Color(0xFF781f1e),
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.drive_file_rename_outline,
                      size: 40,
                      color: Color(0xFFf6faf8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //--------------------------------------------------------------
  //-------------------------- _takeSignature --------------------
  //--------------------------------------------------------------

  void _takeSignature() async {
    Response? response = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FirmaScreen()),
    );
    if (response != null) {
      setState(() {
        _signatureChanged = true;
        _signature = response.result;
      });

      //_signature2 = await _signature.toByteData(format: ui.ImageByteFormat.png);
    }
  }

  //--------------------------------------------------------------
  //-------------------------- _getlistOptionsTipoRed ------------
  //--------------------------------------------------------------

  void _getlistOptionsTipoRed() {
    _itemsTipoRed = [];
    _listoptionsTipoRed = [];

    Option2 opt1 = Option2(id: 'Convencional', description: 'Convencional');
    Option2 opt2 = Option2(id: 'LAPE 7.50MTS', description: 'LAPE 7.50MTS');
    Option2 opt3 = Option2(id: 'LAPE 11.00MTS', description: 'LAPE 11.00MTS');
    Option2 opt4 = Option2(id: 'PIMT(DAE)', description: 'PIMT(DAE)');
    Option2 opt5 = Option2(id: 'Otro', description: 'Otro');
    _listoptionsTipoRed.add(opt1);
    _listoptionsTipoRed.add(opt2);
    _listoptionsTipoRed.add(opt3);
    _listoptionsTipoRed.add(opt4);
    _listoptionsTipoRed.add(opt5);

    _getlistOptionsConexionDirecta();
  }

  //--------------------------------------------------------------
  //------------------ _getlistOptionsConexionDirecta ------------
  //--------------------------------------------------------------

  void _getlistOptionsConexionDirecta() {
    _itemsConexionDirecta = [];
    _listoptionsConexionDirecta = [];

    Option2 opt1 = Option2(id: 'Concéntrico', description: 'Concéntrico');
    Option2 opt2 = Option2(id: 'Cable Taller', description: 'Cable Taller');
    Option2 opt3 = Option2(id: 'Cable Unipolar', description: 'Cable Unipolar');
    Option2 opt4 = Option2(id: 'Cable Teléfono', description: 'Cable Teléfono');
    Option2 opt5 = Option2(id: 'Otro', description: 'Otro');
    _listoptionsConexionDirecta.add(opt1);
    _listoptionsConexionDirecta.add(opt2);
    _listoptionsConexionDirecta.add(opt3);
    _listoptionsConexionDirecta.add(opt4);
    _listoptionsConexionDirecta.add(opt5);

    _getlistOptionsRetiroConexion();
  }

  //--------------------------------------------------------------
  //------------------ _getlistOptionsRetiroConexion -------------
  //--------------------------------------------------------------

  void _getlistOptionsRetiroConexion() {
    _itemsRetiroConexion = [];
    _listoptionsRetiroConexion = [];

    Option2 opt1 = Option2(
      id: 'Caja Distribuidora',
      description: 'Caja Distribuidora',
    );
    Option2 opt2 = Option2(id: 'Luminaria', description: 'Luminaria');
    Option2 opt3 = Option2(id: 'Red', description: 'Red');
    Option2 opt4 = Option2(
      id: 'Acometida vecino',
      description: 'Acometida vecino',
    );
    Option2 opt5 = Option2(id: 'Otro', description: 'Otro');
    _listoptionsRetiroConexion.add(opt1);
    _listoptionsRetiroConexion.add(opt2);
    _listoptionsRetiroConexion.add(opt3);
    _listoptionsRetiroConexion.add(opt4);
    _listoptionsRetiroConexion.add(opt5);

    _loadFieldValues();
  }

  //--------------------------------------------------------------
  //-------------------------- _loadFieldValues -------------------
  //--------------------------------------------------------------

  void _loadFieldValues() {
    _optionTipoRed = 'Seleccione Tipo de Red...';
    _optionConexionDirecta = 'Seleccione Conexión Directa...';
    _optionRetiroConexion = 'Seleccione Retiro Conexión...';

    _getComboTipoRed();
    _getComboConexionDirecta();
    _getComboRetiroConexion();
  }

  //--------------------------------------------------------------
  //-------------------------- _getComboTipoRed ------------------
  //--------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboTipoRed() {
    _itemsTipoRed = [];

    List<DropdownMenuItem<String>> list = [];
    list.add(
      const DropdownMenuItem(
        value: 'Seleccione Tipo de Red...',
        child: Text('Seleccione Tipo de Red...'),
      ),
    );

    for (var _listoption in _listoptionsTipoRed) {
      list.add(
        DropdownMenuItem(
          value: _listoption.id,
          child: Text(_listoption.description),
        ),
      );
    }

    _itemsTipoRed = list;

    return list;
  }

  //--------------------------------------------------------------
  //------------------ _getComboConexionDirecta ------------------
  //--------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboConexionDirecta() {
    _itemsConexionDirecta = [];

    List<DropdownMenuItem<String>> list = [];
    list.add(
      const DropdownMenuItem(
        value: 'Seleccione Conexión Directa...',
        child: Text('Seleccione Conexión Directa...'),
      ),
    );

    for (var _listoption in _listoptionsConexionDirecta) {
      list.add(
        DropdownMenuItem(
          value: _listoption.id,
          child: Text(_listoption.description),
        ),
      );
    }

    _itemsConexionDirecta = list;

    return list;
  }

  //--------------------------------------------------------------
  //------------------ _getComboRetiroConexion -------------------
  //--------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboRetiroConexion() {
    _itemsRetiroConexion = [];

    List<DropdownMenuItem<String>> list = [];
    list.add(
      const DropdownMenuItem(
        value: 'Seleccione Retiro Conexión...',
        child: Text('Seleccione Retiro Conexión...'),
      ),
    );

    for (var _listoption in _listoptionsRetiroConexion) {
      list.add(
        DropdownMenuItem(
          value: _listoption.id,
          child: Text(_listoption.description),
        ),
      );
    }

    _itemsRetiroConexion = list;

    return list;
  }

  //--------------------------------------------------------------
  //-------------------------- _showEnre -------------------------
  //--------------------------------------------------------------

  Widget _showEnre() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _enreController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Enre...',
                labelText: 'Enre',
                errorText: _enreShowError ? _enreError : null,
                suffixIcon: const Icon(Icons.e_mobiledata),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                _enre = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  //--------------------------------------------------------------
  //-------------------------- _showOtro -------------------------
  //--------------------------------------------------------------

  Widget _showOtro() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _otroController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Otro...',
                labelText: 'Otro',
                errorText: _otroShowError ? _otroError : null,
                suffixIcon: const Icon(Icons.alt_route),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                _otro = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  //--------------------------------------------------------------
  //-------------------------- _showMedidorColocado --------------
  //--------------------------------------------------------------

  Widget _showMedidorColocado() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _medidorcolocadoController,
              decoration: InputDecoration(
                fillColor: _medidorcolocado == ''
                    ? Colors.yellow[200]
                    : Colors.white,
                filled: true,
                hintText: 'Medidor colocado...',
                labelText: 'Medidor colocado',
                errorText: _medidorcolocadoShowError
                    ? _medidorcolocadoError
                    : null,
                suffixIcon: const Icon(Icons.schedule),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                _medidorcolocado = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  //--------------------------------------------------------------
  //-------------------------- _showMedidorVecino ----------------
  //--------------------------------------------------------------

  Widget _showMedidorVecino() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _medidorvecinoController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Medidor vecino...',
                labelText: 'Medidor vecino',
                errorText: _medidorvecinoShowError ? _medidorvecinoError : null,
                suffixIcon: const Icon(Icons.history),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                _medidorvecino = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  //--------------------------------------------------------------
  //-------------------------- _showTensionContratada ------------
  //--------------------------------------------------------------

  Widget _showTensionContratada() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _tensionContratadaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Tensión contratada...',
                labelText: 'Tensión contratada',
                errorText: _tensionContratadaShowError
                    ? _tensionContratadaError
                    : null,
                suffixIcon: const Icon(Icons.power),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                _tensionContratada = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  //--------------------------------------------------------------
  //-------------------------- _showPotenciaContratada -----------
  //--------------------------------------------------------------

  Widget _showPotenciaContratada() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _potenciaContratadaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Potencia contratada...',
                labelText: 'Potencia contratada',
                errorText: _potenciaContratadaShowError
                    ? _potenciaContratadaError
                    : null,
                suffixIcon: const Icon(Icons.battery_charging_full),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                _potenciaContratada = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  //--------------------------------------------------------------
  //-------------------------- _showMtsCableRetirado -------------
  //--------------------------------------------------------------

  Widget _showMtsCableRetirado() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _mtsCableRetiradoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Mts. Cable Retirado...',
                labelText: 'Mts. Cable Retirado',
                errorText: _mtsCableRetiradoShowError
                    ? _mtsCableRetiradoError
                    : null,
                suffixIcon: const Icon(Icons.straighten),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                _mtsCableRetirado = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  //--------------------------------------------------------------
  //-------------------------- _showObservaciones ----------------
  //--------------------------------------------------------------

  Widget _showObservaciones() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _observacionesController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Observaciones...',
                labelText: 'Observaciones',
                errorText: _observacionesShowError ? _observacionesError : null,
                suffixIcon: const Icon(Icons.notes),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                _observaciones = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  //------------------------------------------------------
  //-------------------- _guardar ------------------------
  //------------------------------------------------------

  void _guardar() async {
    if (!validateFields()) {
      return;
    } else {
      setState(() {
        _showLoader = true;
      });
      await _grabarEnBDLocal();
      setState(() {
        _showLoader = false;
      });
    }
  }

  //--------------------------------------------------------------
  //-------------------- validateFields --------------------------
  //--------------------------------------------------------------

  bool validateFields() {
    bool isValid = true;

    if (_document == '') {
      isValid = false;
      _documentShowError = true;
      _documentError = 'Debe ingresar el Documento';
    } else {
      _documentShowError = false;
    }

    if (_name == '') {
      isValid = false;
      _nameShowError = true;
      _nameError = 'Debe ingresar Nombre y Apellido';
    } else {
      _nameShowError = false;
    }

    if (_domicilio == '' ||
        _barrio == '' ||
        _localidad == '' ||
        _partido == '' ||
        _entrecalles1 == '' ||
        _entrecalles2 == '' ||
        _telefono == '' ||
        _email == '' ||
        _medidorcolocado == '' ||
        _tipoRed == 'Seleccione Tipo de Red...' ||
        _conexionDirecta == 'Seleccione Conexión Directa...' ||
        _retiroConexion == 'Seleccione Retiro Conexión...') {
      _enviado = 0;
    }

    setState(() {});

    return isValid;
  }

  //-----------------------------------------------------------------
  //-------------------------- pLMayusc -----------------------------
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

  //--------------------------------------------------------------
  //-------------------- _grabarEnBDLocal ------------------------
  //-------------------------------------------------------------

  Future<void> _grabarEnBDLocal() async {
    int maxWidth = 800; // Ancho máximo
    int maxHeight = 600; // Alto máximo

    String base64ImageAntes1 = '';
    if (_photoChangedAntes1) {
      Uint8List imageBytesAntes1 = await _imageAntes1.readAsBytes();
      Uint8List resizedBytes = await resizeImage(
        imageBytesAntes1,
        maxWidth,
        maxHeight,
      );
      base64ImageAntes1 = base64Encode(resizedBytes);
    }

    String base64ImageAntes2 = '';
    if (_photoChangedAntes2) {
      Uint8List imageBytesAntes2 = await _imageAntes2.readAsBytes();
      Uint8List resizedBytes = await resizeImage(
        imageBytesAntes2,
        maxWidth,
        maxHeight,
      );
      base64ImageAntes2 = base64Encode(resizedBytes);
    }

    String base64ImageDespues1 = '';
    if (_photoChangedDespues1) {
      Uint8List imageBytesDespues1 = await _imageDespues1.readAsBytes();
      Uint8List resizedBytes = await resizeImage(
        imageBytesDespues1,
        maxWidth,
        maxHeight,
      );
      base64ImageDespues1 = base64Encode(resizedBytes);
    }

    String base64ImageDespues2 = '';
    if (_photoChangedDespues2) {
      Uint8List imageBytesDespues2 = await _imageDespues2.readAsBytes();
      Uint8List resizedBytes = await resizeImage(
        imageBytesDespues2,
        maxWidth,
        maxHeight,
      );
      base64ImageDespues2 = base64Encode(resizedBytes);
    }

    String base64ImageDNIFrente = '';
    if (_photoChangedDNIFrente) {
      Uint8List imageBytesDNIFrente = await _imageFrente.readAsBytes();
      Uint8List resizedBytes = await resizeImage(
        imageBytesDNIFrente,
        maxWidth,
        maxHeight,
      );
      base64ImageDNIFrente = base64Encode(resizedBytes);
    }

    String base64ImageDNIDorso = '';
    if (_photoChangedDNIDorso) {
      Uint8List imageBytesDNIDorso = await _imageDorso.readAsBytes();
      Uint8List resizedBytes = await resizeImage(
        imageBytesDNIDorso,
        maxWidth,
        maxHeight,
      );
      base64ImageDNIDorso = base64Encode(resizedBytes);
    }

    String base64ImageFirmaCliente = '';
    if (_signatureChanged) {
      List<int> imageBytesFirmaCliente = _signature!.buffer.asUint8List();
      base64ImageFirmaCliente = base64Encode(imageBytesFirmaCliente);
    }

    if (base64ImageAntes1 == '' ||
        //base64ImageAntes2 == '' ||
        base64ImageDespues1 == '' ||
        //base64ImageDespues2 == '' ||
        base64ImageDNIFrente == '' ||
        base64ImageDNIDorso == '' ||
        base64ImageFirmaCliente == '') {
      _enviado = 0;
    }

    int nrosuministro = 0;

    List<ObrasNuevoSuministro> suministros = [];
    suministros = await DBSuministros.suministros();

    if (suministros.isEmpty) {
      nrosuministro = 1;
    } else {
      for (var suministro in suministros) {
        if (suministro.nrosuministro > nrosuministro) {
          nrosuministro = suministro.nrosuministro;
        }
      }
      nrosuministro = nrosuministro + 1;
    }

    widget.editMode
        ? nrosuministro = widget.suministro.nrosuministro
        : nrosuministro = nrosuministro;

    ObrasNuevoSuministro requestObrasNuevoSuministro = ObrasNuevoSuministro(
      antesfotO1: base64ImageAntes1,
      antesfotO2: base64ImageAntes2,
      apellidonombre: pLMayusc(_name),
      barrio: pLMayusc(_barrio!),
      causantec: widget.user.codigoCausante,
      conexiondirecta: _conexionDirecta,
      corte: _corte ? 'SI' : 'NO',
      cuadrilla: widget.user.fullName,
      denuncia: _denuncia ? 'SI' : 'NO',
      despuesfotO1: base64ImageDespues1,
      despuesfotO2: base64ImageDespues2,
      directa: '',
      dni: _document,
      domicilio: pLMayusc(_domicilio!),
      email: _email,
      enre: _enre,
      entrecalleS1: pLMayusc(_entrecalles1!),
      entrecalleS2: pLMayusc(_entrecalles2!),
      enviado: _enviado,
      fecha: DateTime.now().toString(),
      fotodnifrente: base64ImageDNIFrente,
      fotodnireverso: base64ImageDNIDorso,
      firmacliente: base64ImageFirmaCliente,
      grupoc: widget.user.codigogrupo,
      idcertifbaremo: 0,
      idcertifmateriales: 0,
      kitnro: 0,
      localidad: pLMayusc(_localidad!),
      materiales: 0,
      medidorcolocado: _medidorcolocado,
      medidorvecino: _medidorvecino,
      mtscableretirado: _mtsCableRetirado == ''
          ? 0
          : int.parse(_mtsCableRetirado!),
      nroobra:
          105693, //Decia 82501 lo pide cambiar Leonardo Diaz el dìa 12/4/2023
      nrosuministro: nrosuministro,
      observaciones: _observaciones,
      otro: _otro,
      partido: pLMayusc(_partido!),
      postepodrido: _postepodrido ? 'SI' : 'NO',
      potenciacontratada: _potenciaContratada == ''
          ? 0
          : int.parse(_potenciaContratada!),
      retiroconexion: _retiroConexion,
      retirocrucecalle: _retirocrucecalle ? 'SI' : 'NO',
      telefono: _telefono,
      tensioncontratada: _tensionContratada == ''
          ? 0
          : int.parse(_tensionContratada!),
      tipored: _tipoRed,
      trabajoconhidro: _trabajoconhidro ? 'SI' : 'NO',
    );

    bool existeDNIenBD = false;

    for (var suministro in suministros) {
      if (suministro.dni == _document && _document != dniAntesEditar) {
        _showSnackbar('El DNI ya existe', Colors.red);
        existeDNIenBD = true;
      }
    }

    if (!existeDNIenBD && widget.editMode == false) {
      await DBSuministros.insertSuministro(requestObrasNuevoSuministro);
      _showSnackbar('Suministro grabado con éxito', Colors.lightGreen);
      Navigator.pop(context, 'yes');
    }

    if (widget.editMode == true && !existeDNIenBD) {
      await DBSuministros.update(requestObrasNuevoSuministro);
      _showSnackbar('Suministro grabado con éxito', Colors.lightGreen);
      Navigator.pop(context, 'yes');
    }

    if (widget.editMode == true &&
        existeDNIenBD &&
        _document == dniAntesEditar) {
      await DBSuministros.update(requestObrasNuevoSuministro);
      _showSnackbar('Suministro grabado con éxito', Colors.lightGreen);
      Navigator.pop(context, 'yes');
    }
  }

  //-------------------------------------------------------------
  //-------------------- _showSnackbar --------------------------
  //-------------------------------------------------------------

  void _showSnackbar(String message, Color color) {
    SnackBar snackbar = SnackBar(
      content: Text(message),
      backgroundColor: color,
      //duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    //ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  //-------------------------------------------------------------
  //-------------------- _loadFields ----------------------------
  //-------------------------------------------------------------

  void _loadFields() async {
    _document = widget.suministro.dni!;
    _documentController.text = widget.suministro.dni!;

    _name = widget.suministro.apellidonombre!;
    _nameController.text = widget.suministro.apellidonombre!;

    _domicilio = widget.suministro.domicilio!;
    _domicilioController.text = widget.suministro.domicilio!;

    _barrio = widget.suministro.barrio!;
    _barrioController.text = widget.suministro.barrio!;

    _localidad = widget.suministro.localidad!;
    _localidadController.text = widget.suministro.localidad!;

    _partido = widget.suministro.partido!;
    _partidoController.text = widget.suministro.partido!;

    _entrecalles1 = widget.suministro.entrecalleS1!;
    _entrecalles1Controller.text = widget.suministro.entrecalleS1!;

    _entrecalles2 = widget.suministro.entrecalleS2!;
    _entrecalles2Controller.text = widget.suministro.entrecalleS2!;

    _telefono = widget.suministro.telefono!;
    _telefonoController.text = widget.suministro.telefono!;

    _email = widget.suministro.email!;
    _emailController.text = widget.suministro.email!;

    _corte = widget.suministro.corte == 'SI' ? true : false;

    _denuncia = widget.suministro.denuncia == 'SI' ? true : false;

    _retirocrucecalle = widget.suministro.retirocrucecalle == 'SI'
        ? true
        : false;

    _trabajoconhidro = widget.suministro.trabajoconhidro == 'SI' ? true : false;

    _postepodrido = widget.suministro.postepodrido == 'SI' ? true : false;

    _tipoRed = widget.suministro.tipored!;
    _optionTipoRed = widget.suministro.tipored!;

    _conexionDirecta = widget.suministro.conexiondirecta!;
    _optionConexionDirecta = widget.suministro.conexiondirecta!;

    _retiroConexion = widget.suministro.retiroconexion!;
    _optionRetiroConexion = widget.suministro.retiroconexion!;

    _enre = widget.suministro.enre!;
    _enreController.text = widget.suministro.enre!;

    _otro = widget.suministro.otro!;
    _otroController.text = widget.suministro.otro!;

    _medidorcolocado = widget.suministro.medidorcolocado!;
    _medidorcolocadoController.text = widget.suministro.medidorcolocado!;

    _medidorvecino = widget.suministro.medidorvecino!;
    _medidorvecinoController.text = widget.suministro.medidorvecino!;

    _tensionContratada = widget.suministro.tensioncontratada.toString() != '0'
        ? widget.suministro.tensioncontratada.toString()
        : '';
    _tensionContratadaController.text = _tensionContratada!;

    _potenciaContratada = widget.suministro.potenciacontratada.toString() != '0'
        ? widget.suministro.potenciacontratada.toString()
        : '';
    _potenciaContratadaController.text = _potenciaContratada!;

    _mtsCableRetirado = widget.suministro.mtscableretirado.toString() != '0'
        ? widget.suministro.mtscableretirado.toString()
        : '';
    _mtsCableRetiradoController.text = _mtsCableRetirado!;

    _observaciones = widget.suministro.observaciones.toString();
    _observacionesController.text = widget.suministro.observaciones.toString();

    Uint8List fotoDNIFrente = base64Decode(widget.suministro.fotodnifrente!);
    final String pathRutafotoDNIFrente =
        '${(await getTemporaryDirectory()).path}/fotoDNIFrente.png';
    File fotoDNIFrenteFile = await File(pathRutafotoDNIFrente).create();
    fotoDNIFrenteFile.writeAsBytesSync(fotoDNIFrente, flush: true);
    _imageFrente = XFile(fotoDNIFrenteFile.path);
    widget.suministro.fotodnifrente != ''
        ? _photoChangedDNIFrente = true
        : _photoChangedDNIFrente = false;

    Uint8List fotoDNIDorso = base64Decode(widget.suministro.fotodnireverso!);
    final String pathRutafotoDNIDorso =
        '${(await getTemporaryDirectory()).path}/fotoDNIDorso.png';
    File fotoDNIDorsoFile = await File(pathRutafotoDNIDorso).create();
    fotoDNIDorsoFile.writeAsBytesSync(fotoDNIDorso, flush: true);
    _imageDorso = XFile(fotoDNIDorsoFile.path);
    widget.suministro.fotodnireverso != ''
        ? _photoChangedDNIDorso = true
        : _photoChangedDNIDorso = false;

    Uint8List fotoAntes1 = base64Decode(widget.suministro.antesfotO1!);
    final String pathRutafotoAntes1 =
        '${(await getTemporaryDirectory()).path}/fotoAntes1.png';
    File fotoAntes1File = await File(pathRutafotoAntes1).create();
    fotoAntes1File.writeAsBytesSync(fotoAntes1, flush: true);
    _imageAntes1 = XFile(fotoAntes1File.path);
    widget.suministro.antesfotO1 != ''
        ? _photoChangedAntes1 = true
        : _photoChangedAntes1 = false;

    Uint8List fotoAntes2 = base64Decode(widget.suministro.antesfotO2!);
    final String pathRutafotoAntes2 =
        '${(await getTemporaryDirectory()).path}/fotoAntes2.png';
    File fotoAntes2File = await File(pathRutafotoAntes2).create();
    fotoAntes2File.writeAsBytesSync(fotoAntes2, flush: true);
    _imageAntes2 = XFile(fotoAntes2File.path);
    widget.suministro.antesfotO2 != ''
        ? _photoChangedAntes2 = true
        : _photoChangedAntes2 = false;

    Uint8List fotoDespues1 = base64Decode(widget.suministro.despuesfotO1!);
    final String pathRutafotoDespues1 =
        '${(await getTemporaryDirectory()).path}/fotoDespues1.png';
    File fotoDespues1File = await File(pathRutafotoDespues1).create();
    fotoDespues1File.writeAsBytesSync(fotoDespues1, flush: true);
    _imageDespues1 = XFile(fotoDespues1File.path);
    widget.suministro.despuesfotO1 != ''
        ? _photoChangedDespues1 = true
        : _photoChangedDespues1 = false;

    Uint8List fotoDespues2 = base64Decode(widget.suministro.despuesfotO2!);
    final String pathRutafotoDespues2 =
        '${(await getTemporaryDirectory()).path}/fotoDespues2.png';
    File fotoDespues2File = await File(pathRutafotoDespues2).create();
    fotoDespues2File.writeAsBytesSync(fotoDespues2, flush: true);
    _imageDespues2 = XFile(fotoDespues2File.path);
    widget.suministro.despuesfotO2 != ''
        ? _photoChangedDespues2 = true
        : _photoChangedDespues2 = false;

    Uint8List firmaCliente2 = base64Decode(widget.suministro.firmacliente!);
    _signature = ByteData.view(firmaCliente2.buffer);

    widget.suministro.firmacliente != ''
        ? _signatureChanged = true
        : _signatureChanged = false;

    setState(() {});

    _getSuministros();
  }

  //-----------------------------------------------------------------
  //--------------------- _getSuministros ---------------------------
  //-----------------------------------------------------------------

  Future<void> _getSuministros() async {
    _showLoader = true;
    _suministros = await DBSuministros.suministros();
    _suministros.sort((a, b) {
      return pLMayusc(a.apellidonombre!).compareTo(pLMayusc(b.apellidonombre!));
    });
    _showLoader = false;
    setState(() {});
  }
}
