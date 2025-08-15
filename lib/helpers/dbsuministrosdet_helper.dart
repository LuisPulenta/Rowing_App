import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/models.dart';

class DBSuministrosdet {
  static Future<Database> _openDBSuministrosdet() async {
    return openDatabase(join(await getDatabasesPath(), 'Suministrosdet.db'),
        onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE Suministrosdet(nroregistrod INTEGER , nrosuministrocab INTEGER, catcodigo TEXT, codigosap TEXT, cantidad DOUBLE)',
      );
    }, version: 1);
  }

  static Future<int> insertSuministrodet(
      ObraNuevoSuministroDet suministrodet) async {
    Database database = await _openDBSuministrosdet();
    return database.insert('Suministrosdet', suministrodet.toMap());
  }

  static Future<int> delete(ObraNuevoSuministroDet suministrodet) async {
    Database database = await _openDBSuministrosdet();
    return database.delete('Suministrosdet',
        where: 'nrosuministrocab = ?',
        whereArgs: [suministrodet.nrosuministrocab]);
  }

  static Future<int> update(ObraNuevoSuministroDet suministrodet) async {
    Database database = await _openDBSuministrosdet();
    return database.update('Suministrosdet', suministrodet.toMap(),
        where: 'nrosuministrocab = ?',
        whereArgs: [suministrodet.nrosuministrocab]);
  }

  static Future<int> deleteall() async {
    Database database = await _openDBSuministrosdet();
    return database.delete('Suministrosdet');
  }

  static Future<List<ObraNuevoSuministroDet>> suministrosdet() async {
    Database database = await _openDBSuministrosdet();
    final List<Map<String, dynamic>> suministrosdetMap =
        await database.query('Suministrosdet');
    return List.generate(
        suministrosdetMap.length,
        (i) => ObraNuevoSuministroDet(
              nroregistrod: suministrosdetMap[i]['nroregistrod'],
              nrosuministrocab: suministrosdetMap[i]['nrosuministrocab'],
              catcodigo: suministrosdetMap[i]['catcodigo'],
              codigosap: suministrosdetMap[i]['codigosap'],
              cantidad: suministrosdetMap[i]['cantidad'],
            ));
  }
}
