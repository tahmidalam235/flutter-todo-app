import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),

      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("tasks")
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final tasks = snapshot.data!.docs;

            final completed =
                tasks.where((e) => e["completed"] == true).length;

            final pending = tasks.length - completed;

            final productivity = tasks.isEmpty
                ? 0
                : ((completed / tasks.length) * 100).round();

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [

                const Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                const CircleAvatar(
                  radius: 55,
                  backgroundColor: Color(0xff2E8B72),
                  child: Text(
                    "T",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                const Center(
                  child: Text(
                    "Tahmid Alam",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                const Center(
                  child: Text(
                    "tahmid@example.com",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                Row(
                  children: [

                    Expanded(
                      child: statCard(
                        completed.toString(),
                        "Completed",
                        Colors.green,
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: statCard(
                        pending.toString(),
                        "Pending",
                        Colors.orange,
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: statCard(
                        "$productivity%",
                        "Productivity",
                        Colors.teal,
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 35),

                const Text(
                  "SETTINGS",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                settingsTile(
                  Icons.notifications_outlined,
                  "Notifications",
                ),

                settingsTile(
                  Icons.palette_outlined,
                  "Appearance",
                ),

                settingsTile(
                  Icons.help_outline,
                  "Help & Support",
                ),

                settingsTile(
                  Icons.info_outline,
                  "About",
                ),

                const SizedBox(height: 25),

                SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      Colors.red.withOpacity(.12),
                      elevation: 0,
                    ),
                    onPressed: () {},

                    child: const Text(
                      "Log Out",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),

              ],
            );
          },
        ),
      ),
    );
  }

  Widget statCard(String value, String title, Color color) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 22,
        ),
        child: Column(
          children: [

            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget settingsTile(IconData icon, String title) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.teal,
        ),
        title: Text(title),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
      ),
    );
  }
}