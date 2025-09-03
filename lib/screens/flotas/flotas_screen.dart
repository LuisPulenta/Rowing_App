import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';

class FlotaScreen extends StatefulWidget {
  final User user;
  const FlotaScreen({super.key, required this.user});

  @override
  _FlotaScreenState createState() => _FlotaScreenState();
}

class _FlotaScreenState extends State<FlotaScreen>
    with SingleTickerProviderStateMixin {
  //---------------------------------------------------------------------
  //-------------------------- Variables --------------------------------
  //---------------------------------------------------------------------

  String _codigo = '';
  final String _codigoError = '';
  final bool _codigoShowError = false;
  bool _showLoader = false;
  late Vehiculo _vehiculo;
  late VFlota _vFlota;
  final TextEditingController _codigoController = TextEditingController();

  String kmFechaAnterior = '';
  int kmFinAnterior = 0;

  List<Preventivo> _preventivos = [];

  String _km = '';
  final String _kmError = '';
  final bool _kmShowError = false;
  final TextEditingController _kmController = TextEditingController();

  List<VehiculosKilometraje> _kilometrajes = [];
  List<VehiculosProgramaPrev> _programasprev = [];

  int _nroReg = 0;
  bool _seguimientoGrabado = false;

  TabController? _tabController;

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

    _tabController = TabController(length: 2, vsync: this);
  }

  //---------------------------------------------------------------------
  //-------------------------- Pantalla ---------------------------------
  //---------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: (const Text('Km y Preventivos')),
        centerTitle: true,
        backgroundColor: const Color(0xff242424),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color((0xFF484848)), Color((0xFF484848))],
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
                  child: Column(
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            _showLogo(),
                            const SizedBox(height: 20),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 15,
                              margin: const EdgeInsets.all(5),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 5,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 10,
                                          child: _showLegajo(),
                                        ),
                                        Expanded(flex: 7, child: _showButton()),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            _showInfo(),
                            const SizedBox(height: 5),
                            _showButtons(),
                          ],
                        ),
                      ),
                      _showLoader
                          ? const LoaderComponent(text: 'Por favor espere...')
                          : Container(),
                    ],
                  ),
                ),
                //-------------------------------------------------------------------------
                //-------------------------- 2° TABBAR ------------------------------------
                //-------------------------------------------------------------------------
                Center(child: _getContent()),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xff242424),
        child: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 5,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          labelPadding: const EdgeInsets.symmetric(horizontal: 10),
          tabs: <Widget>[
            Tab(
              child: Column(
                children: const [
                  Icon(Icons.directions_car),
                  SizedBox(width: 5),
                  Text('Km', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            Tab(
              child: Column(
                children: const [
                  Icon(Icons.construction),
                  SizedBox(width: 5),
                  Text('Preventivos', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //-----------------------------------------------------------
  //--------------------- _showLogo ---------------------------
  //-----------------------------------------------------------

  Widget _showLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Image.asset('assets/flota1.png', width: 70, height: 70),
        getImage(user: widget.user, height: 70, width: 200),
        // Image.asset(
        //   "assets/logo.png",
        //   height: 70,
        //   width: 200,
        // ),
        Image.asset(
          'assets/flota2.png',
          width: 70,
          height: 70,
          color: Colors.white,
        ),
      ],
    );
  }

  //-----------------------------------------------------------
  //--------------------- _showLegajo -------------------------
  //-----------------------------------------------------------

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

  //-------------------------------------------------------------
  //--------------------- _showButton ---------------------------
  //-------------------------------------------------------------

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
                                        (_vehiculo.fechaVencObleaGAS! - 80723),
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
    );
  }

  //-----------------------------------------------------------
  //--------------------- _showButtons ------------------------
  //-----------------------------------------------------------

  Widget _showButtons() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _kmController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: _vehiculo.usaHoras == 1
                    ? 'Ingrese Hs...'
                    : 'Ingrese Km...',
                labelText: _vehiculo.usaHoras == 1 ? 'Hs:' : 'Km',
                errorText: _kmShowError ? _kmError : null,
                prefixIcon: const Icon(Icons.ac_unit),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                _km = value;
                setState(() {});
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF120E43),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: _km != '' ? _kilometros : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [Icon(Icons.save), Text('Guardar')],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //-----------------------------------------------------------
  //--------------------- _search -----------------------------
  //-----------------------------------------------------------

  Future<void> _search() async {
    FocusScope.of(context).unfocus();
    _codigoController.text = _codigo.toUpperCase();
    if (_codigo.isEmpty) {
      final _ = await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Ingrese una Patente.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    if (widget.user.habilitaFlotas == 'SI') {
      await _getUsuarioChapa();
    } else {
      await _getVehiculo();
    }
  }

  //-----------------------------------------------------------
  //--------------------- _kilometros -------------------------
  //-----------------------------------------------------------

  void _kilometros() async {
    FocusScope.of(context).unfocus(); //Oculta el teclado
    //--------------------- CHEQUEA VALOR INGRESADO ------------------------

    if (int.parse(_km) < kmFinAnterior) {
      var response = await showAlertDialog(
        context: context,
        title: 'Aviso',
        message: _vehiculo.usaHoras == 1
            ? 'El valor de Hs ingresado es menor al último guardado. ¿Está seguro de guardar?'
            : 'El valor de Km ingresado es menor al último guardado. ¿Está seguro de guardar?',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: 'si', label: 'SI'),
          const AlertDialogAction(key: 'no', label: 'NO'),
        ],
      );
      if (response == 'no') {
        return;
      }
    }

    //--------------------- CHEQUEA CONEXION A INTERNET ------------------------

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      final _ = await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Verifica que estés conectado a Internet',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    //---------------- GRABA NUEVO REGISTRO EN TABLA VEHICULOSKILOMETRAJES ---------

    do {
      setState(() {
        _showLoader = true;
      });

      Response response2 = await ApiHelper.getNroRegistroMax();
      if (response2.isSuccess) {
        _nroReg = int.parse(response2.result.toString()) + 1;
      }

      Map<String, dynamic> request = {
        'orden': _nroReg,
        'equipo': _vehiculo.codProducto,
        'kilini': kmFinAnterior,
        'kilfin': int.parse(_km),
        'horsal': 0,
        'horlle': 0,
        'codsuc': 0,
        'nrodeot': 0,
        'cambio': '',
        'procesado': 0,
        'kmfechaanterior': kmFechaAnterior != '' ? kmFechaAnterior : null,
        'nopromediar': 0,
      };

      Response response = await ApiHelper.postNoToken(
        '/api/VehiculosKilometraje/',
        request,
      );

      setState(() {
        _showLoader = false;
      });

      if (!response.isSuccess) {
        final _ = await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ],
        );
        return;
      } else {
        _seguimientoGrabado = true;
      }
    } while (_seguimientoGrabado == false);

    //---------------- ACTUALIZA KM EN TABLA VEHICULOS ---------

    Map<String, dynamic> request2 = {'id': _vehiculo.codveh, 'kmhsactual': _km};

    await ApiHelper.put(
      '/api/Vehiculos/',
      _vehiculo.codveh.toString(),
      request2,
    );

    //---------------- ACTUALIZA KM EN TABLA VEHICULOSPROGRAMASPREV ---------
    Response response3 = Response(isSuccess: false);

    response3 = await ApiHelper.getProgramasPrev(
      _vehiculo.codProducto.toString(),
    );

    _programasprev = response3.result;

    _programasprev.forEach((element) async {
      Map<String, dynamic> request3 = {
        'nrointerno': element.nroInterno,
        'kmhsactual': int.parse(_km) - kmFinAnterior,
      };

      await ApiHelper.put(
        '/api/VehiculosProgramasPrev/',
        element.nroInterno.toString(),
        request3,
      );
    });
    //---------------- MENSAJE FINAL Y CIERRE DE PAGINA ---------
    final _ = await showAlertDialog(
      context: context,
      title: 'Aviso',
      message: 'Valor guardado con éxito!',
      actions: <AlertDialogAction>[
        const AlertDialogAction(key: null, label: 'Aceptar'),
      ],
    );
    Navigator.pop(context, 'yes');
  }

  //------------------------------------------------------------
  //--------------------- _getVehiculo -------------------------
  //------------------------------------------------------------

  Future<void> _getVehiculo() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      final _ = await showAlertDialog(
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
      final _ = await showAlertDialog(
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

    _vehiculo.kmhsactual ??= 0;

    Response response2 = Response(isSuccess: false);

    response2 = await ApiHelper.getKilometrajes(
      _vehiculo.codProducto.toString(),
    );
    _kilometrajes = response2.result;

    kmFechaAnterior = _kilometrajes.isNotEmpty
        ? _kilometrajes[_kilometrajes.length - 1].fecha.toString()
        : '';
    kmFinAnterior = (_kilometrajes.isNotEmpty
        ? _kilometrajes[_kilometrajes.length - 1].kilfin!
        : _vehiculo.kmhsactual)!;

    Response response3 = Response(isSuccess: false);

    response3 = await ApiHelper.getPreventivos(_vehiculo.numcha.toString());
    if (response3.isSuccess) {
      _preventivos = response3.result;
    }
    setState(() {});
  }

  //------------------------------------------------------------
  //--------------------- _getUsuarioChapa ---------------------
  //------------------------------------------------------------

  Future<void> _getUsuarioChapa() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      final _ = await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Verifica que estes conectado a internet.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    Response response = await ApiHelper.getUsuarioChapa(_codigo);

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
      _vFlota = response.result;
    });

    if (_vFlota.grupoV == widget.user.codigogrupo &&
        _vFlota.causanteV == widget.user.codigoCausante) {
      _getVehiculo();
    } else {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Esta patente no está asignada a su Usuario',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
    }
    setState(() {});
  }

  //------------------------------------------------------------
  //--------------------- _gato --------------------------------
  //------------------------------------------------------------

  String _gato(String? dato) {
    return dato != null ? dato.toString() : '';
  }

  //---------------------------------------------------------------------
  //------------------------------ _getContent --------------------------
  //---------------------------------------------------------------------

  Widget _getContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _preventivos.isEmpty ? Container() : _showPreventivosCount(),
        Expanded(child: _preventivos.isEmpty ? _noContent() : _getListView()),
      ],
    );
  }

  //--------------------------------------------------------------------
  //--------------------- _showPreventivosCount ------------------------
  //--------------------------------------------------------------------

  Widget _showPreventivosCount() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 40,
      child: Row(
        children: [
          const Text(
            'Cantidad de Preventivos: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _preventivos.length.toString(),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  //-----------------------------------------------------------------------
  //------------------------------ _noContent -----------------------------
  //-----------------------------------------------------------------------

  Widget _noContent() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: const Center(
        child: Text(
          'No hay Preventivos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  //-----------------------------------------------------------------------
  //------------------------------ _getListView ---------------------------
  //-----------------------------------------------------------------------

  Widget _getListView() {
    return ListView(
      children: _preventivos.map((e) {
        return Card(
          color: const Color(0xFFC7C7C8),
          shadowColor: Colors.white,
          elevation: 10,
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Container(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 90,
                                    child: Text(
                                      'Descripción: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      e.descripcionParte.toString(),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 90,
                                    child: Text(
                                      '',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      e.descripcion.toString(),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 90,
                                    child: Text(
                                      'Unid. Med.: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      e.frecuencia.toString(),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 90,
                                    child: Text(
                                      'Frecuencia.: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      e.cantFrec.toString(),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 90,
                                    child: Text(
                                      'Fecha Ult. Ej.: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: e.ultFechaEJ != null
                                        ? Text(
                                            DateFormat('dd/MM/yyyy').format(
                                              DateTime.parse(
                                                e.ultFechaEJ.toString(),
                                              ),
                                            ),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          )
                                        : const Text(
                                            '',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 90,
                                    child: Text(
                                      'Km Ult. Ej.: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      e.ultKmHsEj.toString(),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 90,
                                    child: Text(
                                      'Km actual: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: e.actKmHsEj == null
                                        ? const Text(
                                            '',
                                            style: TextStyle(fontSize: 12),
                                          )
                                        : Text(
                                            e.actKmHsEj.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 90,
                                    child: Text(
                                      'Diferencia: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      e.diferencia.toString(),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 90,
                                    child: Text(
                                      'Estado: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: e.estados.toString() == 'Vencido'
                                        ? Text(
                                            e.estados.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : Text(
                                            e.estados.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
