import 'package:checkmate/model/taskModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ArchiveProvider extends ChangeNotifier {
  // User instance
  User? get user => FirebaseAuth.instance.currentUser;
  //Firestore instance
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<Task> _taskList = [];
  Map<DateTime, int> _taskMap = {};
  Map<String, int> _taskMapYear = {};
  DateTime _firstTaskDate = DateTime.now();
  String? doneTask;
  String? hourAmount;
  String? dayAmount;

  get taskList => _taskList;
  get taskMap => _taskMap;
  get taskMapYear => _taskMapYear;
  get firstTaskDate => _firstTaskDate;
  ArchiveProvider() {}

  Future<void> clearAll() async {
    _taskList.clear();
    _taskMap.clear();
    _taskMapYear.clear();
    notifyListeners();
  }

  Future<String> fetchWeek() async {
    await clearAll();
    print('fetching week');
    QuerySnapshot querySnapshot = await db
        .collection('user_task')
        .where('user_uid', isEqualTo: user?.uid)
        .where('isDone', isEqualTo: true)
        .where('startDate',
            isGreaterThanOrEqualTo:
                DateTime.now().subtract(const Duration(days: 7)),
            isLessThan: DateTime.now())
        .orderBy('startDate', descending: true)
        .get();

    // normal tasklist
    for (final task in querySnapshot.docs) {
      if (!_taskList.any((t) => t.taskId == task['taskId'])) {
        _taskList.add(Task(
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
    for (var task in _taskList) {
      final keyDate = DateTime(
        task.startDate.year,
        task.startDate.month,
        task.startDate.day,
      );
      final key = keyDate;

      if (_taskMap.containsKey(key)) {
        _taskMap[key] = _taskMap[key]! + 1;
      } else {
        _taskMap[key] = 1;
      }
    }
    notifyListeners();
    Duration(milliseconds: 1000);
    return 'success';
  }

  Future<String> fetchMonth() async {
    await clearAll();
    print('fetching month');
    QuerySnapshot querySnapshot = await db
        .collection('user_task')
        .where('user_uid', isEqualTo: user?.uid)
        .where('isDone', isEqualTo: true)
        .where('startDate',
            isGreaterThanOrEqualTo: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              1,
            ),
            isLessThan: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day + 1,
            ))
        .orderBy('startDate', descending: true)
        .get();

    // normal tasklist
    for (final task in querySnapshot.docs) {
      if (!_taskList.any((t) => t.taskId == task['taskId'])) {
        _taskList.add(Task(
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
    for (var task in _taskList) {
      final keyDate = DateTime(
        task.startDate.year,
        task.startDate.month,
        task.startDate.day,
      );
      final key = keyDate;

      if (_taskMap.containsKey(key)) {
        _taskMap[key] = _taskMap[key]! + 1;
      } else {
        _taskMap[key] = 1;
      }
    }
    notifyListeners();
    Duration(milliseconds: 1000);
    return 'success';
  }

  Future<String> fetchYear() async {
    await clearAll();
    print('fetching Year');
    QuerySnapshot querySnapshot = await db
        .collection('user_task')
        .where('user_uid', isEqualTo: user?.uid)
        .where('isDone', isEqualTo: true)
        .where('startDate',
            isGreaterThanOrEqualTo:
                DateTime.now().subtract(const Duration(days: 30)),
            isLessThan: DateTime.now())
        .orderBy('startDate', descending: true)
        .get();

    // normal tasklist
    for (final task in querySnapshot.docs) {
      if (!_taskList.any((t) => t.taskId == task['taskId'])) {
        _taskList.add(Task(
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
    for (var task in _taskList) {
      String key = task.startDate.month.toString();
      if (_taskMapYear.containsKey(key)) {
        _taskMapYear[key] = _taskMapYear[key]! + 1;
      } else {
        _taskMapYear[key] = 1;
      }
    }
    notifyListeners();
    Duration(milliseconds: 1000);
    return 'success';
  }

  Future<String> fetchAll() async {
    await clearAll();

    print('fetching all');
    QuerySnapshot querySnapshot = await db
        .collection('user_task')
        .where('user_uid', isEqualTo: user?.uid)
        .where('isDone', isEqualTo: true)
        .orderBy('startDate', descending: true)
        .get();

    // normal tasklist
    for (final task in querySnapshot.docs) {
      if (!_taskList.any((t) => t.taskId == task['taskId'])) {
        _taskList.add(Task(
          taskId: task['taskId'],
          taskName: task['taskName'],
          taskDesc: task['taskDesc'],
          startDate: task['startDate'].toDate(),
          endDate: task['endDate'].toDate(),
          isDone: task['isDone'],
          cycle: task['cycle'],
          notify: task['notify'], 
          notiDate: task['notiDate'].toDate(),
        ));
      }
      if (isSameDay(DateTime.now(), _firstTaskDate)) {
        _firstTaskDate = task['startDate'].toDate();
      }
      for (var task in _taskList) {
        final keyDate = DateTime(
          task.startDate.year,
          task.startDate.month,
          task.startDate.day,
        );
        final key = keyDate;

        if (_taskMap.containsKey(key)) {
          _taskMap[key] = _taskMap[key]! + 1;
        } else {
          _taskMap[key] = 1;
        }
      }
    }

    notifyListeners();
    Duration(milliseconds: 1000);
    return 'success';
  }
}
