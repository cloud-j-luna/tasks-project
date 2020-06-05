import 'dart:ui';

import 'package:flutter/material.dart';

class ScreenStyles {
  TextStyle baseTextStyle,
      headerTextStyle,
      regularTextStyle,
      subHeaderTextStyle;

  factory ScreenStyles() {
    return _instance;
  }
  static final ScreenStyles _instance = ScreenStyles._privateContructor();

  ScreenStyles._privateContructor() {
    baseTextStyle = TextStyle(fontFamily: 'Roboto');

    headerTextStyle = baseTextStyle.copyWith(
        color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w600);

    regularTextStyle = baseTextStyle.copyWith(
        color: Colors.grey[800],
        fontSize: 9.0,
        fontWeight: FontWeight.w400);

    subHeaderTextStyle = regularTextStyle.copyWith(fontSize: 12.0);
  }
}
