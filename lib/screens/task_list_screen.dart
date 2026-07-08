import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/firestore_service.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  final String title;
  final bool? completed;

  const TaskListScreen({
    super.key,
    required this.title,
    this.completed,
  });

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
int selectedFilter = 0;

Widget _filterChip({
required String text,
required int index,
}) {
final selected = selectedFilter == index;

return GestureDetector(
onTap: () {
setState(() {
selectedFilter = index;
});
},
child: AnimatedContainer(
duration: const Duration(milliseconds: 220),
margin: const EdgeInsets.only(right: 10),
padding: const EdgeInsets.symmetric(
horizontal: 18,
vertical: 10,
),
decoration: BoxDecoration(
color: selected
? const Color(0xff2E8B72)
: Colors.white,
borderRadius: BorderRadius.circular(30),
border: Border.all(
color: selected
? const Color(0xff2E8B72)
: Colors.grey.shade300,
),
),
child: Text(
text,
style: GoogleFonts.inter(
fontWeight: FontWeight.w600,
color: selected
? Colors.white
: Colors.black87,
),
),
),
);
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xffF6F7FB),
body: SafeArea(
child: StreamBuilder<QuerySnapshot>(
stream: FirestoreService().getTasks(),
builder: (context, snapshot) {

if (!snapshot.hasData) {
return const Center(
child: CircularProgressIndicator(),
);
}

List tasks = snapshot.data!.docs;

if (selectedFilter == 1) {
tasks = tasks
.where((e) => e["completed"] == true)
.toList();
}

if (selectedFilter == 2) {
tasks = tasks
.where((e) => e["completed"] == false)
.toList();
}

return Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [

const SizedBox(height: 22),

Padding(
padding: const EdgeInsets.symmetric(
horizontal: 20,
),
child: Text(
"My Tasks",
style: GoogleFonts.inter(
fontSize: 34,
fontWeight: FontWeight.w800,
),
),
),

const SizedBox(height: 18),

Padding(
padding: const EdgeInsets.symmetric(
horizontal: 20,
),
child: Row(
children: [

_filterChip(
text: "All",
index: 0,
),

_filterChip(
text: "Completed",
index: 1,
),

_filterChip(
text: "Pending",
index: 2,
),

],
),
),

const SizedBox(height: 22),

Expanded(
child: tasks.isEmpty
? Center(
child: Text(
"No Tasks Found",
style: GoogleFonts.inter(
fontSize: 18,
fontWeight:
FontWeight.w600,
),
),
)
: ListView.builder(
padding:
const EdgeInsets.fromLTRB(
20,
0,
20,
20),
itemCount: tasks.length,
itemBuilder:
(context, index) {

final task = tasks[index];
return TaskCard(
  task: task,

  onTap: () async {
    await FirestoreService()
        .updateTask(
      task.id,
      !(task["completed"] ?? false),
    );
  },

  onEdit: () {
    Future.delayed(
      Duration.zero,
          () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                AddTaskScreen(
                  task: task,
                ),
          ),
        );
      },
    );
  },

  onDelete: () async {
    await FirestoreService()
        .deleteTask(task.id);
  },
);
},
),
),

],
);
},
),
),
);
}
}