import 'package:flutter/material.dart';
import '../widgets/activity_chart.dart';
import '../widgets/habit_tracker.dart';
import '../widgets/wakeup_time.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Engineer Productivity'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const WakeUpTimeTracker(),
            const SizedBox(height: 20),
            const ActivityChart(),
            const SizedBox(height: 20),
            HabitTracker(),
          ],
        ),
      ),
    );
  }
}