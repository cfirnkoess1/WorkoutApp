import 'package:flutter/material.dart';
import 'package:workout_app/create_workout_page.dart';
import 'package:workout_app/profile_page.dart';
import 'package:workout_app/bottom_navbar.dart';
import 'package:workout_app/calendar_page.dart';
import 'package:http/http.dart' as http;
import 'package:workout_app/no_workout_scheduled.dart';
import 'package:workout_app/todays_workout_page.dart';

import 'dart:convert';

class HomePage extends StatelessWidget {
  final int userID;

  const HomePage({Key? key, required this.userID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalendarPage()),
                );
              },
              child: Text('Go to Calendar Page'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateWorkoutPage(userId: userID)),
                );
              },
              child: Text('Create Workout'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage(userID: userID)),
                );
              },
              child: Text('View User Profile'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                checkForTodayWorkout(context);
              },
              child: Text("Today's Workout"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1, // Set the current index for the home page
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CalendarPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage(userID: userID)),
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchCalendarEvents() async {
    final response = await http.get(Uri.parse('http://localhost:3000/calendar'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> calendarEvents = List<Map<String, dynamic>>.from(data);
      return calendarEvents;
    } else {
      throw Exception('Failed to fetch calendar events');
    }
  }

  Future<void> checkForTodayWorkout(BuildContext context) async {
  List<Map<String, dynamic>> calendarEvents;
  try {
    calendarEvents = await fetchCalendarEvents();
    int? workoutId = getWorkoutIdForToday(calendarEvents);
    if (workoutId != null) {
      print('Workout is scheduled for today!');
      // Navigate to the page showing today's workout
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TodaysWorkoutPage(workoutId: workoutId)),
      );
    } else {
      // No workout scheduled for today
      print('No workout scheduled for today');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NoWorkoutScheduledPage()), // Use your existing NoWorkoutScheduledPage
      );
    }
  } catch (e) {
    print('Error: $e');
    // Handle error
  }
}

int? getWorkoutIdForToday(List<Map<String, dynamic>> calendarEvents) {
  DateTime today = DateTime.now();
  String todayDate = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
  for (var event in calendarEvents) {
    if (event['DATE'].startsWith(todayDate)) {
      return event['Workout_ID'];
    }
  }
  return null;
}


  bool isWorkoutScheduledForToday(List<Map<String, dynamic>> calendarEvents) {
    DateTime today = DateTime.now();
    String todayDate = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    return calendarEvents.any((event) => event['DATE'].startsWith(todayDate));
  }
}
