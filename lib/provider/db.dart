import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:checkmate/firebase_options.dart';

class Database extends ChangeNotifier {
  Database();

  //CRUD + Information
  // User instance
  User get user => FirebaseAuth.instance.currentUser!;
  String get userEmail => user.email!;
  String get userName => user.displayName!;
  //Firestore instance
  FirebaseFirestore db = FirebaseFirestore.instance;
  //ADD DATA
  // Future<void> addData(String collection, Map<String, dynamic> data) async {
  //   await db.collection(collection).add(data);
  // }
}
