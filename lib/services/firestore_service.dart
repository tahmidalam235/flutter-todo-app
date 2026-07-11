import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<QuerySnapshot> getTasks() {
    final user = _auth.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection("tasks")
        .where("uid", isEqualTo: user.uid)
        .snapshots();
  }
  Future<void> addTask({
    required String title,
    required String description,
    required String category,
    required String priority,
    required String time,
    required String date,
  }) async {
    await _firestore.collection("tasks").add({
      "title": title,
      "description": description,
      "category": category,
      "priority": priority,
      "time": time,
      "date": date,
      "completed": false,
      "uid": _auth.currentUser?.uid ?? "",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateTask(String id, bool completed) async {
    await _firestore.collection("tasks").doc(id).update({
      "completed": completed,

      "completedAt": completed
          ? FieldValue.serverTimestamp()
          : null,
    });
  }

  Future<void> updateTaskData({
    required String id,
    required String title,
    required String description,
    required String category,
    required String priority,
    required String time,
    required String date,
  }) async {
    await _firestore.collection("tasks").doc(id).update({
      "title": title,
      "description": description,
      "category": category,
      "priority": priority,
      "time": time,
      "date": date,
    });
  }

  Future<void> deleteTask(String id) async {
    await _firestore.collection("tasks").doc(id).delete();
  }
  Future<void> addNotification({
    required String title,
    required String body,
  }) async {
    await _firestore.collection("notifications").add({
      "uid": _auth.currentUser?.uid ?? "",
      "title": title,
      "body": body,
      "createdAt": FieldValue.serverTimestamp(),
      "read": false,
    });
  }
}