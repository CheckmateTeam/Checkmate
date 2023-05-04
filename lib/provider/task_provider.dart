import 'package:checkmate/model/taskModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}



class CalendarModel extends ChangeNotifier {
  // User instance
  User? get user => FirebaseAuth.instance.currentUser;
  //Firestore instance
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<Task> taskList = [];

  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  List<Task>? _selectedTasks;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  Map<DateTime, List<Task>> _taskMap = {};
  Map<String, bool> _taskStatus = {};

  get focusedDay => _focusedDay;
  get selectedDay => _selectedDay;
  get selectedTasks => _selectedTasks;
  get onDaySelected => _onDaySelected;
  get tasks => _taskMap;
  get getTasksForDay => _getTasksForDay;
  get rangeStart => _rangeStart;
  get rangeEnd => _rangeEnd;
  get calendarFormat => _calendarFormat;
  get taskStatus => _taskStatus;

  CalendarModel() {
    _selectedDay = _focusedDay;
    _selectedTasks = _taskMap[DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        )] ??
        [];
  }

  Future<String> fetchTask() async {
    QuerySnapshot querySnapshot = await db
        .collection('user_task')
        .where('user_uid', isEqualTo: user?.uid)
        .orderBy('startDate')
        .get();
    for (var task in querySnapshot.docs) {
      Task newTask = Task(
        taskId: task['taskId'],
        taskName: task['taskName'],
        taskDesc: task['taskDesc'],
        startDate: (task['startDate'] as Timestamp).toDate(),
        endDate: (task['endDate'] as Timestamp).toDate(),
        cycle: task['cycle'],
        notify: task['notify'],
      );
      final keyDate = DateTime(
        newTask.startDate.year,
        newTask.startDate.month,
        newTask.startDate.day,
      );
      final key = keyDate;

      if (_taskMap.containsKey(key)) {
        if (!_taskMap[key]!.any((t) => t.taskId == newTask.taskId)) {
          _taskMap[key]!.add(newTask);
        }
      } else {
        _taskMap[key] = [newTask];
      }

      final taskIdKey = task['taskId'];
      final isDone = task['isDone'];
      _taskStatus[taskIdKey] = isDone;
    }
    _selectedDay = _focusedDay;
    _selectedTasks = _taskMap[DateTime(
          _selectedDay!.year,
          _selectedDay!.month,
          _selectedDay!.day,
        )] ??
        [];
    await Future.delayed(Duration(milliseconds: 100));
    notifyListeners();
    return 'success';
  }

  _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      notifyListeners();
    }
    DateTime selectedDate = DateTime(
      selectedDay.year,
      selectedDay.month,
      selectedDay.day,
    );
    _selectedTasks = _getTasksForDay(selectedDate);
    // _selectedTasks = _taskMap[selectedDate] ?? [];
    notifyListeners();
  }

  void onFormatChanged(CalendarFormat format) {
    _calendarFormat = format;
    notifyListeners();
  }

  void onPageChanged(DateTime focusedDay) {
    _focusedDay = focusedDay;
    notifyListeners();
  }

  void statusChange(String taskId) {
    _taskStatus[taskId] = !_taskStatus[taskId]!;
    notifyListeners();
  }

  Future<void> updateTask(DateTime day) async {
    fetchTask();
    notifyListeners();
  }

  List<Task> _getTasksForDay(DateTime day) {
    return _taskMap[DateTime(
          day.year,
          day.month,
          day.day,
        )] ??
        [];
  }

  Future<void> addTask(Task task) async {
    await db.collection('user_task').add({
      'user_uid': user?.uid,
      'taskId': const Uuid().v4().toString(),
      'taskName': task.taskName,
      'taskDesc': task.taskDesc,
      'startDate': task.startDate,
      'endDate': task.endDate,
      'cycle': task.cycle,
      'notify': task.notify,
      'isDone': task.isDone,
    });

    notifyListeners();
  }

  void updateDoneTask(Task task) async {
    await db
        .collection('user_task')
        .where('taskId', isEqualTo: task.taskId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs[0].reference
          .update({'isDone': !querySnapshot.docs[0]['isDone']});
    });
    final keyDate = DateTime(
      task.startDate.year,
      task.startDate.month,
      task.startDate.day,
    );
    final key = keyDate;
    if (task.isDone == true) {
      int prevIndex = _taskMap[key]!.indexWhere((t) => t.taskId == task.taskId);
      _taskMap[key]!.remove(task);
      _taskMap[key]!.insert(
          prevIndex,
          Task(
              taskId: task.taskId,
              taskName: task.taskName,
              taskDesc: task.taskDesc,
              startDate: task.startDate,
              endDate: task.endDate,
              cycle: task.cycle,
              notify: task.notify,
              isDone: false));
    } else {
      int prevIndex = _taskMap[key]!.indexWhere((t) => t.taskId == task.taskId);
      _taskMap[key]!.remove(task);
      _taskMap[key]!.insert(
          prevIndex,
          Task(
              taskId: task.taskId,
              taskName: task.taskName,
              taskDesc: task.taskDesc,
              startDate: task.startDate,
              endDate: task.endDate,
              cycle: task.cycle,
              notify: task.notify,
              isDone: true));
    }
    _selectedDay = _focusedDay;
    _selectedTasks = _taskMap[DateTime(
          _selectedDay!.year,
          _selectedDay!.month,
          _selectedDay!.day,
        )] ??
        [];

    notifyListeners();
  }

  void deleteTask(Task task) async {
    await db
        .collection('user_task')
        .where('taskId', isEqualTo: task.taskId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs[0].reference.delete();
    });
    final keyDate = DateTime(
      task.startDate.year,
      task.startDate.month,
      task.startDate.day,
    );
    final key = keyDate;

    if (_taskMap.containsKey(key)) {
      if (_taskMap[key]!.any((t) => t.taskId == task.taskId)) {
        _taskMap[key]!.remove(task);
      }
    }
    _selectedDay = _focusedDay;
    _selectedTasks = _taskMap[DateTime(
          _selectedDay!.year,
          _selectedDay!.month,
          _selectedDay!.day,
        )] ??
        [];
    await Future.delayed(Duration(milliseconds: 100));
    notifyListeners();
  }

  void editTask(Task task, String newTaskName, String newTaskDesc) async {
    await db
        .collection('user_task')
        .where('taskId', isEqualTo: task.taskId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs[0].reference.update({
        'taskName': newTaskName,
        'taskDesc': newTaskDesc,
      });
    });
    final keyDate = DateTime(
      task.startDate.year,
      task.startDate.month,
      task.startDate.day,
    );
    final key = keyDate;

    if (_taskMap.containsKey(key)) {
      if (_taskMap[key]!.any((t) => t.taskId == task.taskId)) {
        _taskMap[key]
            ?.where((element) => element.taskId == task.taskId)
            .first
            .taskName = newTaskName;
        _taskMap[key]
            ?.where((element) => element.taskId == task.taskId)
            .first
            .taskDesc = newTaskDesc;
      }
    }
    _selectedDay = _focusedDay;
    _selectedTasks = _taskMap[DateTime(
          _selectedDay!.year,
          _selectedDay!.month,
          _selectedDay!.day,
        )] ??
        [];
    await Future.delayed(Duration(milliseconds: 100));
    notifyListeners();
  }
}
