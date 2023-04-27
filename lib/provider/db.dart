import 'package:checkmate/model/taskModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Database extends ChangeNotifier {
  String username = 'fetching...';
  String email = 'fetching...';
  String points = 'fetching...';
  bool cycle = false;
  Database() {
    init();
  }
  Future init() async {
    await db
        .collection('user_info')
        .where('uid', isEqualTo: user?.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      username = querySnapshot.docs[0]['displayName'];
      email = querySnapshot.docs[0]['email'];
      points = querySnapshot.docs[0]['points'].toString();
      cycle = querySnapshot.docs[0]['cycle'];
    });
  }

  //CRUD + Information
  // User instance
  User? get user => FirebaseAuth.instance.currentUser;

  //Firestore instance
  FirebaseFirestore db = FirebaseFirestore.instance;
  String get userName => username;
  String get userEmail => email;
  String get userPoints => points;
  bool get userCycle => cycle;

  Future<void> addNewUser(String email, String name) async {
    await db.collection('user_info').add({
      'uid': user?.uid,
      'displayName': name,
      'email': email,
      'goal': 0,
      'lastLogin': DateTime.now(),
      'points': 0,
      'cycle': false,
    });
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await db.collection('task').add({
      'uid': user?.uid,
      'taskId': Uuid().v4().toString(),
      'taskName': task.taskName,
      'taskDesc': task.taskDesc,
      'startDate': task.startDate,
      'endDate': task.endDate,
      'cycle': task.cycle,
      'notify': task.notify,
    });
    notifyListeners();
  }

  Future<void> updateLogin() async {
    init();
    await db
        .collection('user_info')
        .where('uid', isEqualTo: user?.uid)
        .get()
        .then((QuerySnapshot querySnapshot) => querySnapshot.docs[0].reference
            .update({'lastLogin': DateTime.now()}));
    notifyListeners();
  }

  Future<void> changeUsername(String name) async {
    await db
        .collection('user_info')
        .where('uid', isEqualTo: user?.uid)
        .get()
        .then((QuerySnapshot querySnapshot) =>
            querySnapshot.docs[0].reference.update({'displayName': name}));
    username = name;
    notifyListeners();
  }
}
