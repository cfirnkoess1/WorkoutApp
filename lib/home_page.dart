 import 'package:flutter/material.dart';
import 'package:workout_app/create_workout_page.dart';
import 'package:workout_app/profile_page.dart';
import 'package:workout_app/bottom_navbar.dart';
import 'package:workout_app/calendar_page.dart';
import 'package:http/http.dart' as http;
import 'package:workout_app/no_workout_scheduled.dart';
import 'package:workout_app/todays_workout_page.dart';
import 'package:workout_app/view_created_workouts.dart';

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
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, 
                mainAxisSpacing: 20.0, 
                crossAxisSpacing: 20.0, 
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CalendarPage()),
                      );
                    },
                    child: Text(
                      'Go to Calendar Page',
                      style: TextStyle(color: Color(0xFFD9D9D9)),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45.0),
                      ),
                      primary: Color(0xFF37474F), 
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ViewCreatedWorkoutsPage()),
                      );
                    },
                    child: Text(
                      'View Created Workouts',
                      style: TextStyle(color: Color(0xFFD9D9D9)), 
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45.0),
                      ),
                      primary: Color(0xFF37474F), 
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreateWorkoutPage(userId: userID)),
                      );
                    },
                    child: Text(
                      'Create Workout',
                      style: TextStyle(color: Color(0xFFD9D9D9)), 
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45.0),
                      ),
                      primary: Color(0xFF37474F), 
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage(userID: userID)),
                      );
                    },
                    child: Text(
                      'View User Profile',
                      style: TextStyle(color: Color(0xFFD9D9D9)), 
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45.0),
                      ),
                      primary: Color(0xFF37474F), 
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                checkForTodayWorkout(context);
              },
              child: Text(
                "Today's Workout",
                style: TextStyle(color: Color(0xFFD9D9D9)),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 150),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45.0),
                ),
                primary: Color(0xFF37474F), 
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TodaysWorkoutPage(workoutId: workoutId)),
        );
      } else {
        // No workout scheduled for today
        print('No workout scheduled for today');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NoWorkoutScheduledPage()),
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
}