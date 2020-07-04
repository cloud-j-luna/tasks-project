import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:trackthosetasks/BLoC/bloc_provider.dart';
import 'package:trackthosetasks/BLoC/dashboard_bloc.dart';
import 'package:trackthosetasks/assets/colors.dart';
import 'package:trackthosetasks/assets/strings.dart';
import 'package:trackthosetasks/assets/styles.dart';
import 'package:trackthosetasks/models/task_list.dart';
import 'package:trackthosetasks/screens/views/profile_screen.dart';
import 'package:trackthosetasks/screens/views/task_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreen createState() => _DashboardScreen();
}

class _DashboardScreen extends State<DashboardScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // These are the callbacks
    switch (state) {
      case AppLifecycleState.resumed:
        // _dashBoardBloc.getFromFile();
        break;
      case AppLifecycleState.inactive:
        // widget is inactive
        break;
      case AppLifecycleState.paused:
        // widget is paused
        break;
      case AppLifecycleState.detached:
        // widget is detached
        break;
    }
  }

  final _styles = ScreenStyles();

  DashboardBloc _dashBoardBloc;
  @override
  Widget build(BuildContext context) {
    // final _appBloc = AppBloc();

    _dashBoardBloc = DashboardBloc();

    return Scaffold(
      appBar: AppBar(
        title: Text("YOUR LISTS"),
        backgroundColor: CustomColors.primaryDarkColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
          )
        ],
      ),
      body: _buildSearch(context, _dashBoardBloc),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return _buildAddTaskListForm(context, dialogContext);
              }).then((value) {
            if (value == null) return;
            print(value);
            _dashBoardBloc.addTaskList(value);
          });
        },
        child: Icon(Icons.add),
        backgroundColor: CustomColors.primaryDarkColor,
      ),
    );
  }

  Widget _buildSearch(BuildContext context, DashboardBloc bloc) {
    return BlocProvider<DashboardBloc>(
      bloc: bloc,
      child: Ink(
          color: CustomColors.lighGrey,
          child: Column(
            children: <Widget>[
              Expanded(child: _buildStreamBuilder(bloc)),
            ],
          )),
    );
  }

  Widget _buildStreamBuilder(DashboardBloc bloc) {
    return StreamBuilder(
      stream: bloc.listsStream,
      builder: (context, snapshot) {
        final results = snapshot.data;

        if (results == null) {
          // bloc.getFromFile();
          return Center(child: Text('Error no Lists'));
        }

        if (results.isEmpty) {
          return Center(child: Text('No Results'));
        }

        return _buildSearchResults(results);
      },
    );
  }

  Widget _buildSearchResults(List<TaskList> results) {
    results.sort((t1, t2) => t1.name.compareTo(t2.name));
    results.sort((t1, t2) => t1.isFavourite ? 0 : 1);

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final taskList = results[index];
        return _taskListItem_card(context, taskList);
      },
    );
  }

  Widget _taskListItem(BuildContext context, TaskList taskList) {
    return ListTile(
      onTap: () {
        log("Opening list:  ${taskList.name}");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TaskListScreen(
                      taskList,
                      _dashBoardBloc,
                    ))).then((value) => setState(
              () {},
            ));
      },
      leading: IconButton(
          icon: taskList.isFavourite
              ? Icon(Icons.favorite)
              : Icon(Icons.favorite_border),
          onPressed: () {
            print('favourite toggle');
            taskList.toggleFavourite();
            _dashBoardBloc.saveTaskLists();
          }),
      title: Text(
        taskList.name,
        style: _styles.dashboardTaskListItem,
      ),
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }

  Widget _taskListItem_card(BuildContext context, TaskList taskList) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: GestureDetector(
          
            onTap: () {
              log("Opening list:  ${taskList.name}");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TaskListScreen(
                            taskList,
                            _dashBoardBloc,
                          ))).then((value) => setState(
                    () {},
                  ));
            },
            child: Card(
              child: Wrap(
                direction: Axis.horizontal,
                children: <Widget>[
                  ListTile(
                    trailing: IconButton(
                        icon: taskList.isFavourite
                            ? Icon(Icons.favorite)
                            : Icon(Icons.favorite_border),
                        onPressed: () {
                          print('favourite toggle');
                          taskList.toggleFavourite();
                          _dashBoardBloc.saveTaskLists();
                        }),
                    title: Text(
                      taskList.name,
                      style: _styles.dashboardTaskListItem,
                    ),
                  ),
                  Divider(),
                  Center(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(25, 5, 25, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Tasks: ${taskList.totalTasks}"),
                              Spacer(),
                              Text("Completed: ${taskList.completedTaks}"),
                              Spacer(),
                              Text("Active: ${taskList.activeTasks}"),
                            ],
                          ))),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(25, 5, 25, 15),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                              child: LinearProgressIndicator(
                                  semanticsLabel: "Completiong %",
                                  semanticsValue: "33%",
                                  backgroundColor:
                                      CustomColors.primaryLightColor,
                                  valueColor: AlwaysStoppedAnimation(
                                      CustomColors.primaryDarkColor),
                                  value: taskList.totalTasks == 0
                                      ? 0
                                      : taskList.completedTaks /
                                          taskList.totalTasks)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  Widget _buildAddTaskListForm(
      BuildContext context, BuildContext dialogContext) {
    TextEditingController _textController = TextEditingController();

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
                    controller: _textController,
                    decoration: InputDecoration(hintText: TASK_LIST_NAME_LABEL),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text(TASK_LIST_CREATE),
                    color: CustomColors.primaryLightColor,
                    onPressed: () {
                      Navigator.pop(dialogContext, _textController.text);
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
}
