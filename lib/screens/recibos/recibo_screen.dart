import 'package:flutter/material.dart';

class ReciboScreen extends StatelessWidget {
  const ReciboScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReciboScreen'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Text('Recibo'),
            Image.network(
              'http://190.111.249.225/RowingAppApi/images/Recibos/firma.jpg',
              width: 200,
            ),
          ],
        ),
      ),
    );
  }
}
