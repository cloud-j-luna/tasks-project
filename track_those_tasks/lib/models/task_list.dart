import 'package:trackthosetasks/models/task.dart';

class TaskList {
  String id;
  final String uuid;
  String name;
  bool isFavourite;
  List<Task> tasks;
  TaskListSettings settings;

  TaskList({this.uuid, this.name}) {
    this.tasks = List<Task>();
    this.settings = TaskListSettings();
    this.isFavourite = false;
  }

  void addTask(Task task) {
    if (task == null) return;
    this.tasks.add(task);
  }

  @override
  String toString() {
    return "[${uuid.toString()}] : $name - ${tasks.length} tasks ";
  }

  Map<String, dynamic> toJson() => {
        'uuid': this.uuid.toString(),
        'name': this.name,
        'isFavourite': this.isFavourite,
        'tasks': this.tasks,
        'settings': this.settings
      };

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
  bool isContinous;

  TaskListSettings() {
    this.allowsSimultaneousTasks = false;
    this.isContinous = false;
  }

  factory TaskListSettings.fromJson(Map<String, dynamic> parsedJson) {
    TaskListSettings self = TaskListSettings();
    self.allowsSimultaneousTasks =
        parsedJson['_allowsSimultaneousTasks'] ?? false;
    self.isContinous = parsedJson['isContinous'] ?? false;
    return self;
  }

  Map<String, dynamic> toJson() => {
        'allowsSimultaneousTasks': this.allowsSimultaneousTasks,
        'isContinous': this.isContinous,
      };
}
