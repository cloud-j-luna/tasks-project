import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:trackthosetasks/BLoC/dashboard_bloc.dart';
import 'package:trackthosetasks/BLoC/task_list_bloc.dart';
import 'package:trackthosetasks/assets/strings.dart';
import 'package:trackthosetasks/models/task.dart';
import 'package:trackthosetasks/models/task_list.dart';
import 'package:trackthosetasks/assets/styles.dart';
import 'package:trackthosetasks/screens/views/task_list_settings_screen.dart';
import 'package:uuid/uuid.dart';

class TaskListScreen extends StatefulWidget {
  final SelectedTaskListBloc selectedTaskListBloc;
  final DashboardBloc dashboardBloc;

  TaskListScreen(this.selectedTaskListBloc, this.dashboardBloc);

  @override
  State<StatefulWidget> createState() => _TaskListScreen();
}

class _TaskListScreen extends State<TaskListScreen> {
  @override
  Widget build(BuildContext context) {
    final _dashboardBloc = widget.dashboardBloc;
    final _selectedTaskListBloc = widget.selectedTaskListBloc;
    TaskList _taskList = _selectedTaskListBloc.selectedTaskList;

    _updateCurrentTaskList(TaskList updatedTaskList) {
      _selectedTaskListBloc.updateTaskList.add(updatedTaskList);
    }

    _deleteCurrentTaskList(BuildContext context) {
      bool result = _dashboardBloc.removeTaskList(_taskList.uuid);
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

    return StreamBuilder(
        stream: _selectedTaskListBloc.taskListStream,
        builder: (context, snapshot) {
          if (snapshot.data == null) log("error");

          return Scaffold(
            appBar: AppBar(
              title: Text(_taskList.name),
              actions: <Widget>[
                IconButton(
                  onPressed: () => {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TaskListSettingsScreen(
                                    _taskList, _dashboardBloc)))
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
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return _buildAddTaskListForm(context, dialogContext);
                    }).then((value) {
                  String title = value[0];
                  String description = value[1];

                  log("Creating task with title: $title : $description");
                  Task task = Task(
                      uuid: Uuid().toString(),
                      title: title,
                      description: description);

                  _taskList.addTask(task);
                  _selectedTaskListBloc.updateTaskList.add(_taskList);
                });
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.green,
            ),
            body: _taskList.tasks == null
                ? Text(TASK_LIST_EMPTY)
                : Container(
                    padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
                    width: double.maxFinite,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(_taskList.name),
                        ),
                        _buildListOfTasks(_taskList),
                      ],
                    ),
                  ),
          );
        });
  }

  Widget _buildListOfTasks(TaskList taskList) {
    return Expanded(
        child: ListView.builder(
            itemCount: taskList.tasks?.length,
            itemBuilder: (context, index) {
              Task task = taskList.tasks[index];
              return _buildTaskCard(task);

              /*return Container(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          task.title,
                          style: ScreenStyles().headerTextStyle,
                        ),
                        Container(height: 10.0),
                        Text(
                          task.description,
                          style: ScreenStyles().subHeaderTextStyle,
                        )
                      ],
                    ),
                  ));*/
            }));
  }

  Widget _buildTaskCard(Task task) {
    return Card(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          trailing: Icon(Icons.more_vert),
          title: Text(task.title),
          subtitle: Text(task.description),
          isThreeLine: true,
          dense: true,
        ),
        Text("00:00"),
        ButtonBar(children: _buildTaskActionButtons(task))
      ],
    ));
  }

  Widget _buildAddTaskListForm(
      BuildContext context, BuildContext dialogContext) {
    TextEditingController _titleController = TextEditingController();
    TextEditingController _descriptionController = TextEditingController();

    return AlertDialog(
      content: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            right: -40.0,
            top: -40.0,
            child: InkResponse(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                child: Icon(Icons.close),
                backgroundColor: Colors.red,
              ),
            ),
          ),
          Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _titleController,
                    decoration:
                        InputDecoration(hintText: TASK_LIST_ADD_TASK_TITLE),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                        hintText: TASK_LIST_ADD_TASK_DESCRIPTION),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text(TASK_LIST_ADD_TASK_SUBMIT),
                    onPressed: () {
                      Navigator.pop(dialogContext,
                          [_titleController.text, _descriptionController.text]);
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTaskActionButtons(Task task) {
    List<Widget> actions = List<Widget>();

    if (task.status == TaskStatus.inProgress)
      actions.add(FlatButton(
        child: Text(TASK_ACTION_RESUME),
        onPressed: () => task.startTask(),
      ));

    if (task.status == TaskStatus.none)
      actions.add(FlatButton(
        child: Text(TASK_ACTION_START),
        onPressed: () => task.startTask(),
      ));

    if (task.status == TaskStatus.doing) {
      actions.add(FlatButton(
        child: Text(TASK_ACTION_PAUSE),
        onPressed: () => task.pauseTask(),
      ));

      actions.add(FlatButton(
        child: Text(TASK_ACTION_DONE),
        onPressed: () => task.finishTask(),
      ));
    }

    return actions;
  }
}
