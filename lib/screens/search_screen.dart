import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/firestore_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  String search = "";

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xff121212)
          : const Color(0xffF6F7FB),

      appBar: AppBar(
        backgroundColor: isDark
            ? const Color(0xff121212)
            : const Color(0xffF6F7FB),
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          "Search Tasks",
          style: GoogleFonts.inter(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(
          children: [
            TextField(
              controller: searchController,

              autofocus: true,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
              ),

              decoration: InputDecoration(
                hintText: "Search by title or category",

                hintStyle: GoogleFonts.inter(
                  color: isDark ? Colors.white54 : Colors.grey,
                ),

                prefixIcon: Icon(
                  Icons.search,
                  color: isDark ? Colors.white70 : Colors.grey,
                ),

                suffixIcon: search.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),

                        onPressed: () {
                          searchController.clear();

                          setState(() {
                            search = "";
                          });
                        },
                      ),

                filled: true,

                fillColor: isDark
                    ? const Color(0xff1F1F1F)
                    : Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),

              onChanged: (value) {
                setState(() {
                  search = value.toLowerCase();
                });
              },
            ),

            const SizedBox(height: 20),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirestoreService().getTasks(),

                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final tasks = snapshot.data!.docs;
                  final filteredTasks = tasks.where((task) {
                    final title = task["title"].toString().toLowerCase();

                    final category = task["category"].toString().toLowerCase();

                    return title.contains(search) || category.contains(search);
                  }).toList();

                  if (filteredTasks.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),

                          const SizedBox(height: 20),

                          Text(
                            "No matching tasks found",
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            "Try another keyword",
                            style: GoogleFonts.inter(
                              color: isDark
                                  ? Colors.white70
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: filteredTasks.length,

                    separatorBuilder: (_, _) => const SizedBox(height: 12),

                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];

                      return Container(
                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xff1F1F1F)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(18),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),

                        child: Row(
                          children: [
                            Icon(
                              task["completed"] == true
                                  ? Icons.check_circle_rounded
                                  : Icons.radio_button_unchecked,
                              color: task["completed"] == true
                                  ? const Color(0xff2E8B72)
                                  : Colors.grey,
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task["title"],
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? Colors.white : Colors.black,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    task["category"],
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: task["completed"] == true
                                    ? const Color(0xffE8F8F2)
                                    : const Color(0xffFFF3E0),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                task["completed"] == true
                                    ? "Completed"
                                    : "Pending",
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: task["completed"] == true
                                      ? const Color(0xff2E8B72)
                                      : Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
