import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../screens.dart';

class VeredasScreen extends StatefulWidget {
  final User user;
  final Obra obra;
  final Position positionUser;
  const VeredasScreen({
    super.key,
    required this.user,
    required this.obra,
    required this.positionUser,
  });

  @override
  State<VeredasScreen> createState() => _VeredasScreenState();
}

class _VeredasScreenState extends State<VeredasScreen> {
  //---------------------------------------------------------------
  //----------------------- Variables -----------------------------
  //---------------------------------------------------------------

  Obra _obra = Obra(
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

  ObrasReparo obrasReparoSelected = ObrasReparo(
    nroregistro: 0,
    nroobra: 0,
    fechaalta: '',
    fechainicio: '',
    fechacumplimento: '',
    requeridopor: '',
    subcontratista: '',
    subcontratistareparo: '',
    codcausante: '',
    nroctoc: '',
    direccion: '',
    altura: '',
    latitud: '',
    longitud: '',
    codtipostdrparo: 0,
    estadosubcon: '',
    recursos: '',
    montodisponible: 0,
    grua: '',
    idUsuario: 0,
    terminal: '',
    observaciones: '',
    foto1: '',
    tipoVereda: '',
    cantidadMTL: 0,
    ancho: 0,
    profundidad: 0,
    fechaCierreElectrico: '',
    imageFullPath: '',
    fotoInicio: '',
    fotoFin: '',
    modulo: '',
    observacionesFotoInicio: '',
    observacionesFotoFin: '',
    fotoInicioFullPath: '',
    fotoFinFullPath: '',
    clase: '',
    ancho2: 0,
    largo2: 0,
  );

  List<ObrasReparo> _obrasReparos = [];

  //---------------------------------------------------------------
  //----------------------- initState -----------------------------
  //---------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _obra = widget.obra;
    _getVeredas();
  }

  //---------------------------------------------------------------
  //----------------------- Pantalla ------------------------------
  //---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(title: const Text('Veredas'), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF781f1e),
        onPressed: () async {
          if (widget.obra.finalizada == 1) {
            await showAlertDialog(
              context: context,
              title: 'Error',
              message: 'Obra Terminada. No se puede agregar veredas.',
              actions: <AlertDialogAction>[
                const AlertDialogAction(key: null, label: 'Aceptar'),
              ],
            );
            return;
          }

          if (widget.user.habilitaFotos != 1) {
            await showAlertDialog(
              context: context,
              title: 'Error',
              message: 'Su usuario no está habilitado para agregar Veredas.',
              actions: <AlertDialogAction>[
                const AlertDialogAction(key: null, label: 'Aceptar'),
              ],
            );
            return;
          }
          String? result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  VeredaAgregarScreen(user: widget.user, obra: widget.obra),
            ),
          );
          if (result != 'zzz') {
            _getVeredas();
            setState(() {});
          }
        },
        child: const Icon(Icons.add, size: 38),
      ),
      body: Column(
        children: [
          _getInfoObra(),
          const SizedBox(height: 3),
          _obrasReparos.isEmpty
              ? Container()
              : Row(
                  children: [
                    const SizedBox(width: 5),
                    const Text(
                      'Cant. Veredas: ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _obrasReparos.length.toString(),
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 5),
          Expanded(
            child: _obrasReparos.isEmpty ? _noContent() : _getListView(),
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
      height: 200,
      width: 300,
      margin: const EdgeInsets.all(20),
      child: const Center(
        child: Text(
          'Esta Obra no tiene Veredas pendientes cargadas.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.white,
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
      children: _obrasReparos.map((e) {
        return Card(
          color: Colors.white,
          //color: Color(0xFFC7C7C8),
          shadowColor: Colors.white,
          elevation: 10,
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: InkWell(
            onTap: () async {
              obrasReparoSelected = e;
              await _goObraReparo(e);
            },
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
                                      width: 110,
                                      child: Text(
                                        'Dirección: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF0e4888),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${e.direccion!} ${e.altura}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 1),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 110,
                                      child: Text(
                                        'Tipo Vereda: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF0e4888),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.tipoVereda!,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 1),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 110,
                                      child: Text(
                                        'Mts. lineales: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF0e4888),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.cantidadMTL.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 1),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 110,
                                      child: Text(
                                        'Ancho [cm]: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF0e4888),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.ancho.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 1),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 110,
                                      child: Text(
                                        'Profundidad [cm]: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF0e4888),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.profundidad.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 1),
                                e.fechacumplimento != 'null' &&
                                        e.fechacumplimento != null
                                    ? Row(
                                        children: [
                                          const SizedBox(
                                            width: 110,
                                            child: Text(
                                              'Fecha  cumpl.: ',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              DateFormat('dd/MM/yyyy').format(
                                                DateTime.parse(
                                                  e.fechacumplimento!,
                                                ),
                                              ),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  e.fechacumplimento == null || e.fechacumplimento == 'null'
                      ? const Icon(
                          Icons.fact_check,
                          color: Color(0xFF781f1e),
                          size: 40,
                        )
                      : const Icon(Icons.save, color: Colors.red, size: 40),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  //-----------------------------------------------------------------------
  //-------------------------- _getInfoObra -------------------------------
  //-----------------------------------------------------------------------

  Widget _getInfoObra() {
    return Card(
      color: const Color(0xFFC7C7C8),
      shadowColor: Colors.white,
      elevation: 10,
      margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'N° Obra: ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF781f1e),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    _obra.nroObra.toString(),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Text(
                  'Nombre: ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF781f1e),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    _obra.nombreObra,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Text(
                  'OP/N° Fuga: ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF781f1e),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    _obra.elempep,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            SizedBox(
              height:
                  (_obra.fechaCierreElectrico != '' &&
                      _obra.fechaCierreElectrico != null)
                  ? 5
                  : 0,
            ),
            _obra.fechaCierreElectrico != '' &&
                    _obra.fechaCierreElectrico != null
                ? Row(
                    children: [
                      (widget.user.modulo == 'Aysa' ||
                              widget.user.modulo == 'Cetaco')
                          ? const Text(
                              'Fec. Cierre Hidr.',
                              style: TextStyle(
                                color: Color(0xFF781f1e),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            )
                          : const Text(
                              'Fec. Cierre Eléc.',
                              style: TextStyle(
                                color: Color(0xFF781f1e),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                      Expanded(
                        child: Text(
                          DateFormat('dd/MM/yyyy').format(
                            DateTime.parse(
                              _obra.fechaCierreElectrico.toString(),
                            ),
                          ),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  //-----------------------------------------------------------------------
  //-------------------------- _goObraReparo ------------------------------
  //-----------------------------------------------------------------------

  Future<void> _goObraReparo(ObrasReparo obraReparo) async {
    if (obraReparo.fechacumplimento == null ||
        obraReparo.fechacumplimento == 'null') {
      final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 7)),
        lastDate: DateTime.now().add(const Duration(days: 0)),
      );
      if (selected == null) return;
      obraReparo.fechacumplimento = selected.toString().substring(0, 10);
      setState(() {});
    } else {
      obraReparo.fechacumplimento = null;
    }

    Map<String, dynamic> request = {
      'NROREGISTRO': obraReparo.nroregistro,
      'FECHACUMPLIMENTO': obraReparo.fechacumplimento,
      'ObservacionesFotoInicio': obraReparo.observacionesFotoInicio ?? '',
      'ObservacionesFotoFin': obraReparo.observacionesFotoFin ?? '',
    };

    await ApiHelper.put(
      '/api/ObrasReparos/',
      obraReparo.nroregistro.toString(),
      request,
    );

    setState(() {
      _getVeredas();
    });
  }

  //-----------------------------------------------------------------------
  //-------------------------- _getVeredas --------------------------------
  //-----------------------------------------------------------------------

  Future<void> _getVeredas() async {
    setState(() {});

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

    Response response = await ApiHelper.getObrasReparos(widget.obra.nroObra);

    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'N° de Obra no válido',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );

      setState(() {});
      return;
    }
    _obrasReparos = response.result;

    setState(() {});
  }
}
