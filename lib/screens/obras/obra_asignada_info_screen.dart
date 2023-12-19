import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rowing_app/components/loader_component.dart';
import 'package:rowing_app/helpers/api_helper.dart';
import 'package:rowing_app/models/models.dart';

class ObraAsignadaInfoScreen extends StatefulWidget {
  final User user;
  final ObraAsignada obra;

  const ObraAsignadaInfoScreen(
      {Key? key, required this.user, required this.obra})
      : super(key: key);

  @override
  _ObraAsignadaInfoScreenState createState() => _ObraAsignadaInfoScreenState();
}

class _ObraAsignadaInfoScreenState extends State<ObraAsignadaInfoScreen> {
//---------------------------------------------------------------
//----------------------- Variables -----------------------------
//---------------------------------------------------------------

  String _fechaCierreSelected = '';

  String _observaciones = '';
  final String _observacionesError = '';
  final bool _observacionesShowError = false;
  final TextEditingController _observacionesController =
      TextEditingController();

  bool _showLoader = false;

  ObraAsignada _obra = ObraAsignada(
      nroregistro: 0,
      nroobra: 0,
      subcontratista: '',
      causante: '',
      tareaquerealiza: '',
      observacion: '',
      fechaalta: '',
      fechafinasignacion: '',
      idusr: 0,
      fechaCierre: '',
      nombreObra: '',
      modulo: '');

  DateTime selectedDate = DateTime.now();

//---------------------------------------------------------------
//----------------------- initState -----------------------------
//---------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _obra = widget.obra;
    _fechaCierreSelected =
        _obra.fechaCierre != null ? _obra.fechaCierre.toString() : '';
    _observaciones =
        widget.obra.observacion != null ? widget.obra.observacion! : '';
    _observacionesController.text = _observaciones;
  }

//---------------------------------------------------------------
//----------------------- Pantalla -----------------------------
//---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: Text('Obra ${widget.obra.nroobra}'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              _getInfoObra(),
              const SizedBox(
                height: 10,
              ),
              _showObservaciones(),
              const SizedBox(
                height: 10,
              ),
              _showButton(),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          _showLoader
              ? const LoaderComponent(text: 'Por favor espere...')
              : Container(),
        ],
      ),
    );
  }

//----------------------------------------------------------------------------
//------------------------------ _showObservaciones --------------------------
//----------------------------------------------------------------------------

  Widget _showObservaciones() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        child: TextField(
          controller: _observacionesController,
          maxLines: 3,
          decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              isDense: true,
              hintText: 'Ingrese Observaciones...',
              labelText: 'Observaciones:',
              errorText: _observacionesShowError ? _observacionesError : null,
              prefixIcon: const Icon(Icons.chat),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
          onChanged: (value) {
            _observaciones = value;
          },
        ));
  }

  //-------------------------------------------------------------
//--------------------- _showButton ---------------------------
//-------------------------------------------------------------

  Widget _showButton() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.save),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Guardar'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF781f1e),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () => _grabar(),
            ),
          ),
        ],
      ),
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
                const Text("N° Obra: ",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF781f1e),
                      fontWeight: FontWeight.bold,
                    )),
                Expanded(
                  flex: 3,
                  child: Text(_obra.nroobra.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                      )),
                ),
                const Text("Módulo: ",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF781f1e),
                      fontWeight: FontWeight.bold,
                    )),
                Expanded(
                  flex: 4,
                  child: Text(_obra.modulo.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const Text("Nombre: ",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF781f1e),
                      fontWeight: FontWeight.bold,
                    )),
                Expanded(
                  child: Text(_obra.nombreObra!,
                      style: const TextStyle(
                        fontSize: 12,
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                _fechaCierreSelected == "" || _fechaCierreSelected == null
                    ? MaterialButton(
                        color: const Color(0xFF781f1e),
                        child: const Text('Fec. Cierre .',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          _selectDate(context);
                          setState(() {});
                        })
                    : Container()
              ],
            ),
            SizedBox(
              height:
                  (_fechaCierreSelected != "" && _fechaCierreSelected != null)
                      ? 5
                      : 0,
            ),
            _fechaCierreSelected != "" && _fechaCierreSelected != "null"
                ? Row(
                    children: [
                      const Text("Fecha Cierre: ",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF781f1e),
                            fontWeight: FontWeight.bold,
                          )),
                      Expanded(
                        child: Text(
                            DateFormat('dd/MM/yyyy')
                                .format(DateTime.parse(_fechaCierreSelected)),
                            style: const TextStyle(
                              fontSize: 12,
                            )),
                      ),
                    ],
                  )
                : Container(),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

//-----------------------------------------------------
//-------------------- _selectDate --------------------
//-----------------------------------------------------

  void _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 15)),
      lastDate: DateTime.now().add(const Duration(days: 0)),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
        _fechaCierreSelected = selectedDate.toString();
        setState(() {});
      });
    }
  }

//-------------------------------------------------
//-------------------- _grabar --------------------
//-------------------------------------------------

  _grabar() async {
    FocusScope.of(context).unfocus(); //Oculta el teclado

    _obra.fechaCierre = selectedDate.toString();
    setState(() {});

    Map<String, dynamic> request = {
      // 'nrosuministro': 0,
      'NROREGISTRO': widget.obra.nroregistro,
      'NROOBRA': widget.obra.nroobra,
      'SUBCONTRATISTA': widget.obra.subcontratista,
      'CAUSANTE': widget.obra.causante,
      'TAREAQUEREALIZA': widget.obra.tareaquerealiza,
      'OBSERVACION': _observaciones,
      'FECHAALTA': widget.obra.fechaalta,
      'FECHAFINASIGNACION': widget.obra.fechafinasignacion,
      'IDUSR': widget.obra.idusr,
      'FechaCierre': selectedDate.toString(),
    };

    Response response = await ApiHelper.put('/api/Obras/PutObrasAsignacion/',
        widget.obra.nroregistro.toString(), request);

    if (response.isSuccess) {
      _showSnackbar("Datos guardados con éxito");
      setState(() {});
      Navigator.of(context).pop();
    }
  }

//-------------------------------------------------------------
//-------------------- _showSnackbar --------------------------
//-------------------------------------------------------------

  void _showSnackbar(String text) {
    SnackBar snackbar = SnackBar(
      content: Text(text),
      backgroundColor: Colors.lightGreen,
      //duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    //ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
