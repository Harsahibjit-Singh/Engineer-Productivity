import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HabitTracker extends StatefulWidget {
  const HabitTracker({super.key});

  @override
  State<HabitTracker> createState() => _HabitTrackerState();
}

class _HabitTrackerState extends State<HabitTracker> {
  late List<Habit> habits;
  late SharedPreferences _prefs;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    _prefs = await SharedPreferences.getInstance();
    
    setState(() {
      habits = [
        Habit(
          id: 'water',
          name: 'Water Intake',
          target: 12,
          current: _prefs.getInt('water_current') ?? 0,
          unit: 'glasses',
          icon: Icons.local_drink,
          color: Colors.blue,
        ),
        Habit(
          id: 'exercise',
          name: 'Exercise',
          target: 30,
          current: _prefs.getInt('exercise_current') ?? 0,
          unit: 'minutes',
          icon: Icons.directions_run,
          color: Colors.green,
        ),
        Habit(
          id: 'dsa',
          name: 'DSA Problems',
          target: 1,
          current: _prefs.getInt('dsa_current') ?? 0,
          unit: 'problem',
          icon: Icons.code,
          color: Colors.orange,
        ),
        Habit(
          id: 'tech',
          name: 'New Tech Learning',
          target: 30,
          current: _prefs.getInt('tech_current') ?? 0,
          unit: 'minutes',
          icon: Icons.computer,
          color: Colors.purple,
        ),
      ];
      _isLoading = false;
    });
  }

  Future<void> _updateHabit(String id, int newValue) async {
    await _prefs.setInt('${id}_current', newValue);
  }

  void _incrementHabit(int index) {
    setState(() {
      if (habits[index].current < habits[index].target) {
        habits[index].current++;
        _updateHabit(habits[index].id, habits[index].current);
      }
    });
  }

  void _decrementHabit(int index) {
    setState(() {
      if (habits[index].current > 0) {
        habits[index].current--;
        _updateHabit(habits[index].id, habits[index].current);
      }
    });
  }

  void _showHabitDetails(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(habits[index].icon, color: habits[index].color, size: 28),
                  const SizedBox(width: 10),
                  Text(
                    habits[index].name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Progress: ${habits[index].current}/${habits[index].target} ${habits[index].unit}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: habits[index].target > 0 
                    ? habits[index].current / habits[index].target 
                    : 0,
                minHeight: 10,
                backgroundColor: Colors.grey[200],
                color: habits[index].color,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _decrementHabit(index),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[100],
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Decrease'),
                  ),
                  ElevatedButton(
                    onPressed: () => _incrementHabit(index),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[100],
                      foregroundColor: Colors.green,
                    ),
                    child: const Text('Increase'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Habits',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: List.generate(habits.length, (index) {
                final habit = habits[index];
                final progress = habit.target > 0 
                    ? habit.current / habit.target 
                    : 0;

                return GestureDetector(
                  onTap: () => _showHabitDetails(index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[50],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(habit.icon, color: habit.color),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  habit.name,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              Text(
                                '${habit.current}/${habit.target}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: habit.color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: progress.toDouble(),
                            minHeight: 8,
                            backgroundColor: Colors.grey[200],
                            color: habit.color,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 10),
            Text(
              'Total Progress: ${_calculateTotalProgress()}%',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateTotalProgress() {
    if (habits.isEmpty) return 0.0;
    
    double total = 0.0;
    for (var habit in habits) {
      total += habit.target > 0 ? habit.current / habit.target : 0.0;
    }
    return ((total / habits.length) * 100).roundToDouble();
  }
}

class Habit {
  final String id;
  final String name;
  final int target;
  int current;
  final String unit;
  final IconData icon;
  final Color color;

  Habit({
    required this.id,
    required this.name,
    required this.target,
    required this.current,
    required this.unit,
    required this.icon,
    required this.color,
  });
}