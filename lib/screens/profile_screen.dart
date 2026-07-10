import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

import '../services/auth_service.dart';
import 'login_screen.dart';
import 'edit_profile_screen.dart';
import 'notification_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'main_navigation_screen.dart';
import 'dart:async';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  late Timer _timer;
  DateTime _currentTime = DateTime.now();

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
    _timer.cancel();
    super.dispose();
  }
  String getGreeting() {
    final hour = _currentTime.hour;

    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xff121212) : const Color(0xffF6F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const MainNavigationScreen(),
              ),
            );
          },
        ),
        title: const Text("Profile"),
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
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              children: [

                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff2E8B72),
                        Color(0xff49B59B),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff2E8B72)
                            .withValues(alpha: .25),
                        blurRadius: 22,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [

                            Text(
                              "${getGreeting()} 👋",
                              style: GoogleFonts.inter(
                                color: Colors.white70,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              FirebaseAuth.instance.currentUser
                                  ?.displayName ??
                                  "User",
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
            DateFormat(
            "EEEE, dd MMMM yyyy",
            ).format(_currentTime),
                              style: GoogleFonts.inter(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
            DateFormat(
            "hh:mm a",
            ).format(_currentTime),
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                          ],
                        ),
                      ),

                      CircleAvatar(
                        radius: 34,
                        backgroundColor: Colors.white24,
                        child: Text(
                          (FirebaseAuth.instance.currentUser
                              ?.displayName ??
                              "U")[0]
                              .toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

                const SizedBox(height: 25),


                const SizedBox(height: 15),



                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton.icon(
                    icon: const Icon(
                      Icons.edit_rounded,
                      size: 20,
                    ),
                    label: const Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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



                Text(
                  "SETTINGS",
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Card(
                  color: isDark
                      ? const Color(0xff1F1F1F)
                      : Colors.white,
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.teal,
                    ),
                    title: Text(
                      "Notifications",
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationScreen(),
                        ),
                      );
                    },
                  ),
                ),

                Card(
                  color: isDark
                      ? const Color(0xff1F1F1F)
                      : Colors.white,
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return SwitchListTile(
                        secondary: const Icon(
                          Icons.dark_mode_outlined,
                          color: Colors.teal,
                        ),
                        title: Text(
                          "Dark Mode",
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        value: themeProvider.isDarkMode,
                        onChanged: (value) {
                          themeProvider.toggleTheme(value);
                        },
                      );
                    },
                  ),
                ),

                settingsTile(
                  Icons.help_outline,
                  "Help & Support",
                  isDark,
                ),

                settingsTile(
                  Icons.info_outline,
                  "About",
                  isDark,
                ),

                const SizedBox(height: 25),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .05),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [

                          const Icon(
                            Icons.verified_user_rounded,
                            color: Color(0xff2E8B72),
                          ),

                          const SizedBox(width: 10),

                          Text(
                            "Profile Completion",
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                        ],
                      ),

                      const SizedBox(height: 20),

                      LinearProgressIndicator(
                        value: 1.0,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(20),
                        backgroundColor: Colors.grey.withValues(alpha: .15),
                        valueColor: const AlwaysStoppedAnimation(
                          Color(0xff2E8B72),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "100% Complete",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff2E8B72),
                        ),
                      ),

                    ],
                  ),
                ),

                const SizedBox(height: 30),

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

  Widget statCard(
      String value,
      String title,
      Color color,
      bool isDark,
      ) {
    return Card(
      color: isDark
          ? const Color(0xff1F1F1F)
          : Colors.white,
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
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey,
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget settingsTile(
      IconData icon,
      String title,
      bool isDark,
      ) {
    return Card(
      color: isDark
          ? const Color(0xff1F1F1F)
          : Colors.white,
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
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: isDark ? Colors.white70 : Colors.black54,
          size: 16,
        ),
      ),
    );
  }
}

