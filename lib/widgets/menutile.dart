import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  final IconData icon;
  final String menuitem;
  final Widget screen;

  const MenuTile(
      {Key? key,
      required this.icon,
      required this.menuitem,
      required this.screen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(menuitem,
          style: const TextStyle(fontSize: 15, color: Colors.white)),
      tileColor: const Color(0xff8c8c94),
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
