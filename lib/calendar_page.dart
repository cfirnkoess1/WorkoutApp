import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:workout_app/view_workout_page.dart';
import 'package:workout_app/bottom_navbar.dart';
import 'package:workout_app/home_page.dart';

import 'profile_page.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _currentDate;
  List<dynamic> _calendarData = []; 
  List<dynamic> _workoutsData = []; 

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    _fetchCalendarData();
    _fetchWorkoutsData();
  }
//get the calendar data
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
//get the workout data
  Future<void> _fetchWorkoutsData() async {
    final response = await http.get(Uri.parse('http://localhost:3000/workout'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _workoutsData = data;
      });
    } else {
      print('Failed to fetch workouts data');
    }
  }
//get the title of the workout you are searching for to put on top of the popup
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
//show a workout when you click the calendar
  Future<void> showWorkoutTitle(BuildContext context, int workoutId, DateTime selectedDate) async {
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewWorkoutPage(workoutId: workoutId)),
                  );
                },
                child: Text('View Workout',
                    style: TextStyle(color: Colors.blue[900]),),
              ),
              TextButton(
                onPressed: () {
                  // Remove the workout from the selected date
                  _removeWorkoutFromCalendar(selectedDate);
                  Navigator.of(context).pop();
                },
                child: Text('Remove Workout',
                    style: TextStyle(color: Colors.red),),
              ),TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close',
                    style: TextStyle(color: Colors.blue[900]),),
              ),
            ],
          );
        },
      );
    } else {
      
    }
  }
//delete workout function
 Future<void> _removeWorkoutFromCalendar(DateTime selectedDate) async {
  try {
    String dateString = DateFormat('yyyy-MM-dd').format(selectedDate);
    final response = await http.delete(
      Uri.parse('http://localhost:3000/calendar/$dateString'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      print('Workout removed from calendar successfully');
      // Refresh calendar data
      _fetchCalendarData();
    } else {
      print('Failed to remove workout from calendar');
    }
  } catch (e) {
    print('Error removing workout from calendar: $e');
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
      backgroundColor: const Color(0xFF212121), 
      //navbar on the page 
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0, 
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage(userID: 1)),
            );
          } else if (index == 2) {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProfilePage(userID: 1)),
            ); // Navigate back to the home page
          }
        },
      ),
    );
  }
//actual build calendar widget
  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(_currentDate.year, _currentDate.month),
      lastDay: DateTime.utc(_currentDate.year, _currentDate.month + 1).subtract(Duration(days: 1)),
      focusedDay: _currentDate,
      calendarFormat: CalendarFormat.month,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
         titleTextStyle: TextStyle(
        color: Colors.white ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Colors.white), 
        weekendStyle: TextStyle(color: Colors.red), 
      ),
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(color: Colors.blue.withOpacity(0.5)),
        selectedDecoration: BoxDecoration(color: Colors.blue),
        markersMaxCount: 2,
        defaultTextStyle: TextStyle(color: Colors.white), 
      ),
      onDaySelected: (selectedDate, focusedDate) async {
        int? workoutId = getWorkoutIdForDate(selectedDate);
        if (workoutId != null) {
          // Show workout details with the option to remove it
          await showWorkoutTitle(context, workoutId, selectedDate);
        } else {
          // Show available workouts to add
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
                    child: Text('Close',
                    style: TextStyle(color: Colors.blue[900]),),
                  ),
                  TextButton(
                    onPressed: () async {
                      await showWorkoutList(context, selectedDate);
                    },
                    child: Text('Add Workout',
                    style: TextStyle(color: Colors.blue[900]),),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }

  Future<void> showWorkoutList(BuildContext context, DateTime selectedDate) async {
    List<int> workoutIds = [];
    List<String> workoutTitles = [];
    for (var workout in _workoutsData) {
      workoutIds.add(workout['ID']);
      workoutTitles.add(workout['TITLE']);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Available Workouts'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < workoutTitles.length; i++)
                    ListTile(
                      title: Text(workoutTitles[i]),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Add calendar date with the corresponding workout ID
                          _addCalendarDate(selectedDate, workoutIds[i]);
                          Navigator.of(context).pop();
                        },
                        child: Text('Add',
                    style: TextStyle(color: Colors.blue[900]),),
                      ),
                    ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close',
                    style: TextStyle(color: Colors.blue[900]),)
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _addCalendarDate(DateTime date, int workoutId) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/calendar'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'date': DateFormat('yyyy-MM-dd').format(date),
          'workoutId': workoutId,
        }),
      );
      if (response.statusCode == 200) {
        print('Calendar date added successfully');
         // Close both dialogs
      Navigator.of(context).pop();
        // Refresh calendar data
      await _fetchCalendarData(); // Wait for data to be fetched
      setState(() {
        // Set state to trigger a rebuild of the UI
      });
      } else {
        print('Failed to add calendar date');
      }
    } catch (e) {
      print('Error adding calendar date: $e');
    }
  }
}
