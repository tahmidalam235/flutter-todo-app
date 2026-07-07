Widget taskCard(dynamic task) {
  return Card(
    margin: const EdgeInsets.only(bottom: 15),
    child: ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TaskDetailScreen(task: task),
          ),
        );
      },

      leading: Checkbox(
        value: task["completed"],
        onChanged: (value) async {
          await FirestoreService().updateTask(
            task.id,
            value!,
          );

          setState(() {});
        },
      ),

      title: Text(
        task["title"],
        style: TextStyle(
          decoration: task["completed"]
              ? TextDecoration.lineThrough
              : null,
        ),
      ),

      subtitle: Text(
        "${task["category"]} • ${task["time"]}",
      ),

      trailing: PopupMenuButton<String>(
        onSelected: (value) async {

          if (value == "delete") {

            await FirestoreService().deleteTask(task.id);

          }

          if (value == "edit") {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddTaskScreen(task: task),
              ),
            );

          }

        },

        itemBuilder: (_) => [

          const PopupMenuItem(
            value: "edit",
            child: Text("Edit"),
          ),

          const PopupMenuItem(
            value: "delete",
            child: Text("Delete"),
          ),

        ],
      ),
    ),
  );
}