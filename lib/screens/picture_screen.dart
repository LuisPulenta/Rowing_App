import 'package:flutter/material.dart';

class PictureScreen extends StatefulWidget {
  const PictureScreen({Key? key}) : super(key: key);

  @override
  _PictureScreenState createState() => _PictureScreenState();
}

class _PictureScreenState extends State<PictureScreen> {
  final String _observacionesError = '';
  final bool _observacionesShowError = false;
  String dropdownValue = 'Seleccione un Tipo de Foto...';

  final String _optionIdError = '';
  final bool _optionIdShowError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff8c8c94),
      appBar: AppBar(
        title: const Text('Nueva Foto'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 5),
          // image.path.length == 0
          //     ? Image.asset(
          //         "assets/noimage.png",
          //         width: 320,
          //         height: 320,
          //       )
          //     : Image.file(
          //         File(image.path),
          //         width: MediaQuery.of(context).size.width,
          //         fit: BoxFit.cover,
          //       ),
          const SizedBox(height: 5),
          _showOptions(),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Observaciones...',
                  labelText: 'Observaciones',
                  errorText:
                      _observacionesShowError ? _observacionesError : null,
                  prefixIcon: const Icon(Icons.text_fields),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              onChanged: (value) {},
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          _showButtons(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.camera_alt), onPressed: () async {}),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  Widget _showOptions() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonFormField(
          value: dropdownValue,
          onChanged: (option) {
            setState(() {});
          },
          items: <String>[
            'Seleccione un Tipo de Foto...',
            'Relevamiento(Vereda/Calzada/Traza)',
            'Previa al trabajo',
            'Durante el trabajo',
            'Finalización del Trabajo'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          decoration: InputDecoration(
            hintText: 'Seleccione un Tipo de Foto...',
            labelText: '',
            fillColor: Colors.white,
            filled: true,
            errorText: _optionIdShowError ? _optionIdError : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          )),
    );
  }

  Widget _showButtons() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.save),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Guardar Foto'),
                ],
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return const Color(0xFF781f1e);
                }),
              ),
              onPressed: () => _savePhoto(),
            ),
          ),
        ],
      ),
    );
  }

  void _savePhoto() {}
}
