import 'package:shared_preferences/shared_preferences.dart';

class Subject {
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

  Future<void> loadFromPrefs(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    grade = prefs.getInt('grade_$name') ?? 0;
    sure = prefs.getBool('sure_$name') ?? true;
    weight = prefs.getInt('weight_$name') ?? 0;
  }
}

class SubjectList {
  List<Subject> subjects = [];

  void addSubject(Subject subject){
    subjects.add(subject);
    subject.saveToPrefs();
  }

  void removeSubject(Subject subject) {
    subjects.remove(subject);
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
        Subject subject = Subject(newName: name, newWeight: 0, newGrade: 0);
        await subject.loadFromPrefs(name);
        subjects.add(subject);
      }
    }
  }

  int calculateTotalWeight(){
    int totalWeight = 0;
    for(var subject in subjects){
      totalWeight += subject.weight;
    }
    return totalWeight;
  }

  int size() => subjects.length;
}