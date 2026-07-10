import 'package:flutter/material.dart';

class ProductivityScreen extends StatelessWidget {
  final int totalTasks;
  final int completedTasks;
  final int pendingTasks;

  const ProductivityScreen({
    super.key,
    required this.totalTasks,
    required this.completedTasks,
    required this.pendingTasks,
  });

  @override
  Widget build(BuildContext context) {
    final progress =
    totalTasks == 0 ? 0.0 : completedTasks / totalTasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Productivity Score"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [

                    const Text(
                      "Productivity",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 12,
                    ),

                    const SizedBox(height: 25),

                    Text(
                      "${(progress * 100).round()}%",
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: [

                        Column(
                          children: [
                            const Text("Completed"),
                            Text(
                              "$completedTasks",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),

                        Column(
                          children: [
                            const Text("Pending"),
                            Text(
                              "$pendingTasks",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),

                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}