import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/firestore_service.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  String getTodayDate() {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    final now = DateTime.now();

    return "${months[now.month - 1]} ${now.day}, ${now.year}";
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedFilter = 0;
  final TextEditingController searchController = TextEditingController();

  String searchText = "";

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  String getTodayDate() {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    final now = DateTime.now();

    return "${months[now.month - 1]} ${now.day}, ${now.year}";
  }

  Widget _statItem(
      String title,
      String value,
      Color color,
      ) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
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
            if (searchText.isNotEmpty) {
              tasks = tasks.where((task) {
                final title =
                task["title"].toString().toLowerCase();

                final category =
                task["category"].toString().toLowerCase();

                return title.contains(searchText) ||
                    category.contains(searchText);
              }).toList();
            }
            tasks = tasks.where((e) => e["completed"] == false).toList();
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, userSnapshot) {
                    if (!userSnapshot.hasData) {
                      return const SizedBox();
                    }

                    final data =
                    userSnapshot.data!.data() as Map<String, dynamic>;

                    String name =
                    (data["name"] ?? "User").toString();

                    name =
                        name[0].toUpperCase() + name.substring(1);

                    return Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xff2E8B72),
                            Color(0xff49B59B),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff2E8B72)
                                .withValues(alpha: .25),
                            blurRadius: 22,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [

                                Text(
                                  "${getGreeting()} 👋",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  getTodayDate(),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          CircleAvatar(
                            radius: 34,
                            backgroundColor: Colors.white24,
                            child: Text(
                              name.substring(0, 1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

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
                  itemCount: tasks.length + 1,
                  itemBuilder: (context, index) {

                    if (index == 0) {
                      final completed =
                          tasks.where((e) => e["completed"] == true).length;

                      final pending =
                          tasks.where((e) => e["completed"] == false).length;

                      final total = tasks.length;

                      final progress =
                      total == 0 ? 0.0 : completed / total;

                      return Column(
                        children: [

                          Container(
                            margin: const EdgeInsets.fromLTRB(8, 0, 8, 22),
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xff1E1E1E)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Column(
                              children: [

                                Row(
                                  children: [
                                    const Icon(
                                      Icons.auto_graph_rounded,
                                      color: Color(0xff2E8B72),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "Today's Progress",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color:
                                        isDark ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 18),

                                LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 10,
                                  borderRadius: BorderRadius.circular(20),
                                ),

                                const SizedBox(height: 20),

                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    _statItem(
                                      "Completed",
                                      completed.toString(),
                                      Colors.green,
                                    ),
                                    _statItem(
                                      "Pending",
                                      pending.toString(),
                                      Colors.orange,
                                    ),
                                    _statItem(
                                      "Progress",
                                      "${(progress * 100).toInt()}%",
                                      const Color(0xff2E8B72),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8),
                            child: TextField(
                              controller: searchController,
                              onChanged: (value) {
                                setState(() {
                                  searchText = value.toLowerCase();
                                });
                              },
                              decoration: InputDecoration(
                                hintText: "Search your tasks...",
                                prefixIcon:
                                const Icon(Icons.search_rounded),
                                filled: true,
                                fillColor: isDark
                                    ? const Color(0xff1E1E1E)
                                    : Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(18),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 22),
                        ],
                      );
                    }

                    final task = tasks[index - 1];

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
