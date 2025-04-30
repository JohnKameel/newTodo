import 'package:sqflite/sqflite.dart';

class SqfLiteHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      print('Db is already open');
      return _database!;
    }
    _database = await startDb();
    print('db is open');
    return _database!;
  }

  Future<Database> startDb() async {
    final dbPath = await getDatabasesPath();
    final currentPath = '$dbPath/mynotes.db';

    return await openDatabase(currentPath, version: 1,
        onCreate: (db, version) async {
      return await db.execute('''
          CREATE TABLE notes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          dec TEXT
          )
          ''');
    });
  }

  Future<void> insertNote(String title, String dec) async {
    Database db = await database;
    await db.insert("notes", {'title': title, 'dec': dec});
  }

  Future<void> updateNote(int id, String title, String dec) async {
    final db = await database;
    await db.update(
      "notes",
      {'title': title, 'dec': dec},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteNote(int id) async {
    Database db = await database;
    await db.delete("notes", where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    Database db = await database;
    return await db.query("notes");
  }
}
