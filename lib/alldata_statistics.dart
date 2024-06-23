import 'package:kreditindex_calculator/statistics.dart';
import 'package:provider/provider.dart';

import 'credit_division_notifier.dart';

class AllDataStatistics extends Statistics {
  AllDataStatistics({required super.newSubjectList, required super.newContext});

  @override
  void setCreditDivisionNumber() {
    creditDivisionNumber = context.read<CreditDivisionNotifier>().creditDivisionNumber * subjectList.size();
  }

  @override
  void calculateTotalWeight() {
    creditCount = 0;
    for (var subject in subjectList.subjects) {
      creditCount += subject.weight;
    }
  }

  @override
  void calculateFinalCreditCount() {
    finalCreditCount = creditCount;
    for (var subject in subjectList.subjects) {
      if (subject.grade < 2) {
        finalCreditCount -= subject.weight;
      }
    }
  }

  @override
  void calculateEarlierCreditIndex(int currentSemester){}

  @override
  void calculateCreditIndex() {
    int sum = 0;
    for (var subject in subjectList.subjects) {
      if (subject.grade > 1) {
        sum += subject.weight * subject.grade;
      }
    }

    creditIndex = sum / creditDivisionNumber.toDouble();
  }

  @override
  void calculateWeightedCreditIndex() {
    int sum = 0;
    for (var subject in subjectList.subjects) {
      if (subject.grade > 1) {
        sum += subject.weight * subject.grade;
      }
    }

    weightedCreditIndex = creditCount == 0 ? 0.0 : sum / creditCount.toDouble();
  }

  @override
  void calculateSummarizedCreditIndex(int currentSemester) {}

  @override
  void calculateAverage() {
    int sum = 0;
    for (var subject in subjectList.subjects) {
      sum += subject.grade;
    }

    average = subjectList.subjects.isEmpty ? 0.0 : sum / subjectList.size();
  }

  @override
  int getFailedSubjectCount(){
    int failedSubjectCounter = 0;
    for(var subject in subjectList.subjects){
      if(subject.grade < 2){
        failedSubjectCounter++;
      }
    }
    return failedSubjectCounter;
  }
}