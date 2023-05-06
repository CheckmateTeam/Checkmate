// ignore_for_file: file_names

import 'package:checkmate/provider/archive_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TaskListYear extends StatefulWidget {
  const TaskListYear({super.key});

  @override
  State<TaskListYear> createState() => _TaskListYearState();
}

class _TaskListYearState extends State<TaskListYear> {
  late Map<String, int> barData;
  late Future<String> _myFuture;

  @override
  void initState() {
    super.initState();

    _myFuture =
        Provider.of<ArchiveProvider>(context, listen: false).fetchYear();
  }

  @override
  Widget build(BuildContext context) {
    final taskList = context.watch<ArchiveProvider>().taskList;
    barData = context.watch<ArchiveProvider>().taskMapYear;
    return FutureBuilder(
      future: _myFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            //month
            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(children: [
                        Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                                DateFormat('y').format(DateTime(
                                      DateTime.now().year - 1,
                                      DateTime.now().month,
                                      DateTime.now().day,
                                    )) +
                                    " - " +
                                    DateFormat('y').format(DateTime.now()),
                                style: TextStyle(
                                  fontSize: 16,
                                ))),
                      ]),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: taskList.length,
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
                                                  taskList[index].taskName,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      decoration:
                                                          TextDecoration.none),
                                                ),
                                                Text(
                                                  taskList[index]
                                                              .taskDesc
                                                              .length >
                                                          15
                                                      ? taskList[index]
                                                              .taskDesc
                                                              .substring(
                                                                  0, 15) +
                                                          "..."
                                                      : taskList[index]
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
                                                taskList[index].startDate),
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
              rod.toY.round().toString() == "0"
                  ? ""
                  : rod.toY.round().toString(),
              const TextStyle(
                color: Color.fromARGB(255, 77, 77, 77),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromARGB(255, 44, 44, 44),
      fontWeight: FontWeight.bold,
      fontSize: 13,
    );
    String text = '';
    int day = value.toInt();
    text = DateFormat('MMM').format(DateTime(
      DateTime.now().year,
      day,
      DateTime.now().day,
    ));

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
        for (int i = 1; i <= 12; i++)
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                fromY: 0,
                toY: barData[i.toString()]?.toDouble() ?? 0,
                gradient: _barsGradient,
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 20,
                  color: Colors.grey[200],
                ),
              ),
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
