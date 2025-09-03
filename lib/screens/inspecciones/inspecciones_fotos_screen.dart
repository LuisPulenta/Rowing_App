import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../helpers/helpers.dart';
import '../../models/models.dart';

class InspeccionesFotosScreen extends StatefulWidget {
  final User user;
  const InspeccionesFotosScreen({super.key, required this.user});

  @override
  _InspeccionesFotosScreenState createState() =>
      _InspeccionesFotosScreenState();
}

class _InspeccionesFotosScreenState extends State<InspeccionesFotosScreen> {
  //-----------------------------------------------------------------
  //--------------------- Variables ---------------------------------
  //-----------------------------------------------------------------

  int _current = 0;
  double _sliderValue = 3;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  List<VistaInspeccionesFoto> _fotos = [];

  bool _mostrar = false;

  //-----------------------------------------------------------------
  //--------------------- initState ---------------------------------
  //-----------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _getFotosInspecciones();
  }

  //-----------------------------------------------------------------
  //--------------------- Pantalla ----------------------------------
  //-----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: const Text('Fotos Inspecciones'),
        centerTitle: true,
        actions: [
          Row(
            children: [
              const Text(
                'Datos:',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              Switch(
                value: _mostrar,
                activeThumbColor: Colors.green,
                inactiveThumbColor: Colors.grey,
                onChanged: (value) {
                  _mostrar = value;
                  setState(() {});
                },
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[_showFiltro(), _showPhotosCarousel()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //-----------------------------------------------------------------------
  //-------------------------- _showPhotosCarousel ------------------------
  //-----------------------------------------------------------------------

  Widget _showPhotosCarousel() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0),
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.75,
              autoPlay: false,
              initialPage: 0,
              autoPlayInterval: const Duration(seconds: 0),
              enlargeCenterPage: true,
              viewportFraction: 0.9,
              aspectRatio: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
            carouselController: _carouselController,
            items: _fotos.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Column(
                    children: [
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: i.imageFullPath.toString(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.contain,
                              height: 360,
                              width: 460,
                              placeholder: (context, url) => const Image(
                                image: AssetImage('assets/loading.gif'),
                                fit: BoxFit.contain,
                                height: 100,
                                width: 100,
                              ),
                            ),
                          ),
                        ),
                      ),
                      _mostrar
                          ? Column(
                              children: [
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 86,
                                      child: Text(
                                        'Supervisor: ',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${i.apellido} ${i.nombre}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 86,
                                      child: Text(
                                        'Fecha: ',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      DateFormat('dd/MM/yyyy').format(
                                        DateTime.parse(i.fecha.toString()),
                                      ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 86,
                                      child: Text(
                                        'Causante: ',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        i.causante,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 86,
                                      child: Text(
                                        'Descripción: ',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        i.descripcion,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 86,
                                      child: Text(
                                        'Cumple: ',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      i.cumple,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 86,
                                      child: Text(
                                        'Cliente: ',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      i.cliente,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  );
                },
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Flexible(
                child: ElevatedButton(
                  onPressed: () => _carouselController.previousPage(),
                  child: const Text(
                    '←',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Text(
                'Fotos: ${_fotos.length.toString()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Flexible(
                child: ElevatedButton(
                  onPressed: () => _carouselController.nextPage(),
                  child: const Text(
                    '→',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //-----------------------------------------------------------------------
  //-------------------------- _getFotosInspecciones ----------------------
  //-----------------------------------------------------------------------

  Future<void> _getFotosInspecciones() async {
    setState(() {});

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {});
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Verifica que estes conectado a internet.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );
      return;
    }

    Response response = await ApiHelper.getFotosInspecciones(
      _sliderValue.round().toString(),
    );

    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'No hay fotos',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ],
      );

      setState(() {});
      return;
    }
    _fotos = response.result;

    _current = 0;

    setState(() {
      _carouselController.jumpToPage(0);
    });
  }

  //----------------------------------------------------------------------
  //------------------------------ _showFiltro ---------------------------
  //----------------------------------------------------------------------

  Widget _showFiltro() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Antiguedad (días): ',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Slider(
                min: 3,
                max: 15,
                activeColor: const Color.fromARGB(255, 228, 193, 18),
                value: _sliderValue,
                onChanged: (value) {
                  _sliderValue = value;
                  _getFotosInspecciones();
                },
                divisions: 4,
              ),
              Center(
                child: Text(
                  _sliderValue.round().toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
