import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class WeeklyActivityScreen extends StatelessWidget {
  final List<double> weeklyData;

  const WeeklyActivityScreen({
    super.key,
    required this.weeklyData,
  });

  List<DateTime> get _weekDates {
    final now = DateTime.now();

    final monday = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));

    return List.generate(
      7,
          (i) => monday.add(Duration(days: i)),
    );
  }

  double get _maxY {
    final max = weeklyData.reduce((a, b) => a > b ? a : b);

    if (max <= 4) return 5;

    return max + 1;
  }

  BarChartGroupData _bar(int x, double y) {
    final today = DateTime.now().weekday - 1;

    final bool isToday = x == today;

    return BarChartGroupData(
      x: x,
      showingTooltipIndicators: [0],
      barRods: [

        BarChartRodData(
          toY: y,
          width: isToday ? 22 : 18,

          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),

          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: isToday
                ? const [
              Color(0xff145A4B),
              Color(0xff2E8B72),
            ]
                : const [
              Color(0xff2E8B72),
              Color(0xff57D2B2),
            ],
          ),

          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: _maxY,
            color: Colors.grey.withValues(alpha: .12),
          ),
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final weekDates = _weekDates;

    final totalCompleted =
    weeklyData.fold<double>(0, (sum, value) => sum + value);

    final highest = weeklyData.reduce(
          (a, b) => a > b ? a : b,
    );

    final bestDayIndex = weeklyData.indexOf(highest);

    final bestDay =
    highest == 0
        ? "No Activity"
        : DateFormat("EEEE").format(
      weekDates[bestDayIndex],
    );

    return Scaffold(
      backgroundColor:
      isDark
          ? const Color(0xff121212)
          : const Color(0xffF6F7FB),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor:
        isDark
            ? const Color(0xff121212)
            : const Color(0xffF6F7FB),

        title: const Text(
          "Weekly Activity",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
          padding: const EdgeInsets.all(20),
          children: [

      Container(
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),

        gradient: const LinearGradient(
          colors: [
            Color(0xff2E8B72),
            Color(0xff4CB69F),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        boxShadow: [
          BoxShadow(
            color: const Color(0xff2E8B72)
                .withValues(alpha: .25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          const Text(
            "This Week",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "${totalCompleted.toInt()} Tasks Completed",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [

              _summaryItem(
                "Best Day",
                bestDay,
              ),

              _summaryItem(
                "Average",
                "${(totalCompleted / 7).toStringAsFixed(1)}",
              ),

            ],
          ),

        ],
      ),
    ),

    const SizedBox(height: 28),

    Container(
    padding: const EdgeInsets.all(22),

    decoration: BoxDecoration(
    color: Theme.of(context).cardColor,

    borderRadius:
    BorderRadius.circular(26),

    boxShadow: [
    BoxShadow(
    color:
    Colors.black.withValues(alpha: .05),
    blurRadius: 18,
    offset: const Offset(0, 8),
    ),
    ],
    ),

    child: Column(
    crossAxisAlignment:
    CrossAxisAlignment.start,
    children: [

    Row(
    children: [

    const Icon(
    Icons.bar_chart_rounded,
    color: Color(0xff2E8B72),
    ),

    const SizedBox(width: 10),

    Text(
    "Weekly Performance",
    style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color:
    Theme.of(context)
        .colorScheme
        .onSurface,
    ),
    ),

    ],
    ),

    const SizedBox(height: 30),
    SizedBox(
    height: 340,
    child: BarChart(
    BarChartData(
    maxY: _maxY,
    alignment: BarChartAlignment.spaceAround,
    borderData: FlBorderData(show: false),

      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (_) {
          return FlLine(
            strokeWidth: .8,
            color: Colors.grey.withValues(alpha: .15),
          );
        },
      ),

    titlesData: FlTitlesData(
    leftTitles: const AxisTitles(),
    rightTitles: const AxisTitles(),
    topTitles: AxisTitles(
    sideTitles: SideTitles(
    showTitles: true,
    reservedSize: 28,
    getTitlesWidget: (value, meta) {
    final index = value.toInt();

    if (index < 0 || index >= weeklyData.length) {
    return const SizedBox();
    }

    return Text(
    weeklyData[index].toInt().toString(),
    style: TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.bold,
    color: Colors.grey.shade700,
    ),
    );
    },
    ),
    ),

    bottomTitles: AxisTitles(
    sideTitles: SideTitles(
    showTitles: true,
    reservedSize: 62,
    getTitlesWidget: (value, meta) {
    final index = value.toInt();

    if (index < 0 || index > 6) {
    return const SizedBox();
    }

    final date = weekDates[index];
    final isToday = DateUtils.isSameDay(
    date,
    DateTime.now(),
    );

    return Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [

    Container(
    padding: const EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 3,
    ),
    decoration: BoxDecoration(
    color: isToday
    ? const Color(0xff2E8B72)
        : Colors.transparent,
    borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
    DateFormat("dd").format(date),
    style: TextStyle(
    color: isToday
    ? Colors.white
        : Theme.of(context)
        .colorScheme
        .onSurface,
    fontWeight: FontWeight.bold,
    fontSize: 13,
    ),
    ),
    ),

    const SizedBox(height: 4),

    Text(
    DateFormat("EEE").format(date),
    style: TextStyle(
    fontSize: 12,
    color: isToday
    ? const Color(0xff2E8B72)
        : Colors.grey.shade600,
    fontWeight: isToday
    ? FontWeight.bold
        : FontWeight.normal,
    ),
    ),

    ],
    ),
    );
    },
    ),
    ),
    ),

    barGroups: List.generate(
    7,
    (i) => _bar(i, weeklyData[i]),
    ),
    ),
    ),
    ),

    const SizedBox(height: 20),

      if (totalCompleted == 0)
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            children: [

              const Icon(
                Icons.insights_rounded,
                size: 60,
                color: Color(0xff2E8B72),
              ),

              const SizedBox(height: 18),

              Text(
                "No activity this week",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Complete your first task to start building your weekly progress.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 15,
                ),
              ),

            ],
          ),
        )
      else
        Column(
          children: [

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .05),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [

                  const Icon(
                    Icons.emoji_events_rounded,
                    color: Color(0xff2E8B72),
                    size: 42,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Weekly Insight",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    "🏆 Best Day: $bestDay",
                    style: const TextStyle(fontSize: 17),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "✅ Completed: ${totalCompleted.toInt()} task(s)",
                    style: const TextStyle(fontSize: 17),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "📈 Average: ${(totalCompleted / 7).toStringAsFixed(1)} task/day",
                    style: const TextStyle(fontSize: 17),
                  ),

                ],
              ),
            ),

          ],
        ),
    ],
    ),
    ),
          ],
      ),
    );
  }

  Widget _summaryItem(
      String title,
      String value,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

      ],
    );
  }
  }