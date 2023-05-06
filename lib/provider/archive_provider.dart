import 'package:checkmate/model/taskModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ArchiveProvider extends ChangeNotifier {
  // User instance
  User? get user => FirebaseAuth.instance.currentUser;
  //Firestore instance
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<Task> _taskList = [];
  Map<DateTime, int> _taskMap = {};
  String? doneTask;
  String? hourAmount;
  String? dayAmount;

  get taskList => _taskList;
  get taskMap => _taskMap;
  ArchiveProvider() {
    fetchWeek();
  }

  Future<void> clearAll() async {
    _taskList.clear();
    _taskMap.clear();
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
                DateTime.now().subtract(const Duration(days: 7)))
        .orderBy('startDate')
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
          notiDate: task['notiDate']
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
    print('fetching month');
    QuerySnapshot querySnapshot = await db
        .collection('user_task')
        .where('user_uid', isEqualTo: user?.uid)
        .where('isDone', isEqualTo: true)
        .where('startDate',
            isGreaterThanOrEqualTo:
                DateTime.now().subtract(const Duration(days: 30)))
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
          notiDate: task['notiDate']
        ));
      }
    }
    // amount tasklist
    for (var task in querySnapshot.docs) {
      final keyDate = DateTime(
        task['startDate'].year,
        task['startDate'].month,
        task['startDate'].day,
      );
      final key = keyDate;

      if (_taskMap.containsKey(key)) {
        _taskMap[key] = _taskMap[key]! + 1;
      } else {
        _taskMap[key] = 1;
      }
      print(_taskMap.length);
      print(_taskList.length);
    }
    notifyListeners();
    return 'success';
  }

  Future<void> fetchYear() async {
    print('fetching year');
    QuerySnapshot querySnapshot = await db
        .collection('user_task')
        .where('user_uid', isEqualTo: user?.uid)
        .where('isDone', isEqualTo: true)
        .where('startDate',
            isGreaterThanOrEqualTo:
                DateTime.now().subtract(const Duration(days: 365)))
        .orderBy('startDate')
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
          notiDate: task['notiDate']
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
    print(_taskList.length);
  }
}
