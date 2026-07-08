import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/firestore_service.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xffF6F7FB),
        elevation: 0,
        title: const Text(
          'My Tasks',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService().getTasks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List tasks = snapshot.data!.docs;

          if (selectedFilter == 1) {
            tasks = tasks.where((e) => e["completed"] == true).toList();
          } else if (selectedFilter == 2) {
            tasks = tasks.where((e) => e["completed"] == false).toList();
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    ChoiceChip(
                      label: const Text("All"),
                      selected: selectedFilter == 0,
                      onSelected: (_) => setState(() => selectedFilter = 0),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text("Completed"),
                      selected: selectedFilter == 1,
                      onSelected: (_) => setState(() => selectedFilter = 1),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text("Pending"),
                      selected: selectedFilter == 2,
                      onSelected: (_) => setState(() => selectedFilter = 2),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
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
