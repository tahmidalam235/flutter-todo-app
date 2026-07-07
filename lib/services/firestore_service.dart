import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getTasks() {
    return _firestore
        .collection("tasks")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  Future<void> addTask({
    required String title,
    required String description,
    required String category,
    required String priority,
    required String time,
  }) async {
    await _firestore.collection("tasks").add({
      "title": title,
      "description": description,
      "category": category,
      "priority": priority,
      "time": time,
      "completed": false,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateTask(String id, bool completed) async {
    await _firestore.collection("tasks").doc(id).update({
      "completed": completed,
    });
  }

  Future<void> deleteTask(String id) async {
    await _firestore.collection("tasks").doc(id).delete();
  }
}