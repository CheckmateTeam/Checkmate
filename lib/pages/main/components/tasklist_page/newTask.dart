// ignore_for_file: camel_case_types

import 'dart:math';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:checkmate/model/taskModel.dart';
import 'package:checkmate/pages/home.dart';
import 'package:checkmate/pages/main/task_page.dart';
import 'package:checkmate/provider/db.dart';
import 'package:checkmate/provider/task_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../services/noti_service.dart';

class createTask extends StatefulWidget {
  const createTask({super.key});

  @override
  State<createTask> createState() => _createTaskState();
}

class _createTaskState extends State<createTask> {
  bool _validate = false;
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
  String cycle = 'none';
  String dropdownValue = 'Never';
  TextEditingController taskName = TextEditingController();
  TextEditingController taskDescription = TextEditingController();
  TimeOfDay timestart = TimeOfDay.now();
  TimeOfDay timeend = TimeOfDay.now();
  DateTime datestart = DateTime.now();
  DateTime dateend = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Create New Task",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Divider(),
              const Text("Topic",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              TextField(
                controller: taskName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  errorText: _validate ? 'Value Can\'t Be Empty' : null,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("START",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      InkWell(
                        onTap: () async {
                          DateTime? date = await showDatePicker(
                              context: context,
                              initialDate: datestart,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2050));

                          if (date != null) {
                            if (date.isAfter(dateend)) {
                              setState(() {
                                dateend = date;
                              });
                            }
                            setState(() {
                              datestart = date;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 18,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 5),
                            Text(
                                "${datestart.day}  ${DateFormat('MMMM').format(DateTime(0, datestart.month))}  ${datestart.year}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).primaryColor)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () async {
                          TimeOfDay? time = await showTimePicker(
                              context: context, initialTime: timestart);
                          if (time != null) {
                            setState(() {
                              timestart = time;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                  "${DateFormat.jm().format(DateTime(0, 0, 0, timestart.hour, timestart.minute))}",
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("END",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      InkWell(
                        onTap: () async {
                          DateTime? date = await showDatePicker(
                              context: context,
                              initialDate: dateend,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2050));

                          if (date != null) {
                            if (dateend.isBefore(datestart)) {
                              setState(() {
                                datestart = date;
                              });
                            }
                            setState(() {
                              dateend = date;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 18,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 5),
                            Text(
                                "${dateend.day}  ${DateFormat('MMMM').format(DateTime(0, dateend.month))}  ${dateend.year}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).primaryColor)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () async {
                          TimeOfDay? time = await showTimePicker(
                              context: context, initialTime: timeend);
                          if (time != null) {
                            setState(() {
                              timeend = time;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                  "${DateFormat.jm().format(DateTime(0, 0, 0, timeend.hour, timeend.minute))}",
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                    ],
                  )
                ],
              ),
              const Text("Cycle",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const Text("Please use points to enable this feature",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 163, 163, 163),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.shopping_basket_outlined,
                    color: Colors.white,
                  ),
                  label: const Text("Go to points shop",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white))),
              // Container(
              //   height: 50,
              //   decoration: BoxDecoration(
              //     border: Border.all(color: Color.fromARGB(255, 87, 87, 87)!),
              //     borderRadius: BorderRadius.circular(40),
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children: [
              //       Text("Once",
              //           style: TextStyle(
              //               fontSize: 14, fontWeight: FontWeight.bold)),
              //       Text("Daily",
              //           style: TextStyle(
              //               fontSize: 14, fontWeight: FontWeight.bold)),
              //       Text("Weekly",
              //           style: TextStyle(
              //               fontSize: 14, fontWeight: FontWeight.bold)),
              //       Text("Monthly",
              //           style: TextStyle(
              //               fontSize: 14, fontWeight: FontWeight.bold)),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 10),
              const Text("Notify",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              SizedBox(
                width: 350,
                child: DropdownButton(
                  isExpanded: true,
                  value: dropdownValue,
                  items: dropdownItems
                      .map((item) => DropdownMenuItem(
                            child: Text(item),
                            value: item,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      dropdownValue = value.toString();
                    });
                  },
                ),
              ),
              const SizedBox(height: 5),
              const Text("Description",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              TextField(
                controller: taskDescription,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  errorText: _validate ? 'Value Can\'t Be Empty' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          ElevatedButton(
              style: ButtonStyle(
                  minimumSize:
                      MaterialStateProperty.all<Size>(const Size(170, 40)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).primaryColor)),
              onPressed: () async {
                int notiId = Random().nextInt(10000);
                if (taskName.text.isEmpty || taskDescription.text.isEmpty) {
                  setState(() {
                    _validate = true;
                  });
                  return;
                }
                context.read<CalendarModel>().addTask(Task(
                    taskName: taskName.text,
                    taskDesc: taskDescription.text,
                    startDate: DateTime(datestart.year, datestart.month,
                        datestart.day, timestart.hour, timestart.minute),
                    endDate: DateTime(dateend.year, dateend.month, dateend.day,
                        timeend.hour, timeend.minute),
                    cycle: cycle,
                    notify: dropdownValue,
                    notiId: notiId));

                AnimatedSnackBar.material("Success! Your task has created",
                        type: AnimatedSnackBarType.success)
                    .show(context);
                Navigator.pop(context, true);
                await Provider.of<CalendarModel>(context, listen: false)
                    .updateTask(DateTime.now());
                NotificationService().scheduledNotification(
                    title: taskName.text,
                    body: taskDescription.text,
                    month: datestart.month,
                    day: datestart.day,
                    hour: timestart.hour,
                    minutes: timestart.minute,
                    id: notiId);
              },
              child: const Text("Create",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)))
        ],
      ),
    );
  }
}
