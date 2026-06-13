import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BazaDanych {
  static final BazaDanych _instance = BazaDanych._internal();
  factory BazaDanych() => _instance;
  BazaDanych._internal();

  Database? _db;

  Future<void> init() async {
    if (_db != null) return;
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'ulubione.db');
    _db = await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('CREATE TABLE postacie(name TEXT PRIMARY KEY, json TEXT)');
      await db.execute('CREATE TABLE zaklecia(name TEXT PRIMARY KEY, json TEXT)');
    });
  }

  Future<void> insertPostac(Map postac) async {
    await init();
    await _db!.insert('postacie', {'name': postac['name'], 'json': jsonEncode(postac)}, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removePostac(String name) async {
    await init();
    await _db!.delete('postacie', where: 'name = ?', whereArgs: [name]);
  }

  Future<List<Map<String, dynamic>>> getAllPostacie() async {
    await init();
    final rows = await _db!.query('postacie');
    return rows.map((r) => jsonDecode(r['json'] as String) as Map<String, dynamic>).toList();
  }

  Future<void> insertZaklecie(Map zak) async {
    await init();
    await _db!.insert('zaklecia', {'name': zak['name'], 'json': jsonEncode(zak)}, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeZaklecie(String name) async {
    await init();
    await _db!.delete('zaklecia', where: 'name = ?', whereArgs: [name]);
  }

  Future<List<Map<String, dynamic>>> getAllZaklecia() async {
    await init();
    final rows = await _db!.query('zaklecia');
    return rows.map((r) => jsonDecode(r['json'] as String) as Map<String, dynamic>).toList();
  }
}
