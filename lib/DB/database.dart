import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test1/models/note.dart';

import '../models/note_dields.dart';


class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();

  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // الحصول على مسار قاعدة البيانات
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // فتح قاعدة البيانات أو إنشائها
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

    await db.execute('CREATE INDEX idx_title_content ON ${NoteFields.tableName}(${NoteFields.title}, ${NoteFields.content})');
  }

  Future<NoteModel> create(NoteModel note) async {
    final db = await instance.database;

    final id = await db.insert(NoteFields.tableName, note.toJson());
    return note.copy(id: id);
  }

  Future<List<NoteModel>> searchDatabase(String searchTerm) async {
    final db = await instance.database;
    final searchPattern = '%$searchTerm%';
    final results = await db.query(
      NoteFields.tableName,
      where: '${NoteFields.title} LIKE ? OR ${NoteFields.content} LIKE ?',
      whereArgs: [searchPattern, searchPattern],
    );

    return results.map((json) => NoteModel.fromJson(json)).toList();
  }

  Future<List<NoteModel>> getAllFavoriteNotes() async {
    final db = await instance.database;

    final result = await db.query(
      NoteFields.tableName,
      where: '${NoteFields.isFavorite} = ?',
      whereArgs: [1],
    );
    return result.map((json) => NoteModel.fromJson(json)).toList();
  }

  Future<NoteModel> readNote(int id) async {
    final db = await instance.database;

    // استخدام try-catch للتعامل مع الأخطاء المحتملة
    try {
      final maps = await db.query(
        NoteFields.tableName,
        columns: NoteFields.values,
        where: '${NoteFields.id} = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return NoteModel.fromJson(maps.first);
      } else {
        throw Exception('Note ID $id not found');
      }
    } catch (e) {
      throw Exception('Error reading note: $e');
    }
  }

  Future<List<NoteModel>> readAllNotes() async {
    final db = await instance.database;

    // قراءة جميع الملاحظات مع الترتيب حسب الوقت المضاف حديثاً
    final result = await db.query(NoteFields.tableName, orderBy: '${NoteFields.createdTime} DESC');

    return result.map((json) => NoteModel.fromJson(json)).toList();
  }

  Future<int> update(NoteModel note) async {
    final db = await instance.database;

    return db.update(
      NoteFields.tableName,
      note.toJson(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      NoteFields.tableName,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllNotes() async {
    final db = await instance.database;

    // بدلاً من إسقاط الجدول، حذف جميع السجلات لتحسين الأداء
    await db.delete(NoteFields.tableName);
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
    _database = null; // تأكيد عدم استخدام قاعدة بيانات مغلقة
  }
}
