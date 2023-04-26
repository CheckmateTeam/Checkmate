import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Database extends ChangeNotifier {
  String username = 'fetching...';
  String email = 'fetching...';
  String points = 'fetching...';
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

  Future<void> addNewUser(String email, String name) async {
    await db.collection('user_info').add({
      'uid': user?.uid,
      'displayName': name,
      'email': email,
      'goal': 0,
      'lastLogin': DateTime.now(),
      'points': 0,
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
