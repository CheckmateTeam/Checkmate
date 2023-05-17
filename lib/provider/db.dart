import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class Database extends ChangeNotifier {
  final LocalStorage storage = LocalStorage('boss');

  String username = 'fetching...';
  String email = 'fetching...';
  String points = 'fetching...';
  String cycle = 'fetching...';
  String goal = 'fetching...';
  late DateTime lastBoss;

  Database() {
    init();
  }
  Future<void> init() async {
    await db
        .collection('user_info')
        .where('uid', isEqualTo: user?.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      username = querySnapshot.docs[0]['displayName'];
      email = querySnapshot.docs[0]['email'];
      points = querySnapshot.docs[0]['points'].toString();
      cycle = querySnapshot.docs[0]['cycle'].toString();
      goal = querySnapshot.docs[0]['goal'].toString();
    });
    lastBoss = DateTime.parse(storage.getItem('lastBoss')) ??
        DateTime.now().subtract(Duration(days: 1));
    notifyListeners();
  }

  // User instance
  User? get user => FirebaseAuth.instance.currentUser;

  //Firestore instance
  FirebaseFirestore db = FirebaseFirestore.instance;
  String get userName => username;
  String get userEmail => email;
  String get userPoints => points;
  String get userCycle => cycle;
  String get userGoal => goal;
  DateTime get userLastBoss => lastBoss;

  //DB FUNCTION
  Future<void> addNewUser(String email, String name) async {
    await db.collection('user_info').add({
      'uid': user?.uid,
      'displayName': name,
      'email': email,
      'goal': 0,
      'lastLogin': DateTime.now(),
      'points': 0,
      'cycle': 'none',
    });
    notifyListeners();
  }

  void setGoal(int goal) {
    db.collection('user_info').where('uid', isEqualTo: user?.uid).get().then(
        (QuerySnapshot querySnapshot) =>
            querySnapshot.docs[0].reference.update({'goal': goal}));
    notifyListeners();
  }

  void deductPoint(int point) {
    db.collection('user_info').where('uid', isEqualTo: user?.uid).get().then(
        (QuerySnapshot querySnapshot) => querySnapshot.docs[0].reference
            .update({'points': int.parse(points) - point}));
    notifyListeners();
  }

  void updateLogin() {
    init();
    db.collection('user_info').where('uid', isEqualTo: user?.uid).get().then(
        (QuerySnapshot querySnapshot) => querySnapshot.docs[0].reference
            .update({'lastLogin': DateTime.now()}));
    notifyListeners();
  }

  void changeUsername(String name) {
    db.collection('user_info').where('uid', isEqualTo: user?.uid).get().then(
        (QuerySnapshot querySnapshot) =>
            querySnapshot.docs[0].reference.update({'displayName': name}));
    username = name;
    notifyListeners();
  }

  void enterBoss(DateTime time) {
    storage.setItem('lastBoss', time.toIso8601String());
    lastBoss = time;
    notifyListeners();
  }
}
