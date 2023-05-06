import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Database extends ChangeNotifier {
  String username = 'fetching...';
  String email = 'fetching...';
  String points = 'fetching...';
  String cycle = 'fetching...';

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
    });

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

  void buyItem(int itemPrice) {
    db
        .collection('user_info')
        .where('uid', isEqualTo: user?.uid)
        .get() 
        .then((QuerySnapshot querySnapshot) async {
      int points = querySnapshot.docs[0]['points'];
      if (points != null && points >= itemPrice){
        final newPoints = points - itemPrice;
        await db
            .collection('user_info')
            .doc(querySnapshot.docs[0].id)
            .update({'points': newPoints});
        notifyListeners();
      }
    });
  }
}
