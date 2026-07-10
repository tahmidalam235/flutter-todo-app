import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryDistributionScreen extends StatelessWidget {
  final Map<String, int> categoryCount;
  final int totalTasks;

  const CategoryDistributionScreen({
    super.key,
    required this.categoryCount,
    required this.totalTasks,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category Distribution"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          ...categoryCount.entries.map((entry) {

            return Card(
              margin: const EdgeInsets.only(bottom: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [

                        Text(
                          entry.key,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        Text(
                          "${entry.value}",
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 10),

                    LinearProgressIndicator(
                      value: totalTasks == 0
                          ? 0
                          : entry.value / totalTasks,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(20),
                    ),

                  ],
                ),
              ),
            );

          }),

        ],
      ),
    );
  }
}