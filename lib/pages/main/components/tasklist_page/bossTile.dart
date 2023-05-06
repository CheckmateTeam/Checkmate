import 'package:checkmate/pages/challenge/mainChallenge.dart';
import 'package:checkmate/provider/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class BossTile extends StatefulWidget {
  const BossTile({super.key});

  @override
  State<BossTile> createState() => _BossTileState();
}

class _BossTileState extends State<BossTile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final taskData = context.watch<CalendarModel>();
    return InkWell(
      onTap: () {
        if (!isSameDay(taskData.focusedDay, DateTime.now())) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  icon: const Icon(Icons.warning_amber_rounded, size: 50),
                  iconColor: Colors.red,
                  title: const Text(
                    "You can only fight the boss on the current day",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("OK"))
                  ],
                );
              });
        } else {
          if (taskData.tasks[DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                  )] ==
                  null ||
              taskData
                      .tasks[DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                  )]
                      .length ==
                  0) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    icon: const Icon(Icons.warning_amber_rounded, size: 50),
                    iconColor: Colors.red,
                    title: const Text(
                      "You need to complete at least one task to fight the boss",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("OK"))
                    ],
                  );
                });
            return;
          } else {
            int taskLength = taskData
                .tasks[DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            )]
                .length;

            int completedTask = 0;
            for (int i = 0; i < taskLength; i++) {
              print(taskData.selectedTasks[i].isDone);
              if (taskData.selectedTasks[i].isDone) {
                completedTask++;
              }
            }

            if (completedTask != taskLength) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      icon: const Icon(Icons.warning_amber_rounded, size: 50),
                      iconColor: Colors.red,
                      title: const Text(
                        "You need to complete all tasks to fight the boss",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("OK"))
                      ],
                    );
                  });
              return;
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      icon: const Icon(Icons.info_outlined, size: 50),
                      iconColor: Color.fromARGB(255, 1, 67, 117),
                      title: const Text(
                        "Enter the boss fight?",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      content: const Text(
                        "You can only fight the boss once a day. You can come back to fight the boss later if you want to complete more tasks.",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      actionsAlignment: MainAxisAlignment.spaceAround,
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel")),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MainChallenge()));
                            },
                            child: const Text("Go"))
                      ],
                    );
                  });
            }
          }
        }
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(99, 158, 158, 158),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, 2), // changes position of shadow
            )
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Image(image: AssetImage("assets/boss/boss.png")),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Current boss",
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
                Text("Ancient Wizard",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  width: 100,
                  child: LinearProgressIndicator(
                    value: 1,
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                ),
                Text("5000/5000")
              ],
            ),
            IconButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.primaries[0]),
                  shape: MaterialStateProperty.all(const CircleBorder()),
                ),
                onPressed: () {
                  if (!isSameDay(taskData.focusedDay, DateTime.now())) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            icon: const Icon(Icons.warning_amber_rounded,
                                size: 50),
                            iconColor: Colors.red,
                            title: const Text(
                              "You can only fight the boss on the current day",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("OK"))
                            ],
                          );
                        });
                  } else {
                    if (taskData.tasks[DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                            )] ==
                            null ||
                        taskData
                                .tasks[DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                            )]
                                .length ==
                            0) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              icon: const Icon(Icons.warning_amber_rounded,
                                  size: 50),
                              iconColor: Colors.red,
                              title: const Text(
                                "You need to complete at least one task to fight the boss",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("OK"))
                              ],
                            );
                          });
                      return;
                    } else {
                      int taskLength = taskData
                          .tasks[DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                      )]
                          .length;

                      int completedTask = 0;
                      for (int i = 0; i < taskLength; i++) {
                        print(taskData.selectedTasks[i].isDone);
                        if (taskData.selectedTasks[i].isDone) {
                          completedTask++;
                        }
                      }

                      if (completedTask != taskLength) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                icon: const Icon(Icons.warning_amber_rounded,
                                    size: 50),
                                iconColor: Colors.red,
                                title: const Text(
                                  "You need to complete all tasks to fight the boss",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("OK"))
                                ],
                              );
                            });
                        return;
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                icon: const Icon(Icons.info_outlined, size: 50),
                                iconColor: Color.fromARGB(255, 1, 67, 117),
                                title: const Text(
                                  "Enter the boss fight?",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                content: const Text(
                                  "You can only fight the boss once a day. You can come back to fight the boss later if you want to complete more tasks.",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                actionsAlignment: MainAxisAlignment.spaceAround,
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Cancel")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const MainChallenge()));
                                      },
                                      child: const Text("Go"))
                                ],
                              );
                            });
                      }
                    }
                  }
                },
                icon: const Icon(Icons.arrow_forward_ios),
                color: Colors.white)
          ],
        ),
      ),
    );
  }
}
