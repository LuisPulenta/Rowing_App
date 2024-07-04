import 'package:flutter/material.dart';
import 'package:rowing_app/screens/screens.dart';

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
            const SizedBox(
              height: 10,
            ),
            const Text("Firma:"),
            Image.network(
              'http://190.111.249.225/RowingAppApi/images/Recibos/firma.jpg',
              width: 200,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 120.0),
              child: ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Icon(Icons.picture_as_pdf),
                    Text('Ver Recibo'),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF781f1e),
                  minimumSize: const Size(100, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () async {
                  String? result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PdfViewScreen(
                          url:
                              'http://190.111.249.225/RowingAppApi/images/Recibos/Recibo.pdf',
                          firma:
                              'http://190.111.249.225/RowingAppApi/images/Recibos/firma.jpg'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
