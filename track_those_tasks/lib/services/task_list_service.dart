import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:trackthosetasks/models/task.dart';
import 'package:trackthosetasks/models/task_list.dart';

class TaskListService {
  Future<List<TaskList>> get taskLists async {
    final file = await rootBundle.loadString("assets/mock_data.json");

    List<TaskList> taskLists = new List<TaskList>();

    var jsonObj = jsonDecode(file);
    for (dynamic obj in jsonObj) {
      TaskList taskList = new TaskList(name: obj['name'], uuid: obj['uuid']);

      taskList.tasks = (obj['tasks'] as List)
          .map((parsedJson) => Task.fromJson(parsedJson))
          .toList();

      taskLists.add(taskList);
    }
    return taskLists;
  }

  Future<bool> saveTaskLists(List<TaskList> lists) async {
    final file = await rootBundle.loadString("assets/mock_data.json");

    var json = jsonEncode(lists);
    File(file)
      ..createSync(recursive: true)
      ..writeAsString(json);
  }
}
