import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime selectedDate;
  final ScrollController _scrollController = ScrollController();

  static const double _itemWidth = 78;

  static const int _centerIndex = 5000;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    selectedDate = DateTime(
      now.year,
      now.month,
      now.day,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(15 * _itemWidth);
    });
  }

  String get firestoreDate =>
      "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xffF6F7FB),
        elevation: 0,
        centerTitle: true,
        title: const Text("Calendar",
            style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${_month(selectedDate.month)} ${selectedDate.year}",
              style: const TextStyle(color: Colors.grey, fontSize: 17),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 105,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: 31,
                itemBuilder: (context, index) {
                  final date = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day + (index - 15),
                  );

                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate = date;
                        });
                      },
                      child: _dayWidget(date),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "Tasks for ${selectedDate.day} ${_month(selectedDate.month)}",
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("tasks")
                    .where(
                  "uid",
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return data.containsKey("date") &&
                        data["date"] == firestoreDate;
                  }).toList();

                  if (docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Tasks Available",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final task = docs[index];
                      return Card(
                        margin:
                        const EdgeInsets.only(bottom: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(18),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal.shade50,
                            child: const Icon(
                              Icons.calendar_today,
                              color: Colors.teal,
                            ),
                          ),

                          title: Text(task["title"]),

                          subtitle: Text(
                            "${task["category"]} • ${task["time"]}",
                          ),

                          trailing: Icon(
                            task["completed"]
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: task["completed"]
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _dayWidget(DateTime date) {
    final selected =
        date.year == selectedDate.year &&
            date.month == selectedDate.month &&
            date.day == selectedDate.day;

    return Container(
      width: 68,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xff2E8B72)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            _weekday(date.weekday),
            style: TextStyle(
                color: selected
                    ? Colors.white
                    : Colors.grey),
          ),
          const SizedBox(height: 5),
          Text(
            "${date.day}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: selected
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ],
      ),
    );

  }

  String _weekday(int w) =>
      ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][w - 1];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  String _month(int m) => [
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
    "December"
  ][m - 1];
}
