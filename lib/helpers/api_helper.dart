import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rowing_app/models/models.dart';
import 'package:rowing_app/models/tipo_novedad.dart';
import 'package:rowing_app/models/vehiculos_siniestros_foto.dart';
import 'package:rowing_app/models/vista_inspecciones%20_foto.dart';
import 'constants.dart';

class ApiHelper {
//---------------------------------------------------------------------------
  static Future<Response> getObrasRowing() async {
    var url = Uri.parse('${Constants.apiUrl}/api/Account/GetObrasRowing');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Obra> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Obra.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getObrasEnergia() async {
    var url = Uri.parse('${Constants.apiUrl}/api/Account/GetObrasEnergia');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Obra> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Obra.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getObrasTasa() async {
    var url = Uri.parse('${Constants.apiUrl}/api/Account/GetObrasObrasTasa');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Obra> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Obra.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> put(
      String controller, String id, Map<String, dynamic> request) async {
    var url = Uri.parse('${Constants.apiUrl}$controller$id');
    var response = await http.put(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(request),
    );

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true);
  }

//---------------------------------------------------------------------------
  static Future<Response> post(
      String controller, Map<String, dynamic> request) async {
    var url = Uri.parse('${Constants.apiUrl}$controller');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(request),
    );

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true, result: response.body);
  }

//---------------------------------------------------------------------------
  static Future<Response> delete(String controller, String id) async {
    var url = Uri.parse('${Constants.apiUrl}$controller$id');
    var response = await http.delete(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true);
  }

//---------------------------------------------------------------------------
  static Future<Response> getCausante(String codigo) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/Causantes/GetCausanteByCodigo2/$codigo');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);
    return Response(isSuccess: true, result: Causante.fromJson(decodedJson));
  }

//---------------------------------------------------------------------------
  static Future<Response> getEntregas(String codigo) async {
    var url =
        Uri.parse('${Constants.apiUrl}/api/Entregas/GetEntregas2/$codigo');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Entrega> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Entrega.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getTicket(String codigo) async {
    var url =
        Uri.parse('${Constants.apiUrl}/api/ObrasPostes/GetTicket2/$codigo');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);
    return Response(isSuccess: true, result: Ticket.fromJson(decodedJson));
  }

//---------------------------------------------------------------------------
  static Future<Response> getObrasDocumentos(String codigo) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/ObrasDocuments/GetObrasDocumentos/$codigo');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<ObrasDocumento> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(ObrasDocumento.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getReclamos(String codigo) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/ObrasPostes/GetReclamosByUser/$codigo');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Reclamo> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Reclamo.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getObrasReclamosRowing() async {
    var url =
        Uri.parse('${Constants.apiUrl}/api/Account/GetObrasReclamosRowing');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Obra> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Obra.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getObrasReclamosEnergia() async {
    var url =
        Uri.parse('${Constants.apiUrl}/api/Account/GetObrasReclamosEnergia');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Obra> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Obra.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getObrasReclamosTasa() async {
    var url =
        Uri.parse('${Constants.apiUrl}/api/Account/GetObrasReclamosObrasTasa');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Obra> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Obra.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getCatalogosRowing() async {
    var url = Uri.parse('${Constants.apiUrl}/api/Catalogos/GetCatalogosRowing');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Catalogo> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Catalogo.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getCatalogosEnergia() async {
    var url =
        Uri.parse('${Constants.apiUrl}/api/Catalogos/GetCatalogosEnergia');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Catalogo> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Catalogo.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getCatalogosObrasTasa() async {
    var url =
        Uri.parse('${Constants.apiUrl}/api/Catalogos/GetCatalogosObrasTasa');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Catalogo> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Catalogo.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getObra(String id) async {
    var url = Uri.parse('${Constants.apiUrl}/api/Account/GetObra/$id');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);
    return Response(isSuccess: true, result: Obra.fromJson(decodedJson));
  }

//---------------------------------------------------------------------------
  static Future<Response> getVehiculoByChapa(String chapa) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/Vehiculos/GetVehiculoByChapa/$chapa');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);
    return Response(isSuccess: true, result: Vehiculo.fromJson(decodedJson));
  }

//---------------------------------------------------------------------------
  static Future<Response> getKilometrajes(String codigo) async {
    var url =
        Uri.parse('${Constants.apiUrl}/api/Vehiculos/GetKilometrajes/$codigo');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<VehiculosKilometraje> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(VehiculosKilometraje.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> postNoToken(
      String controller, Map<String, dynamic> request) async {
    var url = Uri.parse('${Constants.apiUrl}$controller');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(request),
    );

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true);
  }

//---------------------------------------------------------------------------
  static Future<Response> getNroRegistroMax() async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/VehiculosKilometraje/GetNroRegistroMax');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);

    return Response(isSuccess: true, result: decodedJson);
  }

//---------------------------------------------------------------------------
  static Future<Response> getProgramasPrev(String codigo) async {
    var url =
        Uri.parse('${Constants.apiUrl}/api/Vehiculos/GetProgramasPrev/$codigo');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<VehiculosProgramaPrev> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(VehiculosProgramaPrev.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getTipoNovedades() async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/CausantesNovedades/GetTipoNovedades');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<TipoNovedad> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(TipoNovedad.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getNovedades(String grupo, String causante) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/CausantesNovedades/GetNovedades/$grupo/$causante');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Novedad> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Novedad.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getClientes() async {
    var url = Uri.parse('${Constants.apiUrl}/api/Inspecciones/GetClientes');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Cliente> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Cliente.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getTiposTrabajos(int idcliente) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/Inspecciones/GetTiposTrabajos/$idcliente');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<TiposTrabajo> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(TiposTrabajo.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getGruposFormularios(
      int idcliente, int idtipotrabajo) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/Inspecciones/GetGruposFormularios/$idcliente/$idtipotrabajo');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<GruposFormulario> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(GruposFormulario.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getDetallesFormularios(int idcliente) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/Inspecciones/GetDetallesFormularios/$idcliente');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<DetallesFormulario> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(DetallesFormulario.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getInspecciones(String codigo) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/Inspecciones/GetInspecciones/$codigo');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<VistaInspeccion> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(VistaInspeccion.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getInspeccion(int codigo) async {
    var url =
        Uri.parse('${Constants.apiUrl}/api/Inspecciones/GetInspeccion/$codigo');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);
    return Response(isSuccess: true, result: Inspeccion.fromJson(decodedJson));
  }

//---------------------------------------------------------------------------
  static Future<Response> getDetallesInspecciones(int codigo) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/Inspecciones/GetDetallesInspecciones/$codigo');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<InspeccionDetalle> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(InspeccionDetalle.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getObraInspeccion(int codigo) async {
    var url = Uri.parse('${Constants.apiUrl}/api/Inspecciones/GetObra/$codigo');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);
    return Response(isSuccess: true, result: Obra.fromJson(decodedJson));
  }

  //---------------------------------------------------------------------------
  static Future<Response> postInspeccionDetalle(
      String controller, Map<String, dynamic> request) async {
    var url = Uri.parse('${Constants.apiUrl}$controller');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(request),
    );

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true, result: response.body);
  }

  //---------------------------------------------------------------------------
  static Future<Response> postInspeccionDetalleConFotoExistente(
      String controller, Map<String, dynamic> request) async {
    var url = Uri.parse('${Constants.apiUrl}$controller');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(request),
    );

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true, result: response.body);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getUsuarioChapa(String codigo) async {
    var url =
        Uri.parse('${Constants.apiUrl}/api/Vehiculos/GetUsuarioChapa/$codigo');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);
    return Response(isSuccess: true, result: VFlota.fromJson(decodedJson));
  }

  //---------------------------------------------------------------------------

  static Future<Response> putWebSesion(int nroConexion) async {
    var url = Uri.parse('${Constants.apiUrl}/api/WebSesions/$nroConexion');
    var response = await http.put(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);
    return Response(isSuccess: true, result: decodedJson);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getPreventivos(String codigo) async {
    var url =
        Uri.parse('${Constants.apiUrl}/api/Vehiculos/GetPreventivos/$codigo');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Preventivo> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Preventivo.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getSiniestros(String grupo, String causante) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/VehiculosSiniestros/GetSiniestros/$grupo/$causante');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<VehiculosSiniestro> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(VehiculosSiniestro.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getFotosSiniestro(String codigo) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/VehiculosSiniestrosFotos/GetVehiculosSiniestrosFotos/$codigo');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<VehiculosSiniestrosFoto> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(VehiculosSiniestrosFoto.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getFotosInspecciones(String codigo) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/Inspecciones/GetVistaInspeccionesFotos/$codigo');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<VistaInspeccionesFoto> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(VistaInspeccionesFoto.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }
}
