import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';

class PresentismoScreen extends StatefulWidget {
  final User user;
  const PresentismoScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<PresentismoScreen> createState() => _PresentismoScreenState();
}

class _PresentismoScreenState extends State<PresentismoScreen> {
//---------------------------------------------------------------------
//-------------------------- Variables --------------------------------
//---------------------------------------------------------------------

  bool _permitidoGrabar = true;

  final String _zona = '';
  final String _zonaError = '';
  final bool _zonaShowError = false;
  final TextEditingController _zonaController = TextEditingController();

  final String _actividad = '';
  final String _actividadError = '';
  final bool _actividadShowError = false;
  final TextEditingController _actividadController = TextEditingController();

  final String _estado = '';
  final String _estadoError = '';
  final bool _estadoShowError = false;
  final TextEditingController _estadoController = TextEditingController();

  final String _observaciones = '';
  final String _observacionesError = '';
  final bool _observacionesShowError = false;
  final TextEditingController _observacionesController =
      TextEditingController();

  List<Causante> _empleados = [];
  List<CausantesEstado> _estados = [];
  List<CausantesZona> _zonas = [];
  List<CausantesActividad> _actividades = [];
  bool _showLoader = false;
  bool _showLoader2 = false;

  List<CausantesPresentismo> _presentismosHoy = [];

  final List _elements = [];

  final Causante _empleadoSeleccionado = Causante(
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
      firmaFullPath: '');

//---------------------------------------------------------------------
//-------------------------- InitState --------------------------------
//---------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _getEmpleados();
  }

//---------------------------------------------------------------------
//-------------------------- Pantalla ---------------------------------
//---------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: Text(
            'Presentismo ${DateFormat('dd/MM/yyyy').format(DateTime.parse(DateTime.now().toString()))}'),
        centerTitle: true,
      ),
      body: Center(
        child: _showLoader
            ? const LoaderComponent(text: 'Por favor espere...')
            : _getContent(),
      ),
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ METODO GETCONTENT --------------------------
//-----------------------------------------------------------------------------

  Widget _getContent() {
    return _permitidoGrabar
        ? Column(
            children: <Widget>[
              _showEmpleadosCount(),
              Expanded(
                child: _empleados.isEmpty
                    ? _noContent()
                    : Stack(
                        children: [
                          _getListView(),
                          _showLoader2
                              ? const LoaderComponent(
                                  text: 'Grabando Presentismos...')
                              : Container(),
                        ],
                      ),
              ),
              _empleados.isEmpty ? Container() : _showButton(),
            ],
          )
        : Center(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 2, color: Colors.red)),
                child: const Center(
                  child: Text(
                    'Ya hay Presentismos registrados en el día de hoy',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                    maxLines: 2,
                  ),
                ),
              ),
            ),
          );
  }

//-----------------------------------------------------------------
//--------------------- _showButton -------------------------------
//-----------------------------------------------------------------

  Widget _showButton() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _showSaveButton(),
        ],
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- _showSaveButton ---------------------------
//-----------------------------------------------------------------

  Widget _showSaveButton() {
    return Expanded(
      child: ElevatedButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.save),
              SizedBox(
                width: 15,
              ),
              Text('Guardar Presentismos'),
            ],
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF781f1e),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onPressed: () async {
            var response = await showAlertDialog(
                context: context,
                title: 'Aviso',
                message: '¿Está seguro de guardar los Presentismos?',
                actions: <AlertDialogAction>[
                  const AlertDialogAction(key: 'si', label: 'SI'),
                  const AlertDialogAction(key: 'no', label: 'NO'),
                ]);
            if (response == 'no') {
              return;
            }
            _save();
          }),
    );
  }

//-----------------------------------------------------------------
//--------------------- _showSaveButton ---------------------------
//-----------------------------------------------------------------

  _save() async {
    setState(() {
      _showLoader2 = true;
    });

    DateTime hoy = DateTime.now();
    int hora = (hoy.hour * 3600 + hoy.minute * 60 + hoy.second);

    for (Causante empleado in _empleados) {
      if (empleado.presentismo.toString() == 'Elija un Estado...') {
        await showAlertDialog(
            context: context,
            title: 'Error',
            message: 'Hay empleados sin Estado seleccionado',
            actions: <AlertDialogAction>[
              const AlertDialogAction(key: null, label: 'Aceptar'),
            ]);
        return;
      }
      if (empleado.zonaTrabajo == 'Elija una Zona...') {
        await showAlertDialog(
            context: context,
            title: 'Error',
            message: 'Hay empleados sin Zona seleccionada',
            actions: <AlertDialogAction>[
              const AlertDialogAction(key: null, label: 'Aceptar'),
            ]);
        return;
      }
      if (empleado.nombreActividad == 'Elija una Actividad...') {
        await showAlertDialog(
            context: context,
            title: 'Error',
            message: 'Hay empleados sin Actividad seleccionada',
            actions: <AlertDialogAction>[
              const AlertDialogAction(key: null, label: 'Aceptar'),
            ]);
        return;
      }
    }

    for (Causante empleado in _empleados) {
      Map<String, dynamic> request = {
        'IDPRESENTISMO': 0,
        'IDSUPERVISOR': widget.user.idUsuario,
        'FECHA': hoy.toString().substring(0, 10),
        'HORA': hora,
        'GRUPOC': empleado.grupo,
        'CAUSANTEC': empleado.codigo,
        'ESTADO': empleado.presentismo,
        'ZONATRABAJO': empleado.zonaTrabajo,
        'ACTIVIDAD': empleado.nombreActividad,
        'CECO': empleado.notas != null
            ? empleado.notas!.length <= 50
                ? empleado.notas
                : empleado.notas!.substring(0, 50)
            : '',
        'OBSERVACIONES': empleado.imageFullPath!.length <= 50
            ? empleado.imageFullPath
            : empleado.imageFullPath!.substring(
                0, 50), //Uso imageFullPath para guardar las Observaciones
        'PerteneceCuadrilla': empleado.perteneceCuadrilla
      };

      Response response =
          await ApiHelper.post('/api/Causantes/PostPresentismos', request);

      if (!response.isSuccess) {
        await showAlertDialog(
            context: context,
            title: 'Error',
            message: response.message,
            actions: <AlertDialogAction>[
              const AlertDialogAction(key: null, label: 'Aceptar'),
            ]);
        return;
      }
    }
    setState(() {
      _showLoader2 = false;
    });

    await showAlertDialog(
        context: context,
        title: 'Aviso',
        message: 'Presentismos guardados con éxito!',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ]);
    Navigator.pop(context);
  }

//--------------------------------------------------------------------------
//------------------------------  _showEmpleadosCount ----------------------
//--------------------------------------------------------------------------

  Widget _showEmpleadosCount() {
    double ancho = MediaQuery.of(context).size.width * 0.9;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          height: 40,
          child: Row(
            children: [
              const Text('Cantidad de Empleados: ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
              Text(_empleados.length.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ),
        const Divider(
          height: 3,
          color: Colors.white,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Row(
            children: [
              SizedBox(
                width: ancho * 0.35,
                child: const Text('Empleado',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    )),
              ),
              const SizedBox(
                width: 15,
              ),
              SizedBox(
                width: ancho * 0.21,
                child: const Text('Zona de Trabajo',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    )),
              ),
              const SizedBox(
                width: 15,
              ),
              SizedBox(
                width: ancho * 0.21,
                child: const Text('Actividad',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    )),
              ),
              SizedBox(
                width: ancho * 0.13,
                child: const Text('Estado',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    )),
              ),
            ],
          ),
        ),
        const Divider(
          height: 6,
          color: Colors.white,
        ),
      ],
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ METODO NOCONTENT -----------------------------
//-----------------------------------------------------------------------------

  Widget _noContent() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: const Center(
        child: Text(
          'No hay Empleados registrados',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

//-----------------------------------------------------------------------------
//------------------------------ METODO GETLISTVIEW ---------------------------
//-----------------------------------------------------------------------------

  Widget _getListView() {
    double ancho = MediaQuery.of(context).size.width * 0.9;
    return RefreshIndicator(
        onRefresh: _getEmpleados,
        child: GroupedListView<dynamic, String>(
          elements: _elements,
          groupBy: (element) => element['perteneceCuadrilla'],
          groupComparator: (value1, value2) => value1.compareTo(value2),
          itemComparator: (item1, item2) =>
              item1['nombre'].compareTo(item2['nombre']),
          order: GroupedListOrder.ASC,
          useStickyGroupSeparators: true,
          groupSeparatorBuilder: (String value) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          itemBuilder: (c, element) {
            return Card(
              color: const Color(0xFFC7C7C8),
              shadowColor: Colors.white,
              elevation: 10,
              margin: const EdgeInsets.fromLTRB(10, 0, 5, 10),
              child: InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: ancho * 0.35,
                                              child: Text(
                                                  element['nombre']
                                                      .toUpperCase(),
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Color(0xFF781f1e),
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            SizedBox(
                                              width: ancho * 0.21,
                                              child: Text(
                                                  element['zonaTrabajo'] != null
                                                      ? element['zonaTrabajo']!
                                                      : '',
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                  )),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            SizedBox(
                                              width: ancho * 0.21,
                                              child: Text(
                                                  element['nombreActividad'] !=
                                                          null
                                                      ? element[
                                                          'nombreActividad']!
                                                      : '',
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                  )),
                                            ),
                                            SizedBox(
                                              width: ancho * 0.13,
                                              child: Text(
                                                  element['presentismo'] != null
                                                      ? element['presentismo']!
                                                      : '',
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                  )),
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
                  ],
                ),
              ),
            );
          },
        ));
  }

//---------------------------------------------------------------------
//-------------------------- _getEmpleados ----------------------------
//---------------------------------------------------------------------

  Future<void> _getEmpleados() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      showMyDialog(
          'Error', 'Verifica que estés conectado a Internet', 'Aceptar');
    }

    Response response = Response(isSuccess: false);

    response = await ApiHelper.getEmpleados(widget.user.idUsuario);

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
          ]);
      return;
    }

    setState(() {
      _empleados = response.result;

      for (var empleado in _empleados) {
        empleado.presentismo = 'Presente';
        empleado.imageFullPath =
            ''; //Uso imageFullPath para guardar las Observaciones
      }

      _empleados.sort((b, a) {
        return a.nombre.compareTo(b.nombre);
      });

      for (var element in _empleados) {
        _elements.add(
          {
            'nombre': element.nombre,
            'zonaTrabajo': element.zonaTrabajo,
            'estado': element.estado,
            'perteneceCuadrilla': element.perteneceCuadrilla,
            'nombreActividad': element.nombreActividad,
            'presentismo': element.presentismo,
          },
        );
      }

      _getEstados();
    });
  }

//---------------------------------------------------------------------
//-------------------------- _getEstados ------------------------------
//---------------------------------------------------------------------

  Future<void> _getEstados() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      showMyDialog(
          'Error', 'Verifica que estés conectado a Internet', 'Aceptar');
    }

    Response response = Response(isSuccess: false);

    response = await ApiHelper.getCausantesEstados();

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
          ]);
      return;
    }

    setState(() {
      _estados = response.result;

      _estados.sort((a, b) {
        return a.nomencladorestado.compareTo(b.nomencladorestado);
      });
    });

    _getZonas();
  }

//---------------------------------------------------------------------
//-------------------------- _getZonas --------------------------------
//---------------------------------------------------------------------

  Future<void> _getZonas() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      showMyDialog(
          'Error', 'Verifica que estés conectado a Internet', 'Aceptar');
    }

    Response response = Response(isSuccess: false);

    response = await ApiHelper.getCausantesZonas();

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
          ]);
      return;
    }

    setState(() {
      _zonas = response.result;

      _zonas.sort((a, b) {
        return a.nombrezona.compareTo(b.nombrezona);
      });

      _getActividades();
    });
  }

//---------------------------------------------------------------------
//-------------------------- _getActividades --------------------------
//---------------------------------------------------------------------

  Future<void> _getActividades() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      showMyDialog(
          'Error', 'Verifica que estés conectado a Internet', 'Aceptar');
    }

    Response response = Response(isSuccess: false);

    response = await ApiHelper.getCausantesActividades();

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
          ]);
      return;
    }

    setState(() {
      _actividades = response.result;

      _actividades.sort((a, b) {
        return a.nombreactividad.compareTo(b.nombreactividad);
      });

      _getPresentismosHoy();
    });
  }

//---------------------------------------------------------------------
//-------------------------- _getPresentismosHoy ----------------------
//---------------------------------------------------------------------

  Future<void> _getPresentismosHoy() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      showMyDialog(
          'Error', 'Verifica que estés conectado a Internet', 'Aceptar');
    }

    Response response = Response(isSuccess: false);

    DateTime hoy = DateTime.now();

    response = await ApiHelper.getPresentismosHoy(
        widget.user.idUsuario, hoy.year, hoy.month, hoy.day);

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
          ]);
      return;
    }

    _presentismosHoy = response.result;
    if (_presentismosHoy.isNotEmpty) {
      _permitidoGrabar = false;
    }

    setState(() {});
  }
}
