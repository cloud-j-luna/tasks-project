import 'package:trackthosetasks/models/task.dart';

class TaskList {
  final String uuid;
  String name; 
  List<Task> tasks = List<Task>();

  TaskList({this.uuid, this.name, this.tasks});
}