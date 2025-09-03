import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rowing_app/components/loader_component.dart';
import 'package:rowing_app/helpers/helpers.dart';
import 'package:rowing_app/models/models.dart';
import 'package:rowing_app/screens/screens.dart';

class ObrasNuevosSuministrosScreen extends StatefulWidget {
  final User user;
  const ObrasNuevosSuministrosScreen({super.key, required this.user});

  @override
  State<ObrasNuevosSuministrosScreen> createState() =>
      _ObrasNuevosSuministrosScreenState();
}

class _ObrasNuevosSuministrosScreenState
    extends State<ObrasNuevosSuministrosScreen> {
  //-----------------------------------------------------------
  //--------------------- Variables ---------------------------
  //-----------------------------------------------------------

  List<ObrasNuevoSuministro> _suministros = [];
  List<ObraNuevoSuministroDet> _suministrosdet = [];

  bool _showLoader = false;

  int _nroReg = 0;

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

  ObrasNuevoSuministro suministroSelected = ObrasNuevoSuministro(
    nrosuministro: 0,
    nroobra: 0,
    fecha: '',
    apellidonombre: '',
    dni: '',
    telefono: '',
    email: '',
    cuadrilla: '',
    grupoc: '',
    causantec: '',
    directa: '',
    domicilio: '',
    barrio: '',
    localidad: '',
    partido: '',
    antesfotO1: '',
    antesfotO2: '',
    despuesfotO1: '',
    despuesfotO2: '',
    fotodnifrente: '',
    fotodnireverso: '',
    firmacliente: '',
    entrecalleS1: '',
    entrecalleS2: '',
    medidorcolocado: '',
    medidorvecino: '',
    tipored: '',
    corte: '',
    denuncia: '',
    enre: '',
    otro: '',
    conexiondirecta: '',
    retiroconexion: '',
    retirocrucecalle: '',
    mtscableretirado: 0,
    trabajoconhidro: '',
    postepodrido: '',
    observaciones: '',
    potenciacontratada: 0,
    tensioncontratada: 0,
    kitnro: 0,
    idcertifmateriales: 0,
    idcertifbaremo: 0,
    enviado: 0,
    materiales: 0,
  );

  //-----------------------------------------------------------
  //--------------------- initState ---------------------------
  //-----------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _getSuministros();
  }

  //-----------------------------------------------------------
  //--------------------- Pantalla ----------------------------
  //-----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: const Text('Suministros'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: CircleAvatar(
              child: TextButton(
                child: const Text(
                  "M",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  String? result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ObraSuministroMaterialesInfoScreen(user: _user),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          !_showLoader
              ? Column(
                  children: [
                    _showSuministrosCount(),
                    Expanded(child: _getContent()),
                  ],
                )
              : Container(),
          _showLoader
              ? const LoaderComponent(text: 'Por favor espere...')
              : Container(),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            heroTag: 1,
            backgroundColor: _user.firmaUsuario == null
                ? Colors.red
                : Colors.green,
            onPressed: () async {
              String? result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UsuarioFirmaScreen(user: _user),
                ),
              );
              if (result != 'zzz') {
                _getUsuario();
                setState(() {});
              }
            },
            child: const Icon(Icons.draw, size: 38),
          ),
          const SizedBox(height: 15),
          _user.firmaUsuario == null
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: SizedBox(
                    width: 230,
                    child: Text(
                      'Para registrar Suministros, antes debe registrar su firma',
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : FloatingActionButton(
                  heroTag: 2,
                  backgroundColor: const Color(0xFF781f1e),
                  onPressed: _addSuministro,
                  child: const Icon(Icons.add, size: 38),
                ),
        ],
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _addSuministro ----------------------------
  //-----------------------------------------------------------------

  void _addSuministro() async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ObraSuministroAgregarScreen(
          user: _user,
          editMode: false,
          suministro: ObrasNuevoSuministro(
            nrosuministro: 0,
            nroobra: 0,
            fecha: '',
            apellidonombre: '',
            dni: '',
            telefono: '',
            email: '',
            cuadrilla: '',
            grupoc: '',
            causantec: '',
            directa: '',
            domicilio: '',
            barrio: '',
            localidad: '',
            partido: '',
            antesfotO1: '',
            antesfotO2: '',
            despuesfotO1: '',
            despuesfotO2: '',
            fotodnifrente: '',
            fotodnireverso: '',
            firmacliente: '',
            entrecalleS1: '',
            entrecalleS2: '',
            medidorcolocado: '',
            medidorvecino: '',
            tipored: '',
            corte: '',
            denuncia: '',
            enre: '',
            otro: '',
            conexiondirecta: '',
            retiroconexion: '',
            retirocrucecalle: '',
            mtscableretirado: 0,
            trabajoconhidro: '',
            postepodrido: '',
            observaciones: '',
            potenciacontratada: 0,
            tensioncontratada: 0,
            kitnro: 0,
            idcertifmateriales: 0,
            idcertifbaremo: 0,
            enviado: 0,
            materiales: 0,
          ),
        ),
      ),
    );
    if (result == 'yes') {
      _getSuministros();
    }
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

      if (string[i] == " ") {
        isSpace = true;
      } else {
        isSpace = false;
      }

      name = name + letter;
    }
    return name;
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
    _suministrosdet = await DBSuministrosdet.suministrosdet();

    String dateActual = DateTime.now().toString().substring(0, 10);

    for (var suministro in _suministros) {
      String dateAlmacenada = suministro.fecha!.substring(0, 10);

      //Borra enviados
      if (suministro.enviado == 2 && dateAlmacenada != dateActual) {
        DBSuministros.delete(suministro);
      }

      //Marca si tiene materiales
      for (var suministrodet in _suministrosdet) {
        if (suministrodet.nrosuministrocab == suministro.nrosuministro &&
            suministrodet.cantidad > 0) {
          suministro.materiales = 1;
        }
      }
    }

    _showLoader = false;

    setState(() {});
  }

  //-----------------------------------------------------------------------
  //-------------------------- _showSuministrosCount ----------------------
  //-----------------------------------------------------------------------
  Widget _showSuministrosCount() {
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
                      'Cant.de Suministros: ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _suministros.length.toString(),
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
    return _suministros.isEmpty ? _noContent2() : _getListView();
  }

  //-------------------------------------------------------------------
  //-------------------------- _noContent2 ----------------------------
  //-------------------------------------------------------------------

  Widget _noContent2() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: const Text(
          'No hay Suministros',
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
      padding: const EdgeInsets.only(top: 2),
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      children: _suministros.map((e) {
        return Card(
          color: const Color(0xFFC7C7C8),
          shadowColor: Colors.white,
          elevation: 10,
          margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
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
                          e.enviado == 2
                              ? const Icon(Icons.done_all, color: Colors.green)
                              : e.enviado == 1 && e.materiales == 1
                              ? const Icon(Icons.done, color: Colors.blue)
                              : const Icon(Icons.done, color: Colors.red),
                          const SizedBox(width: 15),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _RowCustom(
                                anchoTitulo: anchoTitulo,
                                titulo: 'Nº:',
                                dato: e.nrosuministro.toString(),
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
                                titulo: 'Cliente:',
                                dato: e.apellidonombre!,
                              ),
                              _RowCustom(
                                anchoTitulo: anchoTitulo,
                                titulo: 'DNI:',
                                dato: e.dni!,
                              ),
                              _RowCustom(
                                anchoTitulo: anchoTitulo,
                                titulo: 'Domicilio:',
                                dato: e.domicilio!,
                              ),
                              _RowCustom(
                                anchoTitulo: anchoTitulo,
                                titulo: 'Barrio:',
                                dato: e.barrio!,
                              ),
                              _RowCustom(
                                anchoTitulo: anchoTitulo,
                                titulo: 'Localidad:',
                                dato: e.localidad!,
                              ),
                              _RowCustom(
                                anchoTitulo: anchoTitulo,
                                titulo: 'Partido:',
                                dato: e.partido!,
                              ),
                              _RowCustom(
                                anchoTitulo: anchoTitulo,
                                titulo: 'Entre calles:',
                                dato:
                                    (e.entrecalleS1 != '' &&
                                        e.entrecalleS2! != "")
                                    ? '${e.entrecalleS1!} y ${e.entrecalleS2!}'
                                    : "",
                              ),
                              _RowCustom(
                                anchoTitulo: anchoTitulo,
                                titulo: 'Teléfono:',
                                dato: e.telefono!,
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
                    e.enviado != 2
                        ? IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () {
                              suministroSelected = e;
                              _goSuministro(e);
                            },
                          )
                        : Container(),
                    e.enviado != 2
                        ? IconButton(
                            icon: Text(
                              "M",
                              style: TextStyle(
                                color: e.materiales == 1
                                    ? Colors.blue
                                    : Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              suministroSelected = e;
                              _goSuministroMaterial(e);
                            },
                          )
                        : Container(),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await _borrarSuministro(e);
                      },
                    ),
                    e.enviado == 1 && e.materiales == 1
                        ? IconButton(
                            icon: const Icon(Icons.upload, color: Colors.blue),
                            onPressed: () async {
                              await _guardarSuministro(e);
                            },
                          )
                        : Container(),
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
  //-------------------------- _borrarSuministro --------------------
  //-----------------------------------------------------------------

  Future<void> _borrarSuministro(ObrasNuevoSuministro e) async {
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
              Text('¿Está seguro de borrar este Suministo?'),
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
              onPressed: () {
                //Borra Materiales
                for (var suministrodet in _suministrosdet) {
                  if (suministrodet.nrosuministrocab == e.nrosuministro) {
                    DBSuministrosdet.delete(suministrodet);
                  }
                }
                //Borra Suministro Cabecera
                DBSuministros.delete(e);
                _getSuministros();
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

  //-----------------------------------------------------------------
  //-------------------------- _goSuministro ------------------------
  //-----------------------------------------------------------------

  void _goSuministro(ObrasNuevoSuministro e) async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ObraSuministroAgregarScreen(
          user: _user,
          editMode: true,
          suministro: e,
        ),
      ),
    );
    if (result == 'yes' || result != 'yes') {
      _getSuministros();
      setState(() {});
    }
  }

  //-----------------------------------------------------------------
  //-------------------------- _goSuministroMaterial ----------------
  //-----------------------------------------------------------------

  void _goSuministroMaterial(ObrasNuevoSuministro e) async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ObraSuministroMaterialesScreen(user: _user, suministro: e),
      ),
    );
    if (result == 'yes' || result != 'yes') {
      _getSuministros();
      setState(() {});
    }
  }

  //-----------------------------------------------------------------
  //-------------------------- _guardarSuministro -------------------
  //-----------------------------------------------------------------

  Future<void> _guardarSuministro(ObrasNuevoSuministro e) async {
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

    Map<String, dynamic> requestSuministro = {
      // 'nrosuministro': 0,
      'nroobra': e.nroobra,
      'fecha': e.fecha.toString().substring(0, 10),
      'apellidonombre': e.apellidonombre,
      'dni': e.dni,
      'telefono': e.telefono,
      'email': e.email,
      'cuadrilla': e.cuadrilla,
      'grupoc': e.grupoc,
      'causantec': e.causantec,
      'directa': '',
      'domicilio': e.domicilio,
      'barrio': e.barrio,
      'localidad': e.localidad,
      'partido': e.partido,
      'ImageArrayANTESFOTO1': e.antesfotO1,
      'ImageArrayANTESFOTO2': e.antesfotO2,
      'ImageArrayDESPUESFOTO1': e.despuesfotO1,
      'ImageArrayDESPUESFOTO2': e.despuesfotO2,
      'ImageArrayFOTODNIFRENTE': e.fotodnifrente,
      'ImageArrayFOTODNIREVERSO': e.fotodnireverso,
      'ImageArrayFIRMACLIENTE': e.firmacliente,
      'entrecalleS1': e.entrecalleS1,
      'entrecalleS2': e.entrecalleS2,
      'medidorcolocado': e.medidorcolocado,
      'medidorvecino': e.medidorvecino,
      'tipored': e.tipored,
      'corte': e.corte,
      'denuncia': e.denuncia,
      'enre': e.enre,
      'otro': e.otro,
      'conexiondirecta': e.conexiondirecta,
      'retiroconexion': e.retiroconexion,
      'retirocrucecalle': e.retirocrucecalle,
      'mtscableretirado': e.mtscableretirado,
      'trabajoconhidro': e.trabajoconhidro,
      'postepodrido': e.postepodrido,
      'observaciones': e.observaciones,
      'potenciacontratada': e.potenciacontratada,
      'tensioncontratada': e.tensioncontratada,
      'kitnro': 0,
      'idcertifmateriales': 0,
      'idcertifbaremo': 0,
      'idusercarga': widget.user.idUsuario,
    };

    setState(() {
      _showLoader = true;
    });

    Response response = await ApiHelper.post(
      '/api/ObrasNuevoSuministros/PostObrasNuevoSuministros',
      requestSuministro,
    );

    if (response.isSuccess) {
      _nroReg = int.parse(response.result.toString());

      for (var suministro in _suministros) {
        if (suministro.dni == e.dni) {
          _ponerEnviado2(suministro);
        }
      }

      _suministrosdet.forEach((suministrodet) async {
        if (suministrodet.nrosuministrocab == e.nrosuministro &&
            suministrodet.cantidad > 0) {
          Map<String, dynamic> requestSuministroDet = {
            'nroregistrod': 0,
            'nrosuministrocab': _nroReg,
            'catcodigo': suministrodet.catcodigo,
            'codigosap': suministrodet.codigosap,
            'cantidad': suministrodet.cantidad,
          };

          await ApiHelper.post(
            '/api/ObrasNuevoSuministrosDet/PostObrasNuevoSuministrosDet',
            requestSuministroDet,
          );
        }
      });

      setState(() {
        _showLoader = false;
      });

      _showSnackbar();
    }
  }

  //-------------------------------------------------------------
  //-------------------- _showSnackbar --------------------------
  //-------------------------------------------------------------

  void _showSnackbar() {
    SnackBar snackbar = const SnackBar(
      content: Text("Suministro subido al Servidor con éxito"),
      backgroundColor: Colors.lightGreen,
      //duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    //ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  //-------------------------------------------------------------
  //-------------------- _ponerEnviado2 -------------------------
  //-------------------------------------------------------------

  Future<void> _ponerEnviado2(ObrasNuevoSuministro suministro) async {
    ObrasNuevoSuministro suministroNuevo = suministro;
    suministroNuevo.enviado = 2;
    await DBSuministros.update(suministroNuevo);
    _getSuministros();
    setState(() {});
  }

  //-------------------------------------------------------------
  //--------------------- _getUsuario ---------------------------
  //-------------------------------------------------------------

  Future<void> _getUsuario() async {
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

    Map<String, dynamic> request = {
      'Email': _user.login,
      'password': _user.contrasena,
    };

    var url = Uri.parse('${Constants.apiUrl}/Api/Account/GetUserByEmail');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(request),
    );

    var body = response.body;
    var decodedJson = jsonDecode(body);
    _user = User.fromJson(decodedJson);

    setState(() {});
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
