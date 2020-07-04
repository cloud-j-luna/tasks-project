import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:trackthosetasks/BLoC/dashboard_bloc.dart';
import 'package:trackthosetasks/assets/strings.dart';
import 'package:trackthosetasks/models/task_list.dart';

class TaskListSettingsScreen extends StatefulWidget {
  final TaskList taskList;
  final DashboardBloc dashboardBloc;

  TaskListSettingsScreen(this.taskList, this.dashboardBloc);

  @override
  State<StatefulWidget> createState() =>
      _TaskListSettingsScreen(this.taskList, this.dashboardBloc);
}

class _TaskListSettingsScreen extends State<TaskListSettingsScreen> {
  final TaskList taskList;
  final DashboardBloc dashboardBloc;
  final TextEditingController _nameController = TextEditingController();
  _TaskListSettingsScreen(this.taskList, this.dashboardBloc);

  @override
  Widget build(BuildContext context) {
    _nameController.text = taskList.name;
    log((taskList?.settings == null).toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(taskList.name),
        actions: <Widget>[
          Builder(
              builder: (ctx) => IconButton(
                    icon: Icon(Icons.save),
                    onPressed: () => _updateTaskList(ctx),
                  ))
        ],
      ),
      body: Container(
        width: double.maxFinite,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: _nameController,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: CheckboxListTile(
                  title: Text(TASK_LIST_SETTINGS_ALLOW_SIMULTANIOUS_TASKS),
                  value: taskList?.settings?.allowsSimultaneousTasks,
                  onChanged: (bool value) {
                    print("updated");
                    setState(() {
                      taskList?.settings?.allowsSimultaneousTasks = value;
                      taskList?.settings?.isContinous = false;
                    });
                  }),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: CheckboxListTile(
                  title: Text(TASK_LIST_SETTINGS_IS_CONTINOUS),
                  value: taskList?.settings?.isContinous,
                  onChanged: (bool value) {
                    print("updated");
                    setState(() {
                      taskList?.settings?.isContinous = value;
                      taskList?.settings?.allowsSimultaneousTasks = false;
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void _updateTaskList(BuildContext context) {
    taskList.name = _nameController.text;
    bool result = dashboardBloc.updateTaskList(taskList);
    if (!result) {
      final snackbar = SnackBar(
        content: Text(TASK_LIST_ERROR_WHILE_SAVING),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );

      Scaffold.of(context).showSnackBar(snackbar);
      return;
    }

    Navigator.pop(context, taskList);
  }
}
