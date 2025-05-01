import 'package:flutter/material.dart';

class WakeUpTimeTracker extends StatefulWidget {
  const WakeUpTimeTracker({super.key});

  @override
  _WakeUpTimeTrackerState createState() => _WakeUpTimeTrackerState();
}

class _WakeUpTimeTrackerState extends State<WakeUpTimeTracker> {
  TimeOfDay _wakeUpTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _wakeUpTime,
    );
    if (picked != null && picked != _wakeUpTime) {
      setState(() {
        _wakeUpTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Wake-up Time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today: ${_wakeUpTime.format(context)}',
                  style: const TextStyle(fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: () => _selectTime(context),
                  child: const Text('Set Time'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}