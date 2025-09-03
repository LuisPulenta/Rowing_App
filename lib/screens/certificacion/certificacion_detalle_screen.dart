import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../../models/models.dart';
import '../../widgets/widgets.dart';

class CertificacionDetalleScreen extends StatefulWidget {
  final User user;
  final Position positionUser;
  final String imei;
  final bool editMode;
  final CabeceraCertificacion cabeceraCertificacion;

  const CertificacionDetalleScreen({
    super.key,
    required this.user,
    required this.positionUser,
    required this.imei,
    required this.editMode,
    required this.cabeceraCertificacion,
  });

  @override
  State<CertificacionDetalleScreen> createState() =>
      _CertificacionDetalleScreenState();
}

class _CertificacionDetalleScreenState
    extends State<CertificacionDetalleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Certificado ${widget.cabeceraCertificacion.id.toString()}',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: const Color(0xFFC7C7C8),
          margin: const EdgeInsets.all(0),
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              CustomRow(
                nombredato: 'Id Acta: ',
                dato: widget.cabeceraCertificacion.id.toString(),
              ),
              CustomRow(
                nombredato: 'Fecha: ',
                dato: DateFormat('dd/MM/yyyy').format(
                  DateTime.parse(widget.cabeceraCertificacion.fechacarga!),
                ),
              ),
              CustomRow(
                nombredato: 'N° Obra: ',
                dato:
                    '${widget.cabeceraCertificacion.nroobra} - ${widget.cabeceraCertificacion.nombreObra}',
              ),
              CustomRow(
                nombredato: 'Def.Proy.: ',
                dato: widget.cabeceraCertificacion.defProy,
              ),
              CustomRow(
                nombredato: 'Central: ',
                dato: widget.cabeceraCertificacion.central,
              ),
              CustomRow(
                nombredato: 'SubC: ',
                dato:
                    '${widget.cabeceraCertificacion.subCodigo} - ${widget.cabeceraCertificacion.codCausanteC}',
              ),
              CustomRow(
                nombredato: 'Fecha Corresp.: ',
                dato: DateFormat('dd/MM/yyyy').format(
                  DateTime(1900, 1, 1).add(
                    Duration(
                      days:
                          widget.cabeceraCertificacion.fechacorrespondencia! -
                          36163,
                    ),
                  ),
                ),
              ),
              CustomRow(
                nombredato: 'Cod.Prod.: ',
                dato: widget.cabeceraCertificacion.codigoproduccion,
              ),
              CustomRow(
                nombredato: 'Mes Imput.: ',
                dato: widget.cabeceraCertificacion.mesImputacion.toString(),
              ),
              CustomRow(
                nombredato: 'Objeto: ',
                dato: widget.cabeceraCertificacion.objeto,
              ),
              CustomRow(
                nombredato: 'MontoC: ',
                dato: widget.cabeceraCertificacion.valortotalc != null
                    ? NumberFormat.currency(
                        symbol: '\$',
                      ).format(widget.cabeceraCertificacion.valortotalc)
                    : '',
              ),
              CustomRow(
                nombredato: 'MontoT: ',
                dato: widget.cabeceraCertificacion.valortotalc != null
                    ? NumberFormat.currency(
                        symbol: '\$',
                      ).format(widget.cabeceraCertificacion.valortotalt)
                    : '',
              ),
              CustomRow(
                nombredato: 'Porc. Acta: ',
                dato: NumberFormat.currency(
                  symbol: '%',
                ).format(widget.cabeceraCertificacion.porcActa),
              ),
              CustomRow(
                nombredato: 'Observ.: ',
                dato: widget.cabeceraCertificacion.observacion,
              ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Container(
              //         width: 100,
              //         margin: const EdgeInsets.symmetric(horizontal: 10),
              //         child: Row(
              //           children: [
              //             Column(
              //               mainAxisAlignment: MainAxisAlignment.start,
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Row(
              //                   children: const [
              //                     Text("Id Acta: ",
              //                         style: TextStyle(
              //                           fontSize: 12,
              //                           color: Color(0xFF781f1e),
              //                           fontWeight: FontWeight.bold,
              //                         )),
              //                   ],
              //                 ),
              //                 Row(
              //                   children: const [
              //                     Text("Fecha: ",
              //                         style: TextStyle(
              //                           fontSize: 12,
              //                           color: Color(0xFF781f1e),
              //                           fontWeight: FontWeight.bold,
              //                         )),
              //                   ],
              //                 ),
              //                 Row(
              //                   children: const [
              //                     Text("N° Obra: ",
              //                         style: TextStyle(
              //                           fontSize: 12,
              //                           color: Color(0xFF781f1e),
              //                           fontWeight: FontWeight.bold,
              //                         )),
              //                   ],
              //                 ),
              //                 Row(
              //                   children: const [
              //                     Text("Def Proy.: ",
              //                         style: TextStyle(
              //                           fontSize: 12,
              //                           color: Color(0xFF781f1e),
              //                           fontWeight: FontWeight.bold,
              //                         )),
              //                   ],
              //                 ),
              //                 Row(
              //                   children: const [
              //                     Text("Central: ",
              //                         style: TextStyle(
              //                           fontSize: 12,
              //                           color: Color(0xFF781f1e),
              //                           fontWeight: FontWeight.bold,
              //                         )),
              //                   ],
              //                 ),
              //                 Row(
              //                   children: const [
              //                     Text("SubC: ",
              //                         style: TextStyle(
              //                           fontSize: 12,
              //                           color: Color(0xFF781f1e),
              //                           fontWeight: FontWeight.bold,
              //                         )),
              //                   ],
              //                 ),
              //                 Row(
              //                   children: const [
              //                     Text("Fecha Corresp.: ",
              //                         style: TextStyle(
              //                           fontSize: 12,
              //                           color: Color(0xFF781f1e),
              //                           fontWeight: FontWeight.bold,
              //                         )),
              //                   ],
              //                 ),
              //                 Row(
              //                   children: const [
              //                     Text("Cod. Prod.: ",
              //                         style: TextStyle(
              //                           fontSize: 12,
              //                           color: Color(0xFF781f1e),
              //                           fontWeight: FontWeight.bold,
              //                         )),
              //                   ],
              //                 ),
              //                 Row(
              //                   children: const [
              //                     Text("Mes Imput.: ",
              //                         style: TextStyle(
              //                           fontSize: 12,
              //                           color: Color(0xFF781f1e),
              //                           fontWeight: FontWeight.bold,
              //                         )),
              //                   ],
              //                 ),
              //                 Row(
              //                   children: const [
              //                     Text("Objeto: ",
              //                         style: TextStyle(
              //                           fontSize: 12,
              //                           color: Color(0xFF781f1e),
              //                           fontWeight: FontWeight.bold,
              //                         )),
              //                   ],
              //                 ),
              //                 Row(
              //                   children: const [
              //                     Text("MontoC: ",
              //                         style: TextStyle(
              //                           fontSize: 12,
              //                           color: Color(0xFF781f1e),
              //                           fontWeight: FontWeight.bold,
              //                         )),
              //                   ],
              //                 ),
              //                 Row(
              //                   children: const [
              //                     Text("MontoT: ",
              //                         style: TextStyle(
              //                           fontSize: 12,
              //                           color: Color(0xFF781f1e),
              //                           fontWeight: FontWeight.bold,
              //                         )),
              //                   ],
              //                 ),
              //                 Row(
              //                   children: const [
              //                     Text("Porc. Acta: ",
              //                         style: TextStyle(
              //                           fontSize: 12,
              //                           color: Color(0xFF781f1e),
              //                           fontWeight: FontWeight.bold,
              //                         )),
              //                   ],
              //                 ),
              //                 Row(
              //                   children: const [
              //                     Text("Mes Prod.: ",
              //                         style: TextStyle(
              //                           fontSize: 12,
              //                           color: Color(0xFF781f1e),
              //                           fontWeight: FontWeight.bold,
              //                         )),
              //                   ],
              //                 ),
              //                 Row(
              //                   children: const [
              //                     Text("Observ.: ",
              //                         style: TextStyle(
              //                           fontSize: 12,
              //                           color: Color(0xFF781f1e),
              //                           fontWeight: FontWeight.bold,
              //                         )),
              //                   ],
              //                 ),
              //               ],
              //             ),
              //             Expanded(
              //               child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   children: <Widget>[
              //                     Row(
              //                       children: [
              //                         Text(
              //                             widget.cabeceraCertificacion.id
              //                                 .toString(),
              //                             style: const TextStyle(
              //                               fontSize: 12,
              //                             )),
              //                       ],
              //                     ),
              //                     Row(
              //                       children: [
              //                         Text(
              //                             DateFormat('dd/MM/yyyy').format(
              //                                 DateTime.parse(widget
              //                                     .cabeceraCertificacion
              //                                     .fechacarga!)),
              //                             style: const TextStyle(
              //                               fontSize: 12,
              //                             )),
              //                       ],
              //                     ),
              //                     Row(
              //                       children: [
              //                         Text(
              //                             widget.cabeceraCertificacion.nroobra
              //                                     .toString() +
              //                                 ' - ' +
              //                                 widget.cabeceraCertificacion
              //                                     .nombreObra
              //                                     .toString(),
              //                             style: const TextStyle(
              //                               fontSize: 12,
              //                             )),
              //                       ],
              //                     ),
              //                     Row(
              //                       children: [
              //                         Text(
              //                             widget.cabeceraCertificacion.defProy
              //                                 .toString(),
              //                             style: const TextStyle(
              //                               fontSize: 12,
              //                             )),
              //                       ],
              //                     ),
              //                     Row(
              //                       children: [
              //                         Text(
              //                             widget.cabeceraCertificacion.central
              //                                 .toString(),
              //                             style: const TextStyle(
              //                               fontSize: 12,
              //                             )),
              //                       ],
              //                     ),
              //                     Row(
              //                       children: [
              //                         Text(
              //                             widget.cabeceraCertificacion.subCodigo
              //                                     .toString() +
              //                                 " - " +
              //                                 widget.cabeceraCertificacion
              //                                     .codCausanteC
              //                                     .toString(),
              //                             style: const TextStyle(
              //                               fontSize: 12,
              //                             )),
              //                       ],
              //                     ),
              //                     Row(
              //                       children: [
              //                         Text(
              //                             DateFormat('dd/MM/yyyy').format(
              //                                 DateTime(1900, 1, 1).add(Duration(
              //                                     days: widget
              //                                             .cabeceraCertificacion
              //                                             .fechacorrespondencia! -
              //                                         36163))),
              //                             style: const TextStyle(
              //                               fontSize: 12,
              //                             ))
              //                       ],
              //                     ),
              //                     Row(
              //                       children: [
              //                         Text(
              //                             widget.cabeceraCertificacion
              //                                 .codigoproduccion
              //                                 .toString(),
              //                             style: const TextStyle(
              //                               fontSize: 12,
              //                             )),
              //                       ],
              //                     ),
              //                     Row(
              //                       children: [
              //                         Text(
              //                             widget.cabeceraCertificacion
              //                                 .mesImputacion
              //                                 .toString(),
              //                             style: const TextStyle(
              //                               fontSize: 12,
              //                             )),
              //                       ],
              //                     ),
              //                     Row(
              //                       children: [
              //                         Text(
              //                             widget.cabeceraCertificacion.objeto
              //                                 .toString(),
              //                             style: const TextStyle(
              //                               fontSize: 12,
              //                             )),
              //                       ],
              //                     ),
              //                     Row(
              //                       children: [
              //                         Text(
              //                             widget.cabeceraCertificacion
              //                                         .valortotalc !=
              //                                     null
              //                                 ? NumberFormat.currency(
              //                                         symbol: '\$')
              //                                     .format(widget
              //                                         .cabeceraCertificacion
              //                                         .valortotalc)
              //                                 : '',
              //                             style: const TextStyle(
              //                               fontSize: 12,
              //                             )),
              //                       ],
              //                     ),
              //                     Row(
              //                       children: [
              //                         Text(
              //                             widget.cabeceraCertificacion
              //                                         .valortotalt !=
              //                                     null
              //                                 ? NumberFormat.currency(
              //                                         symbol: '\$')
              //                                     .format(widget
              //                                         .cabeceraCertificacion
              //                                         .valortotalt)
              //                                 : '',
              //                             style: const TextStyle(
              //                               fontSize: 12,
              //                             )),
              //                       ],
              //                     ),
              //                     Row(
              //                       children: [
              //                         Text(
              //                             NumberFormat.currency(symbol: '\%')
              //                                 .format(widget
              //                                     .cabeceraCertificacion
              //                                     .porcActa),
              //                             style: const TextStyle(
              //                               fontSize: 12,
              //                             )),
              //                       ],
              //                     ),
              //                     Row(
              //                       children: [
              //                         Text(
              //                             widget.cabeceraCertificacion
              //                                 .mesImputacion
              //                                 .toString(),
              //                             style: const TextStyle(
              //                               fontSize: 12,
              //                             )),
              //                       ],
              //                     ),
              //                     Row(
              //                       children: [
              //                         Expanded(
              //                           child: Text(
              //                               widget.cabeceraCertificacion
              //                                   .observacion
              //                                   .toString(),
              //                               maxLines: 5,
              //                               style: const TextStyle(
              //                                 fontSize: 12,
              //                               )),
              //                         ),
              //                       ],
              //                     ),
              //                   ]),
              //             )
              //           ],
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 20),
              _showButton(),
            ],
          ),
        ),
      ),
    );
  }

  //-----------------------------------------------------------------
  //--------------------- _showButton -------------------------------
  //-----------------------------------------------------------------

  Widget _showButton() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF781f1e),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: _volver,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.arrow_back_ios),
                  SizedBox(width: 20),
                  Text('Volver'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //-------------------------------------------------------------
  //--------------------- _volver -------------------------------
  //-------------------------------------------------------------
  void _volver() {
    Navigator.pop(context, 'yes');
  }
}
