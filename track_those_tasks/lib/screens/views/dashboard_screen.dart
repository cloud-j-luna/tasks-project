import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:trackthosetasks/BLoC/bloc_provider.dart';
import 'package:trackthosetasks/BLoC/dashboard_bloc.dart';
import 'package:trackthosetasks/assets/strings.dart';
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
        _dashBoardBloc.getFromFile();
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

  DashboardBloc _dashBoardBloc;
  @override
  Widget build(BuildContext context) {
    // final _appBloc = AppBloc();

    _dashBoardBloc = DashboardBloc();

    return Scaffold(
      appBar: AppBar(
        title: Text("YOUR LISTS"),
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
            print(value);
            _dashBoardBloc.addTaskList(value);
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildSearch(BuildContext context, DashboardBloc bloc) {
    return BlocProvider<DashboardBloc>(
      bloc: bloc,
      child: Column(
        children: <Widget>[
          Expanded(child: _buildStreamBuilder(bloc)),
        ],
      ),
    );
  }

  Widget _buildStreamBuilder(DashboardBloc bloc) {
    return StreamBuilder(
      stream: bloc.listsStream,
      builder: (context, snapshot) {
        final results = snapshot.data;

        if (results == null) {
          bloc.getFromFile();
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
    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        final taskList = results[index];
        return _tempTile(context, taskList);
      },
    );
  }

  Widget _tempTile(BuildContext context, TaskList taskList) {
    return ListTile(
      onTap: () {
        log("Opening list:  ${taskList.name}");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TaskListScreen(
                      taskList,
                      _dashBoardBloc,
                    )));
      },
      title: Text(taskList.name),
      trailing: Icon(Icons.keyboard_arrow_right),
    );
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
                    controller: _textController,
                    decoration: InputDecoration(hintText: TASK_LIST_NAME_LABEL),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text(TASK_LIST_CREATE),
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
