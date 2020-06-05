import 'package:flutter/material.dart';
import 'package:trackthosetasks/assets/strings.dart';
import 'package:trackthosetasks/models/task.dart';
import 'package:trackthosetasks/models/task_list.dart';
import 'package:trackthosetasks/screens/views/styles.dart';

class TaskListScreen extends StatelessWidget {
  final TaskList taskList;

  const TaskListScreen({Key key, this.taskList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(taskList.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
          )
        ],
      ),
      body: taskList.tasks == null ? Text(TASK_LIST_EMPTY) : Container(
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        width: double.maxFinite,
        child: Column(
          children: <Widget>[
            Expanded(
                child: ListView.builder(
                    itemCount: taskList.tasks?.length,
                    itemBuilder: (context, index) {
                      Task task = taskList.tasks[index];

                      return Container(
                          height: 200,
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10.0,
                                    offset: Offset(0.0, 10.0))
                              ]),
                          width: double.maxFinite,
                          child: Container(
                            margin: EdgeInsets.all(16),
                            constraints: BoxConstraints.expand(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  task.title,
                                  style: ScreenStyles().headerTextStyle,
                                ),
                                Container(height: 10.0),
                                Text(
                                  task.description,
                                  style: ScreenStyles().subHeaderTextStyle,
                                )
                              ],
                            ),
                          ));
                    })),
          ],
        ),
      ),
    );
  }
}
