import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/models.dart';

class DBSuministroscatalogos {
  static Future<Database> _openDBSuministroscatalogos() async {
    return openDatabase(
        join(await getDatabasesPath(), 'Suministroscatalogos.db'),
        onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE Suministroscatalogos(catcodigo TEXT, codigosap TEXT, catCatalogo TEXT,verEnReclamosApp INTEGER, verRequerimientosAPP INTEGER, verRequerimientosEPP INTEGER, verEnSuministros INTEGER, verEnCalle INTEGER, modulo TEXT, cantidad DOUBLE, cantidad2 DOUBLE)',
      );
    }, version: 2);
  }

  static Future<int> insertSuministrocatalogos(Catalogo catalogo) async {
    Database database = await _openDBSuministroscatalogos();
    return database.insert('Suministroscatalogos', catalogo.toMap());
  }

  static Future<int> deleteall() async {
    Database database = await _openDBSuministroscatalogos();
    return database.delete('Suministroscatalogos');
  }

  static Future<List<Catalogo>> catalogos() async {
    Database database = await _openDBSuministroscatalogos();
    final List<Map<String, dynamic>> suministroscatalogosMap =
        await database.query('Suministroscatalogos');
    return List.generate(
        suministroscatalogosMap.length,
        (i) => Catalogo(
              catCodigo: suministroscatalogosMap[i]['catcodigo'],
              codigoSap: suministroscatalogosMap[i]['codigosap'],
              catCatalogo: suministroscatalogosMap[i]['catCatalogo'],
              verEnReclamosApp: suministroscatalogosMap[i]['verEnReclamosApp'],
              verRequerimientosAPP: suministroscatalogosMap[i]
                  ['verRequerimientosAPP'],
              verRequerimientosEPP: suministroscatalogosMap[i]
                  ['verRequerimientosEPP'],
              verEnSuministros: suministroscatalogosMap[i]['verEnSuministros'],
              verEnCalle: suministroscatalogosMap[i]['verEnCalle'],
              modulo: suministroscatalogosMap[i]['modulo'],
              cantidad: suministroscatalogosMap[i]['cantidad'],
              cantidad2: suministroscatalogosMap[i]['cantidad2'],
            ));
  }
}
