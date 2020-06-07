import 'dart:async';
import 'dart:developer';

import 'package:trackthosetasks/models/task.dart';
import 'package:trackthosetasks/models/task_list.dart';
import 'package:trackthosetasks/services/task_list_service.dart';
import 'package:uuid/uuid.dart';

import 'bloc.dart';

class DashboardBloc implements Bloc {
  final List<TaskList> lists = List<TaskList>();
  final TaskListService service = TaskListService();
  final _controller = StreamController<List<TaskList>>();

  Stream<List<TaskList>> get listsStream => _controller.stream;

  sinkTaskList(TaskList taskList) {
    if (lists.indexWhere((element) => element.uuid == taskList.uuid) >= 0) {
      updateTaskList(taskList);
    } else {
      addTaskList(taskList.name);
    }
  }

  @override
  void dispose() {
    _controller.close();
  }

  void getFromFile() async {
    log("gettings task lists from file");
    lists.clear();
    lists.addAll(await service.taskLists);
    _controller.add(lists);
  }

  void saveToFile() async {
    log("Savint file");
    await service.saveTaskLists(lists);
  }

  void addTaskList(String name) {
    TaskList taskList = TaskList(uuid: Uuid().toString(), name: name);

    lists.add(taskList);
    _controller.add(lists);
  }

  bool removeTaskList(String uuid) {
    final int index = getTaskListIndex(uuid);

    if (index == -1) return false;
    TaskList removedTaskList = lists.removeAt(index);
    return removedTaskList != null;
  }

  bool updateTaskList(TaskList updatedTaskList) {
    int index = getTaskListIndex(updatedTaskList.uuid);
    if (index == -1) return false;
    lists[index] = updatedTaskList;
    _controller.add(lists);
    return true;
  }

  int getTaskListIndex(String uuid) {
    return lists.indexWhere((element) => element.uuid == uuid);
  }

  void addTask(String listUuid, Task task) {
    int index = getTaskListIndex(listUuid);
    TaskList list = lists[index];
    list.addTask(task);
    lists[index] = list;
    _controller.add(lists);
  }
}
