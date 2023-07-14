// ignore_for_file: prefer_collection_literals

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:rowing_app/components/loader_component.dart';
import 'package:rowing_app/helpers/api_helper.dart';
import 'package:rowing_app/helpers/dbsuministroscatalogos_helper.dart';
import 'package:rowing_app/models/models.dart';

class ObraSuministroMaterialesInfoScreen extends StatefulWidget {
  final User user;

  const ObraSuministroMaterialesInfoScreen({Key? key, required this.user})
      : super(key: key);

  @override
  _ObraSuministroMaterialesInfoScreenState createState() =>
      _ObraSuministroMaterialesInfoScreenState();
}

class _ObraSuministroMaterialesInfoScreenState
    extends State<ObraSuministroMaterialesInfoScreen> {
//*****************************************************************************
//************************** DEFINICION DE VARIABLES **************************
//*****************************************************************************

  bool _showLoader = false;
  List<Catalogo> _catalogosBD = [];
  List<Catalogo> _catalogos = [];

//*****************************************************************************
//************************** INIT STATE ***************************************
//*****************************************************************************

  @override
  void initState() {
    super.initState();
    _getCatalogosBD();
  }

//*****************************************************************************
//************************** PANTALLA *****************************************
//*****************************************************************************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: const Text('Materiales en BD local'),
        centerTitle: true,
      ),
      body: Center(
        child: _showLoader
            ? const LoaderComponent(
                text: 'Por favor espere...',
              )
            : _getContent(),
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- METODO GETCONTENT -------------------------
//-----------------------------------------------------------------
  Widget _getContent() {
    return _catalogosBD.length > 0 || _catalogos.length > 0
        ? Column(
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              _showSuministroInfo(),
              const SizedBox(
                height: 10,
              ),
              _showButton()
            ],
          )
        : Center(
            child: Text(
                widget.user.modulo + " no tiene materiales para Suministros.",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)));
  }

//-----------------------------------------------------------------
//--------------------- METODO _showSuministroInfo ----------------
//-----------------------------------------------------------------

  Widget _showSuministroInfo() {
    double ancho = MediaQuery.of(context).size.width;
    double anchoTitulo = ancho * 0.45;
    return Card(
      color: const Color(0xFFC7C7C8),
      shadowColor: Colors.white,
      elevation: 10,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
      child: Container(
        height: 100,
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
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
                                titulo: 'Materiales en BD Local:',
                                dato: _catalogosBD.length.toString()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
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
                                titulo: 'Materiales en Servidor:',
                                dato: _catalogos.length > 0
                                    ? _catalogos.length.toString()
                                    : 'No se pudo conectar al Servidor'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

//*****************************************************************************
//************************** METODO _getCatalogosBD ***************************
//*****************************************************************************

  Future<void> _getCatalogosBD() async {
    _catalogosBD = await DBSuministroscatalogos.catalogos();
    setState(() {});
    _getCatalogos(widget.user.modulo);
  }

//*****************************************************************************
//************************** METODO _getCatalogos *****************************
//*****************************************************************************

  Future<void> _getCatalogos(String modulo) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estés conectado a Internet',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response = Response(isSuccess: false);

    response = await ApiHelper.getCatalogosSuministros(modulo);

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

    _catalogos = response.result;

    setState(() {});
  }

  Widget _showButton() {
    return Container(
        margin: const EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                child: const Text('Actualizar Catálogos'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF120E43),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () async {
                  DBSuministroscatalogos.deleteall();
                  _catalogos.forEach((catalogo) {
                    DBSuministroscatalogos.insertSuministrocatalogos(catalogo);
                  });
                  _catalogosBD = await DBSuministroscatalogos.catalogos();
                  setState(() {});
                },
              ),
            ),
          ],
        ));
  }
}

//-----------------------------------------------------------------
//-------------------------- _RowCustom ---------------------------
//-----------------------------------------------------------------
class _RowCustom extends StatelessWidget {
  const _RowCustom({
    Key? key,
    required this.anchoTitulo,
    required this.titulo,
    required this.dato,
  }) : super(key: key);

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
            child: Text(titulo,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF781f1e),
                  fontWeight: FontWeight.bold,
                )),
          ),
          Expanded(
            child: Text(dato,
                style: const TextStyle(
                  fontSize: 14,
                )),
          )
        ],
      ),
    );
  }
}
