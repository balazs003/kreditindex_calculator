import 'package:kreditindex_calculator/subject.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'subjects.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE subjects(name TEXT PRIMARY KEY, weight INTEGER, grade INTEGER, sure INTEGER, seqnum INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertSubject(Subject subject) async {
    final db = await database;
    await db.insert(
      'subjects',
      subject.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateSubject(Subject subject) async {
    final db = await database;
    await db.update(
      'subjects',
      subject.toMap(),
      where: 'name = ?',
      whereArgs: [subject.name],
    );
  }

  Future<void> deleteSubject(String name) async {
    final db = await database;
    await db.delete(
      'subjects',
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  Future<List<Subject>> getSubjects() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('subjects', orderBy: 'seqnum');

    return List.generate(maps.length, (i) {
      return Subject(
        newName: maps[i]['name'],
        newWeight: maps[i]['weight'],
        newGrade: maps[i]['grade'],
        newSure: maps[i]['sure'] == 1,
        newSeqnum: maps[i]['seqnum'],
      );
    });
  }
}