import 'dart:collection';
import 'package:checkmate/model/taskModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

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
  DateTime? _selectedDay;
  List<Task>? _selectedEvents;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  LinkedHashMap<DateTime, List<Task>> _taskMap =
      LinkedHashMap<DateTime, List<Task>>();
  get focusedDay => _focusedDay;
  get selectedDay => _selectedDay;
  get selectedEvents => _selectedEvents;
  get onDaySelected => _onDaySelected;
  get events => _taskMap;
  get getEventsForDay => _getEventsForDay;
  get rangeStart => _rangeStart;
  get rangeEnd => _rangeEnd;
  get calendarFormat => _calendarFormat;

  CalendarModel() {
    init();
    _selectedDay = _focusedDay;
    _selectedEvents = _taskMap[_selectedDay] ?? [];
    notifyListeners();
  }

  init() {
    _taskMap.clear();
    db
        .collection('user_task')
        .where('user_uid', isEqualTo: user?.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (final task in querySnapshot.docs) {
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
          _taskMap[key]?.add(newTask);
        } else {
          _taskMap[key] = [newTask];
        }
      }
    });
  }

  // void checkKey() {
  //   _taskMap.forEach((key, value) {
  //     print(key.toString() + "    amount:" + value.length.toString());
  //   });
  //   print(selectedDay);
  // }

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
    _selectedEvents = _taskMap[selectedDate] ?? [];
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

  List<Task> _getEventsForDay(DateTime day) {
    return _taskMap[day] ?? [];
  }
}
