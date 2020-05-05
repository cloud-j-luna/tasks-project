import 'package:flutter/material.dart';
import 'package:trackthosetasks/models/task_list.dart';

class TaskCardView extends StatefulWidget {
  const TaskCardView({Key key, TaskList taskList}) : super(key: key);

  @override
  _TaskCardViewState createState() => _TaskCardViewState();
}

class _TaskCardViewState extends State<TaskCardView> {
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.album),
              title: Text('The Enchanted Nightingale'),
              subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('BUY TICKETS'),
                  onPressed: () {/* ... */},
                ),
                FlatButton(
                  child: const Text('LISTEN'),
                  onPressed: () {/* ... */},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
