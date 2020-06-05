import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackthosetasks/screens/main_screen.dart';
import 'package:trackthosetasks/services/auth.dart';

import 'BLoC/bloc_provider.dart';
import 'BLoC/task_list_bloc.dart';
import 'models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
        value: AuthService().user, child: _widget());
  }
}

Widget _widget() {
  return BlocProvider<TaskListBloc>(
    bloc: TaskListBloc(),
    child: MaterialApp(
      title: 'Track Those Tasks',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MainScreen(),
    ),
  );
}
