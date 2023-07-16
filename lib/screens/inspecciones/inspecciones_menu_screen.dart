import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rowing_app/models/models.dart';
import 'package:rowing_app/screens/screens.dart';

class InspeccionesMenuScreen extends StatefulWidget {
  final User user;
  final Position positionUser;
  const InspeccionesMenuScreen(
      {Key? key, required this.user, required this.positionUser})
      : super(key: key);

  @override
  _InspeccionesMenuScreenState createState() => _InspeccionesMenuScreenState();
}

class _InspeccionesMenuScreenState extends State<InspeccionesMenuScreen> {
//----------------------------------------------------------------
//------------------ initState -----------------------------------
//----------------------------------------------------------------

  @override
  void initState() {
    super.initState();
  }

//----------------------------------------------------------------
//------------------ Pantalla ------------------------------------
//----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: const Text('Menú Inspecciones'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.format_list_bulleted),
                SizedBox(
                  width: 35,
                ),
                Text('Mis Inspecciones'),
              ],
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF120E43),
              minimumSize: const Size(100, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InspeccionesListaScreen(
                    user: widget.user,
                    positionUser: widget.positionUser,
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.photo_album),
                SizedBox(
                  width: 35,
                ),
                Text('Fotos Insp. últ. 72hs'),
              ],
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF120E43),
              minimumSize: const Size(100, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InspeccionesFotosScreen(
                    user: widget.user,
                  ),
                ),
              );
            },
          ),
        ]),
      ),
    );
  }
}
