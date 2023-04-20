import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:checkmate/firebase_options.dart';

class Database extends ChangeNotifier {
  Database() {
    init();
  }

  //Authen
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }

  //CRUD
  FirebaseFirestore db = FirebaseFirestore.instance;

  //ADD DATA
  // Future<void> addData(String collection, Map<String, dynamic> data) async {
  //   await db.collection(collection).add(data);
  // }
}
