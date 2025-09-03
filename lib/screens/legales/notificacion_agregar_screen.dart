import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:camera/camera.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../helpers/helpers.dart';
import '../../helpers/resize_image.dart';
import '../../models/models.dart';
import '../screens.dart';

class NotificacionAgregarScreen extends StatefulWidget {
  final User user;
  final Juicio juicio;
  const NotificacionAgregarScreen({
    super.key,
    required this.user,
    required this.juicio,
  });

  @override
  State<NotificacionAgregarScreen> createState() =>
      _NotificacionAgregarScreenState();
}

class _NotificacionAgregarScreenState extends State<NotificacionAgregarScreen> {
  //---------------------------------------------------------------------
  //-------------------------- Variables --------------------------------
  //---------------------------------------------------------------------
  bool _showLoader = false;
  bool _photoChanged = false;

  int _nroReg = 0;
  String _tipoArray = '';

  late XFile _image;
  String base64ImagePdf = '';

  String _titulo = '';
  String _tituloError = '';
  bool _tituloShowError = false;
  final TextEditingController _tituloController = TextEditingController();

  String _observaciones = '';
  String _observacionesError = '';
  bool _observacionesShowError = false;
  final TextEditingController _observacionesController =
      TextEditingController();

  String _monto = '';
  final String _montoError = '';
  final bool _montoShowError = false;
  final TextEditingController _montoController = TextEditingController();

  String _tipoTransaccion = 'Elija un tipo de transacción...';
  String _tipoTransaccionError = '';
  bool _tipoTransaccionShowError = false;

  String _condicionPago = '';
  String _condicionPagoError = '';
  bool _condicionPagoShowError = false;
  final TextEditingController _condicionPagoController =
      TextEditingController();

  String _moneda = 'ARG';

  String _nroFactura = '';
  String _nroFacturaError = '';
  bool _nroFacturaShowError = false;
  final TextEditingController _nroFacturaController = TextEditingController();

  String _lugar = '';
  String _lugarError = '';
  bool _lugarShowError = false;
  final TextEditingController _lugarController = TextEditingController();

  String _participantes = '';
  String _participantesError = '';
  bool _participantesShowError = false;
  final TextEditingController _participantesController =
      TextEditingController();

  DateTime? _fechaNotificacionOferta;
  DateTime? _fechaVencimientoOferta;

  //---------------------------------------------------------------------
  //-------------------------- InitState --------------------------------
  //---------------------------------------------------------------------

  //---------------------------------------------------------------------
  //-------------------------- Pantalla ---------------------------------
  //---------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xFF484848),
      backgroundColor: const Color(0xff8c8c94),
      appBar: AppBar(
        title: const Text('Nueva Notificación'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _showTitulo(),
            _showObservaciones(),
            _showMonto(),
            _showMoneda(),
            _showTipoTransaccion(),
            _showCondicionPago(),
            _showNroFactura(),
            _showLugar(),
            _showParticipantes(),
            _showFechaNotificacionOferta(),
            _showFechaVencimientoOferta(),
            _showPhoto(),
            const SizedBox(height: 15),
            _showButton(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  //---------------------------------------------------------------------
  //-------------------------- _showTitulo ------------------------------
  //---------------------------------------------------------------------
  Widget _showTitulo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _tituloController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingresa Título...',
          labelText: 'Título',
          errorText: _tituloShowError ? _tituloError : null,
          suffixIcon: const Icon(Icons.title),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _titulo = value;
        },
      ),
    );
  }

  //-----------------------------------------------------------
  //--------------------- _showObservaciones ------------------
  //-----------------------------------------------------------

  Widget _showObservaciones() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _observacionesController,
        maxLines: 3,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingresa Observaciones...',
          labelText: 'Observaciones',
          errorText: _observacionesShowError ? _observacionesError : null,
          suffixIcon: const Icon(Icons.notes),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _observaciones = value;
        },
      ),
    );
  }

  //---------------------------------------------------------------------
  //-------------------------- _showMonto -------------------------------
  //---------------------------------------------------------------------
  Widget _showMonto() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _montoController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingresa Monto...',
          labelText: 'Monto',
          errorText: _montoShowError ? _montoError : null,
          suffixIcon: const Icon(Icons.monetization_on),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _monto = value;
        },
      ),
    );
  }

  //---------------------------------------------------------------------
  //-------------------------- _showMoneda -------------------------------
  //---------------------------------------------------------------------
  Widget _showMoneda() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          const Text(
            ' Moneda: ',
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
          Expanded(
            flex: 1,
            child: RadioListTile<String>(
              activeColor: const Color(0xFF781f1e),
              value: 'ARG',
              groupValue: _moneda,
              title: const Text('ARG'),
              onChanged: (value) {
                _moneda = value ?? 'ARG';
                setState(() {});
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: RadioListTile<String>(
              activeColor: const Color(0xFF781f1e),
              value: 'USD',
              groupValue: _moneda,
              title: const Text('USD'),
              onChanged: (value) {
                _moneda = value ?? 'USD';
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  //---------------------------------------------------------------------
  //-------------------------- _showTipoTransaccion ---------------------
  //---------------------------------------------------------------------

  Widget _showTipoTransaccion() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonFormField(
        initialValue: _tipoTransaccion,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Elija un tipo de transacción...',
          labelText: 'Tipo de transacción...',
          errorText: _tipoTransaccionShowError ? _tipoTransaccionError : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        items: const [
          DropdownMenuItem(
            value: 'Elija un tipo de transacción...',
            child: Text('Elija un tipo de transacción...'),
          ),
          DropdownMenuItem(value: 'Efectivo', child: Text('Efectivo')),
          DropdownMenuItem(value: 'E-Cheq', child: Text('E-Cheq')),
          DropdownMenuItem(
            value: 'Transferencia',
            child: Text('Transferencia'),
          ),
          DropdownMenuItem(value: 'Otro', child: Text('Otro')),
        ],
        onChanged: (value) {
          _tipoTransaccion = value.toString();
        },
      ),
    );
  }

  //---------------------------------------------------------------------
  //-------------------------- _showCondicionPago --------------------------
  //---------------------------------------------------------------------
  Widget _showCondicionPago() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _condicionPagoController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingresa Condición de Pago...',
          labelText: 'Condición de Pago',
          errorText: _condicionPagoShowError ? _condicionPagoError : null,
          suffixIcon: const Icon(Icons.title),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _condicionPago = value;
        },
      ),
    );
  }

  //---------------------------------------------------------------------
  //-------------------------- _showNroFactura --------------------------
  //---------------------------------------------------------------------
  Widget _showNroFactura() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _nroFacturaController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingresa N° de Factura...',
          labelText: 'N° de Factura',
          errorText: _nroFacturaShowError ? _nroFacturaError : null,
          suffixIcon: const Icon(Icons.title),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _nroFactura = value;
        },
      ),
    );
  }

  //---------------------------------------------------------------------
  //-------------------------- _showLugar -------------------------------
  //---------------------------------------------------------------------
  Widget _showLugar() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _lugarController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingresa Lugar...',
          labelText: 'Lugar',
          errorText: _lugarShowError ? _lugarError : null,
          suffixIcon: const Icon(Icons.title),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _lugar = value;
        },
      ),
    );
  }

  //---------------------------------------------------------------------
  //-------------------------- _showParticipantes -----------------------
  //---------------------------------------------------------------------
  Widget _showParticipantes() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _participantesController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Ingresa Participantes...',
          labelText: 'Participantes',
          errorText: _participantesShowError ? _participantesError : null,
          suffixIcon: const Icon(Icons.title),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _participantes = value;
        },
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showFechaNotificacionOferta --------------------
  //-----------------------------------------------------------------

  Widget _showFechaNotificacionOferta() {
    double ancho = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [Expanded(flex: 2, child: Row(children: const []))],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: ancho * 0.75,
                      height: 60,
                      child: Text(
                        '  Fecha Notificación: ${(_fechaNotificacionOferta != null) ? '    ${_fechaNotificacionOferta!.day}/${_fechaNotificacionOferta!.month}/${_fechaNotificacionOferta!.year}' : ''}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF781f1e),
                          minimumSize: const Size(double.infinity, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () =>
                            _elegirFechaNotificacionOferta(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [Icon(Icons.calendar_month)],
                        ),
                      ),
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

  //-----------------------------------------------------------------
  //--------------------- _elegirFechaNotificacionOferta ------------
  //-----------------------------------------------------------------

  void _elegirFechaNotificacionOferta(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(
        DateTime.now().add(const Duration(days: -60)).year,
        DateTime.now().add(const Duration(days: -60)).month,
        DateTime.now().add(const Duration(days: -60)).day,
      ),
      lastDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
    );
    if (selected != null && selected != _fechaNotificacionOferta) {
      setState(() {
        _fechaNotificacionOferta = selected;
      });
    }
  }

  //-----------------------------------------------------------------
  //--------------------- _showFechaVencimientoOferta --------------------
  //-----------------------------------------------------------------

  Widget _showFechaVencimientoOferta() {
    double ancho = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [Expanded(flex: 2, child: Row(children: const []))],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: ancho * 0.75,
                      height: 60,
                      child: Text(
                        '  Fecha Vencimiento Oferta: ${(_fechaVencimientoOferta != null) ? '    ${_fechaVencimientoOferta!.day}/${_fechaVencimientoOferta!.month}/${_fechaVencimientoOferta!.year}' : ''}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF781f1e),
                          minimumSize: const Size(double.infinity, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () => _elegirFechaVencimientoOferta(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [Icon(Icons.calendar_month)],
                        ),
                      ),
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

  //-----------------------------------------------------------------
  //--------------------- _elegirFechaVencimientoOferta -------------
  //-----------------------------------------------------------------

  void _elegirFechaVencimientoOferta(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(
        DateTime.now().add(const Duration(days: -30)).year,
        DateTime.now().add(const Duration(days: -30)).month,
        DateTime.now().add(const Duration(days: -30)).day,
      ),
      lastDate: DateTime(
        DateTime.now().add(const Duration(days: 180)).year,
        DateTime.now().add(const Duration(days: 180)).month,
        DateTime.now().add(const Duration(days: 180)).day,
      ),
    );
    if (selected != null && selected != _fechaVencimientoOferta) {
      setState(() {
        _fechaVencimientoOferta = selected;
      });
    }
  }

  //-----------------------------------------------------------------
  //--------------------- _showPhoto --------------------------------
  //-----------------------------------------------------------------

  Widget _showPhoto() {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          height: 240,
          margin: const EdgeInsets.only(top: 10),
          child: base64ImagePdf == ''
              ? !_photoChanged
                    ? const Image(
                        image: AssetImage('assets/noimage.png'),
                        width: double.infinity,
                        height: 160,
                        fit: BoxFit.contain,
                      )
                    : Image.file(
                        File(_image.path),
                        width: 160,
                        fit: BoxFit.contain,
                      )
              : const Image(
                  image: AssetImage('assets/pdf.png'),
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.contain,
                ),
        ),
        Positioned(
          top: 15,
          left: 30,
          child: InkWell(
            onTap: () => _takePicture(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                color: Colors.green[50],
                height: 60,
                width: 60,
                child: const Icon(
                  Icons.photo_camera,
                  size: 40,
                  color: Color(0xFF781f1e),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 15,
          left: 30,
          child: InkWell(
            onTap: () => _selectPicture(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                color: Colors.green[50],
                height: 60,
                width: 60,
                child: const Icon(
                  Icons.image,
                  size: 40,
                  color: Color(0xFF781f1e),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 90,
          right: 30,
          child: InkWell(
            onTap: () => _loadPdf(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                color: Colors.green[50],
                height: 60,
                width: 60,
                child: const Icon(
                  Icons.picture_as_pdf,
                  size: 40,
                  color: Color(0xFF781f1e),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  //-------------------------------------------------------------------------
  //----------------------------- _takePicture ------------------------------
  //-------------------------------------------------------------------------

  void _takePicture() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    var firstCamera = cameras.first;
    var response = await showAlertDialog(
      context: context,
      title: 'Seleccionar cámara',
      message: '¿Qué cámara desea utilizar?',
      actions: <AlertDialogAction>[
        const AlertDialogAction(key: 'no', label: 'Trasera'),
        const AlertDialogAction(key: 'yes', label: 'Delantera'),
        const AlertDialogAction(key: 'cancel', label: 'Cancelar'),
      ],
    );
    if (response == 'yes') {
      firstCamera = cameras.first;
    }
    if (response == 'no') {
      firstCamera = cameras.last;
    }

    if (response != 'cancel') {
      Response? response = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TakePictureaScreen(camera: firstCamera),
        ),
      );
      if (response != null) {
        setState(() {
          _photoChanged = true;
          _image = response.result;
          base64ImagePdf = '';
          _tipoArray = 'jpg';
        });
      }
    }
  }

  //-------------------------------------------------------------------------
  //----------------------------- _selectPicture ----------------------------
  //-------------------------------------------------------------------------

  void _selectPicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _photoChanged = true;
        _image = image;
        base64ImagePdf = '';
        _tipoArray = 'jpg';
      });
    }
  }

  //-----------------------------------------------------------------
  //--------------------- _showButton -------------------------------
  //-----------------------------------------------------------------

  Widget _showButton() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF781f1e),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: _save,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.save),
                  SizedBox(width: 20),
                  Text('Guardar Notificación'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _save -------------------------------------
  //-----------------------------------------------------------------

  void _save() {
    if (!validateFields()) {
      setState(() {});
      return;
    }
    _addRecord();
  }

  //-----------------------------------------------------------------
  //--------------------- validateFields ----------------------------
  //-----------------------------------------------------------------

  bool validateFields() {
    bool isValid = true;

    //--------- Titulo ----------
    if (_titulo == '') {
      isValid = false;
      _tituloShowError = true;
      _tituloError = 'Debe completar Título';

      setState(() {});
      return isValid;
    } else if (_titulo.length > 119) {
      isValid = false;
      _tituloShowError = true;
      _tituloError =
          'No debe superar los 119 caracteres. Escribió ${_titulo.length}.';
      setState(() {});
      return isValid;
    } else {
      _tituloShowError = false;
    }

    //--------- Observaciones ----------
    if (_observaciones.length > 299) {
      isValid = false;
      _observacionesShowError = true;
      _observacionesError =
          'No debe superar los 299 caracteres. Escribió ${_observaciones.length}.';
      setState(() {});
      return isValid;
    } else {
      _observacionesShowError = false;
    }

    //--------- TipoTransaccion ----------
    if (_tipoTransaccion == 'Elija un tipo de transacción...' && _monto != '') {
      isValid = false;
      _tipoTransaccionShowError = true;
      _tipoTransaccionError = 'Debe elegir un tipoTransaccion';

      setState(() {});
      return isValid;
    } else {
      _tipoTransaccionShowError = false;
    }

    //--------- CondicionPago ----------
    if (_condicionPago == '' && _monto != '') {
      isValid = false;
      _condicionPagoShowError = true;
      _condicionPagoError = 'Debe completar Condición de Pago';

      setState(() {});
      return isValid;
    } else if (_condicionPago.length > 50) {
      isValid = false;
      _condicionPagoShowError = true;
      _condicionPagoError =
          'No debe superar los 50 caracteres. Escribió ${_condicionPago.length}.';
      setState(() {});
      return isValid;
    } else {
      _condicionPagoShowError = false;
    }

    //--------- N° de Factura ----------
    if (_nroFactura == '' && _monto != '') {
      isValid = false;
      _nroFacturaShowError = true;
      _nroFacturaError = 'Debe completar N° de Factura';

      setState(() {});
      return isValid;
    } else if (_nroFactura.length > 19) {
      isValid = false;
      _nroFacturaShowError = true;
      _nroFacturaError =
          'No debe superar los 19 caracteres. Escribió ${_nroFactura.length}.';
      setState(() {});
      return isValid;
    } else {
      _nroFacturaShowError = false;
    }

    //--------- Lugar ----------
    if (_lugar.length > 50) {
      isValid = false;
      _lugarShowError = true;
      _lugarError =
          'No debe superar los 50 caracteres. Escribió ${_lugar.length}.';
      setState(() {});
      return isValid;
    } else {
      _lugarShowError = false;
    }

    //--------- Participantes ----------
    if (_participantes == '') {
      isValid = false;
      _participantesShowError = true;
      _participantesError = 'Debe completar Participantes';

      setState(() {});
      return isValid;
    } else if (_participantes.length > 100) {
      isValid = false;
      _participantesShowError = true;
      _participantesError =
          'No debe superar los 100 caracteres. Escribió ${_participantes.length}.';
      setState(() {});
      return isValid;
    } else {
      _participantesShowError = false;
    }

    setState(() {});

    return isValid;
  }

  //-----------------------------------------------------------------
  //--------------------- _addRecord ----------------------------
  //-----------------------------------------------------------------

  void _addRecord() async {
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

    String base64Image = '';

    if (_photoChanged) {
      Uint8List imageBytes = await _image.readAsBytes();
      int maxWidth = 800; // Ancho máximo
      int maxHeight = 600; // Alto máximo
      Uint8List resizedBytes = await resizeImage(
        imageBytes,
        maxWidth,
        maxHeight,
      );
      base64Image = base64Encode(resizedBytes);
    }

    if (base64ImagePdf != '') {
      base64Image = base64ImagePdf;
    }

    Response response2 = await ApiHelper.getNroRegistroMaxNotificaciones();
    if (response2.isSuccess) {
      _nroReg = int.parse(response2.result.toString()) + 1;
    }

    Map<String, dynamic> request = {
      'IDNOTIFICACION': _nroReg,
      'IDJUICIO': widget.juicio.iDCASO,
      'TIPO': widget.juicio.tipocaso,
      'TITULO': _titulo,
      'OBSERVACIONES': _observaciones,
      'MONEDA': _moneda,
      'MONTO': _monto,
      'TIPOTRANSACCION': _tipoTransaccion,
      'CONDICIONPAGO': _condicionPago,
      'NROFACTURA': _nroFactura,
      'LUGAR': _lugar,
      'PARTICIPANTES': _participantes,
      'FECHAECHO': _fechaNotificacionOferta != null
          ? _fechaNotificacionOferta.toString().substring(0, 10)
          : '',
      'FECHAVENCIMIENTO': _fechaVencimientoOferta != null
          ? _fechaVencimientoOferta.toString().substring(0, 10)
          : '',
      'TIPOARRAY': _tipoArray,
      'ImageArray': base64Image,
    };

    Response response = await ApiHelper.postNoToken(
      '/api/CausantesJuicios/PostNotificacion',
      request,
    );

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
    Navigator.pop(context, 'yes');
  }

  //-----------------------------------------------------------------
  //------------------------- _loadPdf ------------------------------
  //-----------------------------------------------------------------

  Future<void> _loadPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      withData: true,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      String fileName = result.files.first.name;

      List<int> imageBytesPdf = fileBytes!.buffer.asUint8List();
      base64ImagePdf = base64Encode(imageBytesPdf);
      _tipoArray = 'pdf';

      setState(() {});
    }
  }
}
