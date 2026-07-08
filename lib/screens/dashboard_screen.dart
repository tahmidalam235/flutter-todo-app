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

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xffF6F7FB),

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

final totalTasks = tasks.length;

final completedTasks = tasks.where((task) {
return task["completed"] == true;
}).length;

final pendingTasks = totalTasks - completedTasks;
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

  Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [

      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Good Morning 👋",
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
                letterSpacing: .3,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "Tahmid",
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: const Color(0xff1B1B1B),
                height: 1.1,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [

                Icon(
                  Icons.calendar_today_rounded,
                  size: 16,
                  color: Colors.grey.shade600,
                ),

                const SizedBox(width: 6),

                Text(
                  currentDate,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),

              ],
            ),

            const SizedBox(height: 5),

            Row(
              children: [

                const Icon(
                  Icons.access_time_filled_rounded,
                  size: 17,
                  color: Color(0xff2E8B72),
                ),

                const SizedBox(width: 6),

                Text(
                  currentTime,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xff2E8B72),
                    fontWeight: FontWeight.w700,
                  ),
                ),

              ],
            ),

          ],
        ),
      ),

      InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ProfileScreen(),
            ),
          );
        },
        child: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              colors: [
                Color(0xff36C2A6),
                Color(0xff2E8B72),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withOpacity(.25),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Text(
              "T",
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      )

    ],
  ),

const SizedBox(height: 25),

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
          hintText: "Search Tasks",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    ),
  ),

const SizedBox(height: 25),

Row(
children: [

Expanded(
child: statCard(
  totalTasks.toString(),
  "Total",
  Colors.teal,
  null,
),
),

const SizedBox(width: 15),

Expanded(
child: statCard(
  completedTasks.toString(),
  "Completed",
  Colors.green,
  true,
),
),

const SizedBox(width: 15),

Expanded(
child: statCard(
  pendingTasks.toString(),
  "Pending",
  Colors.orange,
  false,
),
),

],
),

const SizedBox(height: 25),
  const Text(
    "Categories",
    style: TextStyle(
      fontSize: 23,
      fontWeight: FontWeight.bold,
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

  const Text(
    "Recent Tasks",
    style: TextStyle(
      fontSize: 23,
      fontWeight: FontWeight.bold,
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
    bool? completed,
    ) {
  return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TaskListScreen(
              title: "$title Tasks",
              completed: completed,
            ),
          ),
        );
      },
      child: Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
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
            color: const Color(0xff1B1B1B),
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
              : const Color(0xff4A4A4A),
        ),
      ),

      selected: selected,

      selectedColor: const Color(0xff2E8B72),

      backgroundColor: Colors.white,

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
      color: Colors.white,
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
            await FirebaseFirestore.instance
                .collection("tasks")
                .doc(id)
                .update({
              "completed": value,
            });

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
          color: const Color(0xff1B1B1B),
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
}