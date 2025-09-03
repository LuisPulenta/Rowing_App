import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';

class CausantesScreen extends StatefulWidget {
  final User user;
  const CausantesScreen({super.key, required this.user});
  @override
  _CausantesScreenState createState() => _CausantesScreenState();
}

class _CausantesScreenState extends State<CausantesScreen> {
  //---------------------------------------------------------------
  //----------------------- Variables -----------------------------
  //---------------------------------------------------------------

  List<Causante> _causantes = [];
  List<Subcontratista> _subcontratistas = [];
  final TextEditingController _searchController = TextEditingController();

  String _subcontratista = 'Elija un Subcontratista...';
  String _subcontratistaError = '';
  bool _subcontratistaShowError = false;

  late Persona _persona;

  bool _showLoader = false;
  bool _isFiltered = false;
  String _search = '';
  Subcontratista subcontratistaSelected = Subcontratista(
    subCodigo: '',
    subSubcontratista: '',
    modulo: '',
  );

  Causante causanteSelected = Causante(
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
    image: null,
    imageFullPath: '',
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

  //---------------------------------------------------------------
  //----------------------- initState -----------------------------
  //---------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _persona = Persona(
      subcontratista: subcontratistaSelected,
      causante: causanteSelected,
    );
    _getSubcontratistas();
  }

  //---------------------------------------------------------------
  //----------------------- Pantalla ------------------------------
  //---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 218, 218),
      appBar: AppBar(
        title: const Text('Seleccionar Causante'),
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
            ? const LoaderComponent(text: 'Cargando Subcontratistas.')
            : _getContent(),
      ),
    );
  }

  //-----------------------------------------------------------------
  //------------------------------ _filter --------------------------
  //-----------------------------------------------------------------

  void _filter() {
    if (_search.isEmpty) {
      return;
    }
    List<Causante> filteredList = [];
    for (var causante in _causantes) {
      if (causante.nombre.toLowerCase().contains(_search.toLowerCase())) {
        filteredList.add(causante);
      }
    }

    setState(() {
      _causantes = filteredList;
      _isFiltered = true;
    });
  }

  //-----------------------------------------------------------------------
  //------------------------------ _removeFilter --------------------------
  //-----------------------------------------------------------------------

  void _removeFilter() {
    setState(() {
      _isFiltered = false;
    });
    _getSubcontratistas();
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
          title: const Text('Filtrar Obras'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Escriba texto a buscar en Nombre del Causante: ',
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

  //---------------------------------------------------------------------
  //------------------------------ _getContent --------------------------
  //---------------------------------------------------------------------

  Widget _getContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          _causantes.isEmpty ? _showSubcontratistas() : _showTextFilter(),
          _showCausantesCount(),
          Expanded(child: _causantes.isEmpty ? _noContent() : _getListView()),
        ],
      ),
    );
  }

  //------------------------------------------------------------
  //------------------- _showSubcontratistas--------------------
  //------------------------------------------------------------

  Widget _showSubcontratistas() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
            child: _subcontratistas.isEmpty
                ? Row(
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(width: 10),
                      Text('Cargando Subcontratistas...'),
                    ],
                  )
                : Container(
                    width: 200,
                    padding: const EdgeInsets.all(10),
                    child: DropdownButtonFormField(
                      initialValue: _subcontratista,
                      isExpanded: true,
                      isDense: true,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Elija un Subcontratista...',
                        labelText: 'Subcontratista',
                        errorText: _subcontratistaShowError
                            ? _subcontratistaError
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: _getComboSubcontratistas(),
                      onChanged: (value) {
                        _subcontratista = value.toString();
                      },
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 5),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF282886),
            minimumSize: const Size(50, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          //onPressed: () => _getObras(),
          onPressed: () async {
            await _getCausantes();
          },
          child: const Icon(Icons.search),
        ),
      ],
    );
  }

  //---------------------------------------------------------------------
  //------------------------ _getComboSubcontratistas -------------------
  //---------------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboSubcontratistas() {
    List<DropdownMenuItem<String>> list = [];
    list.add(
      const DropdownMenuItem(
        value: 'Elija un Subcontratista...',
        child: Text('Elija un Subcontratista...'),
      ),
    );

    for (var subcontratista in _subcontratistas) {
      list.add(
        DropdownMenuItem(
          value: subcontratista.subCodigo.toString(),
          child: Text(subcontratista.subSubcontratista.toString()),
        ),
      );
    }

    return list;
  }

  //------------------------------------------------------------------
  //--------------------------- _showTextFilter ----------------------
  //------------------------------------------------------------------

  Widget _showTextFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: [
              Expanded(flex: 4, child: _showTextoBuscar()),
              Expanded(flex: 2, child: _showButtons()),
            ],
          ),
          const SizedBox(height: 0),
        ],
      ),
    );
  }

  //----------------------------------------------------------
  //--------------------- _showTextoBuscar -------------------
  //----------------------------------------------------------

  Widget _showTextoBuscar() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _searchController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Texto a buscar...',
          labelText: 'Texto a buscar',

          //errorText: _codigoShowError ? _codigoError : null,
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF282886)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          _search = value;
        },
      ),
    );
  }

  //-----------------------------------------------------------
  //--------------------- _showButtons ------------------------
  //-----------------------------------------------------------

  Widget _showButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF282886),
              minimumSize: const Size(50, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _filter();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Icon(Icons.search), SizedBox(width: 5)],
            ),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size(50, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _search = '';
              _searchController.text = '';
              _filter();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Icon(Icons.cancel), SizedBox(width: 5)],
            ), //=> _search(),
          ),
        ),
      ],
    );
  }

  //---------------------------------------------------------------------
  //------------------------------ _showCausantesCount ------------------
  //---------------------------------------------------------------------

  Widget _showCausantesCount() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 40,
      child: Row(
        children: [
          const Text(
            'Cantidad de Causantes: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _causantes.length.toString(),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
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
              ? 'No hay Causantes con ese criterio de búsqueda'
              : 'No hay Causantes registrados',
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
      onRefresh: _getSubcontratistas,
      child: ListView(
        children: _causantes.map((e) {
          return Card(
            color: const Color(0xFFC7C7C8),
            shadowColor: Colors.white,
            elevation: 10,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: InkWell(
              onTap: () {
                causanteSelected = e;
                _goCausante(_subcontratista, e);
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
                                      Expanded(
                                        flex: 5,
                                        child: Text(
                                          e.nombre.toString(),
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
  //------------------- _getSubcontratistas -----------------------------
  //---------------------------------------------------------------------

  Future<void> _getSubcontratistas() async {
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

    response = await ApiHelper.getSubcontratistas(widget.user.modulo);

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
      _subcontratistas = response.result;
      _subcontratistas.sort((a, b) {
        return a.subSubcontratista.toString().toLowerCase().compareTo(
          b.subSubcontratista.toString().toLowerCase(),
        );
      });
    });
  }

  //-------------------------------------------------------------
  //------------------- _goCausante -----------------------------
  //-------------------------------------------------------------

  void _goCausante(String subcontratista, Causante causante) async {
    Subcontratista subcontratistaSelected = Subcontratista(
      subCodigo: '',
      subSubcontratista: '',
      modulo: '',
    );

    for (var subc in _subcontratistas) {
      if (subc.subCodigo == subcontratista) {
        subcontratistaSelected = subc;
      }
    }

    _persona = Persona(
      subcontratista: subcontratistaSelected,
      causante: causante,
    );
    Navigator.pop(context, _persona);
  }

  //-------------------------------------------------------------
  //------------------- _getCausantes ---------------------------
  //-------------------------------------------------------------

  Future<void> _getCausantes() async {
    if (_subcontratista == 'Elija un Subcontratista...') {
      _subcontratistaShowError = true;
      _subcontratistaError = 'Elija un Subcontratista...';
      setState(() {});
      return;
    } else {
      _subcontratistaShowError = false;
    }

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
    response = await ApiHelper.getCausantesByGrupo(_subcontratista);

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
    _causantes = response.result;

    _causantes.sort((a, b) {
      return a.nombre.toString().toLowerCase().compareTo(
        b.nombre.toString().toLowerCase(),
      );
    });
    setState(() {
      _showLoader = false;
    });
  }
}
