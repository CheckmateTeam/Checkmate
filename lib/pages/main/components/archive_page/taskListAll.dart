import 'package:checkmate/provider/archive_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TaskListAll extends StatefulWidget {
  const TaskListAll({super.key});

  @override
  State<TaskListAll> createState() => _TaskListAllState();
}

class _TaskListAllState extends State<TaskListAll> {
  late Future<String> _myFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _myFuture = Provider.of<ArchiveProvider>(context, listen: false).fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<ArchiveProvider>();
    return FutureBuilder(
      future: _myFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Since ${DateFormat("y/M/d").format(data.firstTaskDate)} - Today",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "You have completed ${data.taskList.length} Tasks",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "with ${20} challenge streaks",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "within ${data.taskMap.length} days",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Stack(alignment: Alignment.center, children: [
                            Text("Goal"),
                            SizedBox(
                              width: 70,
                              height: 70,
                              child: CircularProgressIndicator(
                                strokeWidth: 10,
                                value: 50 / 100,
                                backgroundColor: Colors.grey.withOpacity(0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor),
                              ),
                            ),
                          ]),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "50%",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(children: []),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.taskList.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        color:
                                            Color.fromARGB(99, 158, 158, 158),
                                        spreadRadius: 0,
                                        blurRadius: 10,
                                        offset: Offset(
                                            0, 2), // changes position of shadow
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: const EdgeInsets.only(left: 10.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const CircleAvatar(
                                              child: Icon(
                                                  Icons.table_view_sharp,
                                                  color: Colors.red),
                                            ),
                                            const SizedBox(width: 15.0),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data.taskList[index].taskName,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      decoration:
                                                          TextDecoration.none),
                                                ),
                                                Text(
                                                  data.taskList[index].taskDesc
                                                              .length >
                                                          15
                                                      ? data.taskList[index]
                                                              .taskDesc
                                                              .substring(
                                                                  0, 15) +
                                                          "..."
                                                      : data.taskList[index]
                                                          .taskDesc,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      decoration:
                                                          TextDecoration.none),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Text(
                                            DateFormat('MM/dd').format(
                                                data.taskList[index].startDate),
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[600],
                                                decoration:
                                                    TextDecoration.none)),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 30.0,
                                    ),
                                    child: Seperator()),
                              ],
                            );
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
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
