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
    final completed = task["completed"] ?? false;
    final priority = task["priority"] ?? "Medium";
    final description = task["description"] ?? "";
    final category = task["category"] ?? "";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
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

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  task["title"],
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    decoration: completed
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),

                if (description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],

                const SizedBox(height: 14),

                Row(
                  children: [

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
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

                    const SizedBox(width: 10),

                    Text(
                      task["time"] ?? "",
                      style: GoogleFonts.inter(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(width: 6),

                    Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 6),

                    Text(
                      category,
                      style: GoogleFonts.inter(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
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