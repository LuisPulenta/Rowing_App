import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rowing_app/components/loader_component.dart';
import 'package:rowing_app/helpers/dbsuministroscatalogos_helper.dart';
import 'package:rowing_app/helpers/dbsuministrosdet_helper.dart';
import 'package:rowing_app/models/models.dart';

class ObraSuministroMaterialesScreen extends StatefulWidget {
  final User user;
  final ObrasNuevoSuministro suministro;
  const ObraSuministroMaterialesScreen({
    super.key,
    required this.user,
    required this.suministro,
  });

  @override
  _ObraSuministroMaterialesScreenState createState() =>
      _ObraSuministroMaterialesScreenState();
}

class _ObraSuministroMaterialesScreenState
    extends State<ObraSuministroMaterialesScreen> {
  //-----------------------------------------------------------------
  //--------------------- Variables ---------------------------------
  //-----------------------------------------------------------------

  final bool _showLoader = false;
  List<Catalogo> _catalogos = [];
  List<ObraNuevoSuministroDet> _materialestodos = [];
  final List<ObraNuevoSuministroDet> _materiales = [];

  String _cantidad = '';
  final String _cantidadError = '';
  final bool _cantidadShowError = false;
  final TextEditingController _cantidadController = TextEditingController();

  List<TextEditingController> controllers = [];

  //-----------------------------------------------------------------
  //--------------------- initState ---------------------------------
  //-----------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  //-----------------------------------------------------------------
  //--------------------- Pantalla ----------------------------------
  //-----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: const Text('Materiales Nuevo Suministro'),
        centerTitle: true,
      ),
      body: Center(
        child: _showLoader
            ? const LoaderComponent(text: 'Por favor espere...')
            : _getContent(),
      ),
    );
  }

  //--------------------------------------------------------------
  //--------------------- _getContent ----------------------------
  //--------------------------------------------------------------
  Widget _getContent() {
    return _catalogos.isNotEmpty
        ? Column(
            children: <Widget>[
              const SizedBox(height: 10),
              _showSuministroInfo(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Text(
                    "Material         ",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text("   ", style: TextStyle(color: Colors.white)),
                  Text(
                    "Cantidad                 ",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Expanded(child: _getListView()),
              _showButtons(),
              const SizedBox(height: 10),
            ],
          )
        : Center(
            child: Text(
              "${widget.user.modulo} no tiene materiales para Suministros.",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
  }

  //----------------------------------------------------------
  //--------------------- _showSuministroInfo ----------------
  //----------------------------------------------------------

  Widget _showSuministroInfo() {
    double ancho = MediaQuery.of(context).size.width;
    double anchoTitulo = ancho * 0.2;
    return Card(
      color: const Color(0xFFC7C7C8),
      shadowColor: Colors.white,
      elevation: 10,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
      child: Container(
        height: 150,
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
                        _RowCustom(
                          anchoTitulo: anchoTitulo,
                          titulo: 'Fecha:',
                          dato: DateFormat(
                            'dd/MM/yyyy',
                          ).format(DateTime.parse(widget.suministro.fecha!)),
                        ),
                        _RowCustom(
                          anchoTitulo: anchoTitulo,
                          titulo: 'Cliente:',
                          dato: widget.suministro.apellidonombre!,
                        ),
                        _RowCustom(
                          anchoTitulo: anchoTitulo,
                          titulo: 'DNI:',
                          dato: widget.suministro.dni!,
                        ),
                        _RowCustom(
                          anchoTitulo: anchoTitulo,
                          titulo: 'Domicilio:',
                          dato: widget.suministro.domicilio!,
                        ),
                        _RowCustom(
                          anchoTitulo: anchoTitulo,
                          titulo: 'Barrio:',
                          dato: widget.suministro.barrio!,
                        ),
                        _RowCustom(
                          anchoTitulo: anchoTitulo,
                          titulo: 'Localidad:',
                          dato: widget.suministro.localidad!,
                        ),
                        _RowCustom(
                          anchoTitulo: anchoTitulo,
                          titulo: 'Partido:',
                          dato: widget.suministro.partido!,
                        ),
                        _RowCustom(
                          anchoTitulo: anchoTitulo,
                          titulo: 'Entre calles:',
                          dato:
                              (widget.suministro.entrecalleS1 != '' &&
                                  widget.suministro.entrecalleS2! != "")
                              ? '${widget.suministro.entrecalleS1!} y ${widget.suministro.entrecalleS2!}'
                              : "",
                        ),
                        _RowCustom(
                          anchoTitulo: anchoTitulo,
                          titulo: 'Teléfono:',
                          dato: widget.suministro.telefono!,
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
    );
  }

  //-----------------------------------------------------------
  //--------------------- _getListView ------------------------
  //-----------------------------------------------------------

  Widget _getListView() {
    return ListView(
      children: _catalogos.map((e) {
        return Card(
          color: const Color(0xFFC7C7C8),
          shadowColor: Colors.white,
          elevation: 10,
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
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
                                    flex: 4,
                                    child: Text(
                                      e.catCatalogo.toString(),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      e.cantidad.toString(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  IconButton(
                                    onPressed: () {
                                      _cantidadController.text =
                                          e.cantidad == 0.0
                                          ? ''
                                          : e.cantidad.toString();
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.grey[300],
                                            title: const Text(
                                              "Ingrese la cantidad",
                                            ),
                                            content: TextField(
                                              autofocus: true,
                                              controller: _cantidadController,
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                filled: true,
                                                hintText: '',
                                                labelText: '',
                                                errorText: _cantidadShowError
                                                    ? _cantidadError
                                                    : null,
                                                prefixIcon: const Icon(
                                                  Icons.tag,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              onChanged: (value) {
                                                _cantidad = value;
                                              },
                                            ),
                                            actions: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            const Color(
                                                              0xFFB4161B,
                                                            ),
                                                        minimumSize: const Size(
                                                          double.infinity,
                                                          50,
                                                        ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                5,
                                                              ),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
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
                                                        backgroundColor:
                                                            const Color(
                                                              0xFF120E43,
                                                            ),
                                                        minimumSize: const Size(
                                                          double.infinity,
                                                          50,
                                                        ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                5,
                                                              ),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        for (Catalogo catalogo
                                                            in _catalogos) {
                                                          if (catalogo
                                                                  .catCodigo ==
                                                              e.catCodigo) {
                                                            catalogo.cantidad =
                                                                double.parse(
                                                                  _cantidad,
                                                                );
                                                          }
                                                        }

                                                        Navigator.pop(context);
                                                        setState(() {});
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          );
                                        },
                                        barrierDismissible: false,
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.loop,
                                      color: Colors.blue,
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
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  //-----------------------------------------------------------
  //--------------------- _showButtons ------------------------
  //-----------------------------------------------------------

  Widget _showButtons() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[_showSaveButton()],
      ),
    );
  }

  //-----------------------------------------------------------
  //--------------------- _showSaveButton ---------------------
  //-----------------------------------------------------------

  Widget _showSaveButton() {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF781f1e),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        onPressed: () => _save(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.save),
            SizedBox(width: 15),
            Text('Guardar'),
          ],
        ),
      ),
    );
  }

  //-----------------------------------------------------------
  //--------------------- _loadData ---------------------------
  //-----------------------------------------------------------

  void _loadData() async {
    await _getCatalogos();
    for (Catalogo catalogo in _catalogos) {
      catalogo.cantidad = 0;
    }

    _materialestodos = await DBSuministrosdet.suministrosdet();

    for (var material in _materialestodos) {
      if (material.nrosuministrocab == widget.suministro.nrosuministro) {
        _materiales.add(material);
      }
    }

    if (_materiales.isNotEmpty) {
      for (var catalogo in _catalogos) {
        for (var material in _materiales) {
          if (catalogo.catCodigo == material.catcodigo) {
            catalogo.cantidad = material.cantidad;
          }
        }
      }
    }

    setState(() {});
  }

  //-----------------------------------------------------------
  //--------------------- _getCatalogos -----------------------
  //-----------------------------------------------------------

  Future<void> _getCatalogos() async {
    _catalogos = await DBSuministroscatalogos.catalogos();
  }

  //-----------------------------------------------------------
  //--------------------- _save -------------------------------
  //-----------------------------------------------------------

  Future<void> _save() async {
    _materiales.forEach((material) async {
      await DBSuministrosdet.delete(material);
    });

    for (Catalogo catalogo in _catalogos) {
      ObraNuevoSuministroDet request = ObraNuevoSuministroDet(
        nroregistrod: 0,
        nrosuministrocab: widget.suministro.nrosuministro,
        catcodigo: catalogo.catCodigo!,
        codigosap: catalogo.codigoSap!,
        cantidad: catalogo.cantidad!,
      );

      await DBSuministrosdet.insertSuministrodet(request);
    }

    await showAlertDialog(
      context: context,
      title: 'Aviso',
      message: 'Materiales guardados con éxito!',
      actions: <AlertDialogAction>[
        const AlertDialogAction(key: null, label: 'Aceptar'),
      ],
    );
    Navigator.pop(context);
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
