import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/obras_nuevo_suministro.dart';

class DBSuministros {
  static Future<Database> _openDBSuministros() async {
    return openDatabase(join(await getDatabasesPath(), 'Suministros.db'),
        onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE Suministros(nrosuministro INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE , nroobra INTEGER, fecha TEXT, apellidonombre TEXT, dni TEXT,       telefono TEXT, email INTEGER, cuadrilla TEXT, grupoc TEXT, causantec TEXT, directa TEXT, domicilio TEXT,         barrio TEXT, localidad TEXT, partido TEXT, antesfotO1 TEXT, antesfotO2 TEXT, despuesfotO1 TEXT, despuesfotO2 TEXT,    fotodnifrente TEXT, fotodnireverso TEXT, firmacliente TEXT, entrecalleS1 TEXT, entrecalleS2 TEXT,  medidorcolocado TEXT,         medidorvecino TEXT, tipored TEXT, corte TEXT, denuncia TEXT, enre TEXT, otro TEXT, conexiondirecta TEXT,           retiroconexion TEXT, retirocrucecalle TEXT, mtscableretirado INTEGER, trabajoconhidro TEXT, postepodrido TEXT, observaciones TEXT,           potenciacontratada INTEGER, tensioncontratada INTEGER, kitnro INTEGER, idcertifmateriales INTEGER,           idcertifbaremo INTEGER,enviado INTEGER, materiales INTEGER)',
      );
    }, version: 2);
  }

  static Future<int> insertSuministro(ObrasNuevoSuministro suministro) async {
    Database database = await _openDBSuministros();
    return database.insert('Suministros', suministro.toMap());
  }

  static Future<int> delete(ObrasNuevoSuministro suministro) async {
    Database database = await _openDBSuministros();
    return database.delete('Suministros',
        where: 'nrosuministro = ?', whereArgs: [suministro.nrosuministro]);
  }

  static Future<int> update(ObrasNuevoSuministro suministro) async {
    Database database = await _openDBSuministros();
    return database.update('Suministros', suministro.toMap(),
        where: 'nrosuministro = ?', whereArgs: [suministro.nrosuministro]);
  }

  static Future<int> deleteall() async {
    Database database = await _openDBSuministros();
    return database.delete('Suministros');
  }

  static Future<List<ObrasNuevoSuministro>> suministros() async {
    Database database = await _openDBSuministros();
    final List<Map<String, dynamic>> suministrosMap =
        await database.query('Suministros');
    return List.generate(
        suministrosMap.length,
        (i) => ObrasNuevoSuministro(
              nrosuministro: suministrosMap[i]['nrosuministro'],
              nroobra: suministrosMap[i]['nroobra'],
              fecha: suministrosMap[i]['fecha'],
              apellidonombre: suministrosMap[i]['apellidonombre'],
              dni: suministrosMap[i]['dni'],
              telefono: suministrosMap[i]['telefono'],
              email: suministrosMap[i]['email'],
              cuadrilla: suministrosMap[i]['cuadrilla'],
              grupoc: suministrosMap[i]['grupoc'],
              causantec: suministrosMap[i]['causantec'],
              directa: suministrosMap[i]['directa'],
              domicilio: suministrosMap[i]['domicilio'],
              barrio: suministrosMap[i]['barrio'],
              localidad: suministrosMap[i]['localidad'],
              partido: suministrosMap[i]['partido'],
              antesfotO1: suministrosMap[i]['antesfotO1'],
              antesfotO2: suministrosMap[i]['antesfotO2'],
              despuesfotO1: suministrosMap[i]['despuesfotO1'],
              despuesfotO2: suministrosMap[i]['despuesfotO2'],
              fotodnifrente: suministrosMap[i]['fotodnifrente'],
              fotodnireverso: suministrosMap[i]['fotodnireverso'],
              firmacliente: suministrosMap[i]['firmacliente'],
              entrecalleS1: suministrosMap[i]['entrecalleS1'],
              entrecalleS2: suministrosMap[i]['entrecalleS2'],
              medidorcolocado: suministrosMap[i]['medidorcolocado'],
              medidorvecino: suministrosMap[i]['medidorvecino'],
              tipored: suministrosMap[i]['tipored'],
              corte: suministrosMap[i]['corte'],
              denuncia: suministrosMap[i]['denuncia'],
              enre: suministrosMap[i]['enre'],
              otro: suministrosMap[i]['otro'],
              conexiondirecta: suministrosMap[i]['conexiondirecta'],
              retiroconexion: suministrosMap[i]['retiroconexion'],
              retirocrucecalle: suministrosMap[i]['retirocrucecalle'],
              mtscableretirado: suministrosMap[i]['mtscableretirado'],
              trabajoconhidro: suministrosMap[i]['trabajoconhidro'],
              postepodrido: suministrosMap[i]['postepodrido'],
              observaciones: suministrosMap[i]['observaciones'],
              potenciacontratada: suministrosMap[i]['potenciacontratada'],
              tensioncontratada: suministrosMap[i]['tensioncontratada'],
              kitnro: suministrosMap[i]['kitnro'],
              idcertifmateriales: suministrosMap[i]['idcertifmateriales'],
              idcertifbaremo: suministrosMap[i]['idcertifbaremo'],
              enviado: suministrosMap[i]['enviado'],
              materiales: suministrosMap[i]['materiales'],
            ));
  }
}
