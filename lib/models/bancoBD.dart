import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:save_json/models/item.dart';
import 'package:sqflite/sqflite.dart';

class Banco {
  static final _databaseName = "bancoBD.db";
  static final _databaseVersion = 1;

  Banco._privateConstructor();
  static final Banco instance = Banco._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE item(
          id INTEGER PRIMARY KEY,
          title TEXT NOT NULL
          )
          ''');
  }

  Future<int> insertItem(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('item', row);
  }

  Future<void> deleteTable() async {
    Database db = await instance.database;
    return await db.execute('''DELETE FROM item''');
  }

  Future<void> deleteItem(String id) async {
    Database db = await instance.database;
    return await db.execute('''DELETE FROM item WHERE id = $id''');
  }

  Future<List<Map<String, dynamic>>> listaItems() async {
    Database db = await instance.database;
    return await db.query('item');
  }

  Future<Item> getItem(int id) async {
    Database db = await instance.database;
    var res = await db.rawQuery('SELECT FROM item WHERE id = $id');
    return Item.fromJson(res.first);
  }

  Future<List> getall() async {
    Database db = await instance.database;
    var res = await db.query('item');
    List<Item> list =
        res.isNotEmpty ? res.map((c) => Item.fromJson(c)).toList() : [];
    return list;
  }

  Future<int> updateItem(Item i) async {
    Database db = await instance.database;
    return await db.rawUpdate('''UPDATE item SET 
          title = \'${i.title}\',
           WHERE id = ${i.id}''');
  }

  void close() async {
    Database db = await instance.database;
    return await db.close();
  }
}
