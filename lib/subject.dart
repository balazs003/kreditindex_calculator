import 'package:flutter/foundation.dart';
import 'database_helper.dart';

class Subject {
  late int id;
  late String name;
  late int weight;
  late int grade;
  late bool sure;
  late int seqnum;
  late int semester;

  Subject({required int newId, required String newName, required int newWeight, required int newGrade, required bool newSure, required newSeqnum, required newSemester}) {
    id = newId;
    name = newName;
    weight = newWeight;
    grade = newGrade;
    sure = newSure;
    seqnum = newSeqnum;
    semester = newSemester;
  }

  Map<String, dynamic> toMap() {
    return {
      //'id': id,
      'name': name,
      'weight': weight,
      'grade': grade,
      'sure': sure ? 1 : 0,
      'seqnum': seqnum,
      'semester': semester,
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

  Future<void> saveToDatabase() async {
    await DatabaseHelper().insertSubject(this);
  }

  Future<void> updateInDatabase() async {
    await DatabaseHelper().updateSubject(this);
  }

  void deleteFromDatabase() async {
    await DatabaseHelper().deleteSubject(this);
  }
}

class SubjectList extends ChangeNotifier {
  List<Subject> subjects = [];

  List<Subject> getCurrentSemesterSubjects(int semesterNumber){
    List<Subject> filteredSubjects = [];
    for(var subject in subjects){
      if(subject.semester == semesterNumber){
        filteredSubjects.add(subject);
      }
    }
    return filteredSubjects;
  }

  void addSubject(Subject subject) async {
    subjects.add(subject);
    subject.saveToDatabase();
    notifyListeners();
  }

  void modifySubject(Subject oldSubject, Subject newSubject) async {
    int index = subjects.indexOf(oldSubject);
    subjects[index] = newSubject;
    newSubject.updateInDatabase();
    notifyListeners();
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

  void removeAllSubjects() {
    for (var subject in subjects) {
      subject.deleteFromDatabase();
    }
    subjects.clear();
    notifyListeners();
  }

  int size() => subjects.length;
}
