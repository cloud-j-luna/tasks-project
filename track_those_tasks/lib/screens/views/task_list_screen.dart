import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:trackthosetasks/BLoC/dashboard_bloc.dart';
import 'package:trackthosetasks/BLoC/task_list_bloc.dart';
import 'package:trackthosetasks/assets/strings.dart';
import 'package:trackthosetasks/models/task.dart';
import 'package:trackthosetasks/models/task_list.dart';
import 'package:trackthosetasks/screens/views/task_list_settings_screen.dart';
import 'package:uuid/uuid.dart';
import 'package:proximity_plugin/proximity_plugin.dart';

import 'package:trackthosetasks/extensions.dart';

class TaskListScreen extends StatefulWidget {
  final selectedTaskList;
  final DashboardBloc dashboardBloc;

  TaskListScreen(this.selectedTaskList, this.dashboardBloc);

  @override
  State<StatefulWidget> createState() => _TaskListScreen(selectedTaskList);
}

class _TaskListScreen extends State<TaskListScreen> {
  Timer _timer;
  SelectedTaskListBloc _selectedTaskListBloc;

  StreamSubscription proxSubscription;
  bool _proximityIn;
  bool _paused;

  _TaskListScreen(TaskList selectedTaskList) {
    _selectedTaskListBloc = SelectedTaskListBloc();
    _selectedTaskListBloc.selectTaskList(selectedTaskList);
    _proximityIn = false;
    _paused = false;

    proxSubscription = proximityEvents.listen((event) {
      if (_proximityIn) {
        log("Prox IN");
      } else {
        if (_paused)
          _selectedTaskListBloc.resumeCurrentTasks();
        else
          _selectedTaskListBloc.pauseCurrentTasks();

          _paused = !_paused;
        log("Prox OUT");
      }
      _proximityIn = !_proximityIn;
    });
  }

  _startTimeCounter() {
    print("started");
    setState(() {}); // force UI update
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {},
      ),
    );
  }

  _stopTimeCounter() {
    print("stoped");
    _timer?.cancel();
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    proxSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _dashboardBloc = widget.dashboardBloc;
    TaskList _taskList = _selectedTaskListBloc.selectedTaskList;

    _updateCurrentTaskList(TaskList updatedTaskList) {
      _selectedTaskListBloc.updateTaskList(updatedTaskList);
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
          if (snapshot.data == null) {
            return Text("Loading");
          }

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
                  _selectedTaskListBloc.updateTaskList(_taskList);
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
                        _buildListOfTasks(_taskList, _selectedTaskListBloc),
                      ],
                    ),
                  ),
          );
        });
  }

  Widget _buildListOfTasks(TaskList taskList, SelectedTaskListBloc bloc) {
    return Expanded(
        child: ListView.builder(
            itemCount: taskList.tasks?.length,
            itemBuilder: (context, index) {
              Task task = taskList.tasks[index];
              return _buildTaskCard(task, bloc);

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

  Widget _buildTaskCard(Task task, SelectedTaskListBloc bloc) {
    return Card(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          trailing: Icon(Icons.more_vert),
          title: Text(task.title),
          subtitle: Text(task.description),
          isThreeLine: true,
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: <Widget>[
              Text(task.currentSession.format()),
              VerticalDivider(),
              Text(task.totalDuration.format())
            ],
          ),
        ),
        ButtonBar(children: _buildTaskActionButtons(task, bloc))
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

  List<Widget> _buildTaskActionButtons(Task task, SelectedTaskListBloc bloc) {
    List<Widget> actions = List<Widget>();

    void _startTask() {
      bloc.checkSimultaneousTasks();
      task.startTask();
      _selectedTaskListBloc.addCurrentTask(task);
      _startTimeCounter();
    }

    if (task.status == TaskStatus.inProgress)
      actions.add(FlatButton(
        child: Text(TASK_ACTION_RESUME),
        onPressed: () => _startTask(),
      ));

    if (task.status == TaskStatus.none)
      actions.add(FlatButton(
        child: Text(TASK_ACTION_START),
        onPressed: () => _startTask(),
      ));

    if (task.status == TaskStatus.doing) {
      actions.add(FlatButton(
        child: Text(TASK_ACTION_PAUSE),
        onPressed: () {
          task.pauseTask();
          _stopTimeCounter();
        },
      ));

      actions.add(FlatButton(
        child: Text(TASK_ACTION_DONE),
        onPressed: () {
          task.finishTask();
          _selectedTaskListBloc.removeCurrentTask(task);
          _stopTimeCounter();
        },
      ));
    }

    return actions;
  }
}
