import 'package:checkmate/pages/main/components/bossTile.dart';
import 'package:checkmate/pages/main/components/tableCalendar.dart';
import 'package:checkmate/pages/main/components/taskList.dart';
import 'package:checkmate/provider/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    var data = context.watch<CalendarModel>();
    return Scaffold(
      body: Column(children: [
        //Top calendar
        const Tablecalendar(),
        Expanded(
          child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 0,
                    blurRadius: 20,
                    offset: const Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  BossTile(),
                  SizedBox(height: 20),
                  TaskList(),
                ],
              )),
        ),
      ]),
    );
  }
}
