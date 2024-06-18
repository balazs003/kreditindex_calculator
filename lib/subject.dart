import 'package:flutter/material.dart';
import 'database_helper.dart';

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

  void removeAllSubjects() {
    for (var subject in subjects) {
      subject.deleteFromDatabase();
    }
    subjects.clear();
    notifyListeners();
  }

  int size() => subjects.length;
}
