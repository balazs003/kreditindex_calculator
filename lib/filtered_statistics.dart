import 'package:kreditindex_calculator/statistics.dart';
import 'package:provider/provider.dart';

import 'credit_division_notifier.dart';

class FilteredStatistics extends Statistics {
  FilteredStatistics({required super.newSubjectList, required super.newContext});

  @override
  void setCreditDivisionNumber() {
    creditDivisionNumber = context.read<CreditDivisionNotifier>().creditDivisionNumber;
  }

  @override
  void calculateTotalWeight() {
    creditCount = 0;
    for (var subject in subjectList.filteredSubjects) {
      creditCount += subject.weight;
    }
  }

  @override
  void calculateFinalCreditCount() {
    finalCreditCount = creditCount;
    for (var subject in subjectList.filteredSubjects) {
      if (subject.grade < 2) {
        finalCreditCount -= subject.weight;
      }
    }
  }

  @override
  void calculateEarlierCreditIndex(int currentSemester){
    if(currentSemester <= 1){
      //after the first semester, the current creditindex is taken multiplied by two
      earlierCreditIndex = creditIndex * 2.0;
    } else {
      //almost same code as when we calculate creditindex
      int sum = 0;
      int previousSemester = currentSemester - 1;
      for (var subject in subjectList.subjects) {
        if (subject.semester == previousSemester && subject.grade > 1) {
          sum += subject.weight * subject.grade;
        }
      }
      earlierCreditIndex = sum / creditDivisionNumber.toDouble();
    }
  }

  @override
  void calculateCreditIndex() {
    int sum = 0;
    for (var subject in subjectList.filteredSubjects) {
      if (subject.grade > 1) {
        sum += subject.weight * subject.grade;
      }
    }

    creditIndex = sum / creditDivisionNumber.toDouble();
  }

  @override
  void calculateWeightedCreditIndex() {
    int sum = 0;
    for (var subject in subjectList.filteredSubjects) {
      if (subject.grade > 1) {
        sum += subject.weight * subject.grade;
      }
    }

    weightedCreditIndex = creditCount == 0 ? 0.0 : sum / creditCount.toDouble();
  }

  @override
  void calculateSummarizedCreditIndex(int currentSemester) {
    calculateEarlierCreditIndex(currentSemester);
    summarizedCreditIndex = (creditIndex + earlierCreditIndex) / 2.0;
  }

  @override
  void calculateAverage() {
    int sum = 0;
    for (var subject in subjectList.filteredSubjects) {
      sum += subject.grade;
    }

    average = subjectList.filteredSubjects.isEmpty ? 0.0 : sum / subjectList.filteredSubjects.length;
  }

  @override
  void calculateOptionalSubjectData() {}
}