import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trackthosetasks/assets/colors.dart';

class ScreenStyles {
  TextStyle baseTextStyle = TextStyle(fontFamily: 'Roboto');

  TextStyle headerTextStyle = TextStyle(
      color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w600);

  TextStyle regularTextStyle = TextStyle(
      color: Colors.grey[800], fontSize: 9.0, fontWeight: FontWeight.w400);

  TextStyle subHeaderTextStyle = TextStyle(fontSize: 12.0);

  TextStyle reportCardStyleNumber = TextStyle(
      color: CustomColors.secondaryTextColor,
      fontWeight: FontWeight.bold,
      fontSize: 28.0);

  TextStyle reportCardStyleTitle = TextStyle(
      color: CustomColors.secondaryTextColor,
      fontWeight: FontWeight.w600,
      fontSize: 16.0);

  TextStyle reportCardStyleSubtitle = TextStyle(
      color: CustomColors.secondaryTextColor,
      fontWeight: FontWeight.w600,
      fontSize: 12.0);
}
