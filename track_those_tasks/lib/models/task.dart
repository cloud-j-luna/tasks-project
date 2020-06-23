class Task {
  final String uuid;
  String title;
  String description;
  TaskStatus status;
  List<Duration> intervals;
  List<String> attachmentPaths;
  DateTime startTimestamp;
  DateTime completeDate;

  Task({this.uuid, this.title, this.description}) {
    this.status = TaskStatus.none;
    this.intervals = List<Duration>();
    this.attachmentPaths = List<String>();
  }

  factory Task.fromJson(Map<String, dynamic> parsedJson) {
    return Task(
        uuid: parsedJson['uuid'] as String,
        title: parsedJson['title'] as String,
        description: parsedJson['description'] as String);
  }

  Duration get currentSession {
    if (startTimestamp == null) return null;

    final end = DateTime.now();

    return end.difference(startTimestamp);
  }

  Duration get totalDuration {
    Duration total = Duration();

    intervals.forEach((i) {
      total += i;
    });

    Duration currentSession = this.currentSession;
    return currentSession == null ? total : total + currentSession;
  }

  void addAttachmentPath(String path) {
    this.attachmentPaths.add(path);
  }

  void removeAttachmentPath(int index){
    this.attachmentPaths.removeAt(index);
  }

  void startTask() {
    this.status = TaskStatus.doing;
    startTimestamp = DateTime.now();
  }

  void pauseTask() {
    this.status = TaskStatus.inProgress;
    _endInterval();
  }

  void finishTask() {
    this.status = TaskStatus.done;
    this.completeDate = DateTime.now();
    _endInterval();
  }

  void archiveTask() {
    this.status = TaskStatus.archived;
    _endInterval();
  }

  void _endInterval() {
    if (startTimestamp == null) return;

    final end = DateTime.now();

    intervals.add(end.difference(startTimestamp));
    startTimestamp = null;
  }
}

enum TaskStatus { none, inProgress, doing, done, archived }
