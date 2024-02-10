import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart'; // Import the table_calendar package
import 'package:workout_app/bottom_navbar.dart'; // Import your bottom navigation bar
import 'package:http/http.dart' as http;
import 'dart:convert';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _currentDate;
  Map<DateTime, List<int>> _workoutIds = {};

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    _fetchWorkoutIds();
  }

  Future<void> _fetchWorkoutIds() async {
    final response = await http.get(Uri.parse('http://localhost:3000/calendar/'));
      print('API Response: ${response.body}'); 
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _workoutIds.clear();
        for (var entry in data) {
          final date = DateTime.parse(entry['DATE']);
          final workoutId = entry['Workout_ID'] as int;
          if (_workoutIds[date] == null) {
            _workoutIds[date] = [workoutId];
          } else {
            _workoutIds[date]!.add(workoutId);
          }
        }
      });
    } else {
      print('Failed to fetch workout IDs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar Page'),
      ),
      body: Center(
        child: _buildCalendar(),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0, // Set the current index for the calendar page
        onTap: (index) {
          if (index == 1) {
            Navigator.pop(context); // Navigate back to the home page
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/profile'); // Navigate to the profile page
          }
        },
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(_currentDate.year, _currentDate.month),
      lastDay: DateTime.utc(_currentDate.year, _currentDate.month + 1).subtract(Duration(days: 1)),
      focusedDay: _currentDate,
      calendarFormat: CalendarFormat.month,
      headerStyle: HeaderStyle(
        formatButtonVisible: false, // Hide the format button
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Colors.black),
        weekendStyle: TextStyle(color: Colors.red),
      ),
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(color: Colors.blue.withOpacity(0.5)),
        selectedDecoration: BoxDecoration(color: Colors.blue),
        markersMaxCount: 2,
      ),
      eventLoader: (date) {
        final workoutIds = 1; // _workoutIds[date];
      print('Workout IDs for $date: $workoutIds');
        return _workoutIds[date] ?? [];
      },
      onDaySelected: (selectedDate, focusedDate) {
        setState(() {
          _currentDate = selectedDate;
        });
      },
    );
  }
}
