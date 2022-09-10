import 'package:sqflite/sqflite.dart';

import '../Model/local_database.dart';
import 'package:path/path.dart';

class LocalProductDetailsDataBase {
  static final LocalProductDetailsDataBase instance =
      LocalProductDetailsDataBase._init();

  static Database _database;

  LocalProductDetailsDataBase._init();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB('productid.db');

    return _database;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final integerType = 'INTEGER NOT NULL';
    final textType = 'TEXT NOT NULL';
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';

    await db.execute('''
CREATE TABLE $tableNotes ( 
  ${LocalFieldStore.id} $idType, 
  ${LocalFieldStore.productId} $textType,
  ${LocalFieldStore.time} $textType
  
  )
''');
  }

  Future<LocalStoreProductId> create(LocalStoreProductId note) async {
    final db = await instance.database;
    final id = await db.insert(tableNotes, note.toJson());
    print("id : $id");
    return note.copy(id: id);
  }

  Future<LocalStoreProductId> readNote(int id) async {
    final db = await instance.database;
    final maps = await db.query(tableNotes,
        columns: LocalFieldStore.values,
        where: '${LocalFieldStore.id} = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return LocalStoreProductId.fromJson(maps.first);
    } else {
      throw Exception('Id $id is Not Found');
    }
  }

  Future<List<LocalStoreProductId>> readAllNotes() async {
    final db = await instance.database;
    final orderBy = '${LocalFieldStore.time} ASC';
    final result = await db.query(tableNotes, orderBy: orderBy);
    return result.map((json) => LocalStoreProductId.fromJson(json)).toList();
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(tableNotes,
        where: '${LocalFieldStore.id} = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    _database = null;
    db.close();
  }
}
