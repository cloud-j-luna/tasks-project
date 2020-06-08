import 'dart:developer';

import 'package:trackthosetasks/BLoC/bloc.dart';
import 'package:trackthosetasks/BLoC/dashboard_bloc.dart';
import 'package:trackthosetasks/BLoC/task_list_bloc.dart';

class AppBloc implements Bloc {
  DashboardBloc _dashboardBloc;
  SelectedTaskListBloc _selectedTaskListBloc;
  AppBloc() {
    _dashboardBloc = DashboardBloc();
    _selectedTaskListBloc = SelectedTaskListBloc();
    // _selectedTaskListBloc.taskListStream.listen((void _) {
    //   log(_selectedTaskListBloc.selectedTaskList.toString());
    //   if (_selectedTaskListBloc.selectedTaskList == null) return;

    //   if (_selectedTaskListBloc.selectedTaskList?.uuid == null)
    //     _dashboardBloc.addTaskList(_selectedTaskListBloc.selectedTaskList.name);
    //   else
    //     _dashboardBloc.updateTaskList(_selectedTaskListBloc.selectedTaskList);
    // });
  }

  DashboardBloc get dashboardBloc => _dashboardBloc;
  SelectedTaskListBloc get taskListBloc => _selectedTaskListBloc;

  @override
  void dispose() {
    _dashboardBloc.dispose();
    _selectedTaskListBloc.dispose();
  }
}
