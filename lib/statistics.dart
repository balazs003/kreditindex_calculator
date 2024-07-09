import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kreditindex_calculator/subject.dart';

//Class responsible for providing statistical data about subjects
abstract class Statistics {
  late SubjectList subjectList;
  late BuildContext context;

  double earlierCreditIndex = 0.0;

  int creditCount = 0;
  int finalCreditCount = 0;
  int creditDivisionNumber = 0;
  int optionalSubjectCount = 0;
  int optionalSubjectCreditCount = 0;

  double creditIndex = 0.0;
  double summarizedCreditIndex = 0.0;
  double weightedCreditIndex = 0.0;
  double average = 0.0;

  Statistics({required SubjectList newSubjectList, required BuildContext newContext}){
    subjectList = newSubjectList;
    context = newContext;
  }

  void setCreditDivisionNumber();

  void calculateTotalWeight();

  void calculateFinalCreditCount();

  void calculateEarlierCreditIndex(int currentSemester);

  void calculateCreditIndex();

  void calculateWeightedCreditIndex();

  void calculateSummarizedCreditIndex(int currentSemester);

  void calculateAverage();

  void calculateOptionalSubjectData();

  void calculateAllData(int currentSemester){
    setCreditDivisionNumber();
    calculateTotalWeight();
    calculateCreditIndex();
    calculateSummarizedCreditIndex(currentSemester);
    calculateAverage();
    calculateWeightedCreditIndex();
    calculateFinalCreditCount();
    calculateOptionalSubjectData();
  }

  getFailedSubjectCount() {}
}