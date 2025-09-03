import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../screens.dart';

class GruasCheckListScreen extends StatefulWidget {
  final User user;
  const GruasCheckListScreen({super.key, required this.user});

  @override
  State<GruasCheckListScreen> createState() => _GruasCheckListScreenState();
}

class _GruasCheckListScreenState extends State<GruasCheckListScreen> {
  //-----------------------------------------------------------------------------
  //----------------------------- Variables -------------------------------------
  //-----------------------------------------------------------------------------

  List<VehiculosCheckList> _checkLists = [];

  bool _showLoader = false;

  VehiculosCheckList _checkListSeleccionada = VehiculosCheckList(
    idCheckList: 0,
    fecha: '',
    idUser: 0,
    idCliente: 0,
    cliente: '',
    idVehiculo: 0,
    numcha: '',
    nrotar: '',
    codProducto: '',
    aniofa: 0,
    descripcion: '',
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
    vtv: '',
    fechaVencVTV: '',
    vth: '',
    fechaVencVTH: '',
    cubiertas: '',
    correaCinturon: '',
    apoyaCabezas: '',
    limpiavidrios: '',
    espejos: '',
    indicadoresDeGiro: '',
    bocina: '',
    dispositivoPAT: '',
    ganchos: '',
    alarmaRetroceso: '',
    manguerasCircuitoHidraulico: '',
    farosDelanteros: '',
    farosTraseros: '',
    luzPosicion: '',
    luzFreno: '',
    luzRetroceso: '',
    luzEmergencia: '',
    balizaPortatil: '',
    matafuegos: '',
    identificadorEmpresa: '',
    sobreSalientesPeligro: '',
    diagramaDeCarga: '',
    fajas: '',
    grilletes: '',
    cintaSujecionCarga: '',
    jefeDirecto: '',
    responsableVehiculo: '',
    observaciones: '',
    grupoC: '',
    causanteC: '',
    nombre: '',
    dni: '',
    apellidoNombre: '',
    seguro: '',
    fechaVencSeguro: '',
  );

  late VehiculosCheckList _checkListVacio;

  User _user = User(
    idUsuario: 0,
    codigoCausante: '',
    login: '',
    contrasena: '',
    nombre: '',
    apellido: '',
    autorWOM: 0,
    estado: 0,
    habilitaAPP: 0,
    habilitaFotos: 0,
    habilitaReclamos: 0,
    habilitaSSHH: 0,
    habilitaRRHH: 0,
    modulo: '',
    habilitaMedidores: 0,
    habilitaFlotas: '',
    reHabilitaUsuarios: 0,
    codigogrupo: '',
    codigocausante: '',
    fullName: '',
    fechaCaduca: 0,
    intentosInvDiario: 0,
    opeAutorizo: 0,
    habilitaNuevoSuministro: 0,
    habilitaVeredas: 0,
    habilitaJuicios: 0,
    habilitaPresentismo: 0,
    habilitaSeguimientoUsuarios: 0,
    habilitaVerObrasCerradas: 0,
    habilitaElementosCalle: 0,
    habilitaCertificacion: 0,
    conceptomov: 0,
    conceptomova: 0,
    limitarGrupo: 0,
    rubro: 0,
    firmaUsuario: '',
    firmaUsuarioImageFullPath: '',
    appIMEI: '',
  );

  //-----------------------------------------------------------------------------
  //----------------------------- Init State ------------------------------------
  //-----------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _checkListVacio = _checkListSeleccionada;
    _getCheckLists();

    //-----------------------------------------------------------------------------
    //----------------------------- Pantalla --------------------------------------
    //-----------------------------------------------------------------------------
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: const Text('Check List'),
        centerTitle: true,
        backgroundColor: const Color(0xff242424),
      ),
      body: Stack(
        children: [
          !_showLoader
              ? Column(
                  children: [
                    _showGruasCheckListCount(),
                    Expanded(child: _getContent()),
                  ],
                )
              : Container(),
          _showLoader
              ? const LoaderComponent(text: 'Por favor espere...')
              : Container(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: 2,
        backgroundColor: const Color(0xFF781f1e),
        onPressed: () async {
          String? result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GruasCheckListAgregarScreen(
                user: widget.user,
                editMode: false,
                checkList: _checkListVacio,
              ),
            ),
          );
          if (result != 'zzz') {
            _getCheckLists();
            setState(() {});
          }
        },
        child: const Icon(Icons.add, size: 38),
      ),
    );
  }

  //-----------------------------------------------------------------------
  //-------------------------- _showGruasCheckListCount -------------------
  //-----------------------------------------------------------------------

  Widget _showGruasCheckListCount() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.all(1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            margin: const EdgeInsets.all(1),
            padding: const EdgeInsets.all(0),
            child: Row(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Cant.de Check List: ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _checkLists.length.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF781f1e),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //-------------------------------------------------------------------
  //-------------------------- _getContent ----------------------------
  //-------------------------------------------------------------------

  Widget _getContent() {
    return _checkLists.isEmpty ? _noContent() : _getListView();
  }

  //-------------------------------------------------------------------
  //-------------------------- _noContent -----------------------------
  //-------------------------------------------------------------------

  Widget _noContent() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: const Text(
          'No hay Check List',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //-------------------------------------------------------------------
  //-------------------------- _getListView ---------------------------
  //-------------------------------------------------------------------

  Widget _getListView() {
    double ancho = MediaQuery.of(context).size.width;
    double anchoTitulo = ancho * 0.2;
    return ListView(
      //padding: const EdgeInsets.fromLTRB(10, 5, 2, 25),
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      children: _checkLists.map((e) {
        return Card(
          color: const Color(0xFFC7C7C8),
          shadowColor: Colors.white,
          elevation: 10,
          margin: const EdgeInsets.fromLTRB(10, 15, 10, 0),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _RowCustom(
                                anchoTitulo: anchoTitulo,
                                titulo: 'Id:',
                                dato: e.idCheckList.toString(),
                              ),
                              _RowCustom(
                                anchoTitulo: anchoTitulo,
                                titulo: 'Fecha:',
                                dato: DateFormat(
                                  'dd/MM/yyyy',
                                ).format(DateTime.parse(e.fecha!)),
                              ),
                              _RowCustom(
                                anchoTitulo: anchoTitulo,
                                titulo: 'Patente:',
                                dato: e.numcha!,
                              ),
                              _RowCustom(
                                anchoTitulo: anchoTitulo,
                                titulo: 'Descripción:',
                                dato: e.descripcion!,
                              ),
                              _RowCustom(
                                anchoTitulo: anchoTitulo,
                                titulo: 'Cliente:',
                                dato: e.cliente!,
                              ),
                              _RowCustom(
                                anchoTitulo: anchoTitulo,
                                titulo: 'Descripción:',
                                dato: e.descripcion!,
                              ),
                              _RowCustom(
                                anchoTitulo: anchoTitulo,
                                titulo: 'Nombre y Apellido:',
                                dato: e.apellidoNombre!,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: ancho * 0.1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () async {
                        String? result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GruasCheckListAgregarScreen(
                              user: widget.user,
                              editMode: true,
                              checkList: e,
                            ),
                          ),
                        );
                        if (result != 'zzz') {
                          _getCheckLists();
                          setState(() {});
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await _borrarCheckList(e);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.photo_camera, color: Colors.blue),
                      onPressed: () {
                        _checkListSeleccionada = e;
                        _goFotos(e);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  //-----------------------------------------------------------------
  //-------------------------- _goFotos -----------------------------
  //-----------------------------------------------------------------

  void _goFotos(VehiculosCheckList e) async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            GruasCheckListFotosScreen(user: _user, vehiculosCheckList: e),
      ),
    );
    if (result == 'yes' || result != 'yes') {
      setState(() {});
    }
  }

  //-----------------------------------------------------------------------------
  //------------------------------- _getCheckLists ------------------------------
  //-----------------------------------------------------------------------------

  Future<void> _getCheckLists() async {
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

    response = await ApiHelper.getVehiculosCheckLists(
      widget.user.idUsuario.toString(),
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

    setState(() {
      _checkLists = response.result;
      _checkLists.sort((b, a) {
        return a.idCheckList.toString().toLowerCase().compareTo(
          b.idCheckList.toString().toLowerCase(),
        );
      });
    });
  }

  //-----------------------------------------------------------------
  //-------------------------- _borrarCheckList ---------------------
  //-----------------------------------------------------------------

  Future<void> _borrarCheckList(VehiculosCheckList e) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text(''),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
              Text('¿Está seguro de borrar este Check List?'),
              SizedBox(height: 10),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('NO'),
            ),
            TextButton(
              onPressed: () async {
                //Borra Fotos
                Response response2 =
                    await ApiHelper.deleteVehiculosCheckListsFotos(
                      e.idCheckList.toString(),
                    );

                //Borra Check List
                Response response = await ApiHelper.delete(
                  '/api/VehiculosCheckLists/',
                  e.idCheckList.toString(),
                );

                _getCheckLists();

                setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text('SI'),
            ),
          ],
        );
      },
    );
  }
}

//-----------------------------------------------------------------
//-------------------------- _RowCustom ---------------------------
//-----------------------------------------------------------------

class _RowCustom extends StatelessWidget {
  const _RowCustom({
    super.key,
    required this.anchoTitulo,
    required this.titulo,
    required this.dato,
  });

  final double anchoTitulo;
  final String titulo;
  final String dato;

  @override
  Widget build(BuildContext context) {
    double ancho = MediaQuery.of(context).size.width * 0.75;
    return SizedBox(
      width: ancho,
      child: Row(
        children: [
          SizedBox(
            width: anchoTitulo,
            child: Text(
              titulo,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF781f1e),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(child: Text(dato, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}
