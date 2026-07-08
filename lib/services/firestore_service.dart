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
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateTask(String id, bool completed) async {
    await _firestore.collection("tasks").doc(id).update({
      "completed": completed,
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
    print("Updating task:");
    print("ID: $id");
    print("Date: $date");

    await _firestore.collection("tasks").doc(id).update({
      "title": title,
      "description": description,
      "category": category,
      "priority": priority,
      "time": time,
      "date": date,
    });

    final updated =
    await _firestore.collection("tasks").doc(id).get();

    print("Updated Firestore Data:");
    print(updated.data());
  }
  Future<void> deleteTask(String id) async {
    await _firestore.collection("tasks").doc(id).delete();
  }
}