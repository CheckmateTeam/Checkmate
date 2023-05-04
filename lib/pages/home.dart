import 'package:checkmate/pages/main/archive_page.dart';
import 'package:checkmate/pages/main/notification_page.dart';
import 'package:checkmate/pages/main/profile_page.dart';
import 'package:checkmate/pages/main/task_page.dart';
import 'package:checkmate/provider/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main/components/tasklist_page/newTask.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  // ignore: constant_identifier_names
  static const List<Widget> screen_index = <Widget>[
    TaskListPage(),
    ArchivePage(),
    Text(
      'Add todo',
    ),
    NotificationPage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(child: screen_index.elementAt(_selectedIndex)),
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.only(top: 30),
        //create task button
        child: FloatingActionButton(
          elevation: 0.0,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(100.0))),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => const createTask());
          },
          backgroundColor: const Color.fromRGBO(241, 91, 91, 1),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.archive), label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.archive, color: Colors.transparent), label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_on_outlined), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromRGBO(241, 91, 91, 1),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
