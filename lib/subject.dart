import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Subject {
  late String name;
  late int weight;
  late int grade;
  late bool sure;

  Subject({required String newName, required int newWeight, required int newGrade, required bool newSure}){
    name = newName;
    weight = newWeight;
    grade = newGrade;
    sure = newSure;
  }

  void setGrade(int newGrade){
    grade = newGrade;
    saveToPrefs();
  }

  void setSure(){
    sure = !sure;
    saveToPrefs();
  }

  void saveToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('grade_$name', grade);
    await prefs.setBool('sure_$name', sure);
    await prefs.setInt('weight_$name', weight);
  }

  void deleteFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('grade_$name');
    await prefs.remove('sure_$name');
    await prefs.remove('weight_$name');
  }

  Future<void> loadFromPrefs(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    grade = prefs.getInt('grade_$name') ?? 0;
    sure = prefs.getBool('sure_$name') ?? true;
    weight = prefs.getInt('weight_$name') ?? 0;
  }
}

class SubjectList extends ChangeNotifier {
  List<Subject> subjects = [];

  void addSubject(Subject subject){
    subjects.add(subject);
    subject.saveToPrefs();
    saveSubjectsToPrefs();
    notifyListeners();
  }

  void modifySubject(Subject oldSubject, Subject newSubject) {
    int index = subjects.indexOf(oldSubject);
    if(index != -1){
      subjects[index] = newSubject;

      //IMPORTANT!! always delete old first
      oldSubject.deleteFromPrefs();
      newSubject.saveToPrefs();
      saveSubjectsToPrefs();
      notifyListeners();
    }
  }

  void removeSubject(Subject subject) {
    subjects.remove(subject);
    saveSubjectsToPrefs();
    subject.deleteFromPrefs();
    saveSubjectsToPrefs();
    notifyListeners();
  }

  Future<void> saveSubjectsToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> subjectNames = subjects.map((subject) => subject.name).toList();
    await prefs.setStringList('subject_names', subjectNames);
  }

  Future<void> loadSubjectsFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? subjectNames = prefs.getStringList('subject_names');
    if (subjectNames != null) {
      subjects.clear();
      for (String name in subjectNames) {
        Subject subject = Subject(newName: name, newWeight: 0, newGrade: 0, newSure: true);
        await subject.loadFromPrefs(name);
        subjects.add(subject);
      }
    }
    notifyListeners();
  }

  int calculateTotalWeight(){
    int totalWeight = 0;
    for(var subject in subjects){
      totalWeight += subject.weight;
    }
    return totalWeight;
  }

  void removeAllSubjects(){

    for(var subject in subjects) {
      subject.deleteFromPrefs();
    }

    subjects.clear();
    saveSubjectsToPrefs();
    notifyListeners();
  }

  int size() => subjects.length;
}