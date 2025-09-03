import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../components/loader_component.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';

class ConteoInfoScreen extends StatefulWidget {
  final User user;
  final Conteo conteo;
  const ConteoInfoScreen({super.key, required this.user, required this.conteo});

  @override
  State<ConteoInfoScreen> createState() => _ConteoInfoScreenState();
}

class _ConteoInfoScreenState extends State<ConteoInfoScreen> {
  //---------------------------------------------------------------------
  //-------------------------- Variables --------------------------------
  //---------------------------------------------------------------------
  List<ConteoDet> _conteoDetalles = [];
  bool _showLoader = false;

  String _cantidad = '';
  final String _cantidadError = '';
  final bool _cantidadShowError = false;
  final TextEditingController _cantidadController = TextEditingController();

  //---------------------------------------------------------------------
  //-------------------------- InitState --------------------------------
  //---------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _getConteoDetalles();
  }

  //---------------------------------------------------------------------
  //-------------------------- Pantalla ---------------------------------
  //---------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: Text('Conteo:  ${widget.conteo.idregistro}'),
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
    return Column(
      children: <Widget>[
        _showConteosDetalleCount(),
        Expanded(
          child: _conteoDetalles.isEmpty ? _noContent() : _getListView(),
        ),
        _conteoDetalles.isEmpty ? Container() : _showButton(),
      ],
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
        children: <Widget>[_showSaveButton()],
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showSaveButton ---------------------------
  //-----------------------------------------------------------------

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

  //-------------------------------------------------------
  //--------------------- _save ---------------------------
  //-------------------------------------------------------

  Future<void> _save() async {
    for (ConteoDet conteoDet in _conteoDetalles) {
      if (conteoDet.conteoactual < 0) {
        await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'No puede guardar números menores a cero.',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ],
        );
        return;
      }
    }

    for (ConteoDet conteoDet in _conteoDetalles) {
      Map<String, dynamic> request = {
        'IDCONTEODET': conteoDet.idconteodet,
        'IDCONTEOCAB': conteoDet.idconteocab,
        'CODIGOSIAG': conteoDet.codigosiag,
        'CODIGOSAP': conteoDet.codigosap,
        'DESCRIPCION': conteoDet.descripcion,
        'CONTEOACTUAL': conteoDet.conteoactual,
        'SEGUNINVENTARIO': 0,
        'VALORACTUAL': 0,
      };

      Response response = await ApiHelper.put(
        '/api/ConteoCiclicoCab/',
        conteoDet.idconteodet.toString(),
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
    }

    await showAlertDialog(
      context: context,
      title: 'Aviso',
      message: 'Conteo de Materiales guardado con éxito!',
      actions: <AlertDialogAction>[
        const AlertDialogAction(key: null, label: 'Aceptar'),
      ],
    );
    Navigator.pop(context);
  }

  //-------------------------------------------------------------------------
  //----------------------  _showConteosDetalleCount ------------------------//--------------------------------------------------------------------------

  Widget _showConteosDetalleCount() {
    double ancho = MediaQuery.of(context).size.width * 0.9;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          height: 40,
          child: Row(
            children: [
              const Text(
                'Cantidad de Items: ',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _conteoDetalles.length.toString(),
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
                width: ancho * 0.2,
                child: const Text(
                  'SIAG/SAP',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              const SizedBox(width: 15),
              SizedBox(
                width: ancho * 0.48,
                child: const Text(
                  'Descripción',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              SizedBox(
                width: ancho * 0.15,
                child: const Text(
                  'Cantidad',
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
          'No hay Materiales registrados',
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
      onRefresh: _getConteoDetalles,
      child: ListView(
        children: _conteoDetalles.map((e) {
          return SizedBox(
            height: 60,
            child: Center(
              child: Card(
                color: const Color(0xFFC7C7C8),
                shadowColor: Colors.white,
                elevation: 10,
                margin: const EdgeInsets.fromLTRB(10, 0, 5, 10),
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 5,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: ancho * 0.2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        e.codigosiag,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      e.codigosap.replaceAll(' ', '') !=
                                              e.codigosiag.replaceAll(' ', '')
                                          ? Text(
                                              e.codigosap,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 10,
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 15),
                                SizedBox(
                                  width: ancho * 0.48,
                                  child: Text(
                                    e.descripcion,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                                SizedBox(
                                  width: ancho * 0.15,
                                  child: Text(
                                    e.conteoactual.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _cantidadController.text =
                                        e.conteoactual == 0.0
                                        ? ''
                                        : e.conteoactual.toString();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        _cantidad = _cantidadController.text;
                                        return AlertDialog(
                                          backgroundColor: Colors.grey[300],
                                          title: const Text(
                                            'Ingrese la cantidad',
                                          ),
                                          content: TextField(
                                            autofocus: true,
                                            keyboardType: TextInputType.number,
                                            controller: _cantidadController,
                                            decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              hintText: '',
                                              labelText: '',
                                              errorText: _cantidadShowError
                                                  ? _cantidadError
                                                  : null,
                                              prefixIcon: const Icon(Icons.tag),
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
                                                      for (ConteoDet conteoDet
                                                          in _conteoDetalles) {
                                                        if (conteoDet
                                                                .codigosiag ==
                                                            e.codigosiag) {
                                                          conteoDet
                                                                  .conteoactual =
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
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
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
                          ),
                        ),
                      ],
                    ),
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
  //-------------------------- _getConteoDetalles -----------------------
  //---------------------------------------------------------------------

  Future<void> _getConteoDetalles() async {
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

    response = await ApiHelper.getConteoDetalles(widget.conteo.idregistro);

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
      _conteoDetalles = response.result;
    });
  }
}
