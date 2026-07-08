import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/firestore_service.dart';

class TaskListScreen extends StatelessWidget {
  final String title;
  final bool? completed;

  const TaskListScreen({
    super.key,
    required this.title,
    this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),

      appBar: AppBar(
        backgroundColor: const Color(0xffF6F7FB),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService().getTasks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List tasks = snapshot.data!.docs;

          if (completed != null) {
            tasks = tasks.where((task) {
              return task["completed"] == completed;
            }).toList();
          }

          if (tasks.isEmpty) {
            return Center(
              child: Text(
                "No Tasks Found",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(18),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 15),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ListTile(
                  leading: Icon(
                    task["completed"]
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: task["completed"]
                        ? Colors.green
                        : Colors.orange,
                  ),

                  title: Text(
                    task["title"],
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      decoration: task["completed"]
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),

                  subtitle: Text(
                    task["category"],
                    style: GoogleFonts.inter(),
                  ),

                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: task["completed"]
                          ? Colors.green.shade100
                          : Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      task["completed"]
                          ? "Completed"
                          : "Pending",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: task["completed"]
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}