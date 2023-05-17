class Task {
  String taskId;
  String taskName;
  String taskDesc;
  DateTime startDate;
  DateTime endDate;
  DateTime notiDate;
  String cycle;
  String notify;
  bool isDone;
  int notiId;
  bool isRead;
  Task({
    this.taskId = '',
    required this.taskName,
    required this.taskDesc,
    required this.startDate,
    required this.endDate,
    required this.notiDate,
    required this.cycle,
    required this.notify,
    this.notiId = 0,
    this.isRead = false,
    this.isDone = false,
    
  });
}
