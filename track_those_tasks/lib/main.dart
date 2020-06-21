import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackthosetasks/screens/wrapper.dart';
import 'package:trackthosetasks/services/auth.dart';

import 'models/user.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
void main() {
  runApp(TrackThoseTasks());
}

class TrackThoseTasks extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
        value: AuthService().user, child: _widget());
  }

  Widget _widget() {
    return MaterialApp(
      title: 'Track Those Tasks',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Wrapper(),
      navigatorObservers: [routeObserver],
    );
  }
}
