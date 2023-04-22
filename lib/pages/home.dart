import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static const List<Widget> screen_index = <Widget>[
    Text(
      ' Task',
    ),
    Text(
      ' Archive',
    ),
    Text(
      'Add todo',
    ),
    Text(
      ' Notification',
    ),
    Text(
      'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final _user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          screen_index.elementAt(_selectedIndex),
          Text('Welcome ${_user!.email}'),
          ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              child: Text('Sign out'))
        ],
      )),
      floatingActionButton: Container(
        padding: const EdgeInsets.only(top: 30),
        child: FloatingActionButton(
          elevation: 0.0,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(100.0))),
          onPressed: () {},
          child: const Icon(Icons.add, color: Colors.white),
          backgroundColor: Color.fromRGBO(241, 91, 91, 1),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.archive), label: ""),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.archive,
                color: Colors.white,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_on_outlined), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromRGBO(241, 91, 91, 1),
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
