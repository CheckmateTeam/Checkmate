import 'dart:math';

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
  List<Task> todayNoti = [];
  List<Task> olderNoti = [];

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
  get clearAll => _clearAll;

  CalendarModel() {
    _selectedDay = _focusedDay;
    _selectedTasks = _taskMap[DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        )] ??
        [];
  }
  void _clearAll() {
    _taskMap.clear();
    _taskStatus.clear();
    _selectedTasks!.clear();
    todayNoti.clear();
    olderNoti.clear();
    notifyListeners();
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
        notiDate: (task['notiDate'] as Timestamp).toDate(),
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
      final isRead = task['isRead'];
      final notiId = task['notiId'];
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


  Future<String> fetchNotiTask() async{
    await clearAll();
    print('fetching Noti');
    QuerySnapshot querySnapshot = await db
    .collection('user_task')
        .where('user_uid', isEqualTo: user?.uid)
        .where('notiDate', isLessThan: DateTime.now())
        .orderBy('notiDate')
        .get();

    
      for (final task in querySnapshot.docs) {
        if(isSameDay((task['notiDate'] as Timestamp).toDate(), DateTime.now())){
          
          todayNoti.add(Task(
            taskId: task['taskId'],
            taskName: task['taskName'],
            taskDesc: task['taskDesc'],
            startDate: task['startDate'].toDate(),
            endDate: task['endDate'].toDate(),
            isDone: task['isDone'],
            cycle: task['cycle'],
            notify: task['notify'],
            notiDate: task['notiDate'].toDate()
          ));
        }

        else{
          olderNoti.add(Task(
            taskId: task['taskId'],
            taskName: task['taskName'],
            taskDesc: task['taskDesc'],
            startDate: task['startDate'].toDate(),
            endDate: task['endDate'].toDate(),
            isDone: task['isDone'],
            cycle: task['cycle'],
            notify: task['notify'],
            notiDate: task['notiDate'].toDate()
          ));
        }
      }
    
    for (var task in todayNoti) {
      final keyDate = DateTime(
        task.startDate.year,
        task.startDate.month,
        task.startDate.day,
      );
      final key = keyDate;
    }

    for (var task in olderNoti) {
      final keyDate = DateTime(
        task.startDate.year,
        task.startDate.month,
        task.startDate.day,
      );
      final key = keyDate;
    }
    notifyListeners();
    Duration(milliseconds: 1000);
    return "success";
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
      'notiId': Random().nextInt(10000000),
      'taskId': const Uuid().v4().toString(),
      'taskName': task.taskName,
      'taskDesc': task.taskDesc,
      'startDate': task.startDate,
      'endDate': task.endDate,
      'cycle': task.cycle,
      'notify': task.notify,
      'isDone': task.isDone,
      'isRead': task.isRead,
      'notiDate': task.notiDate
    });

    notifyListeners();
  }

  void updateDoneTask(Task task) async {
    final QuerySnapshot querySnapshot = await db
        .collection('user_task')
        .where('taskId', isEqualTo: task.taskId)
        .get();
    querySnapshot.docs[0].reference
        .update({'isDone': !querySnapshot.docs[0]['isDone']});
    final keyDate = DateTime(
      task.startDate.year,
      task.startDate.month,
      task.startDate.day,
    );
    final key = keyDate;

    int prevIndex = _selectedTasks!.indexWhere((t) => t.taskId == task.taskId);
    _selectedTasks!.remove(task);

    _selectedTasks!.insert(
        prevIndex,
        Task(
            taskId: task.taskId,
            taskName: task.taskName,
            taskDesc: task.taskDesc,
            startDate: task.startDate,
            endDate: task.endDate,
            cycle: task.cycle,
            notify: task.notify,
            isDone: !querySnapshot.docs[0]['isDone'], 
            notiDate: task.notiDate));
    // int prevIndex = _taskMap[key]!.indexWhere((t) => t.taskId == task.taskId);
    // _taskMap[key]!.remove(task);
    // _taskMap[key]!.insert(
    //     prevIndex,
    //     Task(
    //         taskId: task.taskId,
    //         taskName: task.taskName,
    //         taskDesc: task.taskDesc,
    //         startDate: task.startDate,
    //         endDate: task.endDate,
    //         cycle: task.cycle,
    //         notify: task.notify,
    //         isDone: !task.isDone));

    // _selectedDay = _focusedDay;
    // _selectedTasks = _taskMap[DateTime(
    //       _selectedDay!.year,
    //       _selectedDay!.month,
    //       _selectedDay!.day,
    //     )] ??
    //     [];


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

Future<DateTime> convert_notiDate(
    int month, 
    int day, 
    int hour, 
    int minutes, 
    String deadline) async {


    List<String> dropdownItems = [
    'Never',
    '5 mins before deadline',
    '10 mins before deadline',
    '15 mins before deadline',
    '30 mins before deadline',
    '1 hour before deadline',
    '2 hours before deadline',
    '1 day before deadline',
    '2 days before deadline',
    '1 week before deadline'
  ];
      
    
    int x = dropdownItems.indexOf(deadline);

    if(x == 0){minutes += 0;}

    else{
    if(x == 1){minutes -= 5;}
    else if(x == 2){minutes -= 10;}
    else if(x == 3){minutes -= 15;}
    else if(x == 4){minutes -= 30;}
    else if(x == 5){hour -= 1;}
    else if(x == 6){hour -= 2;}
    else if(x == 7){day -= 1;}
    else if(x == 8){day -= 2;}
    else if(x == 9){day -= 7;}

    if(minutes < 0){
      minutes += 60;
      hour -= 1;
    }

    if(hour < 0){
      hour += 24;
      day -= 1;
    }

    if(day <= 0){
      if(month == 2 || month == 4 || month == 6 || month == 8 || month == 9 || month == 11 || month == 1){
        day += 31;
        month -= 1;
      }
      else if(month == 5 || month == 7 || month == 10 || month == 12){
        day += 30;
        month -= 1;
      }
      else{
        day += 28;
        month -= 1;
      }
    }
    }
  
  

    DateTime notiBF = DateTime(
      DateTime.now().year,
      month,
      day,
      hour,
      minutes,
      );


    return notiBF;
  }