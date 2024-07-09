import 'package:flutter/material.dart';

class CommonDataCard {

  static Widget showDataCard(String text, int value, [Color? color]){
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            textAlign: TextAlign.center,
            "$text $value",
            style: TextStyle(fontSize: 18, color: color),
          ),
        ),
      ),
    );
  }
}