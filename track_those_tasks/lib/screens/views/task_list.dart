import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:trackthosetasks/BLoC/dashboard_bloc.dart';
import 'package:trackthosetasks/assets/strings.dart';
import 'package:trackthosetasks/models/task.dart';
import 'package:trackthosetasks/models/task_list.dart';
import 'package:trackthosetasks/screens/views/styles.dart';
import 'package:trackthosetasks/screens/views/task_list_settings_screen.dart';

class TaskListScreen extends StatefulWidget {
  final TaskList taskList;
  final DashboardBloc dashboardBloc;

  TaskListScreen(this.taskList, this.dashboardBloc);

  @override
  State<StatefulWidget> createState() => _TaskListScreen();
}

class _TaskListScreen extends State<TaskListScreen> {
  @override
  Widget build(BuildContext context) {
    final TaskList taskList = widget.taskList;
    final DashboardBloc dashboardBloc = widget.dashboardBloc;

    _updateCurrentTaskList(TaskList updatedTaskList) {
      setState(() {
        widget.taskList.name = updatedTaskList.name;
      });
    }

    _deleteCurrentTaskList(BuildContext context) {
      bool result = dashboardBloc.removeTaskList(taskList.uuid);
      if (!result) {
        final snackbar = SnackBar(
          content: Text(TASK_LIST_ERROR_WHILE_DELETING),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );

        Scaffold.of(context).showSnackBar(snackbar);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(taskList.name),
        actions: <Widget>[
          IconButton(
            onPressed: () => {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TaskListSettingsScreen(taskList, dashboardBloc)))
                  .then((value) => _updateCurrentTaskList(value))
            },
            icon: Icon(Icons.settings),
          ),
          Builder(
              builder: (ctx) => IconButton(
                    onPressed: () {
                      _deleteCurrentTaskList(ctx);
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.delete),
                  ))
        ],
      ),
      body: taskList.tasks == null
          ? Text(TASK_LIST_EMPTY)
          : Container(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
              width: double.maxFinite,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(taskList.name),
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: taskList.tasks?.length,
                          itemBuilder: (context, index) {
                            Task task = taskList.tasks[index];

                            return Container(
                                height: 200,
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(8.0),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 10.0,
                                          offset: Offset(0.0, 10.0))
                                    ]),
                                width: double.maxFinite,
                                child: Container(
                                  margin: EdgeInsets.all(16),
                                  constraints: BoxConstraints.expand(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        task.title,
                                        style: ScreenStyles().headerTextStyle,
                                      ),
                                      Container(height: 10.0),
                                      Text(
                                        task.description,
                                        style:
                                            ScreenStyles().subHeaderTextStyle,
                                      )
                                    ],
                                  ),
                                ));
                          })),
                ],
              ),
            ),
    );
  }
}
