import 'package:flutter/material.dart';
import 'package:rowing_app/models/models.dart';
import 'package:rowing_app/screens/screens.dart';
import 'package:rowing_app/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rowing App'),
      ),
      body: _getBody(),
      drawer: _getMenu(),
    );
  }

  Widget _getBody() {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 60),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff242424),
              Color(0xff8c8c94),
            ],
          ),
        ),
        child: Column(
          children: [
            Image.asset(
              "assets/logo.png",
              height: 200,
            ),
            Text(
              'Bienvenido/a ${widget.user.fullName}',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ));
  }

  Widget _getMenu() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff8c8c94),
              Color(0xff8c8c94),
            ],
          ),
        ),
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff242424),
                    Color(0xff8c8c94),
                  ],
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Image(
                    image: AssetImage('assets/logo.png'),
                    width: 200,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Text(
                        "Usuario: ",
                        style: (TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      Text(
                        widget.user.fullName,
                        style: (TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.white,
              height: 1,
            ),
            MenuTile(
                icon: Icons.construction,
                menuitem: 'Obras',
                screen: ObrasScreen(
                  user: widget.user,
                  opcion: 1,
                )),
            widget.user.habilitaMedidores == 1
                ? MenuTile(
                    icon: Icons.schedule,
                    menuitem: 'Medidores',
                    screen: MedidoresScreen(
                      user: widget.user,
                    ))
                : Container(),
            widget.user.habilitaReclamos == 1
                ? MenuTile(
                    icon: Icons.border_color,
                    menuitem: 'Reclamos',
                    screen: ReclamosScreen(
                      user: widget.user,
                    ))
                : Container(),
            widget.user.habilitaSSHH == 1
                ? MenuTile(
                    icon: Icons.engineering,
                    menuitem: 'Seguridad e Higiene',
                    screen: SeguridadScreen())
                : Container(),
            widget.user.habilitaSSHH == 1
                ? MenuTile(
                    icon: Icons.newspaper,
                    menuitem: 'Novedades',
                    screen: NovedadesScreen(
                      user: widget.user,
                    ))
                : Container(),
            widget.user.habilitaSSHH == 1
                ? MenuTile(
                    icon: Icons.format_list_bulleted,
                    menuitem: 'Inspecciones',
                    screen: InspeccionesListaScreen(
                      user: widget.user,
                    ))
                : Container(),
            widget.user.habilitaSSHH == 1
                ? MenuTile(
                    icon: Icons.directions_car,
                    menuitem: 'Flotas',
                    screen: FlotaScreen(
                      user: widget.user,
                    ))
                : Container(),
            Divider(
              color: Colors.white,
              height: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              tileColor: Color(0xff8c8c94),
              title: Text('Cerrar Sesión',
                  style: TextStyle(fontSize: 15, color: Colors.white)),
              onTap: () {
                _logOut();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRemembered', false);
    await prefs.setString('userBody', '');
    await prefs.setString('date', '');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
