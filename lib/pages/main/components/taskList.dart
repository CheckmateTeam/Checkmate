import 'dart:collection';
import 'dart:ui';

import 'package:checkmate/model/taskModel.dart';
import 'package:checkmate/pages/main/components/taskSheet.dart';
import 'package:checkmate/provider/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  late Future<String> _myFuture;

  @override
  void initState() {
    super.initState();
    _myFuture = Provider.of<CalendarModel>(context, listen: false).fetchTask();
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<CalendarModel>();
    return FutureBuilder(
      future: _myFuture,
      builder: (context, AsyncSnapshot snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? const Center(child: CircularProgressIndicator())
          : snapshot.hasData
              ? data.selectedTasks.isEmpty
                  ? Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "No task",
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.selectedTasks.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${data.selectedTasks[index].startDate.hour}:${data.selectedTasks[index].startDate.minute.toString().length == 1 ? "0${data.selectedTasks[index].startDate.minute}" : data.selectedTasks[index].startDate.minute}",
                                          style: const TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                        const Text(
                                          "|",
                                          style: TextStyle(
                                              fontSize: 27, color: Colors.grey),
                                        ),
                                        Text(
                                          "${data.selectedTasks[index].endDate.hour}:${data.selectedTasks[index].endDate.minute.toString().length == 1 ? "0${data.selectedTasks[index].endDate.minute}" : data.selectedTasks[index].endDate.minute}",
                                          style: const TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                      ],
                                    ),

                                    // Task tile here =>>
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          showModalBottomSheet<dynamic>(
                                              isScrollControlled: true,
                                              context: context,
                                              builder: (context) => TaskSheet(
                                                    selectedTask: data
                                                        .selectedTasks[index],
                                                  ));
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20.0),
                                          decoration: BoxDecoration(
                                            color: data.taskStatus[data
                                                    .selectedTasks[index]
                                                    .taskId]
                                                ? Colors.grey[200]
                                                : Colors.white,
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color.fromARGB(
                                                    99, 158, 158, 158),
                                                spreadRadius: 0,
                                                blurRadius: 10,
                                                offset: Offset(0,
                                                    2), // changes position of shadow
                                              )
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          margin:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Padding(
                                            padding: const EdgeInsets.all(14.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const CircleAvatar(
                                                      child: Icon(
                                                          Icons
                                                              .table_view_sharp,
                                                          color: Colors.red),
                                                    ),
                                                    const SizedBox(width: 15.0),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          data
                                                              .selectedTasks[
                                                                  index]
                                                              .taskName,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                              decoration: data.taskStatus[data
                                                                      .selectedTasks[
                                                                          index]
                                                                      .taskId]
                                                                  ? TextDecoration
                                                                      .lineThrough
                                                                  : TextDecoration
                                                                      .none),
                                                        ),
                                                        Text(
                                                          data
                                                                      .selectedTasks[
                                                                          index]
                                                                      .taskDesc
                                                                      .length >
                                                                  15
                                                              ? data
                                                                      .selectedTasks[
                                                                          index]
                                                                      .taskDesc
                                                                      .substring(
                                                                          0,
                                                                          15) +
                                                                  "..."
                                                              : data
                                                                  .selectedTasks[
                                                                      index]
                                                                  .taskDesc,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              decoration: data.taskStatus[data
                                                                      .selectedTasks[
                                                                          index]
                                                                      .taskId]
                                                                  ? TextDecoration
                                                                      .lineThrough
                                                                  : TextDecoration
                                                                      .none),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Checkbox(
                                                  value: data.taskStatus[data
                                                      .selectedTasks[index]
                                                      .taskId],
                                                  onChanged: (bool? value) {
                                                    data.statusChange(data
                                                        .selectedTasks[index]
                                                        .taskId);
                                                    data.updateDoneTask(
                                                      data.selectedTasks[index]
                                                          .taskId,
                                                    );
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 30.0,
                                    ),
                                    child: Seperator()),
                              ],
                            );
                          }),
                    )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}

Widget Seperator() {
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      final boxWidth = constraints.constrainWidth();
      const dashWidth = 10.0;
      final dashCount = (boxWidth / (2 * dashWidth)).floor();
      return Flex(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        direction: Axis.horizontal,
        children: List.generate(dashCount, (_) {
          return const SizedBox(
            width: dashWidth,
            height: 1.5,
            child: DecoratedBox(
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 214, 213, 213)),
            ),
          );
        }),
      );
    },
  );
}
