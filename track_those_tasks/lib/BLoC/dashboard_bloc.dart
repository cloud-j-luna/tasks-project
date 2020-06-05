import 'dart:async';
import 'dart:developer';

import 'package:trackthosetasks/models/task_list.dart';
import 'package:trackthosetasks/services/task_list_service.dart';
import 'package:uuid/uuid.dart';

import 'bloc.dart';

class DashboardBloc implements Bloc {
  final List<TaskList> lists = List<TaskList>();
  final _controller = StreamController<List<TaskList>>();

  void getFromFile() async {
    log("gettings task lists from file");
    TaskListService service = new TaskListService();

    lists.addAll(await service.taskLists);
    _controller.add(lists);
  }

  void addTaskList(String name) {
    TaskList taskList = TaskList(uuid: Uuid().toString(), name: name);

    lists.add(taskList);
    _controller.add(lists);
  }

  Stream<List<TaskList>> get taskListStream => _controller.stream;

  @override
  void dispose() {
    _controller.close();
  }
}
