import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kreditindex_calculator/subject.dart';
import 'package:provider/provider.dart';
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

  void _setCreditDivisionNumber() {
    creditDivisionNumber = _context.read<CreditDivisionNotifier>().creditDivisionNumber;
  }

  void _calculateTotalWeight() {
    creditCount = 0;
    for (var subject in _subjectList.filteredSubjects) {
      creditCount += subject.weight;
    }
  }

  void _calculateFinalCreditCount() {
    finalCreditCount = creditCount;
    for (var subject in _subjectList.filteredSubjects) {
      if (subject.grade < 2) {
        finalCreditCount -= subject.weight;
      }
    }
  }

  void _calculateEarlierCreditIndex(int currentSemester){
    if(currentSemester <= 1){
      //after the first semester, the current creditindex is taken multiplied by two
      earlierCreditIndex = creditIndex * 2.0;
    } else {
      //almost same code as when we calculate creditindex
      int sum = 0;
      int previousSemester = currentSemester - 1;
      for (var subject in _subjectList.subjects) {
        if (subject.semester == previousSemester && subject.grade > 1) {
          sum += subject.weight * subject.grade;
        }
      }
      earlierCreditIndex = sum / creditDivisionNumber.toDouble();
    }
  }

  void _calculateCreditIndex() {
    int sum = 0;
    for (var subject in _subjectList.filteredSubjects) {
      if (subject.grade > 1) {
        sum += subject.weight * subject.grade;
      }
    }

    creditIndex = sum / creditDivisionNumber.toDouble();
  }

  void _calculateWeightedCreditIndex() {
    int sum = 0;
    for (var subject in _subjectList.filteredSubjects) {
      if (subject.grade > 1) {
        sum += subject.weight * subject.grade;
      }
    }

    weightedCreditIndex = creditCount == 0 ? 0.0 : sum / creditCount.toDouble();
  }

  void _calculateSummarizedCreditIndex(int currentSemester) {
    _calculateEarlierCreditIndex(currentSemester);
    summarizedCreditIndex = (creditIndex + earlierCreditIndex) / 2.0;
  }

  void _calculateAverage() {
    int sum = 0;
    for (var subject in _subjectList.filteredSubjects) {
      sum += subject.grade;
    }

    average = _subjectList.filteredSubjects.isEmpty ? 0.0 : sum / _subjectList.filteredSubjects.length;
  }

  void calculateAllData(int currentSemester){
    _setCreditDivisionNumber();
    _calculateTotalWeight();
    _calculateCreditIndex();
    _calculateSummarizedCreditIndex(currentSemester);
    _calculateAverage();
    _calculateWeightedCreditIndex();
    _calculateFinalCreditCount();
  }
}