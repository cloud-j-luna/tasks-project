import 'package:flutter/material.dart';
import 'package:trackthosetasks/assets/colors.dart';

class TTTMenu {
  const TTTMenu(this.title, this.icon, this.color);
  final String title;
  final IconData icon;
  final Color color;
}

const List<TTTMenu> allMenus = <TTTMenu>[
  TTTMenu('Profile', Icons.account_circle, CustomColors.secondaryDarkColor),
  TTTMenu('Dashboard', Icons.dashboard, CustomColors.secondaryDarkColor),
  TTTMenu('Tasks', Icons.list, CustomColors.secondaryDarkColor),
  TTTMenu('Settings', Icons.settings, CustomColors.secondaryDarkColor),
];
