import 'package:flutter/material.dart';
import 'package:rowing_app/components/loader_component.dart';
import 'package:rowing_app/models/models.dart';

class ObraInfoDataScreen extends StatefulWidget {
  final User user;
  final Obra obra;

  const ObraInfoDataScreen({Key? key, required this.user, required this.obra})
      : super(key: key);

  @override
  State<ObraInfoDataScreen> createState() => _ObraInfoDataScreenState();
}

class _ObraInfoDataScreenState extends State<ObraInfoDataScreen> {
//----------------------------------------------------------------------
//------------------------ Variables -----------------------------------
//----------------------------------------------------------------------
  bool _showLoader = false;

  String _direccion = '';
  String _direccionError = '';
  bool _direccionShowError = false;
  final TextEditingController _direccionController = TextEditingController();

  int _estado = 0;
  String _estadoError = '';
  bool _estadoShowError = false;
  List<Option> _estadoOptions = [];

  int _materialCanio = 0;
  String _materialCanioError = '';
  bool _materialCanioShowError = false;
  List<Option> _materialCanioOptions = [];

  int _optionMotivo = 0;

  String _optionMotivoError = '';
  bool _optionMotivoShowError = false;

  List<DropdownMenuItem<int>> _estados = [];
  List<DropdownMenuItem<int>> _materialesCanio = [];

//----------------------------------------------------------------------
//------------------------  initState ----------------------------------
//----------------------------------------------------------------------
  @override
  void initState() {
    super.initState();

    _getMaterialesCanio();
    _getEstados();
  }

//----------------------------------------------------------------------
//------------------------ Pantalla -----------------------------------
//----------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Datos Obra ${widget.obra.nroObra}'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                _showDireccion(),
                _showEstado(),
                _showMaterialCanio(),
              ],
            ),
          ),
          _showLoader
              ? const LoaderComponent(
                  text: 'Por favor espere...',
                )
              : Container(),
        ],
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO _showDireccion ---------------------
//-----------------------------------------------------------------

  Widget _showDireccion() {
    double ancho = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: const [],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                            style: BorderStyle.solid),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: ancho * 0.75,
                      height: 60,
                      child: Text(
                        '  Dirección: ${_direccion}',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.location_on),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF781f1e),
                            minimumSize: const Size(double.infinity, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () => _getPosition()),
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

  _getPosition() async {
    FocusScope.of(context).unfocus();
  }

//-------------------------------------------------------------------------
//-------------------------- _showEstado ----------------------------------
//-------------------------------------------------------------------------

  _showEstado() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonFormField(
          items: _estados,
          value: _estado,
          onChanged: (option) {
            setState(() {});
          },
          decoration: InputDecoration(
            hintText: 'Seleccione un Estado...',
            labelText: 'Estado',
            fillColor: Colors.white,
            filled: true,
            errorText: _estadoShowError ? _estadoError : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          )),
    );
  }

//----------------------------------------------------------------------
//------------------------ _getEstados -----------------------------------
//----------------------------------------------------------------------

  void _getEstados() {
    _estados = [];

    Option opt1 = Option(id: 1, description: 'Fuga');
    Option opt2 = Option(id: 2, description: 'Sospechoso');
    Option opt3 = Option(id: 3, description: 'Silencioso');
    Option opt4 = Option(id: 4, description: 'No verificable');
    _estadoOptions.add(opt1);
    _estadoOptions.add(opt2);
    _estadoOptions.add(opt3);
    _estadoOptions.add(opt4);
    _getComboEstados();
  }

//----------------------------------------------------------------------
//------------------------ _getComboEstados -----------------------------------
//----------------------------------------------------------------------

  List<DropdownMenuItem<int>> _getComboEstados() {
    _estados = [];

    List<DropdownMenuItem<int>> listEstados = [];
    listEstados.add(const DropdownMenuItem(
      child: Text('Seleccione un Estado...'),
      value: 0,
    ));

    for (var _listoption in _estadoOptions) {
      listEstados.add(DropdownMenuItem(
        child: Text(_listoption.description),
        value: _listoption.id,
      ));
    }

    _estados = listEstados;

    return listEstados;
  }

//-------------------------------------------------------------------------
//-------------------------- _showMaterialCanio ---------------------------
//-------------------------------------------------------------------------

  _showMaterialCanio() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonFormField(
          items: _materialesCanio,
          value: _materialCanio,
          onChanged: (option) {
            setState(() {});
          },
          decoration: InputDecoration(
            hintText: 'Seleccione un Material...',
            labelText: 'Material Caño',
            fillColor: Colors.white,
            filled: true,
            errorText: _materialCanioShowError ? _materialCanioError : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          )),
    );
  }

//----------------------------------------------------------------------
//------------------------ _getMaterialesCanio -------------------------
//----------------------------------------------------------------------

  void _getMaterialesCanio() {
    _estados = [];

    Option opt1 = Option(id: 1, description: 'Hierro Fundido');
    Option opt2 = Option(id: 2, description: 'Asbesto cemento');
    Option opt3 = Option(id: 3, description: 'Poliet./PVC');
    Option opt4 = Option(id: 4, description: 'Plomo');
    Option opt5 = Option(id: 4, description: 'Sin Datos');
    _materialCanioOptions.add(opt1);
    _materialCanioOptions.add(opt2);
    _materialCanioOptions.add(opt3);
    _materialCanioOptions.add(opt4);
    _materialCanioOptions.add(opt5);
    _getComboMaterialCanios();
  }

//----------------------------------------------------------------------
//------------------------ _getComboMaterialCanios ---------------------
//----------------------------------------------------------------------

  List<DropdownMenuItem<int>> _getComboMaterialCanios() {
    _estados = [];

    List<DropdownMenuItem<int>> listMaterialesCanios = [];
    listMaterialesCanios.add(const DropdownMenuItem(
      child: Text('Seleccione un Material...'),
      value: 0,
    ));

    for (var _listoption in _materialCanioOptions) {
      listMaterialesCanios.add(DropdownMenuItem(
        child: Text(_listoption.description),
        value: _listoption.id,
      ));
    }

    _materialesCanio = listMaterialesCanios;

    return listMaterialesCanios;
  }
}
