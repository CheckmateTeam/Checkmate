class Task {
  String taskName;
  String taskDesc;
  DateTime startDate;
  DateTime endDate;
  String cycle;
  String notify;

  Task({
    required this.taskName,
    required this.taskDesc,
    required this.startDate,
    required this.endDate,
    required this.cycle,
    required this.notify,
  });
}
