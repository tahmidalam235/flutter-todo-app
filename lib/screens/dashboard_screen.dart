import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/firestore_service.dart';
import 'add_task_screen.dart';
import 'home_screen.dart';
import 'calendar_screen.dart';
import 'profile_screen.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'search_screen.dart';
import 'task_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'analytics_screen.dart';
import 'productivity_screen.dart';
import 'weekly_activity_screen.dart';
import 'category_distribution_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;
String search = "";
String selectedCategory = "All";
DateTime _currentTime = DateTime.now();
Timer? _timer;

@override
void initState() {
  super.initState();

  _timer = Timer.periodic(
    const Duration(seconds: 1),
        (_) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    },
  );
}
@override
void dispose() {
  _timer?.cancel();
  super.dispose();
}
String get currentDate =>
    DateFormat('EEEE, dd MMMM yyyy').format(_currentTime);

String get currentTime =>
    DateFormat('hh:mm a').format(_currentTime);
  List<double> weeklyData = List.filled(7, 0);
  Map<String, int> categoryCount = {};
  int totalTasks = 0;
  int completedTasks = 0;
  int pendingTasks = 0;
@override
Widget build(BuildContext context) {
  final user = FirebaseAuth.instance.currentUser;

  final displayName = (() {
    final name = user?.displayName?.trim() ?? "";

    if (name.isEmpty) return "User";

    return name[0].toUpperCase() + name.substring(1);
  })();
return Scaffold(
  backgroundColor: Theme.of(context).scaffoldBackgroundColor,

floatingActionButton: FloatingActionButton.extended(
backgroundColor: const Color(0xff2E8B72),
icon: const Icon(Icons.add),
label: const Text("New Task"),
onPressed: () async {
await Navigator.push(
context,
MaterialPageRoute(
builder: (_) => const AddTaskScreen(),
),
);
},
),



body: SafeArea(
child: StreamBuilder<QuerySnapshot>(
stream: FirestoreService().getTasks(),
builder: (context, snapshot) {
if (!snapshot.hasData) {
return const Center(
child: CircularProgressIndicator(),
);
}
final tasks = snapshot.data!.docs;

weeklyData = List.filled(7, 0);

final now = DateTime.now();

final startOfWeek = DateTime(
  now.year,
  now.month,
  now.day,
).subtract(Duration(days: now.weekday - 1));

final endOfWeek = startOfWeek.add(const Duration(days: 7));

for (final doc in tasks) {
  final data = doc.data() as Map<String, dynamic>;

  if (data["completed"] != true) continue;

  final Timestamp? timestamp = data["completedAt"];

  if (timestamp == null) continue;

  final completedDate = timestamp.toDate();

  if (completedDate.isBefore(startOfWeek) ||
      completedDate.isAfter(endOfWeek.subtract(const Duration(seconds: 1)))) {
    continue;
  }

  final dayIndex = completedDate.weekday - 1;

  if (dayIndex >= 0 && dayIndex < 7) {
    weeklyData[dayIndex] += 1;
  }
}

totalTasks = tasks.length;

completedTasks =
    tasks.where((e) => (e.data() as Map<String, dynamic>)["completed"] == true).length;

pendingTasks = totalTasks - completedTasks;

categoryCount = {};

for (final doc in tasks) {
  final data = doc.data() as Map<String, dynamic>;
  final category = data["category"] ?? "Other";
  categoryCount[category] = (categoryCount[category] ?? 0) + 1;
}
final filteredTasks = tasks.where((task) {

  final title = task["title"].toString().toLowerCase();
  final category = task["category"].toString().toLowerCase();

  final matchesSearch =
      title.contains(search) ||
      category.contains(search);

  final matchesCategory =
      selectedCategory == "All" ||
      category == selectedCategory.toLowerCase();

  return matchesSearch && matchesCategory;

}).toList();

return ListView(
padding: const EdgeInsets.all(18),
children: [




  Column(
    children: [

      Row(
        children: [

          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                "assets/logo/piuuuu_logo_text.png",
                height: 52,
                fit: BoxFit.contain,
              ),
            ),
          ),

          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(),
                ),
              );
            },
            child: CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xff2E8B72),
              child: Text(
                displayName[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          IconButton(
            onPressed: _showMoreMenu,
            icon: const Icon(Icons.more_vert_rounded),
          ),

        ],
      ),

      const SizedBox(height: 22),

      InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SearchScreen(),
            ),
          );
        },
        child: IgnorePointer(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search your tasks...",
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: Theme.of(context).cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),

    ],
  ),

const SizedBox(height: 25),

Row(
children: [

  Expanded(
    child: statCard(
      totalTasks.toString(),
      "Total",
      Colors.teal,
      0,
    ),
  ),

const SizedBox(width: 15),

  Expanded(
    child: statCard(
      completedTasks.toString(),
      "Completed",
      Colors.green,
      1,
    ),
  ),

const SizedBox(width: 15),

  Expanded(
    child: statCard(
      pendingTasks.toString(),
      "Pending",
      Colors.orange,
      2,
    ),
  ),

],
),



  const SizedBox(height: 30),
const SizedBox(height: 25),


  Text(
    "Categories",
    style: TextStyle(
      fontSize: 23,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onSurface,
    ),
  ),

  const SizedBox(height: 15),

  SizedBox(
    height: 45,

    child: ListView(
      scrollDirection: Axis.horizontal,
      children: [

        chip("All"),
        chip("Work"),
        chip("Personal"),
        chip("Study"),
        chip("Shopping"),
        chip("Fitness"),

      ],
    ),
  ),

  const SizedBox(height: 30),

  Text(
    "Recent Tasks",
    style: TextStyle(
      fontSize: 23,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onSurface,
    ),
  ),

  const SizedBox(height: 15),

  filteredTasks.isEmpty
      ? Padding(
    padding: const EdgeInsets.symmetric(vertical: 40),
    child: Center(
      child: Column(
        children: [

          Icon(
            Icons.search_off_rounded,
            size: 70,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 15),

          Text(
            "No matching tasks found",
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "Try another keyword",
            style: GoogleFonts.inter(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    ),
  )

      : ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: filteredTasks.length,
    itemBuilder: (context, index) {

      final task = filteredTasks[index];

      return taskTile(
        task.id,
        task["title"],
        task["category"],
        task["completed"] ?? false,
      );
    },
  ),

],
);
},
),
),
);
}

  Widget statCard(
      String number,
      String title,
      Color color,
      int initialFilter,
      ) {
  return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TaskListScreen(
              title: "My Tasks",
              initialFilter: initialFilter,
            )

          ),
        );
      },
      child: Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(22),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.05),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withOpacity(.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            Icons.analytics_rounded,
            color: color,
            size: 22,
          ),
        ),

        const SizedBox(height: 18),

        Text(
          number,
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
      )
  );
}

Widget chip(String text) {
  final selected = selectedCategory == text;

  return Padding(
    padding: const EdgeInsets.only(right: 10),
    child: ChoiceChip(
      label: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: selected
              ? Colors.white
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),

      selected: selected,

      selectedColor: const Color(0xff2E8B72),

      backgroundColor: Theme.of(context).cardColor,

      side: BorderSide.none,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),

      onSelected: (_) {
        setState(() {
          selectedCategory = text;
        });
      },
    ),
  );
}

Widget taskTile(
    String id,
    String title,
    String subtitle,
    bool completed,
    ) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(22),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.05),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 10,
      ),

      leading: Transform.scale(
        scale: 1.15,
        child: Checkbox(
          value: completed,
          shape: const CircleBorder(),
          activeColor: const Color(0xff2E8B72),
          side: BorderSide(
            color: Colors.grey.shade400,
            width: 1.5,
          ),
          onChanged: (value) async {
            await FirestoreService().updateTask(
              id,
              value ?? false,
            );

            setState(() {});
          },
        ),
      ),

      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.inter(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onSurface,
          decoration:
          completed ? TextDecoration.lineThrough : null,
        ),
      ),

      subtitle: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      trailing: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: completed
              ? const Color(0xffE8F8F2)
              : const Color(0xffFFF3E0),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            Icon(
              completed
                  ? Icons.check_circle_rounded
                  : Icons.schedule_rounded,
              size: 16,
              color: completed
                  ? const Color(0xff2E8B72)
                  : Colors.orange,
            ),

            const SizedBox(width: 6),

            Text(
              completed ? "Completed" : "Pending",
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: completed
                    ? const Color(0xff2E8B72)
                    : Colors.orange,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
  void _showMoreMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [


                _menuTile(
                  Icons.bar_chart_rounded,
                  "Productivity Score",
                      () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductivityScreen(
                          totalTasks: totalTasks,
                          completedTasks: completedTasks,
                          pendingTasks: pendingTasks,
                        ),
                      ),
                    );
                  },
                ),

                _menuTile(
                  Icons.show_chart_rounded,
                  "Weekly Activity",
                      () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WeeklyActivityScreen(
                          weeklyData: weeklyData,
                        ),
                      ),
                    );
                  },
                ),

                _menuTile(
                  Icons.pie_chart_rounded,
                  "Category Distribution",
                      () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoryDistributionScreen(
                          categoryCount: categoryCount,
                          totalTasks: totalTasks,
                        ),
                      ),
                    );
                  },
                ),

              ],
            ),
          ),
        );
      },
    );
  }
  Widget _menuTile(
      IconData icon,
      String title,
      VoidCallback onTap,
      ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xff2E8B72).withValues(alpha: .12),
        child: Icon(
          icon,
          color: const Color(0xff2E8B72),
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
      ),
      onTap: onTap,
    );
  }
  BarChartGroupData _bar(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 18,
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xff2E8B72),
        ),
      ],
    );
  }
}