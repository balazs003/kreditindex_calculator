import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kreditindex_calculator/subject.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'credit_division_notifier.dart';

//Class responsible for providing statistical data about subjects
class Statistics {
  late SubjectList _subjectList;
  late BuildContext _context;

  double earlierCreditIndex = 0.0;

  int creditCount = 0;
  int finalCreditCount = 0;
  int creditDivisionNumber = 0;

  double creditIndex = 0.0;
  double summarizedCreditIndex = 0.0;
  double weightedCreditIndex = 0.0;
  double average = 0.0;

  Statistics({required SubjectList newSubjectList, required BuildContext newContext}){
    _subjectList = newSubjectList;
    _context = newContext;
  }

  Future<void> loadEarlierCreditIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    earlierCreditIndex = prefs.getDouble('earlierCreditIndex') ?? 0.0;
  }

  Future<void> saveEarlierCreditIndex(double value) async{
    earlierCreditIndex = value;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('earlierCreditIndex', earlierCreditIndex);
  }

  void _setCreditDivisionNumber() {
    creditDivisionNumber = _context.read<CreditDivisionNotifier>().creditDivisionNumber;
  }

  void _calculateTotalWeight(int semesterNumber) {
    creditCount = 0;
    for (var subject in _subjectList.getCurrentSemesterSubjects(semesterNumber)) {
      creditCount += subject.weight;
    }
  }

  void _calculateFinalCreditCount(int semesterNumber) {
    finalCreditCount = creditCount;
    for (var subject in _subjectList.getCurrentSemesterSubjects(semesterNumber)) {
      if (subject.grade < 2) {
        finalCreditCount -= subject.weight;
      }
    }
  }

  void _calculateCreditIndex(int semesterNumber) {
    int sum = 0;
    for (var subject in _subjectList.getCurrentSemesterSubjects(semesterNumber)) {
      if (subject.grade > 1) {
        sum += subject.weight * subject.grade;
      }
    }

    creditIndex = sum / creditDivisionNumber.toDouble();
  }

  void _calculateWeightedCreditIndex(int semesterNumber) {
    int sum = 0;
    for (var subject in _subjectList.getCurrentSemesterSubjects(semesterNumber)) {
      if (subject.grade > 1) {
        sum += subject.weight * subject.grade;
      }
    }

    weightedCreditIndex = creditCount == 0 ? 0.0 : sum / creditCount.toDouble();
  }

  void _calculateSummarizedCreditIndex() {
    summarizedCreditIndex = (creditIndex + earlierCreditIndex) / 2.0;
  }

  void _calculateAverage(int semesterNumber) {
    int sum = 0;
    for (var subject in _subjectList.getCurrentSemesterSubjects(semesterNumber)) {
      sum += subject.grade;
    }

    average = _subjectList.size() == 0 ? 0.0 : sum / _subjectList.size();
  }

  void calculateAllData(int semesterNumber){
    _setCreditDivisionNumber();
    _calculateTotalWeight(semesterNumber);
    _calculateCreditIndex(semesterNumber);
    _calculateSummarizedCreditIndex();
    _calculateAverage(semesterNumber);
    _calculateWeightedCreditIndex(semesterNumber);
    _calculateFinalCreditCount(semesterNumber);
  }
}