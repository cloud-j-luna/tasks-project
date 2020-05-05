import 'package:flutter/material.dart';
import 'package:trackthosetasks/assets/colors.dart';
import 'package:trackthosetasks/models/task_list.dart';
import 'package:trackthosetasks/screens/views/task_card.dart';

class TaskListView extends StatefulWidget {
  const TaskListView({Key key}) : super(key: key);

  @override
  _TaskListViewState createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  TextEditingController _textController;

  TaskList taskList;

  @override
  void initState() {
    super.initState();

    taskList = new TaskList(uuid: "uuid", name: "test");

    _textController = TextEditingController(
      text: 'task list',
    );
  }

  @override
  Widget build(BuildContext context) {
    return TaskCardView(taskList: taskList);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
