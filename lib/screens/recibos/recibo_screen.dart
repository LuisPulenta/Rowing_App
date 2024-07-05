import 'package:flutter/material.dart';
import 'package:rowing_app/models/models.dart';
import 'package:rowing_app/screens/screens.dart';

class ReciboScreen extends StatefulWidget {
  final User user;
  const ReciboScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ReciboScreen> createState() => _ReciboScreenState();
}

class _ReciboScreenState extends State<ReciboScreen> {
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
            (widget.user.firmaUsuarioImageFullPath != null)
                ? Image.network(
                    widget.user.firmaUsuarioImageFullPath!,
                    width: 200,
                  )
                : Container(),
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
                      builder: (context) => PdfViewScreen(
                          url:
                              'http://190.111.249.225/RowingAppApi/images/Recibos/Recibo.pdf',
                          firma: widget.user.firmaUsuarioImageFullPath!),
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
