import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../screens.dart';

class LegalesScreen extends StatefulWidget {
  final User user;
  const LegalesScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<LegalesScreen> createState() => _LegalesScreenState();
}

class _LegalesScreenState extends State<LegalesScreen> {
  //---------------------------------------------------------------------
  //-------------------------- Variables --------------------------------
  //---------------------------------------------------------------------
  List<Juicio> _juicios = [];
  bool _showLoader = false;
  bool _isFiltered = false;
  String _search = '';

  Juicio _juicioSeleccionado = Juicio(
    iDCASO: 0,
    tipocaso: '',
    estado: '',
    fechAINICIO: '',
    fEULTMOV: '',
    cerrado: 0,
    fechACIERRE: '',
    caratula: '',
    cliente: '',
    abogado: '',
    juzgado: '',
    escribano: '',
    juez: '',
    importejuicio: 0,
    moneda: '',
    importerealdeuda: 0,
    fechAVENCIMIENTO: '',
    fechacalculo: '',
    diasatraso: 0,
    intereseSMORATORIOS: 0,
    importeinteres: 0,
    intereseSPUNITORIOS: 0,
    importepunitorio: 0,
    gastoSJUDICIALES: 0,
    importegastos: 0,
    cobroscliente: 0,
    pagosdemandado: 0,
    honorarios: 0,
    importehonorarios: 0,
    varios: 0,
    importevarios: 0,
    periodo: 0,
    grupo: '',
    causante: '',
    iduserimput: 0,
    nroExpediente: '',
    idContraparte: 0,
  );

  //---------------------------------------------------------------------
  //-------------------------- InitState --------------------------------
  //---------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _getJuicios();
  }
  //---------------------------------------------------------------------
  //-------------------------- Pantalla ---------------------------------
  //---------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: const Text('Legales'),
        centerTitle: true,
        actions: <Widget>[
          _isFiltered
              ? IconButton(
                  onPressed: _removeFilter,
                  icon: const Icon(Icons.filter_none),
                )
              : IconButton(
                  onPressed: _showFilter,
                  icon: const Icon(Icons.filter_alt),
                ),
        ],
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
    return Column(
      children: <Widget>[
        _showJuiciosCount(),
        Expanded(child: _juicios.isEmpty ? _noContent() : _getListView()),
      ],
    );
  }

  //--------------------------------------------------------------------------
  //------------------------------  _showJuiciosCount ------------------------
  //--------------------------------------------------------------------------

  Widget _showJuiciosCount() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 40,
      child: Row(
        children: [
          const Text(
            'Cantidad de Juicios: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _juicios.length.toString(),
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
      child: Center(
        child: Text(
          _isFiltered
              ? 'No hay Juicios con ese criterio de búsqueda'
              : 'No hay Juicios registrados',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //-----------------------------------------------------------------------
  //------------------------------ _getListView ---------------------------
  //-----------------------------------------------------------------------

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getJuicios,
      child: ListView(
        children: _juicios.map((e) {
          return Card(
            color: const Color(0xFFC7C7C8),
            shadowColor: Colors.white,
            elevation: 10,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: InkWell(
              onTap: () {
                _juicioSeleccionado = e;
                _goInfoJuicio(e);
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
                                        width: 70,
                                        child: Text(
                                          'N° Caso: ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF781f1e),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          e.iDCASO.toString(),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      const Text(
                                        'N° Expediente: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          e.nroExpediente.toString(),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 70,
                                        child: Text(
                                          'Tipo Caso: ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF781f1e),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          e.tipocaso.toString(),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 70,
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
                                        child: Text(
                                          e.estado.toString(),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 70,
                                        child: Text(
                                          'Ult. mov.: ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF781f1e),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: e.fEULTMOV != null
                                            ? Text(
                                                DateFormat('dd/MM/yyyy').format(
                                                  DateTime.parse(
                                                    e.fEULTMOV.toString(),
                                                  ),
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              )
                                            : Container(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 70,
                                        child: Text(
                                          'Carátula: ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF781f1e),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          e.caratula.toString(),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 70,
                                        child: Text(
                                          'Abogado: ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF781f1e),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          e.abogado.toString(),
                                          style: const TextStyle(fontSize: 12),
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
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  //---------------------------------------------------------------------
  //-------------------------- _getJuicios ------------------------------
  //---------------------------------------------------------------------

  Future<void> _getJuicios() async {
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

    response = await ApiHelper.getJuicios();

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
      _juicios = response.result;
      _juicios.sort((b, a) {
        return a.iDCASO.compareTo(b.iDCASO);
      });
    });
  }

  //-----------------------------------------------------------------
  //------------------------------ _filter --------------------------
  //-----------------------------------------------------------------

  _filter() {
    if (_search.isEmpty) {
      return;
    }
    List<Juicio> filteredList = [];
    for (var juicio in _juicios) {
      String abog = juicio.abogado != null ? juicio.abogado! : '';
      String carat = juicio.caratula != null ? juicio.caratula! : '';
      String nroexp = juicio.nroExpediente != null ? juicio.nroExpediente! : '';

      if (abog.toLowerCase().contains(_search.toLowerCase()) ||
          carat.toLowerCase().contains(_search.toLowerCase()) ||
          nroexp.toString().toLowerCase().contains(_search.toLowerCase())) {
        filteredList.add(juicio);
      }
    }

    setState(() {
      _juicios = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
  }

  //-----------------------------------------------------------------------
  //------------------------------ _removeFilter --------------------------
  //-----------------------------------------------------------------------

  void _removeFilter() {
    setState(() {
      _isFiltered = false;
    });
    _getJuicios();
  }

  //---------------------------------------------------------------------
  //------------------------------ _showFilter --------------------------
  //---------------------------------------------------------------------

  void _showFilter() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('Filtrar Juicios'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Escriba texto o números a buscar en Abogado o Carátula o en N° de Expediente: ',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 10),
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Criterio de búsqueda...',
                  labelText: 'Buscar',
                  suffixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  _search = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => _filter(),
              child: const Text('Filtrar'),
            ),
          ],
        );
      },
    );
  }

  //---------------------------------------------------------------------------
  //------------------------------ _goInfoJuicio ------------------------------
  //---------------------------------------------------------------------------

  void _goInfoJuicio(Juicio juicio) async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            JuicioInfoScreen(user: widget.user, juicio: juicio),
      ),
    );
    if (result == 'yes' || result != 'yes') {
      //_getJuicios();
      setState(() {});
    }
  }
}
