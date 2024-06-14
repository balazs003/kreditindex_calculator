import 'package:flutter/cupertino.dart';

class CreditDivisionNotifier extends ChangeNotifier {
  int _creditDivisionNumber = 30;

  int get creditDivisionNumber => _creditDivisionNumber;

  void setCreditDivisionNumber(int newNumber) {
    _creditDivisionNumber = newNumber;
    notifyListeners();
  }
}