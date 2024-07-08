import 'package:flutter/material.dart';

class LinearGradientSingleton{
  static LinearGradient getGradientInstance(BuildContext context) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        Theme.of(context).primaryColor,
        Colors.indigoAccent,
      ],
      tileMode: TileMode.mirror,
    );
  }
}