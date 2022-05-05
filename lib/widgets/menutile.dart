import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  final IconData icon;
  final String menuitem;
  final Widget screen;

  const MenuTile(
      {required this.icon, required this.menuitem, required this.screen});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title:
          Text(menuitem, style: TextStyle(fontSize: 15, color: Colors.white)),
      tileColor: Color(0xff8c8c94),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => screen,
          ),
        );
      },
    );
  }
}
