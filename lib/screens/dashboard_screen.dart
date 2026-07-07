import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/firestore_service.dart';
import 'add_task_screen.dart';
import 'task_detail_screen.dart';
import 'home_screen.dart';
import 'calendar_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

String search = "";
String selectedCategory = "All";

final List<String> categories = [
"All",
"Work",
"Personal",
"Study",
"Shopping",
"Fitness",
];

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

final allTasks = snapshot.data!.docs;

final tasks = allTasks.where((task) {

final title =
task['title'].toString().toLowerCase();

final category =
task['category'].toString();

final searchMatch =
title.contains(search);

final categoryMatch =
selectedCategory == "All"
? true
: category == selectedCategory;

return searchMatch && categoryMatch;

}).toList();

final completed =
allTasks.where((e) => e['completed']).length;

final pending =
allTasks.length - completed;

return ListView(
padding: const EdgeInsets.all(20),
children: [

const Text(
"Good Morning 👋",
style: TextStyle(
color: Colors.grey,
),
),

const SizedBox(height: 5),

const Text(
"Tahmid",
style: TextStyle(
fontSize: 30,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 20),

TextField(

decoration: InputDecoration(

hintText: "Search Tasks",

prefixIcon:
const Icon(Icons.search),

filled: true,

fillColor: Colors.white,

border: OutlineInputBorder(
borderRadius:
BorderRadius.circular(18),
borderSide: BorderSide.none,
),
),

onChanged: (value) {

setState(() {
search =
value.toLowerCase();
});

},
),

const SizedBox(height: 20),
Row(
children: [

Expanded(
child: statCard(
allTasks.length.toString(),
"Total",
Colors.teal,
),
),

const SizedBox(width: 12),

Expanded(
child: statCard(
completed.toString(),
"Completed",
Colors.green,
),
),

const SizedBox(width: 12),

Expanded(
child: statCard(
pending.toString(),
"Pending",
Colors.orange,
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
child: ListView.builder(
scrollDirection: Axis.horizontal,
itemCount: categories.length,
itemBuilder: (_, index) {

final category = categories[index];

return Padding(
padding: const EdgeInsets.only(right: 8),
child: ChoiceChip(

label: Text(category),

selected:
selectedCategory == category,

onSelected: (_) {

setState(() {
selectedCategory =
category;
});

},

),
);

},
),
),

const SizedBox(height: 25),

const Text(
"Recent Tasks",
style: TextStyle(
fontSize: 23,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 15),

ListView.builder(

shrinkWrap: true,

physics:
const NeverScrollableScrollPhysics(),

itemCount: tasks.length,

itemBuilder: (context, index) {

final task = tasks[index];

return taskCard(task);

},

),

],
);

},

),

),
  bottomNavigationBar: NavigationBar(
    selectedIndex: 0,
    onDestinationSelected: (index) {
      switch (index) {
        case 0:
          break;

        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const HomeScreen(),
            ),
          );
          break;

        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CalendarScreen(),
            ),
          );
          break;

        case 3:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProfileScreen(),
            ),
          );
          break;
      }
    },
    destinations: const [
      NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: "Home",
      ),
      NavigationDestination(
        icon: Icon(Icons.task_outlined),
        selectedIcon: Icon(Icons.task),
        label: "Tasks",
      ),
      NavigationDestination(
        icon: Icon(Icons.calendar_month_outlined),
        selectedIcon: Icon(Icons.calendar_month),
        label: "Calendar",
      ),
      NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: "Profile",
      ),
    ],
  ),

);

}
Widget statCard(String number, String title, Color color) {
return Card(
child: Padding(
padding: const EdgeInsets.all(18),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [

Text(
number,
style: TextStyle(
fontSize: 28,
fontWeight: FontWeight.bold,
color: color,
),
),

const SizedBox(height: 6),

Text(title),

],
),
),
);
}
Widget taskCard(dynamic task) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TaskDetailScreen(task: task),
        ),
      );
    },
    child: Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: Icon(
          task["completed"]
              ? Icons.check_circle
              : Icons.radio_button_unchecked,
          color: task["completed"] ? Colors.green : Colors.teal,
        ),

        title: Text(task["title"]),

        subtitle: Text(task["category"]),

        trailing: PopupMenuButton(
          itemBuilder: (_) => const [
            PopupMenuItem(
              value: "delete",
              child: Text("Delete"),
            ),
          ],
          onSelected: (value) async {
            if (value == "delete") {
              await FirestoreService().deleteTask(task.id);
            }
          },
        ),
      ),
    ),
  );
}
}