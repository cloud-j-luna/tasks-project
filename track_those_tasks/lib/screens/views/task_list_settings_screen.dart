import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:trackthosetasks/BLoC/dashboard_bloc.dart';
import 'package:trackthosetasks/assets/strings.dart';
import 'package:trackthosetasks/models/task_list.dart';

class TaskListSettingsScreen extends StatelessWidget {
  final TaskList taskList;
  final DashboardBloc dashboardBloc;
  final TextEditingController _nameController = TextEditingController();
  TaskListSettingsScreen(this.taskList, this.dashboardBloc, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _nameController.text = taskList.name;

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
