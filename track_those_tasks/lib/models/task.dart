class Task {
  final String uuid;
  String title;
  String description;
  String status = "new";

  Task({this.uuid, this.title, this.description});

  factory Task.fromJson(Map<String, dynamic> parsedJson) {
    return Task(
        uuid: parsedJson['uuid'] as String,
        title: parsedJson['title'] as String,
        description: parsedJson['description'] as String);
  }
}
