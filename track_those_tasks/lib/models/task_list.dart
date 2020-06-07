import 'package:trackthosetasks/models/task.dart';

class TaskList {
  final String uuid;
  String name;
  List<Task> tasks;

  TaskList({this.uuid, this.name}) {
    this.tasks = List<Task>();
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
