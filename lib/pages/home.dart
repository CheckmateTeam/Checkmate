import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final _user = FirebaseAuth.instance.currentUser;
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Home screen'),
        Text('Welcome ${_user!.email}'),
        ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: Text('Sign out'))
      ],
    ));
  }
}
