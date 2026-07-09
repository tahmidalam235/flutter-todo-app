import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/firestore_service.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xff121212) : const Color(0xffF6F7FB),
      appBar: AppBar(
        backgroundColor:
        isDark ? const Color(0xff121212) : const Color(0xffF6F7FB),
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService().getTasks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List tasks = snapshot.data!.docs;

          tasks.sort((a, b) {
            final aTime = a["createdAt"] as Timestamp?;
            final bTime = b["createdAt"] as Timestamp?;

            if (aTime == null || bTime == null) return 0;

            return bTime.compareTo(aTime);
          });

          if (selectedFilter == 1) {
            tasks = tasks.where((e) => e["completed"] == true).toList();
          } else if (selectedFilter == 2) {
            tasks = tasks.where((e) => e["completed"] == false).toList();
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome Back",
                            style: TextStyle(
                              fontSize: 18,
                              color: isDark ? Colors.white70 : Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .snapshots(),
                            builder: (context, userSnapshot) {
                              if (!userSnapshot.hasData) {
                                return const SizedBox();
                              }

                              final data = userSnapshot.data!.data() as Map<String, dynamic>;

                              String name = (data["name"] ?? "User").toString();

                              // First letter capital
                              name = name[0].toUpperCase() + name.substring(1);

                              return Text(
                                name,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return const SizedBox();
                        }

                        final data = userSnapshot.data!.data() as Map<String, dynamic>;

                        String name = (data["name"] ?? "U").toString();

                        return CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.teal,
                          child: Text(
                            name.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              Expanded(
                child: tasks.isEmpty
                    ? Center(
                  child: Text(
                    "No Tasks Yet",
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];

                    return TaskCard(
                      task: task,
                      onTap: () async {
                        await FirestoreService().updateTask(
                          task.id,
                          !(task["completed"] ?? false),
                        );
                      },
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddTaskScreen(task: task),
                          ),
                        );
                      },
                      onDelete: () async {
                        await FirestoreService().deleteTask(task.id);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 8,
        backgroundColor: const Color(0xff2E8B72),
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddTaskScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("New Task"),
      ),
    );
  }
}
