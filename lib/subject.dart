import 'package:flutter/cupertino.dart';

class Subject extends ChangeNotifier {
  late String name;
  late int weight;
  late int grade;
  bool sure = true;

  Subject({required String newName, required int newWeight, required int newGrade}){
    name = newName;
    weight = newWeight;
    grade = newGrade;
  }

  void setGrade(int newGrade){
    grade = newGrade;
    notifyListeners();
  }

  void setSure(){
    sure = !sure;
    notifyListeners();
  }
}

class SubjectList extends ChangeNotifier {
  List<Subject> subjects = [];

  void addSubject(Subject subject){
    subjects.add(subject);
    notifyListeners();
  }

  void removeSubject(Subject subject) {
    subjects.remove(subject);
    notifyListeners();
  }

  int size() => subjects.length;
}