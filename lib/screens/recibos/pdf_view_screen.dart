import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_imei/flutter_device_imei.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../components/loader_component.dart';
import '../../helpers/api_helper.dart';
import '../../models/models.dart';
import '../screens.dart';

class PdfViewScreen extends StatefulWidget {
  final String url;
  final String firma;
  final Position positionUser;
  final Recibo recibo;
  final Token token;
  final User user;

  const PdfViewScreen({
    super.key,
    required this.url,
    required this.firma,
    required this.positionUser,
    required this.recibo,
    required this.token,
    required this.user,
  });

  @override
  State<PdfViewScreen> createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  //---------------------- Variables ---------------------------------
  bool _showLoader = false;
  String urlPDFPath = '';
  bool exists = true;
  int _totalPages = 0;
  int _currentPage = 0;
  bool pdfReady = false;
  late PDFViewController _pdfViewController;
  bool loaded = false;
  String newPath = '';
  String ruta = '';
  String imei = '';
  String _email = '';

  String _imeiNo = '';
  var _apiLevel;

  //---------------------------------------------------------------
  //----------------------- initState -----------------------------
  //---------------------------------------------------------------

  @override
  void initState() {
    getFileFromUrl(widget.url).then(
      (value) => {
        setState(() {
          urlPDFPath = value.path;
          loaded = true;
          exists = true;
        }),
      },
    );
    initPlatformState();

    super.initState();
  }

  //--------------------- initPlatformState -------------------------
  //-----------------------------------------------------------------

  Future<void> initPlatformState() async {
    late String imeiNo = '';
    var apiLevel;

    var status = await Permission.phone.status;

    if (status.isDenied) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text('Aviso'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Text(
                  'La App necesita que habilite el Permiso de acceso al teléfono para utilizar el IMEI del celular con que se loguea.',
                ),
                SizedBox(height: 10),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
      openAppSettings();
      //exit(0);
    }

    try {
      imeiNo = await FlutterDeviceImei.instance.getIMEI() ?? '';
      imei = imeiNo;
    } on PlatformException catch (e) {}

    if (!mounted) return;

    _imeiNo = imeiNo;
    _apiLevel = apiLevel;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    _email = prefs.getString('email') ?? '';

    setState(() {});
  }

  //---------------------------------------------------------------
  //----------------------- Pantalla ------------------------------
  //---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    if (loaded) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ver Recibo'), centerTitle: true),
        body: Stack(
          children: [
            PDFView(
              filePath: urlPDFPath,
              autoSpacing: true,
              enableSwipe: true,
              pageSnap: true,
              swipeHorizontal: true,
              nightMode: false,
              onError: (e) {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Error'),
                    content: const Text(
                      'Hubo un error al obtener tu Recibo. Por favor reintenta mas tarde.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Aceptar'),
                      ),
                    ],
                  ),
                );
              },
              onRender: (pages) {
                setState(() {
                  _totalPages = pages!;
                  pdfReady = true;
                });
              },
              onViewCreated: (PDFViewController vc) {
                setState(() {
                  _pdfViewController = vc;
                });
              },
              onPageChanged: (int? page, int? total) {
                setState(() {
                  _currentPage = page!;
                });
              },
              onPageError: (page, e) {},
            ),
            _showLoader
                ? const LoaderComponent(text: 'Por favor espere...')
                : Container(),
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.chevron_left),
              iconSize: 50,
              color: Colors.black,
              onPressed: () {
                setState(() {
                  if (_currentPage > 0) {
                    _currentPage--;
                    _pdfViewController.setPage(_currentPage);
                  }
                });
              },
            ),
            Text(
              '${_currentPage + 1}/$_totalPages',
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              iconSize: 50,
              color: Colors.black,
              onPressed: () {
                setState(() {
                  if (_currentPage < _totalPages - 1) {
                    _currentPage++;
                    _pdfViewController.setPage(_currentPage);
                  }
                });
              },
            ),
            const Spacer(),
            if (widget.recibo.firmado == 0)
              FloatingActionButton(
                backgroundColor: const Color(0xFF781f1e),
                child: const Icon(Icons.draw, color: Colors.white, size: 40),
                onPressed: () async {
                  _showLoader = true;
                  setState(() {});
                  final PdfDocument document = PdfDocument(
                    inputBytes: File(urlPDFPath).readAsBytesSync(),
                  );

                  final PdfPage page = document.pages[0];

                  page.graphics.drawImage(
                    //PdfBitmap(await _readImageData('firma.png')),
                    PdfBitmap(
                      (await networkImageToBase64(widget.firma)) as List<int>,
                    ),
                    const Rect.fromLTWH(300, 460, 56, 35),
                  );
                  //const Rect.fromLTWH(390, 685, 80, 50));

                  List<int> bytes = await document.save();
                  document.dispose();

                  await _saveAndLaunchFile(bytes, 'ReciboConFirma.pdf');
                  _showLoader = false;
                  setState(() {});
                },
              ),
            if (widget.recibo.firmado != 0)
              FloatingActionButton(
                backgroundColor: const Color(0xFF781f1e),
                child: const Icon(Icons.mail, color: Colors.white, size: 40),
                onPressed: () async {
                  Response response = Response(isSuccess: false);
                  Map<String, dynamic> request = {
                    'to': _email,
                    'subject':
                        'Recibo Mes: ${widget.recibo.mes}-${widget.recibo.anio} Secuencia: ${widget.recibo.nroSecuencia}',
                    'body':
                        'Se adjunta recibo del Mes ${widget.recibo.mes}-${widget.recibo.anio} Secuencia: ${widget.recibo.nroSecuencia}',
                    'fileUrl': widget.url,
                    'fileName':
                        'Recibo Mes ${widget.recibo.mes}-${widget.recibo.anio} Secuencia ${widget.recibo.nroSecuencia}.pdf',
                  };
                  response = await ApiHelper.sendMail(request, widget.token);
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
                  _showSnackbar(
                    'Se le ha enviado el Recibo por mail',
                    Colors.lightGreen,
                  );
                  Navigator.pop(context, 'yes');
                },
              ),
          ],
        ),
      );
    } else {
      if (exists) {
        //Replace with your loading UI
        return Scaffold(
          appBar: AppBar(title: const Text('Ver Recibo'), centerTitle: true),
          body: const Text('Loading..', style: TextStyle(fontSize: 20)),
        );
      } else {
        //Replace Error UI
        return Scaffold(
          appBar: AppBar(title: const Text('Ver Recibo'), centerTitle: true),
          body: const Text('PDF no disponible', style: TextStyle(fontSize: 20)),
        );
      }
    }
  }

  //--------------------------------------------------------
  //--------------------- requestPermission ----------------
  //--------------------------------------------------------

  Future<bool> requestPermission() async {
    bool storagePermission = await Permission.storage.isGranted;
    bool mediaPermission = await Permission.accessMediaLocation.isGranted;
    bool manageExternal = await Permission.manageExternalStorage.isGranted;

    if (!storagePermission) {
      storagePermission = await Permission.storage.request().isGranted;
    }

    if (!mediaPermission) {
      mediaPermission = await Permission.accessMediaLocation
          .request()
          .isGranted;
    }

    if (!manageExternal) {
      manageExternal = await Permission.manageExternalStorage
          .request()
          .isGranted;
    }

    bool isPermissionGranted =
        storagePermission && mediaPermission && manageExternal;

    if (isPermissionGranted) {
      return true;
    } else {
      return false;
    }
  }

  //--------------------------------------------------------
  //--------------------- initRecorder ---------------------
  //--------------------------------------------------------

  Future initRecorder() async {
    bool permission = await requestPermission();
    if (Platform.isAndroid) {
      if (permission) {
        var directory = await getExternalStorageDirectory();
        newPath = '';
        String convertedDirectoryPath = (directory?.path).toString();
        List<String> paths = convertedDirectoryPath.split('/');
        for (int x = 1; x < convertedDirectoryPath.length; x++) {
          String folder = paths[x];
          if (folder != 'Android') {
            newPath += '/$folder';
          } else {
            break;
          }
        }
        newPath = '$newPath/rowingApp/Pdf';

        directory = Directory(newPath);
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
      }
    }
  }

  //--------------------------------------------------------
  //--------------------- _saveAndLaunchFile ---------------
  //--------------------------------------------------------

  Future<void> _saveAndLaunchFile(List<int> bytes, String fileName) async {
    await initRecorder();

    final path = (await getExternalStorageDirectory())!.path;
    //final path = (await getApplicationDocumentsDirectory())!.path;

    final file = File('$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);

    ruta = '$path/$fileName';

    Uint8List bytes2 = Uint8List.fromList(bytes);

    //OpenFile.open(ruta);

    if (file.path.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfScreen(
            ruta: ruta,
            recibo: widget.recibo,
            positionUser: widget.positionUser,
            imei: imei,
            token: widget.token,
          ),
        ),
      );
    }
  }

  //--------------------- _readImageData -------------------
  Future<Uint8List> _readImageData(String name) async {
    final data = await rootBundle.load('assets/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  //-------------------- _showSnackbar --------------------------
  void _showSnackbar(String message, Color color) {
    SnackBar snackbar = SnackBar(
      content: Text(message),
      backgroundColor: color,
      //duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    //ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}

//----------------------- getFileFromUrl ------------------------------
Future<File> getFileFromUrl(String url, {name}) async {
  var fileName = 'testonline';
  if (name != null) {
    fileName = name;
  }
  try {
    var data = await http.get(Uri.parse(url));
    var bytes = data.bodyBytes;
    var dir = await getApplicationDocumentsDirectory();
    File file = File('${dir.path}/$fileName.pdf');
    print(dir.path);
    File urlFile = await file.writeAsBytes(bytes);
    return urlFile;
  } catch (e) {
    throw Exception('Error opening url file');
  }
}

Future<Uint8List?> networkImageToBase64(String imageUrl) async {
  Uint8List bytes = (await NetworkAssetBundle(
    Uri.parse(imageUrl),
  ).load(imageUrl)).buffer.asUint8List();
  return bytes;
}
