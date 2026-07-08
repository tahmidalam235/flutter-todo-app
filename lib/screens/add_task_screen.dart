import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTaskScreen extends StatefulWidget {

  final dynamic task;

  const AddTaskScreen({
    super.key,
    this.task,
  });

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  String category = "Work";
  String priority = "Medium";

  TimeOfDay? selectedTime;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      titleController.text = widget.task["title"];
      descriptionController.text = widget.task["description"] ?? "";
      category = widget.task["category"];
      priority = widget.task["priority"] ?? "Medium";
      final data = widget.task.data() as Map<String, dynamic>;

      if (data.containsKey("time") &&
          data["time"] != null &&
          data["time"] != "No Time") {
        final parts = data["time"].split(" ");
        final hm = parts[0].split(":");

        int hour = int.parse(hm[0]);
        final minute = int.parse(hm[1]);

        if (parts.length > 1 && parts[1] == "PM" && hour != 12) {
          hour += 12;
        }
        if (parts.length > 1 && parts[1] == "AM" && hour == 12) {
          hour = 0;
        }

        selectedTime = TimeOfDay(hour: hour, minute: minute);
      }

      if (data.containsKey("date") && data["date"] != null) {
        selectedDate = DateTime.parse(data["date"]);
      } else {
        selectedDate = DateTime.now();
      }
    }
  }
  Future<void> pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }
  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });

      print("NEW DATE: $selectedDate");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),

      appBar: AppBar(
        title: const Text("New Task"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Task Title",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Enter task title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Task description",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: category,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                labelText: "Category",
              ),
              items: const [
                DropdownMenuItem(value: "Work", child: Text("Work")),
                DropdownMenuItem(value: "Personal", child: Text("Personal")),
                DropdownMenuItem(value: "Study", child: Text("Study")),
                DropdownMenuItem(value: "Shopping", child: Text("Shopping")),
                DropdownMenuItem(value: "Fitness", child: Text("Fitness")),
              ],
              onChanged: (value) {
                setState(() {
                  category = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: priority,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                labelText: "Priority",
              ),
              items: const [
                DropdownMenuItem(value: "High", child: Text("High")),
                DropdownMenuItem(value: "Medium", child: Text("Medium")),
                DropdownMenuItem(value: "Low", child: Text("Low")),
              ],
              onChanged: (value) {
                setState(() {
                  priority = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.access_time),
                label: Text(
                  selectedTime == null
                      ? "Select Time"
                      : selectedTime!.format(context),
                ),
                onPressed: pickTime,
              ),
            ),
            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                ),
                onPressed: pickDate,
              ),
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {

                  if (widget.task == null) {

                    await FirestoreService().addTask(
                      title: titleController.text.trim(),
                      description: descriptionController.text.trim(),
                      category: category,
                      priority: priority,
                      time: selectedTime == null
                          ? "No Time"
                          : selectedTime!.format(context),
                      date:
                      "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}",
                    );

                  } else {

                    final dateToSave =
                        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

                    print("Saving -> $dateToSave");
                    await FirestoreService().updateTaskData(
                      id: widget.task.id,
                      title: titleController.text.trim(),
                      description: descriptionController.text.trim(),
                      category: category,
                      priority: priority,
                      time: selectedTime == null
                          ? (widget.task["time"] ?? "No Time")
                          : selectedTime!.format(context),
                      date: dateToSave,);

                  }

                  Navigator.pop(context);
                },

                child: const Text(
                  "Save Task",
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}