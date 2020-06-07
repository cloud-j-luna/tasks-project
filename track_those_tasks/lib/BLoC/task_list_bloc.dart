import 'dart:async';

import 'package:trackthosetasks/models/task_list.dart';

import 'bloc.dart';

class SelectedTaskListBloc implements Bloc {
  TaskList _taskList;
  TaskList get selectedTaskList => _taskList;

  final _taskListController = StreamController<TaskList>.broadcast();

  SelectedTaskListBloc() {
    taskListStream.listen((taskList) {
      _taskList = taskList;
    });
  }

  Stream<TaskList> get taskListStream => _taskListController.stream;

  Sink<TaskList> get updateTaskList => _taskListController.sink;

  @override
  void dispose() {
    _taskListController.close();
  }
}
