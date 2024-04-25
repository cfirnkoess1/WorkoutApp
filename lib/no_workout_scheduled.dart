import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:workout_app/todays_workout_page.dart';

class NoWorkoutScheduledPage extends StatefulWidget {
  const NoWorkoutScheduledPage({Key? key}) : super(key: key);

  @override
  _NoWorkoutScheduledPageState createState() => _NoWorkoutScheduledPageState();
}

class _NoWorkoutScheduledPageState extends State<NoWorkoutScheduledPage> {
  late List<dynamic> _workoutsData = []; // Store workouts data here

  @override
  void initState() {
    super.initState();
    _fetchWorkoutsData();
  }

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

  Future<void> _addWorkoutToToday(BuildContext context, int workoutId) async {
    DateTime today = DateTime.now();
    String todayDate = DateFormat('yyyy-MM-dd').format(today);

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/calendar'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'date': todayDate,
          'workoutId': workoutId,
        }),
      );
      if (response.statusCode == 201) {
        print('Workout added to today\'s date successfully');
        // Navigate to TodaysWorkoutPage
        Navigator.pushReplacementNamed(context, '/todays_workout');
      } else {
        print('Failed to add workout to today\'s date');
      }
    } catch (e) {
      print('Error adding workout to today\'s date: $e');
    }
  }

  Future<void> _showWorkoutList(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Available Workouts'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var workout in _workoutsData)
                ListTile(
                  title: Text(workout['TITLE']),
                  onTap: () {
                    // Add the workout to today's date and update TodaysWorkoutPage
                    _addWorkoutToToday(context, workout['ID']);
                    Navigator.pop(context); // Close the dialog
                    // Navigate and refresh TodaysWorkoutPage
                    Navigator.pop(context); // Pop the NoWorkoutScheduledPage
                  },
                ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Navigate and refresh TodaysWorkoutPage
                Navigator.pop(context); // Pop the NoWorkoutScheduledPage
              },
              child: Text('Close',
              style: TextStyle(color: Colors.blue[900])),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("No Workout Scheduled"),
        backgroundColor: Color(0xFF607D8B), // Matching the color from the TodaysWorkoutPage
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No workout scheduled for today",
              style: TextStyle(fontSize: 20, color: Color(0xFF607D8B)),  
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Show the list of available workouts
                _showWorkoutList(context);
              },
              child: Text("Add a Workout",
              style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF607D8B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
