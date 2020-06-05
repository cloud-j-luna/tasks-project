import 'dart:async';

import 'package:trackthosetasks/models/task_list.dart';

import 'bloc.dart';

class TaskListBloc implements Bloc {
  TaskList _taskList;
  TaskList get selectedTaskList => _taskList;

  final _taskListController = StreamController<TaskList>();

  Stream<TaskList> get taskListStream => _taskListController.stream;

  void selectTaskList(TaskList taskList) {
    _taskList = taskList;
    _taskListController.sink.add(taskList);
  }

  @override
  void dispose() {
    _taskListController.close();
  }
}