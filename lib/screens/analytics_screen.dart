import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xff121212) : const Color(0xffF6F7FB),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor:
        isDark ? const Color(0xff121212) : const Color(0xffF6F7FB),
        title: const Text(
          "Analytics",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          _sectionCard(
            context,
            "📊 Productivity Score",
            "Shows your completion percentage.",
          ),

          const SizedBox(height: 20),

          _sectionCard(
            context,
            "📈 Weekly Activity",
            "Your task activity this week.",
          ),

          const SizedBox(height: 20),

          _sectionCard(
            context,
            "🥧 Category Distribution",
            "Tasks grouped by category.",
          ),

          const SizedBox(height: 20),

          _sectionCard(
            context,
            "🔥 Current Streak",
            "Coming Soon",
          ),

          const SizedBox(height: 20),

          _sectionCard(
            context,
            "🏆 Achievements",
            "Coming Soon",
          ),

          const SizedBox(height: 20),

          _sectionCard(
            context,
            "💡 Productivity Insights",
            "Coming Soon",
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(
      BuildContext context,
      String title,
      String subtitle,
      ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}