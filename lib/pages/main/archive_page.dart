import 'package:checkmate/pages/main/components/archive_page/taskListAll.dart';
import 'package:checkmate/pages/main/components/archive_page/taskListMonth.dart';
import 'package:flutter/material.dart';
import 'components/archive_page/taskListWeek.dart';
import 'components/archive_page/taskListYear.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({super.key});

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 0),
            child: Text(
              "Archive",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 0,
                  blurRadius: 20,
                  offset: const Offset(0, 4), // changes position of shadow
                ),
              ],
            ),
            child: const SelectWeek(),
          )),
        ],
      ),
    );
  }
}

class SelectWeek extends StatefulWidget {
  const SelectWeek({Key? key}) : super(key: key);
  @override
  State<SelectWeek> createState() => _SelectWeekState();
}

class _SelectWeekState extends State<SelectWeek> {
  @override
  void initState() {
    super.initState();
  }

  int _selectedIndex = 1;
  // ignore: constant_identifier_names
  static const List<Widget> mode_index = <Widget>[
    TaskListWeek(),
    TaskListMonth(),
    TaskListYear(),
    TaskListAll()
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 15,
          ),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            color: Colors.grey.withOpacity(0.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: _selectedIndex == 0
                                ? Colors.white
                                : Colors.transparent),
                        child: const Center(
                            child: Text(
                          "Week",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w700),
                        ))),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          color: _selectedIndex == 1
                              ? Colors.white
                              : Colors.transparent,
                        ),
                        child: const Center(
                            child: Text(
                          "Month",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w700),
                        ))),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 2;
                      });
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          color: _selectedIndex == 2
                              ? Colors.white
                              : Colors.transparent,
                        ),
                        child: const Center(
                            child: Text(
                          "Year",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w700),
                        ))),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 3;
                      });
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          color: _selectedIndex == 3
                              ? Colors.white
                              : Colors.transparent,
                        ),
                        child: const Center(
                            child: Text(
                          "All",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w700),
                        ))),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: mode_index[_selectedIndex],
        ),
      ],
    );
  }
}
