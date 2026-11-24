import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:qr_scan/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider{
  
  static Database? _database;

  static DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database == null) return _database = await initDB();

    return _database!;
  }

  Future<Database> initDB()async {
    
    // Obtenir es Path
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'Scans.db');
    print(path);

    // Creacio de la BBDD
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db){},
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE Scans(
            id INTEGER PRIMARY KEY,
            tipus TEXT,
            valor TEXT
          )''');
      }
    );
    
  }

  Future<int> inserRawScan(ScanModel nouScan) async {
      final id = nouScan.id;
      final tipus = nouScan.tipus;
      final valor = nouScan.valor;

      final db = await database;
      final res = await db.rawInsert('''
        INSERT INTO Scans(id, tipus, valor)
        VALUES($id, '$tipus', '$valor')
      ''');
      return res;
    }

  Future<int> insertScan(ScanModel nouScan) async {
      final db = await database;
      final res = await db.insert('Scans', nouScan.toMap());
      print(res);
      return res;
    }

  
}