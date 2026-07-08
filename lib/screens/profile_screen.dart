import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import 'login_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),

      appBar: AppBar(
        backgroundColor: const Color(0xffF6F7FB),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
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

                CircleAvatar(
                  radius: 55,
                  backgroundColor: const Color(0xff2E8B72),
                  child: Text(
                    (FirebaseAuth.instance.currentUser?.displayName ?? "U")
                        .substring(0, 1)
                        .toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Center(
                  child: Text(
                    FirebaseAuth.instance.currentUser?.displayName ?? "Unknown User",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                const SizedBox(height: 20),

                SizedBox(
                  width: 170,
                  height: 45,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text("Edit Profile"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.teal,
                      side: const BorderSide(color: Colors.teal),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditProfileScreen(),
                        ),
                      );

                      if (context.mounted) {
                        (context as Element).markNeedsBuild();
                      }
                    },
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
                      Colors.red.withValues(alpha: .12),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      await AuthService().signOut();

                      if (!context.mounted) return;

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                            (route) => false,
                      );
                    },

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