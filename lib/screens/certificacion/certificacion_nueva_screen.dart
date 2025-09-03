import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../screens.dart';

class CertificacionNuevaScreen extends StatefulWidget {
  final User user;
  final Position positionUser;
  final String imei;
  final bool editMode;
  final CabeceraCertificacion cabeceraCertificacion;

  const CertificacionNuevaScreen({
    super.key,
    required this.user,
    required this.positionUser,
    required this.imei,
    required this.editMode,
    required this.cabeceraCertificacion,
  });

  @override
  _CertificacionNuevaScreenState createState() =>
      _CertificacionNuevaScreenState();
}

class _CertificacionNuevaScreenState extends State<CertificacionNuevaScreen> {
  //---------------------------------------------------------------
  //----------------------- Variables -----------------------------
  //---------------------------------------------------------------

  int _nroReg = 0;
  bool _showLoader = false;

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

  String _montoC = '';
  String _montoCError = '';
  bool _montoCShowError = false;
  final TextEditingController _montoCController = TextEditingController();

  String _montoT = '';
  String _montoTError = '';
  bool _montoTShowError = false;
  final TextEditingController _montoTController = TextEditingController();

  String _porcActa = '';
  String _porcActaError = '';
  bool _porcActaShowError = false;
  final TextEditingController _porcActaController = TextEditingController();

  bool bandera = false;
  int intentos = 0;

  DateTime? fechaCorrespondencia;

  //DateTime? fechaNovedad = null;

  List<Subcontratista> _contratistas = [];
  List<CausanteObra> _causantes = [];
  List<Objeto> _objetos = [];
  List<CodigoProduccion> _codigosProduccion = [];
  final List<Mes> _meses = [
    Mes(nroMes: 1, nombreMes: 'Enero'),
    Mes(nroMes: 2, nombreMes: 'Febrero'),
    Mes(nroMes: 3, nombreMes: 'Marzo'),
    Mes(nroMes: 4, nombreMes: 'Abril'),
    Mes(nroMes: 5, nombreMes: 'Mayo'),
    Mes(nroMes: 6, nombreMes: 'Junio'),
    Mes(nroMes: 7, nombreMes: 'Julio'),
    Mes(nroMes: 8, nombreMes: 'Agosto'),
    Mes(nroMes: 9, nombreMes: 'Setiembre'),
    Mes(nroMes: 10, nombreMes: 'Octubre'),
    Mes(nroMes: 11, nombreMes: 'Noviembre'),
    Mes(nroMes: 12, nombreMes: 'Diciembre'),
  ];

  String _observaciones = '';
  final String _observacionesError = '';
  final bool _observacionesShowError = false;
  final TextEditingController _observacionesController =
      TextEditingController();

  String _contratista = 'Elija una SubContratista...';
  String _contratistaError = '';
  bool _contratistaShowError = false;

  int? _mesImputacion = 0;
  String _mesImputacionError = '';
  bool _mesImputacionShowError = false;

  String _causante = 'Elija un Causante...';
  String _causanteError = '';
  bool _causanteShowError = false;

  String _objeto = 'Elija un Objeto...';
  String _objetoError = '';
  bool _objetoShowError = false;

  String _codigoProduccion = 'Elija un Código de Producción...';
  String _codigoProduccionError = '';
  bool _codigoProduccionShowError = false;

  //---------------------------------------------------------------
  //----------------------- initState -----------------------------
  //---------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  //---------------------------------------------------------------
  //----------------------- Pantalla ------------------------------
  //---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Nuevo Certificado'), centerTitle: true),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 5),
                _showObra(),
                _showContratistas(),
                _showCausantes(),
                _showFechas(),
                _showObservaciones(),
                _showMontoC(),
                _showMontoT(),
                _showPorcActa(),
                _showObjetos(),
                _showCodigosProduccion(),
                _showMesImputacion(),
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
  //--------------------- _showContratistas ----------------------------
  //-----------------------------------------------------------------
  Widget _showContratistas() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: _contratistas.isEmpty
          ? const Text('Cargando SubContratistas...')
          : DropdownButtonFormField(
              initialValue: _contratista,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Elija una SubContratista...',
                labelText: 'SubContratista',
                errorText: _contratistaShowError ? _contratistaError : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: _getComboContratistas(),
              onChanged: (value) async {
                setState(() {
                  _contratista = value.toString();
                  _causante = 'Elija un Causante...';
                  _causantes = [];
                });
                await _getCausantes();
                setState(() {});
              },
            ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showCausantes ----------------------------
  //-----------------------------------------------------------------
  Widget _showCausantes() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: _causantes.isEmpty
          ? Container() //const Text('Cargando Causantes...')
          : DropdownButtonFormField(
              initialValue: _causante,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Elija un Causante...',
                labelText: 'Causante',
                errorText: _causanteShowError ? _causanteError : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: _getComboCausantes(),
              onChanged: (value) {
                _causante = value.toString();
                setState(() {});
              },
            ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _getComboContratistas ---------------------
  //-----------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboContratistas() {
    List<DropdownMenuItem<String>> list = [];
    list.add(
      const DropdownMenuItem(
        value: 'Elija una SubContratista...',
        child: Text('Elija una SubContratista...'),
      ),
    );

    for (var contratista in _contratistas) {
      list.add(
        DropdownMenuItem(
          value: contratista.subCodigo,
          child: Text(contratista.subSubcontratista),
        ),
      );
    }

    return list;
  }

  //-----------------------------------------------------------------
  //--------------------- _getComboCausantes ------------------------
  //-----------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboCausantes() {
    List<DropdownMenuItem<String>> list = [];
    list.add(
      const DropdownMenuItem(
        value: 'Elija un Causante...',
        child: Text('Elija un Causante...'),
      ),
    );

    for (var causante in _causantes) {
      list.add(
        DropdownMenuItem(
          value: causante.codigo,
          child: Text(
            causante.nombre.length > 30
                ? (causante.nombre.substring(0, 29))
                : (causante.nombre),
          ),
        ),
      );
    }

    return list;
  }

  //---------------------------------------------------------------
  //--------------------- _showObjetos ----------------------------
  //---------------------------------------------------------------

  Widget _showObjetos() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: _contratistas.isEmpty
          ? const Text('Cargando Objetos...')
          : DropdownButtonFormField(
              initialValue: _objeto,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Elija un Objeto...',
                labelText: 'Objeto',
                errorText: _objetoShowError ? _objetoError : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: _getComboObjetos(),
              onChanged: (value) {
                _objeto = value.toString();
              },
            ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _getComboObjetos ------------------------
  //-----------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboObjetos() {
    List<DropdownMenuItem<String>> list = [];
    list.add(
      const DropdownMenuItem(
        value: 'Elija un Objeto...',
        child: Text('Elija un Objeto...'),
      ),
    );

    for (var objeto in _objetos) {
      list.add(
        DropdownMenuItem(value: objeto.objetos, child: Text(objeto.objetos)),
      );
    }

    return list;
  }

  //---------------------------------------------------------------
  //--------------------- _showCodigosProduccion ------------------
  //---------------------------------------------------------------

  Widget _showCodigosProduccion() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: fechaCorrespondencia == null
          ? Container()
          : DropdownButtonFormField(
              initialValue: _codigoProduccion,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Elija un Código de Producción...',
                labelText: 'Código de Producción',
                errorText: _codigoProduccionShowError
                    ? _codigoProduccionError
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: _getComboCodigosProduccion(),
              onChanged: (value) {
                _codigoProduccion = value.toString();
              },
            ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _getComboCodigosProduccion ----------------
  //-----------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboCodigosProduccion() {
    List<DropdownMenuItem<String>> list = [];
    list.add(
      const DropdownMenuItem(
        value: 'Elija un Código de Producción...',
        child: Text('Elija un Código de Producción...'),
      ),
    );

    for (var codigo in _codigosProduccion) {
      list.add(
        DropdownMenuItem(value: codigo.codigo, child: Text(codigo.codigo)),
      );
    }

    return list;
  }

  //---------------------------------------------------------------
  //--------------------- _showMesImputacion ----------------------
  //---------------------------------------------------------------

  Widget _showMesImputacion() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: _meses.isEmpty
          ? const Text('Cargando Meses...')
          : DropdownButtonFormField(
              initialValue: _mesImputacion,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Elija un Mes de Imputación...',
                labelText: 'Mes de Imputación',
                errorText: _mesImputacionShowError ? _mesImputacionError : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: _getComboMesImputacion(),
              onChanged: (value) {
                _mesImputacion = int.tryParse(value.toString());
              },
            ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _getComboMesImputacion --------------------
  //-----------------------------------------------------------------

  List<DropdownMenuItem<int>> _getComboMesImputacion() {
    List<DropdownMenuItem<int>> list = [];
    list.add(
      const DropdownMenuItem(
        value: 0,
        child: Text('Elija un Mes de Imputación...'),
      ),
    );

    int mesActual = DateTime.now().month;

    for (var mes in _meses) {
      if ((mes.nroMes == mesActual) ||
          (mes.nroMes == (mesActual - 1)) ||
          (mes.nroMes == (mesActual - 2)) ||
          (mes.nroMes == (mesActual + 10)) ||
          (mes.nroMes == (mesActual + 11))) {
        list.add(
          DropdownMenuItem(value: mes.nroMes, child: Text(mes.nombreMes)),
        );
      }
    }

    return list;
  }

  //-----------------------------------------------------------------
  //--------------------- _showFechas -------------------------------
  //-----------------------------------------------------------------

  Widget _showFechas() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
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
                        '  Fecha Corresp.:',
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
                          fechaCorrespondencia != null
                              ? '    ${fechaCorrespondencia!.day}/${fechaCorrespondencia!.month}/${fechaCorrespondencia!.year}'
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
                        onPressed: () async {
                          await _fechaCorrespondencia();
                          setState(() {});
                        },
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
  //--------------------- _showObservaciones ------------------------
  //-----------------------------------------------------------------

  Widget _showObservaciones() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _observacionesController,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'Ingresa Observaciones...',
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
                  Text('Guardar Certificado'),
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

    //--------------- Valida Obra --------------------
    if (obra.nroObra == 0) {
      isValid = false;
      showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Debe seleccionar una Obra',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return isValid;
    }

    //--------------- Valida SubContratista --------------------
    if (_contratista == 'Elija una SubContratista...') {
      isValid = false;
      _contratistaShowError = true;
      _contratistaError = 'Debe elegir una SubContratista';

      setState(() {});
      return isValid;
    } else {
      _contratistaShowError = false;
    }

    //--------------- Valida Causante --------------------
    if (_causante == 'Elija un Causante...') {
      isValid = false;
      _causanteShowError = true;
      _causanteError = 'Debe elegir un Causante';

      setState(() {});
      return isValid;
    } else {
      _causanteShowError = false;
    }

    //--------------- Valida Fecha Correspondencia --------------------
    if (fechaCorrespondencia == null) {
      isValid = false;
      showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Debe seleccionar una Fecha de Correspondencia',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return isValid;
    }

    //--------------- Valida MontoC y MontoT --------------------
    if ((_montoC == '') && (_montoT == '')) {
      isValid = false;
      _montoCShowError = true;
      _montoCError = 'Debe ingresar MontoC o MontoT o ambos';
      _montoTShowError = true;
      _montoTError = 'Debe ingresar MontoC o MontoT o ambos';
      setState(() {});
      return isValid;
    } else {
      _montoCShowError = false;
      _montoTShowError = false;
    }

    //--------------- Valida Porc Acta --------------------
    if (_porcActa == '' ||
        ((double.tryParse(_porcActa)! <= 0) ||
            (double.tryParse(_porcActa)! > 100))) {
      isValid = false;
      _porcActaShowError = true;
      _porcActaError = 'Debe colocar un valor entre 1 y 100';

      setState(() {});
      return isValid;
    } else {
      _porcActaShowError = false;
    }

    //--------------- Valida Objeto --------------------
    if (_objeto == 'Elija un Objeto...') {
      isValid = false;
      _objetoShowError = true;
      _objetoError = 'Debe seleccionar un Objeto';

      setState(() {});
      return isValid;
    } else {
      _objetoShowError = false;
    }

    //--------------- Valida Codigo de Produccion --------------------
    if (_codigoProduccion == 'Elija un Código de Producción...') {
      isValid = false;
      _codigoProduccionShowError = true;
      _codigoProduccionError = 'Debe seleccionar un Objeto';

      setState(() {});
      return isValid;
    } else {
      _codigoProduccionShowError = false;
    }

    //--------------- Valida Mes de Imputacion --------------------
    if (_mesImputacion == 0) {
      isValid = false;
      _mesImputacionShowError = true;
      _mesImputacionError = 'Debe seleccionar un Objeto';

      setState(() {});
      return isValid;
    } else {
      _mesImputacionShowError = false;
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

    Response response2 = await ApiHelper.getNroRegistroMaxCertificaciones();
    if (response2.isSuccess) {
      _nroReg = int.parse(response2.result.toString()) + 1;
    }

    String ahora = DateTime.now().toString();

    Map<String, dynamic> request = {
      'ID': !widget.editMode ? _nroReg : widget.cabeceraCertificacion.id,
      'NROOBRA': obra.nroObra,
      'DefProy': obra.defProy,
      'FECHACARGA': DateTime.now().toString().substring(0, 10),
      'FECHADESPACHO': DateTime.now().toString().substring(0, 10),
      'FECHAEJECUCION': DateTime.now().toString().substring(0, 10),
      'NombreObra': obra.nombreObra,
      'NroOE': obra.nroOE,
      'subCodigo': _contratista,
      'CENTRAL': obra.central.length >= 3
          ? obra.central.substring(0, 3)
          : 'xxx',
      'NroPre': !widget.editMode ? _nroReg : widget.cabeceraCertificacion.id,
      'OBSERVACION': _observaciones,
      'FECHACORRESPONDENCIA':
          fechaCorrespondencia!.difference(DateTime(1900, 1, 1)).inDays + 36163,
      'FECHALIBERACION': DateTime.now().toString().substring(0, 10),
      'VALORTOTAL': double.tryParse(_montoC),
      'VALOR90': double.tryParse(_montoC),
      'PRECIO90': double.tryParse(_montoC),
      'MONTO90': double.tryParse(_montoC),
      'CODIGOPRODUCCION': _codigoProduccion,
      'VALORTOTALC': double.tryParse(_montoC),
      'VALORTOTALT': double.tryParse(_montoT),
      'CodCausanteC': _causante,
      'Modulo': widget.user.modulo,
      'IdUsuario': widget.user.idUsuario,
      'Terminal': widget.imei,
      'MesImputacion': _mesImputacion,
      'Objeto': _objeto,
      'PorcActa': double.tryParse(_porcActa),
    };

    if (!widget.editMode) {
      Response response = await ApiHelper.postNoToken(
        '/api/CabeceraCertificacion/PostCabeceraCertificacion',
        request,
      );
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
    } else {
      Response response = await ApiHelper.put(
        '/api/CabeceraCertificacion/',
        widget.cabeceraCertificacion.id.toString(),
        request,
      );
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
    }
    setState(() {
      _showLoader = false;
    });

    Navigator.pop(context, 'yes');
  }

  //-----------------------------------------------------------------
  //--------------------- _loadData ---------------------------------
  //-----------------------------------------------------------------

  void _loadData() async {
    await _getSubcontratistas();
  }

  //-----------------------------------------------------------------
  //--------------------- _getSubcontratistas -----------------------
  //-----------------------------------------------------------------

  Future<void> _getSubcontratistas() async {
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
      response = await ApiHelper.getSubcontratistas(widget.user.modulo);
      intentos++;
      if (response.isSuccess) {
        bandera = true;
        _contratistas = response.result;
      }
    } while (bandera == false);

    setState(() {});

    await _getObjetos();
  }

  //-----------------------------------------------------------------
  //--------------------- _getObjetos -------------------------------
  //-----------------------------------------------------------------

  Future<void> _getObjetos() async {
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
      response = await ApiHelper.getObjetos(widget.user.modulo);
      intentos++;
      if (response.isSuccess) {
        bandera = true;
        _objetos = response.result;
      }
    } while (bandera == false);

    if (widget.editMode) {
      await _loadFields();
    } else {
      setState(() {});
    }
  }

  //-----------------------------------------------------------------
  //--------------------- _getCodigosProduccion ---------------------
  //-----------------------------------------------------------------

  Future<void> _getCodigosProduccion() async {
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
    if (fechaCorrespondencia == null) return;
    Map<String, dynamic> request = {
      'Fecha': fechaCorrespondencia.toString().substring(0, 10),
    };

    if (fechaCorrespondencia != null) {
      do {
        Response response = Response(isSuccess: false);
        response = await ApiHelper.post2(
          '/api/CodigosProduccion/GetCodigos',
          request,
        );
        intentos++;
        if (response.isSuccess) {
          bandera = true;
          _codigosProduccion = response.result;
        }
      } while (bandera == false);
    }
  }

  //-----------------------------------------------------------------
  //--------------------- _getCausantes -----------------------------
  //-----------------------------------------------------------------

  Future<void> _getCausantes() async {
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
      response = await ApiHelper.getCausantesObra(_contratista);
      intentos++;
      if (response.isSuccess) {
        bandera = true;
        _causantes = response.result;
      }
    } while (bandera == false);
  }

  //-----------------------------------------------------------------
  //--------------------- _fechaCorrespondencia ---------------------
  //-----------------------------------------------------------------

  Future<void> _fechaCorrespondencia() async {
    FocusScope.of(context).unfocus();
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().add(const Duration(days: -180)),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != fechaCorrespondencia) {
      setState(() {
        fechaCorrespondencia = selected;
      });
    }
    _codigoProduccion = 'Elija un Código de Producción...';
    await _getCodigosProduccion();
  }

  //-----------------------------------------------------------
  //--------------------- _showObra ---------------------------
  //-----------------------------------------------------------

  Widget _showObra() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Obra: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Def.Proy.: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Central: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Expanded(
                          child: obra.nroObra != 0
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${obra.nroObra} - ${obra.nombreObra}',
                                      maxLines: 1,
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      obra.defProy.toString(),
                                      maxLines: 1,
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(obra.central.toString()),
                                  ],
                                )
                              : Container(),
                        ),
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

  //-------------------------------------------------------------------
  //-------------------------- _showMontoC ----------------------------
  //-------------------------------------------------------------------
  Widget _showMontoC() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _montoCController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingresa MontoC...',
          labelText: 'MontoC',
          errorText: _montoCShowError ? _montoCError : null,
          suffixIcon: const Icon(Icons.monetization_on),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _montoC = value;
        },
      ),
    );
  }

  //-------------------------------------------------------------------
  //-------------------------- _showMontoT ----------------------------
  //-------------------------------------------------------------------
  Widget _showMontoT() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _montoTController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingresa MontoT...',
          labelText: 'MontoT',
          errorText: _montoTShowError ? _montoTError : null,
          suffixIcon: const Icon(Icons.monetization_on),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _montoT = value;
        },
      ),
    );
  }

  //-------------------------------------------------------------------
  //-------------------------- _showPorcActa ----------------------------
  //-------------------------------------------------------------------
  Widget _showPorcActa() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _porcActaController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingresa Porc. Acta...',
          labelText: 'Porc. Acta',
          errorText: _porcActaShowError ? _porcActaError : null,
          suffixIcon: const Icon(Icons.percent),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _porcActa = value;
        },
      ),
    );
  }

  //-------------------------------------------------------------
  //-------------------- _loadFields ----------------------------
  //-------------------------------------------------------------

  Future<void> _loadFields() async {
    obra.nroObra = widget.cabeceraCertificacion.nroobra;
    obra.nombreObra = widget.cabeceraCertificacion.nombreObra!;
    obra.central = widget.cabeceraCertificacion.central!;
    obra.defProy = widget.cabeceraCertificacion.defProy!;
    obra.nroOE = widget.cabeceraCertificacion.nroOE!;

    _contratista = widget.cabeceraCertificacion.subCodigo!;
    _causante = widget.cabeceraCertificacion.codCausanteC!;

    fechaCorrespondencia = DateTime(1900, 1, 1).add(
      Duration(
        days: widget.cabeceraCertificacion.fechacorrespondencia! - 36163,
      ),
    );

    _observaciones = widget.cabeceraCertificacion.observacion!;
    _observacionesController.text = widget.cabeceraCertificacion.observacion!;

    _montoC = widget.cabeceraCertificacion.valortotalc!.toString();
    _montoCController.text = widget.cabeceraCertificacion.valortotalc!
        .toString();

    _montoT = widget.cabeceraCertificacion.valortotalt!.toString();
    _montoTController.text = widget.cabeceraCertificacion.valortotalt!
        .toString();

    _porcActa = widget.cabeceraCertificacion.porcActa!.toString();
    _porcActaController.text = widget.cabeceraCertificacion.porcActa!
        .toString();

    _objeto = widget.cabeceraCertificacion.objeto!;

    _codigoProduccion = widget.cabeceraCertificacion.codigoproduccion!;

    _mesImputacion = widget.cabeceraCertificacion.mesImputacion!;

    _observaciones = widget.cabeceraCertificacion.observacion.toString();
    _observacionesController.text = widget.cabeceraCertificacion.observacion
        .toString();

    await _getCodigosProduccion();
    await _getCausantes();

    setState(() {});
  }
}
