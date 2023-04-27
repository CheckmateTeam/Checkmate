class Task {
  String userId;
  String taskId;
  String taskName;
  String taskDesc;
  DateTime createAt;
  DateTime endDate;
  String cycle;
  String notify;

  Task({
    required this.userId,
    required this.taskId,
    required this.taskName,
    required this.taskDesc,
    required this.createAt,
    required this.endDate,
    required this.cycle,
    required this.notify,
  });
}
