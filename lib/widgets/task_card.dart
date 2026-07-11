import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskCard extends StatelessWidget {
  final dynamic task;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  Color _priorityColor(String priority) {
    switch (priority) {
      case "High":
        return const Color(0xffFF6B6B);
      case "Medium":
        return const Color(0xffF4B740);
      case "Low":
        return const Color(0xff56C271);
      default:
        return Colors.grey;
    }
  }

  Color _priorityBg(String priority) {
    switch (priority) {
      case "High":
        return const Color(0xffFFE5E5);
      case "Medium":
        return const Color(0xffFFF3D6);
      case "Low":
        return const Color(0xffE4F7EA);
      default:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final completed = task["completed"] ?? false;
    final priority = task["priority"] ?? "Medium";
    final description = task["description"] ?? "";
    final category = task["category"] ?? "";
    String formattedDate = "";

    final dateString = task["date"]?.toString() ?? "";

    if (dateString.isNotEmpty) {
      try {
        final date = DateTime.parse(dateString);

        const months = [
          "Jan",
          "Feb",
          "Mar",
          "Apr",
          "May",
          "Jun",
          "Jul",
          "Aug",
          "Sep",
          "Oct",
          "Nov",
          "Dec",
        ];

        formattedDate =
        "${date.day.toString().padLeft(2, '0')}-${months[date.month - 1]}";
      } catch (_) {
        formattedDate = dateString;
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: completed
              ? Colors.green.withOpacity(.18)
              : Colors.grey.withOpacity(.08),
        ),
      ),
      padding: const EdgeInsets.all(18),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: completed
                      ? const Color(0xff2E8B72)
                      : Colors.grey.shade400,
                  width: 2,
                ),
                color: completed
                    ? const Color(0xff2E8B72)
                    : Colors.transparent,
              ),
              child: completed
                  ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 18,
              )
                  : null,
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [

                    Expanded(
                      child: Text(
                        task["title"] ?? "",
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.onSurface,
                          decoration:
                          completed ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _priorityBg(priority),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        priority,
                        style: GoogleFonts.inter(
                          color: _priorityColor(priority),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),

                  ],
                ),

                if (description.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: TextStyle(
                      color: isDark
                          ? Colors.grey.shade300
                          : Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],

                const SizedBox(height: 10),

                Text(
                  "$formattedDate • ${task["time"] ?? "No Time"}",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? Colors.grey.shade300
                        : Colors.grey.shade600,
                  ),
                ),

              ],
            ),
          ),

          PopupMenuButton(
            splashRadius: 20,
            icon: Icon(
              Icons.more_vert_rounded,
              color: Colors.grey.shade500,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: onEdit,
                child: const Text("Edit"),
              ),
              PopupMenuItem(
                onTap: onDelete,
                child: const Text("Delete"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}