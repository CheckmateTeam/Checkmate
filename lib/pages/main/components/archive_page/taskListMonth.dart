import 'package:checkmate/provider/archive_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TaskListMonth extends StatefulWidget {
  const TaskListMonth({super.key});

  @override
  State<TaskListMonth> createState() => _TaskListMonthState();
}

class _TaskListMonthState extends State<TaskListMonth> {
  late Map<DateTime, int> barData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    barData = Provider.of<ArchiveProvider>(context, listen: false).taskMap;
  }

  Widget build(BuildContext context) {
    final taskList = context.read<ArchiveProvider>().taskList;
    final barData = context.read<ArchiveProvider>().taskMap;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                taskList.length.toString() + " tasks",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text("01:20:00 hours",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  )),
              Text(taskList.length.toString() + " days",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ))
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        //Chart hereeee
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width - 30,
                child: BarChart(
                  BarChartData(
                    barTouchData: barTouchData,
                    titlesData: titlesData,
                    borderData: borderData,
                    barGroups: barGroups,
                    gridData: FlGridData(show: false),
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 20,
                  ),
                )),
          ],
        ),
        //week
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text(DateFormat('MMMM').format(DateTime(
                  0, DateTime.now().subtract(Duration(days: 7)).month)) +
              " " +
              DateTime.now().subtract(Duration(days: 7)).day.toString() +
              " - " +
              DateFormat('MMMM').format(DateTime(
                  0, DateTime.now().subtract(Duration(days: 1)).month)) +
              " " +
              DateTime.now().subtract(Duration(days: 1)).day.toString()),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: taskList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(99, 158, 158, 158),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        child: Icon(Icons.table_view_sharp,
                                            color: Colors.red),
                                      ),
                                      const SizedBox(width: 15.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            taskList[index].taskName,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                          Text(
                                            taskList[index].taskDesc.length > 15
                                                ? taskList[index]
                                                        .taskDesc
                                                        .substring(0, 15) +
                                                    "..."
                                                : taskList[index].taskDesc,
                                            style: TextStyle(
                                                fontSize: 16,
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
            ),
          ],
        ),
      ],
    );
  }

  //Chart setting
  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text = '';
    switch (value.toInt()) {
      case 0:
        switch (DateFormat('EEEE')
            .format(DateTime.now().subtract(Duration(days: 6)))
            .toString()) {
          case "Monday":
            text = "Mn";
            break;
          case "Tuesday":
            text = "Te";
            break;
          case "Wednesday":
            text = "Wd";
            break;
          case "Thursday":
            text = "Tu";
            break;
          case "Friday":
            text = "Fr";
            break;
          case "Saturday":
            text = "St";
            break;
          case "Sunday":
            text = "Sn";
            break;
        }
        break;
      case 1:
        text = 'Te';
        break;
      case 2:
        switch (DateFormat('EEEE')
            .format(DateTime.now().subtract(Duration(days: 5)))
            .toString()) {
          case "Monday":
            text = "Mn";
            break;
          case "Tuesday":
            text = "Te";
            break;
          case "Wednesday":
            text = "Wd";
            break;
          case "Thursday":
            text = "Tu";
            break;
          case "Friday":
            text = "Fr";
            break;
          case "Saturday":
            text = "St";
            break;
          case "Sunday":
            text = "Sn";
            break;
        }
        break;
      case 3:
        switch (DateFormat('EEEE')
            .format(DateTime.now().subtract(Duration(days: 4)))
            .toString()) {
          case "Monday":
            text = "Mn";
            break;
          case "Tuesday":
            text = "Te";
            break;
          case "Wednesday":
            text = "Wd";
            break;
          case "Thursday":
            text = "Tu";
            break;
          case "Friday":
            text = "Fr";
            break;
          case "Saturday":
            text = "St";
            break;
          case "Sunday":
            text = "Sn";
            break;
        }
        break;
      case 4:
        switch (DateFormat('EEEE')
            .format(DateTime.now().subtract(Duration(days: 3)))
            .toString()) {
          case "Monday":
            text = "Mn";
            break;
          case "Tuesday":
            text = "Te";
            break;
          case "Wednesday":
            text = "Wd";
            break;
          case "Thursday":
            text = "Tu";
            break;
          case "Friday":
            text = "Fr";
            break;
          case "Saturday":
            text = "St";
            break;
          case "Sunday":
            text = "Sn";
            break;
        }
        break;
      case 5:
        switch (DateFormat('EEEE')
            .format(DateTime.now().subtract(Duration(days: 2)))
            .toString()) {
          case "Monday":
            text = "Mn";
            break;
          case "Tuesday":
            text = "Te";
            break;
          case "Wednesday":
            text = "Wd";
            break;
          case "Thursday":
            text = "Tu";
            break;
          case "Friday":
            text = "Fr";
            break;
          case "Saturday":
            text = "St";
            break;
          case "Sunday":
            text = "Sn";
            break;
        }

        break;
      case 6:
        switch (DateFormat('EEEE')
            .format(DateTime.now().subtract(Duration(days: 1)))
            .toString()) {
          case "Monday":
            text = "Mn";
            break;
          case "Tuesday":
            text = "Te";
            break;
          case "Wednesday":
            text = "Wd";
            break;
          case "Thursday":
            text = "Tu";
            break;
          case "Friday":
            text = "Fr";
            break;
          case "Saturday":
            text = "St";
            break;
          case "Sunday":
            text = "Sn";
            break;
        }

        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          Color.fromARGB(255, 235, 75, 0),
          Color.fromARGB(255, 255, 129, 26),
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: barData[DateTime(
                DateTime.now().subtract(Duration(days: 6)).year,
                DateTime.now().subtract(Duration(days: 6)).month,
                DateTime.now().subtract(Duration(days: 6)).day,
              )]!
                  .toDouble(),
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: barData[DateTime(
                DateTime.now().subtract(Duration(days: 5)).year,
                DateTime.now().subtract(Duration(days: 5)).month,
                DateTime.now().subtract(Duration(days: 5)).day,
              )]!
                  .toDouble(),
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: 2,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              toY: 4,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
              toY: 6,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
              toY: 9,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 6,
          barRods: [
            BarChartRodData(
              toY: 3,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
      ];
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
