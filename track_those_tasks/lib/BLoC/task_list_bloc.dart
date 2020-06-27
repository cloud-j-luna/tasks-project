import 'dart:async';
import 'dart:developer';

import 'package:trackthosetasks/models/task_list.dart';
import 'package:trackthosetasks/models/task.dart';

import 'bloc.dart';

class SelectedTaskListBloc implements Bloc {
  TaskList _taskList;
  TaskList get selectedTaskList => _taskList;
  List<Task> currentTasks = List<Task>();

  final _taskListController = StreamController<TaskList>();

  Stream<TaskList> get taskListStream => _taskListController.stream;

  // Sink<TaskList> get updateTaskList => _taskListController.sink;

  void selectTaskList(TaskList taskList) {
    _taskList = taskList;
    _taskListController.add(_taskList);
  }

  void updateTaskList(TaskList taskList) {
    log("Updating TaskList : ${taskList.name}");
    // TODO Update this to its own logic
    this.selectTaskList(taskList);
  }

  void checkSimultaneousTasks() {
    if (_taskList.settings.allowsSimultaneousTasks) return;

    _taskList.tasks.forEach((task) {
      if (task.status == TaskStatus.doing) task.pauseTask();
    });
  }

  void addCurrentTask(Task task) {
    if (currentTasks.indexWhere((t) => t.uuid == task.uuid) >= 0) return;
    if (!_taskList.settings.allowsSimultaneousTasks) {
      currentTasks.clear();
    }
    currentTasks.add(task);
  }

  void removeCurrentTask(Task task) {
    currentTasks.removeWhere((t) => t.uuid == task.uuid);
  }

  void pauseCurrentTasks() {
    currentTasks.forEach((task) {
      task.pauseTask();
    });
    _taskListController.add(_taskList);
  }

  void resumeCurrentTasks() {
    if (currentTasks.isEmpty) return;
    currentTasks.forEach((task) {
      task.startTask();
    });
    _taskListController.add(_taskList);
  }

  void completeCurrentTask() {
    if (currentTasks.isEmpty) return;

    currentTasks.forEach((task) {
      task.completeTask();
    });

    if (_taskList.settings.isContinous) {
      var indexCurrentTask = _taskList.tasks.indexOf(currentTasks.first);
      var indexNextTask = indexCurrentTask + 1;
      while (indexNextTask < _taskList.tasks.length) {
        final task = _taskList.tasks[indexNextTask];
        if (task.status == TaskStatus.none ||
            task.status == TaskStatus.inProgress) {
          task.startTask();
          addCurrentTask(task);
          break;
        }

        indexNextTask++;
      }
    }
  }

  @override
  void dispose() {
    _taskListController.close();
  }
}
