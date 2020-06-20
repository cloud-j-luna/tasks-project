import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trackthosetasks/assets/strings.dart';
import 'package:trackthosetasks/models/task.dart';

class ShowAttachmentScreenState extends StatefulWidget {
  final Task task;

  ShowAttachmentScreenState({Key key, this.task}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ShowAttachmentScreenState();
}

class _ShowAttachmentScreenState extends State<ShowAttachmentScreenState> {
  @override
  Widget build(BuildContext context) {
    Task _task = widget.task;

    return Scaffold(
        appBar: AppBar(
          title: Text("${_task.title}'s attachments"),
        ),
        body: Padding(
          padding: EdgeInsets.all(5),
          child: GridView.count(
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
              crossAxisCount: 2,
              // Generate 100 widgets that display their index in the List.
              children: _buildGridElements(_task)),
        ));
  }

  List<Widget> _buildGridElements(Task task) {
    List<Widget> widgets = List<Widget>();

    task.attachmentPaths.asMap().forEach((index, e) {
      widgets.add(Padding(
          padding: EdgeInsets.all(5),
          child: Stack(children: <Widget>[
            Center(
                child: Image.file(File(e),
                    alignment: Alignment.center,
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.fitWidth)),
            new Align(
              alignment: Alignment.topRight,
              child: FloatingActionButton(
                  mini: true,
                  child: new Icon(Icons.close),
                  onPressed: () {
                    task.removeAttachmentPath(index);
                    setState(() {});
                  }),
            )
          ])));
    });

    return widgets;
  }
}
