import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:checkmate/model/taskModel.dart';
import 'package:checkmate/provider/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

class EditTask extends StatefulWidget {
  final Task selectedTask;

  const EditTask({super.key, required this.selectedTask});

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskDescController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var selectedTask = widget.selectedTask;
    taskNameController.text = selectedTask.taskName;
    taskDescController.text = selectedTask.taskDesc;
  }

  @override
  Widget build(BuildContext context) {
    Task selectedTask = widget.selectedTask;
    return Wrap(children: [
      Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Edit task",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            const Divider(),
            SizedBox(height: 20),
            TextField(
              controller: taskNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Task name',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: taskDescController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Task description',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.cancel_outlined),
                      label: const Text("Cancel ")),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton.icon(
                      onPressed: () {
                        Provider.of<CalendarModel>(context, listen: false)
                            .editTask(
                          selectedTask,
                          taskNameController.text,
                          taskDescController.text,
                        );
                        AnimatedSnackBar.material(
                          "Task updated",
                          type: AnimatedSnackBarType.info,
                        ).show(context);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.check),
                      label: const Text("Confirm")),
                ),
              ],
            )
          ],
        ),
      ),
    ]);
  }
}
