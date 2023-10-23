import 'package:flutter/material.dart';
import 'package:rowing_app/models/models.dart';
import 'package:rowing_app/screens/screens.dart';

class AdminScreen extends StatefulWidget {
  final User user;
  const AdminScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: const Text('Administrador'),
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
                Icon(Icons.password),
                SizedBox(
                  width: 35,
                ),
                Text('Reactivar Usuario'),
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
                  builder: (context) => ResetearPasswordsScreen(
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