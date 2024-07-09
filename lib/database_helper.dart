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
          'CREATE TABLE subjects(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, weight INTEGER, grade INTEGER, sure INTEGER, seqnum INTEGER, semester INTEGER, optional INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertSubject(Subject subject) async {
    final db = await database;
    final id = await db.insert(
      'subjects',
      subject.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    //its necessary to set the currently added subject's id to the one that's been assigned to it in the database
    subject.id = id;
  }

  Future<void> updateSubject(Subject subject) async {
    final db = await database;
    await db.update(
      'subjects',
      subject.toMap(),
      where: 'id = ?',
      whereArgs: [subject.id],
    );
  }

  Future<void> deleteSubject(Subject subject) async {
    final db = await database;
    await db.delete(
      'subjects',
      where: 'id = ?',
      whereArgs: [subject.id],
    );
  }

  Future<List<Subject>> getSubjects() async {
    final db = await database;

    //when loading data, subjects are grouped by the semester field, so when we modify the sequence, the seqnums will definitely be changed relative to the subjects in the same semester
    final List<Map<String, dynamic>> maps = await db.query('subjects', orderBy: 'seqnum');

    return List.generate(maps.length, (i) {
      return Subject(
        newId: maps[i]['id'],
        newName: maps[i]['name'],
        newWeight: maps[i]['weight'],
        newGrade: maps[i]['grade'],
        newSure: maps[i]['sure'] == 1,
        newSeqnum: maps[i]['seqnum'],
        newSemester: maps[i]['semester'],
        newOptional: maps[i]['optional'] == 1
      );
    });
  }
}