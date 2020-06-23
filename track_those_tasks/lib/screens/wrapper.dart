import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackthosetasks/models/user.dart';
import 'package:trackthosetasks/screens/authenticate/authenticate.dart';
import 'package:trackthosetasks/screens/views/dashboard_screen.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return DashboardScreen();
    }
  }
}
