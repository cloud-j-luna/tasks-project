import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:trackthosetasks/assets/colors.dart';
import 'package:trackthosetasks/assets/strings.dart';
import 'package:trackthosetasks/assets/styles.dart';
import 'package:trackthosetasks/models/task_list.dart';

class ReportScreen extends StatefulWidget {
  final TaskList taskList;

  ReportScreen(this.taskList);

  @override
  State<StatefulWidget> createState() => _ReportScreen(this.taskList);
}

class _ReportScreen extends State<ReportScreen> {
  final TaskList taskList;
  _ReportScreen(this.taskList);

  @override
  Widget build(BuildContext context) {
    log((taskList?.settings == null).toString());
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColors.primaryColor,
          title: Text("${taskList.name}$REPORTING_TITLE"),
        ),
        body: SingleChildScrollView(
            child: Container(
          width: double.maxFinite,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[_buildGraph(), Divider(), _buildTotals()],
            ),
          ),
        )));
  }

  Widget _buildGraph() {
    return Container(
      height: 50,
      child: Text("Graph"),
    );
  }

  Widget _buildTotals() {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 3,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: <Widget>[
        _buildGridCard(
            REPORTING_TOTAL_TASKS, Icons.list, taskList.totalTasks.toDouble()),
        _buildGridCard(
            REPORTING_TOTAL_NEW, Icons.note_add, taskList.newTasks.toDouble()),
        _buildGridCard(REPORTING_TOTAL_ACTIVE, Icons.slideshow,
            taskList.activeTasks.toDouble()),
        _buildGridCard(REPORTING_TOTAL_INPROGRESS_TASKS, Icons.access_time,
            taskList.inProgressTasks.toDouble()),
        _buildGridCard(REPORTING_TOTAL_COMPLETED_TASKS, Icons.check,
            taskList.completedTaks.toDouble()),
        _buildGridCard(REPORTING_TIME_SPENT, Icons.timer, taskList.timeSpent,
            REPORTING_SUBTITLE_HOURS),
        _buildGridCard(REPORTING_AVG_TIME_SPENT, Icons.timer,
            taskList.averageTimeSpent.toDouble(), REPORTING_SUBTITLE_HOURS),
      ],
    );
  }

  Widget _buildGridCard(String title, IconData icon, double value,
      [String subtitle]) {
    // If it's a whole number remove decimal part
    String _valueString =
        value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(2);

    return Card(
      elevation: 2.0,
      color: CustomColors.primaryColor,
      child: InkWell(
          highlightColor: CustomColors.secondaryColor,
          splashColor: CustomColors.secondaryColor,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      icon,
                      color: CustomColors.secondaryTextColor,
                      size: 28,
                    ),
                    Spacer(),
                    Text(_valueString,
                        style: ScreenStyles().reportCardStyleNumber),
                  ],
                ),
                Text(subtitle != null ? subtitle : "",
                    textAlign: TextAlign.right,
                    style: ScreenStyles().reportCardStyleSubtitle),
                Spacer(),
                Text(
                  title,
                  style: ScreenStyles().reportCardStyleTitle,
                )
              ],
            ),
          )),
    );
  }
}
