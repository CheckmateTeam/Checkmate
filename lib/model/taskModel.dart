class Task {
  String taskId;
  String taskName;
  String taskDesc;
  DateTime startDate;
  DateTime endDate;
  String cycle;
  String notify;
  bool isDone;
  int notiId;
  bool isRead;
  DateTime notiDate;
  Task({
    this.taskId = '',
    required this.taskName,
    required this.taskDesc,
    required this.startDate,
    required this.endDate,
    required this.cycle,
    required this.notify,
    this.notiId = 0,
    this.isRead = false,
    this.isDone = false,
    required this.notiDate
  });
}
