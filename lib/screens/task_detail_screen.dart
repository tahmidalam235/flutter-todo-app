import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'add_task_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final dynamic task;

  const TaskDetailScreen({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Details"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              task["title"],
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text("Description: ${task["description"]}"),

            const SizedBox(height: 10),

            Text("Category: ${task["category"]}"),

            const SizedBox(height: 10),

            Text("Priority: ${task["priority"]}"),

            const SizedBox(height: 10),

            Text("Time: ${task["time"]}"),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text("Edit"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddTaskScreen(task: task),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                icon: const Icon(Icons.delete),
                label: const Text("Delete"),
                onPressed: () async {

                  await FirestoreService()
                      .deleteTask(task.id);

                  Navigator.pop(context);

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}