import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:trackthosetasks/models/task.dart';
import 'package:trackthosetasks/models/task_list.dart';

final String url = "http://34.78.149.80:30105/task-lists";

class TaskListService {
  Future<List<TaskList>> get taskLists async {
    var response = await http.get(url);

    if (response.statusCode != 200)
      throw Exception(
          "Failed to get data. Status code: ${response.statusCode}");

    return _decodeData(response.body);
  }

  void saveTaskLists(List<TaskList> lists) async {
    var json = jsonEncode(lists);

    print(json);
    var response = await http.post(url,
        headers: {'content-type': 'application/json'}, body: json);
    print(response.body);
    
    if (response.statusCode != 204) throw Exception("Failed to save. Status code ${response.statusCode}");
  }


  List<TaskList> _decodeData(String file) {
    List<TaskList> taskLists = new List<TaskList>();

    var jsonObj = jsonDecode(file);
    for (dynamic obj in jsonObj) {
      TaskList taskList = new TaskList(name: obj['_name'], uuid: obj['_uuid']);

      taskList.isFavourite = obj['_isFavourite'] ?? false;

      taskList.id = obj['id'];
      taskList.settings = TaskListSettings.fromJson(obj['_settings']);

      taskList.tasks = (obj['_tasks'] as List)
          .map((parsedJson) => Task.fromJson(parsedJson))
          .toList();

      taskLists.add(taskList);
    }
    return taskLists;
  }
}
