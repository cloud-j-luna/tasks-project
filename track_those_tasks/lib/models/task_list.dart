import 'package:trackthosetasks/models/task.dart';

class TaskList {
  final String uuid;
  String name;
  List<Task> tasks;
  TaskListSettings settings;

  TaskList({this.uuid, this.name}) {
    this.tasks = List<Task>();
    this.settings = TaskListSettings();
  }

  void addTask(Task task) {
    if (task == null) return;
    this.tasks.add(task);
  }

  @override
  String toString() {
    return "[${uuid.toString()}] : $name - ${tasks.length} tasks ";
  }
}

class TaskListSettings {
  bool allowsSimultaneousTasks;

  TaskListSettings() {
    this.allowsSimultaneousTasks = false;
  }
}
