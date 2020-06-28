import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:trackthosetasks/BLoC/dashboard_bloc.dart';
import 'package:trackthosetasks/BLoC/task_list_bloc.dart';
import 'package:trackthosetasks/assets/colors.dart';
import 'package:trackthosetasks/assets/strings.dart';
import 'package:trackthosetasks/assets/styles.dart';
import 'package:trackthosetasks/models/task.dart';
import 'package:trackthosetasks/models/task_list.dart';
import 'package:trackthosetasks/screens/views/report_screen.dart';
import 'package:trackthosetasks/screens/views/show_attachment_screen.dart';
import 'package:trackthosetasks/screens/views/take_picture_screen.dart';
import 'package:trackthosetasks/screens/views/task_list_settings_screen.dart';
import 'package:trackthosetasks/sound_player.dart';
import 'package:uuid/uuid.dart';
import 'package:proximity_plugin/proximity_plugin.dart';

import 'package:trackthosetasks/extensions.dart';

class TaskListScreen extends StatefulWidget {
  final selectedTaskList;
  DashboardBloc dashboardBloc;

  TaskListScreen(this.selectedTaskList, this.dashboardBloc);

  @override
  State<StatefulWidget> createState() =>
      _TaskListScreen(selectedTaskList, dashboardBloc);
}

class _TaskListScreen extends State<TaskListScreen> {
  DashboardBloc _dashboardBloc;
  Timer _timer;
  SelectedTaskListBloc _selectedTaskListBloc;

  StreamSubscription proxSubscription;
  bool _proximityIn;
  bool _paused;
  DateTime _startProx;

  _TaskListScreen(TaskList selectedTaskList, DashboardBloc dashboardBloc) {
    _selectedTaskListBloc = SelectedTaskListBloc();
    _selectedTaskListBloc.selectTaskList(selectedTaskList);

    _dashboardBloc = dashboardBloc;
    _proximityIn = false;
    _paused = false;
    bool _proximityFirst = true;

    () async {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      if (androidInfo.isPhysicalDevice) {
        proxSubscription = proximityEvents.listen((event) {
          // Workout for starting event...
          if (_proximityFirst) {
            _proximityFirst = false;
            return;
          }
          _proximityIn = !_proximityIn;

          if (_proximityIn) {
            print('IN');
            _startProx = DateTime.now();
          } else {
            print('OUT');
            final _endProx = DateTime.now();
            final duration = _endProx.difference(_startProx);
            print("Duration ${duration.inSeconds}");
            if (duration >= Duration(seconds: 2)) {
              _selectedTaskListBloc.completeCurrentTask();
            } else {
              if (_paused)
                _selectedTaskListBloc.resumeCurrentTasks();
              else
                _selectedTaskListBloc.pauseCurrentTasks();

              _paused = !_paused;
            }
          }
        });
      }
    }();
  }

  _startTimeCounter() {
    if (_timer != null && _timer.isActive) return;
    print("started");
    if (mounted) setState(() {});
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (_) {
        if (mounted)
          setState(
            () {},
          );
      },
    );
  }

  _stopTimeCounter() {
    print("stoped");
    _timer?.cancel();
    setState(() {});
  }

  @override
  void dispose() {
    proxSubscription?.cancel();
    _timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TaskList _taskList = _selectedTaskListBloc.selectedTaskList;

    _updateCurrentTaskListSettings(TaskList updatedTaskList) {
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
              backgroundColor: CustomColors.primaryDarkColor,
              actions: <Widget>[
                IconButton(
                  onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReportScreen(_taskList)))
                  },
                  icon: Icon(Icons.receipt),
                ),
                IconButton(
                  onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TaskListSettingsScreen(
                                _taskList, _dashboardBloc))).then((value) {
                      if (value != null) _updateCurrentTaskListSettings(value);
                      _dashboardBloc.saveTaskLists();
                    })
                  },
                  icon: Icon(Icons.settings),
                ),
                Builder(
                    builder: (ctx) => IconButton(
                          onPressed: () {
                            _deleteCurrentTaskList(ctx);
                            _dashboardBloc.saveTaskLists();
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
                      uuid: Uuid().v4().toString(),
                      title: title,
                      description: description);

                  _taskList.addTask(task);
                  _selectedTaskListBloc.updateTaskList(_taskList);
                  _dashboardBloc.saveTaskLists();
                });
              },
              child: Icon(Icons.add),
              backgroundColor: CustomColors.primaryDarkColor,
            ),
            body: _taskList.tasks == null
                ? Text(TASK_LIST_EMPTY)
                : Container(
                  color: CustomColors.lighGrey,
                    padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
                    width: double.maxFinite,
                    child: _buildListOfTasks(_taskList, _selectedTaskListBloc),
                  ),
          );
        });
  }

  Widget _buildListOfTasks(TaskList taskList, SelectedTaskListBloc bloc) {
    return ListView.builder(
        itemCount: taskList.tasks?.length,
        itemBuilder: (context, index) {
          Task task = taskList.tasks[index];
          return _buildTaskCard(task, bloc);
        });
  }

  Widget _buildTaskCard(Task task, SelectedTaskListBloc bloc) {
    final _styles = ScreenStyles();

    return Card(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          title: Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Text(
                task.title,
                style: _styles.taskCardTitle,
              )),
          subtitle: Text(task.description),
          isThreeLine: true,
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: <Widget>[
              Text(task.currentSession.format()),
              VerticalDivider(),
              Text(task.totalDuration.format()),
              VerticalDivider(),
              Text("${task.attachmentPaths.length} attachments"),
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
                Navigator.of(dialogContext).pop();
              },
              child: CircleAvatar(
                child: Icon(Icons.close),
                backgroundColor: CustomColors.primaryDarkColor,
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
                    color: CustomColors.primaryLightColor,
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
      _dashboardBloc.saveTaskLists();
      SoundPlayer.playClickSound();
    }

    if (task.status == TaskStatus.inProgress)
      actions.add(FlatButton(
        child: Text(TASK_ACTION_RESUME),
        textColor: CustomColors.primaryColor,
        onPressed: () => _startTask(),
      ));

    if (task.status == TaskStatus.none)
      actions.add(FlatButton(
        child: Text(TASK_ACTION_START),
        textColor: CustomColors.primaryColor,
        onPressed: () => _startTask(),
      ));

    if (task.status == TaskStatus.doing) {
      actions.add(FlatButton(
        child: Text(TASK_ACTION_PAUSE),
        textColor: CustomColors.primaryColor,
        onPressed: () {
          task.pauseTask();
          _stopTimeCounter();
          _dashboardBloc.saveTaskLists();
          SoundPlayer.playDongSound();
        },
      ));

      actions.add(FlatButton(
        child: Text(TASK_ACTION_DONE),
        textColor: CustomColors.primaryColor,
        onPressed: () {
          task.completeTask();
          _selectedTaskListBloc.completeCurrentTask();
          _selectedTaskListBloc.removeCurrentTask(task);
          _stopTimeCounter();
          _dashboardBloc.saveTaskLists();
          SoundPlayer.playConfirmSound();
        },
      ));
    }

    actions.add(FlatButton(
      child: Text(TASK_ACTION_ADD_ATTACHMENT),
      textColor: CustomColors.primaryColor,
      onPressed: () async {
        final cameras = await availableCameras();

        final firstCamera = cameras.first;

        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) {
          return TakePictureScreen(camera: firstCamera);
        })).then((value) {
          task.addAttachmentPath(value);
          setState(() {});
          _dashboardBloc.saveTaskLists();
        });
      },
    ));
    actions.add(FlatButton(
      child: Text(TASK_ACTION_SHOW_ATTACHMENT),
      textColor: CustomColors.primaryColor,
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return ShowAttachmentScreenState(task: task);
        })).then((value) => _dashboardBloc.saveTaskLists());
      },
    ));

    return actions;
  }
}
