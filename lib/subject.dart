import 'package:flutter/material.dart';
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

class Subject {
  late String name;
  late int weight;
  late int grade;
  late bool sure;
  late int seqnum;

  Subject({required String newName, required int newWeight, required int newGrade, required bool newSure, required newSeqnum}) {
    name = newName;
    weight = newWeight;
    grade = newGrade;
    sure = newSure;
    seqnum = newSeqnum;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'weight': weight,
      'grade': grade,
      'sure': sure ? 1 : 0,
      'seqnum': seqnum,
    };
  }

  void setGrade(int newGrade) {
    grade = newGrade;
    updateInDatabase();
  }

  void setSure() {
    sure = !sure;
    updateInDatabase();
  }

  void saveToDatabase() async {
    await DatabaseHelper().insertSubject(this);
  }

  void updateInDatabase() async {
    await DatabaseHelper().updateSubject(this);
  }

  void deleteFromDatabase() async {
    await DatabaseHelper().deleteSubject(name);
  }
}

class SubjectList extends ChangeNotifier {
  List<Subject> subjects = [];

  void addSubject(Subject subject) {
    subjects.add(subject);
    subject.saveToDatabase();
    notifyListeners();
  }

  void modifySubject(Subject oldSubject, Subject newSubject) {
    int index = subjects.indexOf(oldSubject);
    if (index != -1) {
      subjects[index] = newSubject;
      newSubject.updateInDatabase();

      notifyListeners();
    }
  }

  void removeSubject(Subject subject) {
    subjects.remove(subject);
    subject.deleteFromDatabase();

    //updating seqnums after deletion
    updateSubjectSeqnums();
    notifyListeners();
  }

  void updateSubjectSeqnums(){
    for(int i=0; i<subjects.length; i++){
      Subject currentSubject = subjects[i];
      currentSubject.seqnum = i;
      currentSubject.updateInDatabase();
    }
    notifyListeners();
  }

  Future<void> loadSubjectsFromDatabase() async {
    subjects = await DatabaseHelper().getSubjects();
    notifyListeners();
  }

  int calculateTotalWeight() {
    int totalWeight = 0;
    for (var subject in subjects) {
      totalWeight += subject.weight;
    }
    return totalWeight;
  }

  void removeAllSubjects() {
    for (var subject in subjects) {
      subject.deleteFromDatabase();
    }
    subjects.clear();
    notifyListeners();
  }

  int size() => subjects.length;
}
