import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test1/models/note.dart';
import 'package:test1/models/note_dields.dart';

class Hide {
  static final Hide instance = Hide._init();

  static Database? _database;

  Hide._init();
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('hide.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';

    await db.execute('''
    CREATE TABLE ${NoteFields.tableName} (
      ${NoteFields.id} $idType,
      ${NoteFields.title} $textType,
      ${NoteFields.content} $textType,
      ${NoteFields.isFavorite} $boolType,
      ${NoteFields.createdTime} $textType,
      ${NoteFields.archived} $boolType,
      ${NoteFields.deleted} $boolType
    )
    ''');

    await db.execute(
        'CREATE INDEX idx_title_content ON ${NoteFields.tableName}(${NoteFields.title}, ${NoteFields.content})');
  }

  Future<NoteModel> create(NoteModel note) async {
    final db = await instance.database;

    final id = await db.insert(NoteFields.tableName, note.toJson());
    return note.CopyWith(id: id);
  }

  Future<List<NoteModel>> readAllNotes() async {
    final db = await instance.database;

    final result = await db.query(
      NoteFields.tableName,
      where: '${NoteFields.archived} = ? AND ${NoteFields.deleted} = ?',
      whereArgs: [0, 0],
      orderBy: '${NoteFields.createdTime} DESC',
    );

    return result.map((json) => NoteModel.fromJson(json)).toList();
  }
 Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      NoteFields.tableName,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }
  Future<void> close() async {
    final db = await instance.database;
    await db.close();
    _database = null;
  }
}
