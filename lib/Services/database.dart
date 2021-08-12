import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> addTask(Map<String, dynamic> task) async {
    await _db.collection('users').add(task);
  }

  static Future<void> updateTask(String id, Map<String, dynamic> task) async {
    await _db.collection('users').doc(id).update(task);
  }

  static Future<void> deleteTask(String id) async {
    print(id);
    await _db.collection('users').doc(id).delete();
  }
}
