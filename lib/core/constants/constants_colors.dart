import 'package:flutter/material.dart';

class ConstantsColors {
  static const colorWhite = Colors.white;
  static const colorWhite60 = Colors.white60;
  static const colorIndigo = Colors.indigo;
  static const colorIndigoAccent = Colors.indigoAccent;
  static const colorBlueGrey = Colors.blueGrey;
  static const colorBlack54 = Colors.black54;
}

class CommonStyles {
  static const mainTitle = TextStyle(
    fontSize: 16.5,
    color: ConstantsColors.colorBlack54,
    fontWeight: FontWeight.bold,
  );

  static const titleStyle = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    color: ConstantsColors.colorBlueGrey,
  );

  static const clickable = TextStyle(
    color: Colors.black45,
    decoration: TextDecoration.underline,
  );
}

extension StringX on String {
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';

  DateTime get toDate => DateTime.parse(this).toLocal();
}
