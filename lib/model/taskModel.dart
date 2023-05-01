class Task {
  String taskId;
  String taskName;
  String taskDesc;
  DateTime startDate;
  DateTime endDate;
  String cycle;
  String notify;
  bool isDone;
  Task({
    this.taskId = '',
    required this.taskName,
    required this.taskDesc,
    required this.startDate,
    required this.endDate,
    required this.cycle,
    required this.notify,
    this.isDone = false,
  });
}
