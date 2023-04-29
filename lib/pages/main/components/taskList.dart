import 'package:checkmate/provider/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    CalendarModel calendarmodel = Provider.of<CalendarModel>(context);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: calendarmodel.selectedEvents.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${calendarmodel.selectedEvents[index].startDate.hour}:${calendarmodel.selectedEvents[index].startDate.minute.toString().length == 1 ? "0" + calendarmodel.selectedEvents[index].startDate.minute.toString() : calendarmodel.selectedEvents[index].startDate.minute}",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 27, color: Colors.grey),
                    ),
                    Text(
                      "${calendarmodel.selectedEvents[index].endDate.hour}:${calendarmodel.selectedEvents[index].endDate.minute.toString().length == 1 ? "0" + calendarmodel.selectedEvents[index].endDate.minute.toString() : calendarmodel.selectedEvents[index].endDate.minute}",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),

                // Task tile here =>>
                Expanded(
                  child: InkWell(
                    onTap: () {
                      print("clicked");
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                      margin: const EdgeInsets.only(left: 10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  child: Icon(Icons.table_view_sharp,
                                      color: Colors.red),
                                ),
                                const SizedBox(width: 15.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      calendarmodel
                                          .selectedEvents[index].taskName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      calendarmodel
                                          .selectedEvents[index].taskDesc,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Checkbox(
                              value: false,
                              onChanged: (bool? value) {},
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
                child: Seperator())
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
      final dashHeight = 1;
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
