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
  String? doneTask;
  String? hourAmount;
  String? dayAmount;

  get taskList => _taskList;
  ArchiveProvider() {
    fetchWeek();
  }
  Future<void> fetchWeek() async {
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
        ));
      }
    }

    print(_taskList.length);
  }
}
