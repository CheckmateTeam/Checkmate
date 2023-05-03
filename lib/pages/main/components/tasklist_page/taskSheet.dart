import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:checkmate/model/taskModel.dart';
import 'package:checkmate/provider/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'taskEditSheet.dart';

class TaskSheet extends StatefulWidget {
  final Task selectedTask;
  const TaskSheet({super.key, required this.selectedTask});

  @override
  State<TaskSheet> createState() => _TaskSheetState();
}

class _TaskSheetState extends State<TaskSheet> {
  @override
  Widget build(BuildContext context) {
    Task selectedTask = widget.selectedTask;
    return Wrap(children: [
      Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(selectedTask.taskName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            const Divider(
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            Text(selectedTask.taskDesc, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                  "Delete task",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                content: const Text(
                                  "Are you sure you want to delete this task?",
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Cancel")),
                                  TextButton(
                                      onPressed: () async {
                                        AnimatedSnackBar.material(
                                          "Task deleted",
                                          type: AnimatedSnackBarType.error,
                                        ).show(context);
                                        context
                                            .read<CalendarModel>()
                                            .deleteTask(selectedTask);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Delete")),
                                ],
                              );
                            });
                      },
                      icon: const Icon(Icons.delete_outline_sharp),
                      label: const Text("Delete ")),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) =>
                                EditTask(selectedTask: selectedTask));
                      },
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text("Edit")),
                ),
              ],
            )
          ],
        ),
      ),
    ]);
  }
}
