import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:workout_app/view_workout_page.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _currentDate;
  List<dynamic> _calendarData = []; // Store response data here

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    _fetchCalendarData();
  }

  Future<void> _fetchCalendarData() async {
    final response = await http.get(Uri.parse('http://localhost:3000/calendar/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _calendarData = data;
      });
    } else {
      print('Failed to fetch calendar data');
    }
  }

  Future<String?> getWorkoutTitle(int workoutId) async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/workout/$workoutId'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['TITLE'];
      } else {
        print('Failed to fetch workout title');
        return null;
      }
    } catch (e) {
      print('Error fetching workout title: $e');
      return null;
    }
  }

  Future<void> showWorkoutTitle(BuildContext context, int workoutId) async {
    String? workoutTitle = await getWorkoutTitle(workoutId);
    if (workoutTitle != null) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Workout Title'),
          content: Text(workoutTitle),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewWorkoutPage(workoutId: workoutId)),
                );
              },
              child: Text('View Workout'),
            ),
          ],
        );
      },
    );
  } else {
      // Handle error or display a message indicating failure to fetch workout title
    }
  }

  int? getWorkoutIdForDate(DateTime selectedDate) {
    String selectedDateString = DateFormat('yyyy-MM-dd').format(selectedDate);

    for (var entry in _calendarData) {
      String date = entry['DATE'].substring(0, 10);
      int workoutId = entry['Workout_ID'];

      if (date == selectedDateString) {
        return workoutId;
      }
    }

    return null;
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
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(_currentDate.year, _currentDate.month),
      lastDay: DateTime.utc(_currentDate.year, _currentDate.month + 1).subtract(Duration(days: 1)),
      focusedDay: _currentDate,
      calendarFormat: CalendarFormat.month,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
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
      onDaySelected: (selectedDate, focusedDate) async {
        int? workoutId = getWorkoutIdForDate(selectedDate);
        if (workoutId != null) {
          await showWorkoutTitle(context, workoutId);
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('No Workout Scheduled'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close'),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}
