// ignore_for_file: unnecessary_const

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../screens.dart';

class CertificacionesScreen extends StatefulWidget {
  final User user;
  final Position positionUser;
  final String imei;

  const CertificacionesScreen({
    super.key,
    required this.user,
    required this.positionUser,
    required this.imei,
  });

  @override
  _CertificacionesScreenState createState() => _CertificacionesScreenState();
}

class _CertificacionesScreenState extends State<CertificacionesScreen> {
  //-----------------------------------------------------------------
  //--------------------- Variables ---------------------------------
  //-----------------------------------------------------------------

  List<CabeceraCertificacion> _certificaciones = [];
  bool _showLoader = false;

  //-----------------------------------------------------------------
  //--------------------- initState ---------------------------------
  //-----------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _getCertificaciones();
  }

  //-----------------------------------------------------------------
  //--------------------- Pantallas ---------------------------------
  //-----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(title: const Text('Certificaciones'), centerTitle: true),
      body: Center(
        child: _showLoader
            ? const LoaderComponent(text: 'Por favor espere...')
            : _getContent(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF781f1e),
        onPressed: () => _addCertificacion(),
        child: const Icon(Icons.add, size: 38),
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _getCertificaciones -----------------------
  //-----------------------------------------------------------------

  Future<void> _getCertificaciones() async {
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

    response = await ApiHelper.getCertificaciones(
      widget.user.modulo.toString(),
      widget.user.idUsuario,
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
      _certificaciones = response.result;
      _certificaciones.sort((a, b) {
        return a.id.toString().toLowerCase().compareTo(
          b.id.toString().toLowerCase(),
        );
      });
    });
  }

  //-----------------------------------------------------------------
  //--------------------- _getContent -------------------------------
  //-----------------------------------------------------------------

  Widget _getContent() {
    return Column(
      children: <Widget>[
        _showCertificacionesCount(),
        Expanded(
          child: _certificaciones.isEmpty ? _noContent() : _getListView(),
        ),
      ],
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _noContent --------------------------------
  //-----------------------------------------------------------------

  Widget _noContent() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: const Center(
        child: Text(
          'No hay Certificaciones registradas',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _getListView ------------------------------
  //-----------------------------------------------------------------

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getCertificaciones,
      child: ListView(
        children: _certificaciones.map((e) {
          return Card(
            color: const Color(0xFFC7C7C8),
            shadowColor: Colors.white,
            elevation: 10,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
            child: InkWell(
              onTap: () {
                _goInfoCertificacion(e);
              },
              child: Container(
                height: 180,
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: 100,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Text(
                                      'Id Acta: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: const [
                                    Text(
                                      'Fecha: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: const [
                                    Text(
                                      'N° Obra: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: const [
                                    Text(
                                      'Central: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: const [
                                    Text(
                                      'SubC: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: const [
                                    Text(
                                      'Fecha Corresp.: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: const [
                                    Text(
                                      'Cod. Prod.: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: const [
                                    Text(
                                      'Mes Imput.: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: const [
                                    Text(
                                      'Objeto: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: const [
                                    Text(
                                      'MontoC: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: const [
                                    Text(
                                      'MontoT: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF781f1e),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Text(
                                        e.id.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        DateFormat(
                                          'dd/MM/yyyy',
                                        ).format(DateTime.parse(e.fechacarga!)),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${e.nroobra} - ${e.nombreObra}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        e.central.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${e.subCodigo} - ${e.codCausanteC}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        DateFormat('dd/MM/yyyy').format(
                                          DateTime(1900, 1, 1).add(
                                            Duration(
                                              days:
                                                  e.fechacorrespondencia! -
                                                  36163,
                                            ),
                                          ),
                                        ),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        e.codigoproduccion.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        e.mesImputacion.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        e.objeto.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        e.valortotalc != null
                                            ? NumberFormat.currency(
                                                symbol: '\$',
                                              ).format(e.valortotalc)
                                            : '',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        e.valortotalt != null
                                            ? NumberFormat.currency(
                                                symbol: '\$',
                                              ).format(e.valortotalt)
                                            : '',
                                        style: const TextStyle(fontSize: 12),
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        (e.nrO103 == '')
                            ? IconButton(
                                icon: const CircleAvatar(
                                  backgroundColor: Color(0xFF781f1e),
                                  child: Icon(
                                    Icons.edit,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () async {
                                  _editCabeceraCertificacion(e);
                                },
                              )
                            : Container(),
                        (e.nrO103 == '')
                            ? IconButton(
                                icon: const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.delete,
                                    size: 24,
                                    color: Colors.red,
                                  ),
                                ),
                                onPressed: () async {
                                  await _borrarCabeceraCertificacion(e);
                                },
                              )
                            : Container(),
                        IconButton(
                          icon: const CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 24,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () async {
                            _goInfoCertificacion(e);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _goInfoCertificacion ----------------------
  //-----------------------------------------------------------------

  void _goInfoCertificacion(CabeceraCertificacion e) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CertificacionDetalleScreen(
          user: widget.user,
          positionUser: widget.positionUser,
          imei: widget.imei,
          editMode: true,
          cabeceraCertificacion: e,
        ),
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showCertificacionesCount -----------------
  //-----------------------------------------------------------------

  Widget _showCertificacionesCount() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 40,
      child: Row(
        children: [
          const Text(
            'Cantidad de Certificaciones: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _certificaciones.length.toString(),
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

  //-----------------------------------------------------------------
  //--------------------- _addCertificacion -------------------------
  //-----------------------------------------------------------------

  void _addCertificacion() async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CertificacionNuevaScreen(
          user: widget.user,
          positionUser: widget.positionUser,
          imei: widget.imei,
          editMode: false,
          cabeceraCertificacion: CabeceraCertificacion(
            id: 0,
            nroobra: 0,
            defProy: '',
            fechacarga: '',
            fechadespacho: '',
            fechaejecucion: '',
            nombreObra: '',
            nroOE: '',
            finalizada: 0,
            materialesdescontados: 0,
            subCodigo: '',
            central: '',
            preadicional: 0,
            nroPre: 0,
            sipa: '',
            observacion: '',
            tipificacion: '',
            fechacorrespondencia: 0,
            marcadeventa: 0,
            nrO103: '',
            nrO105: '',
            idusuariop: 0,
            fechaliberacion: '',
            idusuariol: 0,
            nroordenpago: 0,
            valortotal: 0,
            pagaR90: '',
            valoR90: 0,
            preciO90: 0,
            montO90: 0,
            pagaR10: '',
            valoR10: 0,
            preciO10: 0,
            montO10: 0,
            idusuariofr: 0,
            fechafondoreparo: '',
            nropagofr: 0,
            codigoproduccion: '',
            observacionO: '',
            clase: '',
            valortotalc: 0,
            valortotalt: 0,
            porcAplicado: 0,
            pagarx: '',
            valorx: 0,
            preciO10X: 0,
            montox: 0,
            codCausanteC: '',
            cobrar: 0,
            presentado: '',
            estado: '',
            modulo: '',
            idUsuario: 0,
            terminal: '',
            fecha103: '',
            fecha105: '',
            mesImputacion: 0,
            objeto: '',
            porcActa: 0,
          ),
        ),
      ),
    );
    if (result == 'yes') {
      _getCertificaciones();
    }
  }

  //-----------------------------------------------------------------
  //-------------------- _borrarCabeceraCertificacion ---------------
  //-----------------------------------------------------------------

  Future<void> _borrarCabeceraCertificacion(CabeceraCertificacion e) async {
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
              Text('¿Está seguro de borrar este Certificado?'),
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
                Response response = await ApiHelper.delete(
                  '/api/CabeceraCertificacion/',
                  e.id.toString(),
                );

                _getCertificaciones();

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

  //---------------------------------------------------------------
  //----------------- _editCabeceraCertificacion ------------------
  //---------------------------------------------------------------

  void _editCabeceraCertificacion(CabeceraCertificacion e) async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CertificacionNuevaScreen(
          user: widget.user,
          positionUser: widget.positionUser,
          imei: widget.imei,
          editMode: true,
          cabeceraCertificacion: e,
        ),
      ),
    );
    if (result == 'yes' || result != 'yes') {
      _getCertificaciones();
      setState(() {});
    }
  }
}
