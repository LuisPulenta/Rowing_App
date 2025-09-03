import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';

class PresentismoTurnoNocheScreen extends StatefulWidget {
  final User user;
  const PresentismoTurnoNocheScreen({super.key, required this.user});

  @override
  State<PresentismoTurnoNocheScreen> createState() =>
      _PresentismoTurnoNocheScreenState();
}

class _PresentismoTurnoNocheScreenState
    extends State<PresentismoTurnoNocheScreen> {
  //---------------------------------------------------------------------
  //-------------------------- Variables --------------------------------
  //---------------------------------------------------------------------

  final bool _permitidoGrabar = true;

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

  String _observaciones = '';
  final String _observacionesError = '';
  final bool _observacionesShowError = false;
  final TextEditingController _observacionesController =
      TextEditingController();

  List<CausantesPresentismoTurnoNoche> _empleados = [];
  List<CausantesEstado> _estados = [];
  List<CausantesZona> _zonas = [];
  List<CausantesActividad> _actividades = [];
  bool _showLoader = false;
  bool _showLoader2 = false;

  final List<CausantesPresentismoTurnoNoche> _presentismosHoy = [];

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
    firmaFullPath: '',
  );

  //---------------------------------------------------------------------
  //-------------------------- InitState --------------------------------
  //---------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _getTurnosNoche();
  }

  //---------------------------------------------------------------------
  //-------------------------- Pantalla ---------------------------------
  //---------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: const Text('Presentismo Turno Noche'),
        centerTitle: true,
      ),
      body: Center(
        child: _showLoader
            ? const LoaderComponent(text: 'Por favor espere...')
            : _getContent(),
      ),
    );
  }

  //---------------------------------------------------------------------
  //------------------------------ _getContent --------------------------
  //---------------------------------------------------------------------

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
                                  text: 'Grabando Presentismos...',
                                )
                              : Container(),
                        ],
                      ),
              ),
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
                  border: Border.all(width: 2, color: Colors.red),
                ),
                child: const Center(
                  child: Text(
                    'Ya hay Presentismos registrados en el día de hoy',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                  ),
                ),
              ),
            ),
          );
  }

  //-------------------------------------------------------
  //--------------------- _save ---------------------------
  //-------------------------------------------------------

  Future<void> _save(CausantesPresentismoTurnoNoche empleado) async {
    setState(() {
      _showLoader2 = true;
    });

    Map<String, dynamic> request = {
      'IDPRESENTISMO': empleado.idpresentismo,
      'IDSUPERVISOR': empleado.idsupervisor,
      'FECHA': empleado.fecha.substring(0, 10),
      'HORA': empleado.hora,
      'GRUPOC': empleado.grupoc,
      'CAUSANTEC': empleado.causantec,
      'ESTADO': empleado.estado,
      'ZONATRABAJO': empleado.zonatrabajo,
      'ACTIVIDAD': empleado.actividad,
      'CECO': empleado.ceco,
      'OBSERVACIONES': empleado.observaciones,
      'PerteneceCuadrilla': empleado.perteneceCuadrilla,
    };

    Response response = await ApiHelper.put(
      '/api/Causantes/PutPresentismo/',
      empleado.idpresentismo.toString(),
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
    _getTurnosNoche();
    setState(() {
      _showLoader2 = false;
    });

    await showAlertDialog(
      context: context,
      title: 'Aviso',
      message: 'Presentismo guardado con éxito!',
      actions: <AlertDialogAction>[
        const AlertDialogAction(key: null, label: 'Aceptar'),
      ],
    );
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
              const Text(
                'Cantidad de Empleados: ',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _empleados.length.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 3, color: Colors.white),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Row(
            children: [
              SizedBox(
                width: ancho * 0.35,
                child: const Text(
                  'Empleado',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              const SizedBox(width: 15),
              SizedBox(
                width: ancho * 0.21,
                child: const Text(
                  'Zona de Trabajo',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              const SizedBox(width: 15),
              SizedBox(
                width: ancho * 0.21,
                child: const Text(
                  'Actividad',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              SizedBox(
                width: ancho * 0.13,
                child: const Text(
                  'Estado',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 6, color: Colors.white),
      ],
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
          'No hay Empleados registrados',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //-----------------------------------------------------------------------
  //------------------------------ _getListView ---------------------------
  //-----------------------------------------------------------------------

  Widget _getListView() {
    double ancho = MediaQuery.of(context).size.width * 0.9;
    return RefreshIndicator(
      onRefresh: _getTurnosNoche,
      child: ListView(
        children: _empleados.map((e) {
          return InkWell(
            onTap: () {
              _actividadController.text = e.actividad != null
                  ? e.actividad!
                  : '';

              _estadoController.text = e.estado;

              _zonaController.text = e.zonatrabajo != null
                  ? e.zonatrabajo!
                  : '';

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.grey[300],
                    title: Text(e.nombre.toString()),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              e.perteneceCuadrilla != ''
                                  ? 'Pertenece a Cuadrilla: ${e.perteneceCuadrilla}'
                                  : 'Pertenece a Cuadrilla: Sin Datos',
                              textAlign: TextAlign.start,
                            ),
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField(
                            autofocus: true,
                            initialValue: e.estado,
                            isExpanded: true,
                            isDense: true,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Elija un Estado...',
                              labelText: 'Estado',
                              errorText: _estadoShowError ? _estadoError : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            items: _getComboEstados(),
                            onChanged: (value) {
                              e.estado = value.toString();
                            },
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFB4161B),
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () {
                                _observaciones = '';
                                _observacionesController.text = '';
                                Navigator.pop(context);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: const [
                                  Icon(Icons.cancel),
                                  Text('Cancelar'),
                                ],
                              ),
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
                              onPressed: () {
                                _save(e);
                                Navigator.pop(context);
                                setState(() {});
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: const [
                                  Icon(Icons.save),
                                  Text('Aceptar'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                },
                barrierDismissible: false,
              );
            },
            child: SizedBox(
              height: 60,
              child: Card(
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
                          horizontal: 0,
                          vertical: 5,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${DateFormat('dd/MM/yyyy').format(DateTime.parse(e.fecha.toString()))} - ${e.perteneceCuadrilla}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.purple,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: ancho * 0.35,
                                                    child: Text(
                                                      e.nombre.toString(),
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        color: Color(
                                                          0xFF781f1e,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 15),
                                                  SizedBox(
                                                    width: ancho * 0.21,
                                                    child: Text(
                                                      e.zonatrabajo != null
                                                          ? e.zonatrabajo!
                                                          : '',
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 15),
                                                  SizedBox(
                                                    width: ancho * 0.21,
                                                    child: Text(
                                                      e.actividad != null
                                                          ? e.actividad!
                                                          : '',
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: ancho * 0.13,
                                                    child: Text(
                                                      e.estado,
                                                      style: const TextStyle(
                                                        fontSize: 10,
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
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  //---------------------------------------------------------------------
  //-------------------------- _getTurnosNoche ----------------------------
  //---------------------------------------------------------------------

  Future<void> _getTurnosNoche() async {
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

    response = await ApiHelper.getTurnosNoche(widget.user.idUsuario);

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
      _empleados = response.result;

      for (var empleado in _empleados) {
        empleado.estado = 'Presente';
      }

      _empleados.sort((a, b) {
        return a.fecha.toString().compareTo(b.fecha.toString());
      });

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
        'Error',
        'Verifica que estés conectado a Internet',
        'Aceptar',
      );
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
        ],
      );
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
        'Error',
        'Verifica que estés conectado a Internet',
        'Aceptar',
      );
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
        ],
      );
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
        'Error',
        'Verifica que estés conectado a Internet',
        'Aceptar',
      );
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
        ],
      );
      return;
    }

    setState(() {
      _actividades = response.result;

      _actividades.sort((a, b) {
        return a.nombreactividad.compareTo(b.nombreactividad);
      });
    });
  }

  //---------------------------------------------------------------------
  //-------------------------- _getComboEstados -------------------------
  //---------------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboEstados() {
    List<DropdownMenuItem<String>> list = [];
    list.add(
      const DropdownMenuItem(
        value: 'Elija un Estado...',
        child: Text('Elija un Estado...'),
      ),
    );

    for (var estado in _estados) {
      list.add(
        DropdownMenuItem(
          value: estado.nomencladorestado.toString(),
          child: Text(estado.nomencladorestado.toString()),
        ),
      );
    }

    return list;
  }
}
