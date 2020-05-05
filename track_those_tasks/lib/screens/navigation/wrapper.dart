import 'package:flutter/material.dart';
import 'package:trackthosetasks/assets/colors.dart';
import 'package:trackthosetasks/screens/navigation/menus.dart';
import 'package:trackthosetasks/screens/views/dashboard.dart';
import 'package:trackthosetasks/screens/views/profile.dart';
import 'package:trackthosetasks/screens/views/settings.dart';
import 'package:trackthosetasks/screens/views/task_list.dart';
import 'package:trackthosetasks/services/auth.dart';

class WrapperView extends StatefulWidget {
  @override
  _WrapperViewState createState() => _WrapperViewState();
}

class _WrapperViewState extends State<WrapperView> {
  final AuthService _authService = AuthService();

  List<Widget> pages = List<Widget>();
  int _currentIndex = 1;

  @override
  void initState() {
    pages.add(ProfileView());
    pages.add(DashboardView());
    pages.add(TaskListView());
    pages.add(SettingsView());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryLightColor,
      body: SafeArea(
        top: true,
        child: IndexedStack(
          index: _currentIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: CustomColors.secondaryDarkColor,
        selectedItemColor: CustomColors.white,
        unselectedItemColor: CustomColors.secondaryLightColor,
        items: allMenus.map((TTTMenu menu) {
          return BottomNavigationBarItem(
            icon: Icon(menu.icon),
            backgroundColor: menu.color,
            title: Text(menu.title),
          );
        }).toList(),
      ),
    );
  }
}
