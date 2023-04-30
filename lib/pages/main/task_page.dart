import 'package:checkmate/pages/challenge/mainChallenge.dart';
import 'package:checkmate/pages/main/components/tableCalendar.dart';
import 'package:checkmate/pages/main/components/taskList.dart';
import 'package:checkmate/pages/main/utilities/utils.dart';
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
    // TODO: implement initState
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    context.read<CalendarModel>().init();
    return Scaffold(
      body: Column(children: const [
        Tablecalendar(),
        TaskList(),
      ]),
    );
  }
}



// postiton
// Positioned(
//   left: 200,
//   child: ElevatedButton(
//       onPressed: () {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) =>
//                     const MainChallenge()));
//       },
//       child: Icon(
//         Icons.fire_extinguisher_outlined,
//         size: 30,
//         color: Colors.white,
//       ),
//       style: ElevatedButton.styleFrom(
//         primary: Colors.red,
//         padding: const EdgeInsets.symmetric(
//             horizontal: 20.0, vertical: 20.0),
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(40.0)),
//       )),
// )
