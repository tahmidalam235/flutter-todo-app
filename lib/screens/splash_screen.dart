import 'dart:async';

import 'package:flutter/material.dart';

import 'main_navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 2),
          () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const MainNavigationScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? Colors.black : Colors.white,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.asset(
              "assets/logo/piuuuu_logo.png",
              height: 120,
            ),

            const SizedBox(height: 28),

            Image.asset(
              "assets/logo/piuuuu_logo_text.png",
              height: 52,
            ),

            const SizedBox(height: 18),

            Text(
              "Organize your day",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),

          ],
        ),
      ),
    );
  }
}