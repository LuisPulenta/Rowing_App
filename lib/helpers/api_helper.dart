import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:rowing_app/models/models.dart';
import 'constants.dart';

class ApiHelper {
//---------------------------------------------------------------------------
  static Future<Response> getObras(String proyectomodulo) async {
    var url =
        Uri.parse('${Constants.apiUrl}/api/Account/GetObras/$proyectomodulo');
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
  static Future<Response> getObrasTodas() async {
    var url = Uri.parse('${Constants.apiUrl}/api/Account/GetObrasTodas');
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
  static Future<Response> getObrasReclamos(String proyectomodulo) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/Account/GetObrasReclamos/$proyectomodulo');
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
  // static Future<Response> getObrasRowing() async {
  //   var url = Uri.parse('${Constants.apiUrl}/api/Account/GetObrasRowing');
  //   var response = await http.get(
  //     url,
  //     headers: {
  //       'content-type': 'application/json',
  //       'accept': 'application/json',
  //     },
  //   );
  //   var body = response.body;

  //   if (response.statusCode >= 400) {
  //     return Response(isSuccess: false, message: body);
  //   }

  //   List<Obra> list = [];
  //   var decodedJson = jsonDecode(body);
  //   if (decodedJson != null) {
  //     for (var item in decodedJson) {
  //       list.add(Obra.fromJson(item));
  //     }
  //   }
  //   return Response(isSuccess: true, result: list);
  // }

//---------------------------------------------------------------------------
  // static Future<Response> getObrasEnergia() async {
  //   var url = Uri.parse('${Constants.apiUrl}/api/Account/GetObrasEnergia');
  //   var response = await http.get(
  //     url,
  //     headers: {
  //       'content-type': 'application/json',
  //       'accept': 'application/json',
  //     },
  //   );
  //   var body = response.body;

  //   if (response.statusCode >= 400) {
  //     return Response(isSuccess: false, message: body);
  //   }

  //   List<Obra> list = [];
  //   var decodedJson = jsonDecode(body);
  //   if (decodedJson != null) {
  //     for (var item in decodedJson) {
  //       list.add(Obra.fromJson(item));
  //     }
  //   }
  //   return Response(isSuccess: true, result: list);
  // }

//---------------------------------------------------------------------------
  // static Future<Response> getObrasTasa() async {
  //   var url = Uri.parse('${Constants.apiUrl}/api/Account/GetObrasObrasTasa');
  //   var response = await http.get(
  //     url,
  //     headers: {
  //       'content-type': 'application/json',
  //       'accept': 'application/json',
  //     },
  //   );
  //   var body = response.body;

  //   if (response.statusCode >= 400) {
  //     return Response(isSuccess: false, message: body);
  //   }

  //   List<Obra> list = [];
  //   var decodedJson = jsonDecode(body);
  //   if (decodedJson != null) {
  //     for (var item in decodedJson) {
  //       list.add(Obra.fromJson(item));
  //     }
  //   }
  //   return Response(isSuccess: true, result: list);
  // }

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
  // static Future<Response> getObrasReclamosRowing() async {
  //   var url =
  //       Uri.parse('${Constants.apiUrl}/api/Account/GetObrasReclamosRowing');
  //   var response = await http.get(
  //     url,
  //     headers: {
  //       'content-type': 'application/json',
  //       'accept': 'application/json',
  //     },
  //   );
  //   var body = response.body;

  //   if (response.statusCode >= 400) {
  //     return Response(isSuccess: false, message: body);
  //   }

  //   List<Obra> list = [];
  //   var decodedJson = jsonDecode(body);
  //   if (decodedJson != null) {
  //     for (var item in decodedJson) {
  //       list.add(Obra.fromJson(item));
  //     }
  //   }
  //   return Response(isSuccess: true, result: list);
  // }

//---------------------------------------------------------------------------
  // static Future<Response> getObrasReclamosEnergia() async {
  //   var url =
  //       Uri.parse('${Constants.apiUrl}/api/Account/GetObrasReclamosEnergia');
  //   var response = await http.get(
  //     url,
  //     headers: {
  //       'content-type': 'application/json',
  //       'accept': 'application/json',
  //     },
  //   );
  //   var body = response.body;

  //   if (response.statusCode >= 400) {
  //     return Response(isSuccess: false, message: body);
  //   }

  //   List<Obra> list = [];
  //   var decodedJson = jsonDecode(body);
  //   if (decodedJson != null) {
  //     for (var item in decodedJson) {
  //       list.add(Obra.fromJson(item));
  //     }
  //   }
  //   return Response(isSuccess: true, result: list);
  // }

//---------------------------------------------------------------------------
  // static Future<Response> getObrasReclamosTasa() async {
  //   var url =
  //       Uri.parse('${Constants.apiUrl}/api/Account/GetObrasReclamosObrasTasa');
  //   var response = await http.get(
  //     url,
  //     headers: {
  //       'content-type': 'application/json',
  //       'accept': 'application/json',
  //     },
  //   );
  //   var body = response.body;

  //   if (response.statusCode >= 400) {
  //     return Response(isSuccess: false, message: body);
  //   }

  //   List<Obra> list = [];
  //   var decodedJson = jsonDecode(body);
  //   if (decodedJson != null) {
  //     for (var item in decodedJson) {
  //       list.add(Obra.fromJson(item));
  //     }
  //   }
  //   return Response(isSuccess: true, result: list);
  // }

//---------------------------------------------------------------------------
  static Future<Response> getCatalogos(String proyectomodulo) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/Catalogos/GetCatalogos/$proyectomodulo');
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
  static Future<Response> getCatalogosAysa() async {
    var url = Uri.parse('${Constants.apiUrl}/api/Catalogos/GetCatalogosAysa');
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
  // static Future<Response> getCatalogosRowing() async {
  //   var url = Uri.parse('${Constants.apiUrl}/api/Catalogos/GetCatalogosRowing');
  //   var response = await http.get(
  //     url,
  //     headers: {
  //       'content-type': 'application/json',
  //       'accept': 'application/json',
  //     },
  //   );
  //   var body = response.body;

  //   if (response.statusCode >= 400) {
  //     return Response(isSuccess: false, message: body);
  //   }

  //   List<Catalogo> list = [];
  //   var decodedJson = jsonDecode(body);
  //   if (decodedJson != null) {
  //     for (var item in decodedJson) {
  //       list.add(Catalogo.fromJson(item));
  //     }
  //   }
  //   return Response(isSuccess: true, result: list);
  // }

//---------------------------------------------------------------------------
  // static Future<Response> getCatalogosEnergia() async {
  //   var url =
  //       Uri.parse('${Constants.apiUrl}/api/Catalogos/GetCatalogosEnergia');
  //   var response = await http.get(
  //     url,
  //     headers: {
  //       'content-type': 'application/json',
  //       'accept': 'application/json',
  //     },
  //   );
  //   var body = response.body;

  //   if (response.statusCode >= 400) {
  //     return Response(isSuccess: false, message: body);
  //   }

  //   List<Catalogo> list = [];
  //   var decodedJson = jsonDecode(body);
  //   if (decodedJson != null) {
  //     for (var item in decodedJson) {
  //       list.add(Catalogo.fromJson(item));
  //     }
  //   }
  //   return Response(isSuccess: true, result: list);
  // }

//---------------------------------------------------------------------------
  // static Future<Response> getCatalogosObrasTasa() async {
  //   var url =
  //       Uri.parse('${Constants.apiUrl}/api/Catalogos/GetCatalogosObrasTasa');
  //   var response = await http.get(
  //     url,
  //     headers: {
  //       'content-type': 'application/json',
  //       'accept': 'application/json',
  //     },
  //   );
  //   var body = response.body;

  //   if (response.statusCode >= 400) {
  //     return Response(isSuccess: false, message: body);
  //   }

  //   List<Catalogo> list = [];
  //   var decodedJson = jsonDecode(body);
  //   if (decodedJson != null) {
  //     for (var item in decodedJson) {
  //       list.add(Catalogo.fromJson(item));
  //     }
  //   }
  //   return Response(isSuccess: true, result: list);
  // }

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
  static Future<Response> getNroRegistroMax2() async {
    var url =
        Uri.parse('${Constants.apiUrl}/api/ObrasReparos/GetNroRegistroMax');
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

  //---------------------------------------------------------------------------
  static Future<Response> getSubcontratistas(String proyectomodulo) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/Subcontratista/GetSubcontratistas/$proyectomodulo');
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

    List<Subcontratista> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Subcontratista.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getCausantesByGrupo(String grupo) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/Causantes/GetCausantesByGrupo/$grupo');
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

    List<Causante> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Causante.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

//---------------------------------------------------------------------------
  static Future<Response> getCatalogosEPP(String proyectomodulo) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/Catalogos/GetCatalogosEPP/$proyectomodulo');
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
  static Future<Response> getCatalogosAPP(String proyectomodulo) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/Catalogos/GetCatalogosAPP/$proyectomodulo');
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
  static Future<Response> getNroRemitoMax() async {
    var url = Uri.parse('${Constants.apiUrl}/api/WRemitosCab/GetNroRemitoMax');
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
  static Future<Response> getObrasEPP(String proyectomodulo) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/Account/GetObrasEPP/$proyectomodulo');
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
  static Future<Response> getObrasReparos(int nroobra) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/ObrasReparos/GetObrasReparos/$nroobra');
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

    List<ObrasReparo> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(ObrasReparo.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getObrasReparosTodas() async {
    var url =
        Uri.parse('${Constants.apiUrl}/api/ObrasReparos/GetObrasReparosTodas');
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

    List<ObrasReparo> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(ObrasReparo.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getStandardReparos() async {
    var url =
        Uri.parse('${Constants.apiUrl}/api/StandardReparos/GetStandardReparos');
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

    List<StandardReparo> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(StandardReparo.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getObrasReparo(String codigo) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/ObrasReparos/GetObrasReparosByCodigo/$codigo');
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

    List<ObrasReparo> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(ObrasReparo.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getCatalogosSuministros(String proyectomodulo) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/Catalogos/GetCatalogosSuministros/$proyectomodulo');
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
  static Future<Response> getClientes2() async {
    var url = Uri.parse('${Constants.apiUrl}/api/Clientes/GetClientes');
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
  static Future<Response> getVehiculosCheckLists(String idUser) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/VehiculosCheckLists/GetVehiculosCheckLists/$idUser');
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

    List<VehiculosCheckList> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(VehiculosCheckList.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getCheckListFotos(String id) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/VehiculosCheckListsFotos/GetVehiculosCheckListsFoto/$id');
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

    List<CheckListFoto> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(CheckListFoto.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> deleteVehiculosCheckListsFoto(String id) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/VehiculosCheckListsFotos/DeleteVehiculosCheckListsFoto/$id');
    var response = await http.delete(
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

    return Response(isSuccess: true);
  }

  //---------------------------------------------------------------------------
  static Future<Response> deleteVehiculosCheckListsFotos(String id) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/VehiculosCheckListsFotos/DeleteVehiculosCheckListsFotos/$id');
    var response = await http.delete(
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

    return Response(isSuccess: true);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getJuicios() async {
    var url = Uri.parse('${Constants.apiUrl}/api/CausantesJuicios/GetJuicios');
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

    List<Juicio> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Juicio.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getMediaciones(String id) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/CausantesJuicios/GetMediaciones/$id');
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

    List<Mediacion> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Mediacion.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getNotificaciones(String id) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/CausantesJuicios/GetNotificaciones/$id');
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

    List<Notificacion> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Notificacion.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getContrapartes(int id) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/CausantesJuicios/GetContraparte/$id');
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

    List<Contraparte> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Contraparte.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getConteos(int id) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/ConteoCiclicoCab/GetConteoCiclicoCab/$id');
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

    List<Conteo> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Conteo.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getConteoDetalles(int id) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/ConteoCiclicoCab/GetConteoCiclicoDet/$id');
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

    List<ConteoDet> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(ConteoDet.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getEmpleados(int id) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/Causantes/GetCausantesBySupervisor/$id');
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

    List<Causante> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Causante.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getTurnosNoche(int id) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/Causantes/GetPresentismosTurnoNoche/$id');
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

    List<CausantesPresentismoTurnoNoche> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(CausantesPresentismoTurnoNoche.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getCausantesEstados() async {
    var url =
        Uri.parse('${Constants.apiUrl}/api/Causantes/GetCausantesEstados');
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

    List<CausantesEstado> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(CausantesEstado.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getCausantesZonas() async {
    var url = Uri.parse('${Constants.apiUrl}/api/Causantes/GetCausantesZonas');
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

    List<CausantesZona> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(CausantesZona.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getCausantesActividades() async {
    var url =
        Uri.parse('${Constants.apiUrl}/api/Causantes/GetCausantesActividades');
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

    List<CausantesActividad> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(CausantesActividad.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getPresentismosHoy(
      int id, int year, int month, int day) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/Causantes/GetPresentismosBySupervisorDay/$id/$year/$month/$day');
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

    List<CausantesPresentismo> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(CausantesPresentismo.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getNroRegistroMaxNotificaciones() async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/CausantesJuicios/GetNroRegistroMaxNotificaciones');
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
  static Future<Response> getNroRegistroMaxMediaciones() async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/CausantesJuicios/GetNroRegistroMaxMediaciones');
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
  static Future<Response> getCausantesTalleres() async {
    var url = Uri.parse('${Constants.apiUrl}/api/Causantes/GetTalleres');
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

    List<Causante> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Causante.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getTurnos(String id) async {
    var url = Uri.parse('${Constants.apiUrl}/api/Vehiculos/GetTurnos/$id');
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

    List<Turno> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Turno.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getUsuariosGeo(int year, int month, int day) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/UsuariosGeos/GetUsuarios/$year/$month/$day');
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

    List<UsuarioGeo> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(UsuarioGeo.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> getPuntos(
      int usuarioId, int year, int month, int day) async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/UsuariosGeos/getPuntos/$usuarioId/$year/$month/$day');
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

    List<Punto> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Punto.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //---------------------------------------------------------------------------
  static Future<Response> sendAudioFile(File file, String fileName) async {
    final url =
        Uri.parse('${Constants.apiUrl}/api/ObrasDocuments/UploadAudioFile');
    List<int> fileBytes = await file.readAsBytes();
    var request = http.MultipartRequest('POST', url);
    request.files.add(
        http.MultipartFile.fromBytes('file', fileBytes, filename: fileName));
    var response = await request.send();

    if (response.statusCode == 200) {
      return Response(isSuccess: true);
    } else {
      return Response(isSuccess: false);
    }
  }

  //---------------------------------------------------------------------------
  static Future<Response> sendVideoFile(File file, String fileName) async {
    final url =
        Uri.parse('${Constants.apiUrl}/api/ObrasDocuments/UploadVideoFile');
    List<int> fileBytes = await file.readAsBytes();
    var request = http.MultipartRequest('POST', url);
    request.files.add(
        http.MultipartFile.fromBytes('file', fileBytes, filename: fileName));
    var response = await request.send();

    if (response.statusCode == 200) {
      return Response(isSuccess: true);
    } else {
      return Response(isSuccess: false);
    }
  }

//---------------------------------------------------------------------------
  static Future<Response> getNroRegistrwerwewoMaxNotificaciones() async {
    var url = Uri.parse(
        '${Constants.apiUrl}/api/CausantesJuicios/GetNroRegistroMaxNotificaciones');
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
}
