import 'package:trackthosetasks/models/task.dart';

class TaskList {
  final String uuid;
  String name;
  List<Task> tasks;
  TaskListSettings settings;

  TaskList({this.uuid, this.name}) {
    this.tasks = List<Task>();
    this.settings = TaskListSettings();
  }

  void addTask(Task task) {
    if (task == null) return;
    this.tasks.add(task);
  }

  @override
  String toString() {
    return "[${uuid.toString()}] : $name - ${tasks.length} tasks ";
  }

/* TOTALS */
  int get totalTasks => this.tasks.length;

  int get completedTaks =>
      this.tasks.where((element) => element.status == TaskStatus.done).length;

  int get inProgressTasks => this
      .tasks
      .where((element) => element.status == TaskStatus.inProgress)
      .length;

  int get newTasks =>
      this.tasks.where((element) => element.status == TaskStatus.none).length;

  int get activeTasks =>
      this.tasks.where((element) => element.status == TaskStatus.doing).length;

  double get timeSpent {
    Duration totalDuration =
        this.tasks.fold(Duration(), (sum, task) => sum + task.totalDuration);

    double timeSpent = totalDuration.inHours +
        (totalDuration.inMinutes / 60) +
        (totalDuration.inSeconds / 3600);
    return timeSpent;
  }

  double get averageTimeSpent {
    int totalIntervals = 0;
    Duration totalDuration = Duration();

    this.tasks.forEach((t) {
      t.intervals.forEach((i) {
        totalDuration += i;
        totalIntervals++;
      });
    });

    double timeSpent = totalDuration.inHours +
        (totalDuration.inMinutes / 60) +
        (totalDuration.inSeconds / 3600);

    return timeSpent / totalIntervals;
  }
}

class TaskListSettings {
  bool allowsSimultaneousTasks;

  TaskListSettings() {
    this.allowsSimultaneousTasks = false;
  }
}
