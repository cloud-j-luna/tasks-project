import 'dart:async';

import 'package:trackthosetasks/models/task.dart';

import 'bloc.dart';

class TaskBloc implements Bloc {
  final _controller = StreamController<Task>();



  @override
  void dispose() {
    _controller.close();
  }
}
