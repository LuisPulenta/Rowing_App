import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';

class InspeccionesScreen extends StatefulWidget {
  final User user;
  final Position positionUser;
  const InspeccionesScreen({
    super.key,
    required this.user,
    required this.positionUser,
  });

  @override
  _InspeccionesScreenState createState() => _InspeccionesScreenState();
}

class _InspeccionesScreenState extends State<InspeccionesScreen> {
  //----------------------------------------------------------------
  //------------------ Variables -----------------------------------
  //----------------------------------------------------------------

  String _codigo = '';
  final String _codigoError = '';
  final bool _codigoShowError = false;
  bool _enabled1 = false;
  bool _enabled2 = false;
  bool _enabled3 = true;
  bool _esContratista = false;
  late Causante _causante;
  bool bandera = false;
  int intentos = 0;
  List<Cliente> _clientes = [];

  int _cliente = 0;
  final String _clienteError = '';
  final bool _clienteShowError = false;

  int _tipoTrabajoSelected = 0;
  final String _tipoTrabajoError = '';
  final bool _tipoTrabajoShowError = false;
  List<TiposTrabajo> _tipoTrabajos = [];

  List<GruposFormulario> _gruposFormularios = [];
  List<DetallesFormulario> _detallesFormularios = [];
  List<DetallesFormulario> _detallesFormulariosAux = [];
  List<DetallesFormularioCompleto> _detallesFormulariosCompleto = [];
  DetallesFormularioCompleto detallesFormularioCompleto =
      DetallesFormularioCompleto(
        idcliente: 0,
        idgrupoformulario: 0,
        descgrupoformulario: '',
        detallef: '',
        descripcion: '',
        ponderacionpuntos: 0,
        cumple: '',
        foto: '',
        soloTexto: 0,
        obsApp: '',
      );

  Position _positionUser = Position(
    longitude: 0,
    latitude: 0,
    timestamp: DateTime.now(),
    altitudeAccuracy: 0,
    headingAccuracy: 0,
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
  );

  String _nombreSR = '';
  final String _nombreSRError = '';
  final bool _nombreSRShowError = false;
  final TextEditingController _nombreSRController = TextEditingController();

  String _dniSR = '';
  final String _dniSRError = '';
  final bool _dniSRShowError = false;
  final TextEditingController _dniSRController = TextEditingController();

  Obra obra = Obra(
    nroObra: 0,
    nombreObra: '',
    nroOE: '',
    defProy: '',
    central: '',
    elempep: '',
    observaciones: '',
    finalizada: 0,
    supervisore: '',
    codigoEstado: '',
    codigoSubEstado: '',
    modulo: '',
    grupoAlmacen: '',
    obrasDocumentos: [],
    fechaCierreElectrico: '',
    fechaUltimoMovimiento: '',
    photos: 0,
    audios: 0,
    videos: 0,
    posx: '',
    posy: '',
    direccion: '',
    textoLocalizacion: '',
    textoClase: '',
    textoTipo: '',
    textoComponente: '',
    codigoDiametro: '',
    motivo: '',
    planos: '',
    grupoCausante: '',
  );

  //----------------------------------------------------------------
  //------------------ initState -----------------------------------
  //----------------------------------------------------------------

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
    _getPosition();
    _loadData();
  }

  //----------------------------------------------------------------
  //------------------ Pantalla ------------------------------------
  //----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 195, 191, 191),
      appBar: AppBar(title: const Text('Nueva Inspección'), centerTitle: true),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 15,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(flex: 4, child: _showLegajo()),
                            Expanded(flex: 1, child: _showButton()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _esContratista ? _showCamposContratista() : _showInfo(),
                const SizedBox(height: 10),
                _showObra(),
                _showClientes(),
                _showTiposTrabajos(),
                const SizedBox(height: 10),
                _showButton2(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //-----------------------------------------------------------
  //--------------------- _showLegajo -------------------------
  //-----------------------------------------------------------

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

  //-----------------------------------------------------------
  //--------------------- _showButton -------------------------
  //-----------------------------------------------------------

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
              child: Center(child: Icon(Icons.search)),
            ),
          ),
        ],
      ),
    );
  }

  //------------------------------------------------------------
  //--------------------- _showButton2 -------------------------
  //------------------------------------------------------------

  Widget _showButton2() {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15),
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
              onPressed: _enabled1 && _enabled2 && _enabled3 && obra.nroObra > 0
                  ? _generarCuestionario
                  : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.search),
                  SizedBox(width: 5),
                  Text('Generar cuestionario'),
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

  //------------------------------------------------------------
  //--------------------- _showCamposContratista ---------------
  //------------------------------------------------------------

  Widget _showCamposContratista() {
    return Column(children: [_shownombreSR(), _showdniSR()]);
  }

  //-----------------------------------------------------------
  //--------------------- _search -----------------------------
  //-----------------------------------------------------------

  Future<void> _search() async {
    FocusScope.of(context).unfocus();
    if (_codigo.isEmpty) {
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

  //--------------------------------------------------------------
  //--------------------- _getCausante ---------------------------
  //--------------------------------------------------------------

  Future<void> _getCausante() async {
    if (_codigo == '000000') {
      _esContratista = true;
      _enabled3 = false;
      _enabled1 = true;
      setState(() {});
      return;
    }

    _esContratista = false;
    _enabled1 = false;
    setState(() {});

    _esContratista = false;
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {});
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

    Response response = await ApiHelper.getCausante(_codigo);

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
        _enabled1 = false;
      });
      return;
    }

    setState(() {
      _causante = response.result;
      _enabled1 = true;
    });
  }

  //--------------------------------------------------------------
  //--------------------- _loadData ------------------------------
  //--------------------------------------------------------------

  void _loadData() async {
    await _getClientes();
  }

  //--------------------------------------------------------------
  //--------------------- _getClientes ---------------------------
  //--------------------------------------------------------------

  Future<void> _getClientes() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      showMyDialog(
        'Error',
        'Verifica que estés conectado a Internet',
        'Aceptar',
      );
    }

    bandera = false;
    intentos = 0;

    do {
      Response response = Response(isSuccess: false);
      response = await ApiHelper.getClientes();
      intentos++;
      if (response.isSuccess) {
        bandera = true;
        _clientes = response.result;
      }
    } while (bandera == false);
    setState(() {});
  }

  //------------------------------------------------------------------------
  //------------------------------ _showClientes----------------------------
  //------------------------------------------------------------------------

  Widget _showClientes() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
            child: _clientes.isEmpty
                ? Row(
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(width: 10),
                      Text('Cargando Clientes...'),
                    ],
                  )
                : DropdownButtonFormField(
                    initialValue: _cliente,
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
                      _tipoTrabajoSelected = 0;
                      _getTiposTrabajos();
                    },
                  ),
          ),
        ),
      ],
    );
  }

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

  //-----------------------------------------------------------------------
  //------------------------- _getTiposTrabajos----------------------------
  //-----------------------------------------------------------------------

  Future<void> _getTiposTrabajos() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      showMyDialog(
        'Error',
        'Verifica que estés conectado a Internet',
        'Aceptar',
      );
    }

    bandera = false;
    intentos = 0;

    do {
      Response response = Response(isSuccess: false);
      response = await ApiHelper.getTiposTrabajos(_cliente);
      intentos++;
      if (response.isSuccess) {
        bandera = true;
        _tipoTrabajos = response.result;
      }
    } while (bandera == false);
    setState(() {});
  }

  //------------------------------------------------------------------
  //------------------ _showTiposTrabajos-----------------------------
  //------------------------------------------------------------------

  Widget _showTiposTrabajos() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: _tipoTrabajos.isEmpty
          ? const Text('')
          : DropdownButtonFormField(
              items: _getComboTiposTrabajos(),
              initialValue: _tipoTrabajoSelected,
              onChanged: (option) {
                _tipoTrabajoSelected = option as int;
                if (_tipoTrabajoSelected > 0) {
                  _enabled2 = true;
                }
                _gruposFormularios = [];
                _getGruposFormularios();

                setState(() {});
              },
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Seleccione un Tipo de Trabajo...',
                labelText: 'Tipo de Trabajo',
                errorText: _tipoTrabajoShowError ? _tipoTrabajoError : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
    );
  }

  List<DropdownMenuItem<int>> _getComboTiposTrabajos() {
    List<DropdownMenuItem<int>> list = [];
    list.add(
      const DropdownMenuItem(
        value: 0,
        child: Text('Seleccione un Tipo de Trabajo...'),
      ),
    );

    for (var tipoTrabajo in _tipoTrabajos) {
      list.add(
        DropdownMenuItem(
          value: tipoTrabajo.idtipotrabajo,
          child: Text(tipoTrabajo.descripcion),
        ),
      );
    }

    return list;
  }

  //------------------------------------------------------------------
  //------------------ _getGruposFormularios--------------------------
  //------------------------------------------------------------------

  Future<void> _getGruposFormularios() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      showMyDialog(
        'Error',
        'Verifica que estés conectado a Internet',
        'Aceptar',
      );
    }

    bandera = false;
    intentos = 0;

    do {
      Response response = Response(isSuccess: false);
      response = await ApiHelper.getGruposFormularios(
        _cliente,
        _tipoTrabajoSelected,
      );
      intentos++;
      if (response.isSuccess) {
        bandera = true;
        _gruposFormularios = response.result;
      }
    } while (bandera == false);
    setState(() {});
    _getDetallesFormularios();
    _detallesFormulariosAux = _detallesFormularios;
  }

  //------------------------------------------------------------------
  //------------------ _getDetallesFormularios------------------------
  //------------------------------------------------------------------

  Future<void> _getDetallesFormularios() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      showMyDialog(
        'Error',
        'Verifica que estés conectado a Internet',
        'Aceptar',
      );
    }

    _detallesFormularios = [];
    _detallesFormulariosAux = [];
    _detallesFormulariosCompleto = [];

    Response response = Response(isSuccess: false);

    response = await ApiHelper.getDetallesFormularios(_cliente);

    if (response.isSuccess) {
      _detallesFormulariosAux = response.result;
    }

    for (var detalleFormularioAux in _detallesFormulariosAux) {
      for (var grupoFormulario in _gruposFormularios) {
        if (detalleFormularioAux.idgrupoformulario ==
            grupoFormulario.idgrupoformulario) {
          _detallesFormularios.add(detalleFormularioAux);
          detallesFormularioCompleto = DetallesFormularioCompleto(
            idcliente: detalleFormularioAux.idcliente,
            idgrupoformulario: detalleFormularioAux.idgrupoformulario,
            descgrupoformulario: grupoFormulario.descripcion,
            detallef: detalleFormularioAux.detallef,
            descripcion: detalleFormularioAux.descripcion,
            ponderacionpuntos: detalleFormularioAux.ponderacionpuntos,
            cumple: detalleFormularioAux.cumple,
            foto: '',
            soloTexto: detalleFormularioAux.soloTexto,
            obsApp: '',
          );
          _detallesFormulariosCompleto.add(detallesFormularioCompleto);
        }
      }
    }
    var a = 1;
    setState(() {});
  }

  //-----------------------------------------------------------
  //--------------------- _generarCuestionario ----------------
  //-----------------------------------------------------------

  Future<void> _generarCuestionario() async {
    FocusScope.of(context).unfocus();

    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InspeccionCuestionarioScreen(
          user: widget.user,
          causante: _causante,
          obra: obra,
          cliente: _cliente,
          tipotrabajo: _tipoTrabajoSelected,
          esContratista: _esContratista,
          nombreSR: _nombreSRController.text,
          dniSR: _dniSRController.text,
          detallesFormulariosCompleto: _detallesFormulariosCompleto,
          positionUser: _positionUser,
        ),
      ),
    );
    if (result == 'yes') {}
  }

  //-----------------------------------------------------------
  //--------------------- _getPosition ------------------------
  //-----------------------------------------------------------

  Future _getPosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: const Text('Aviso'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: const <Widget>[
                  Text('El permiso de localización está negado.'),
                  SizedBox(height: 10),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text('Aviso'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Text(
                  'El permiso de localización está negado permanentemente. No se puede requerir este permiso.',
                ),
                SizedBox(height: 10),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
      return;
    }

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      _positionUser = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    }
  }

  //-----------------------------------------------------------
  //--------------------- _shownombreSR -----------------------
  //-----------------------------------------------------------

  Widget _shownombreSR() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextField(
        controller: _nombreSRController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingrese Nombre Contratista...',
          labelText: 'Nombre Contratista:',
          errorText: _nombreSRShowError ? _nombreSRError : null,
          prefixIcon: const Icon(Icons.person),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _nombreSR = value;
          _enabled3 = _dniSR.isNotEmpty && _nombreSR.isNotEmpty;
          setState(() {});
        },

        //enabled: _enabled,
      ),
    );
  }

  //-----------------------------------------------------------
  //--------------------- _showdniSR --------------------------
  //-----------------------------------------------------------

  Widget _showdniSR() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextField(
        controller: _dniSRController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingrese DNI Contratista...',
          labelText: 'DNI Contratista:',
          errorText: _dniSRShowError ? _dniSRError : null,
          prefixIcon: const Icon(Icons.assignment_ind),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _dniSR = value;
          _enabled3 = _dniSR.isNotEmpty && _nombreSR.isNotEmpty;
          setState(() {});
        },
        //enabled: _enabled,
      ),
    );
  }

  //-----------------------------------------------------------
  //--------------------- _showObra ---------------------------
  //-----------------------------------------------------------

  Widget _showObra() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: 1),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        const Text(
                          'Obra: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(child: Text(obra.nombreObra)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF781f1e),
              minimumSize: const Size(50, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () async {
              Obra? obra2 = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ObrasScreen(
                    user: widget.user,
                    opcion: 2,
                    positionUser: widget.positionUser,
                  ),
                ),
              );
              if (obra2 != null) {
                obra = obra2;
              }
              setState(() {});
            },
            child: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}
