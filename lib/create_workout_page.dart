import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:workout_app/view_created_workouts.dart';
import 'package:workout_app/lift_creation_page.dart';
import 'package:workout_app/profile_page.dart';
import 'package:workout_app/bottom_navbar.dart';
import 'package:workout_app/calendar_page.dart';

class CreateWorkoutPage extends StatefulWidget {
  final int userId;

  const CreateWorkoutPage({required this.userId});

  @override
  _CreateWorkoutPageState createState() => _CreateWorkoutPageState();
}

class _CreateWorkoutPageState extends State<CreateWorkoutPage> {
  TextEditingController _titleController = TextEditingController();

  void _createWorkout() async {
    String title = _titleController.text;

    // Encode request body to JSON
    String requestBody = json.encode({
      'title': title,
      'userId': widget.userId,
    });

    
    String apiUrl = 'http://localhost:3000/workout';

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json', 
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Workout created successfully
        // Parse the workoutId from the response
        int workoutId = json.decode(response.body)['id'];

        // Navigate to the lift creation page and pass the workoutId
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LiftCreationPage(workoutId: workoutId),
          ),
        );
      } else {
        // Failed to create workout
        // Show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create workout')),
        );
      }
    } catch (error) {
      // Handle errors from the HTTP request
      print('Error creating workout: $error');
    }
  }
//begin building the widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Workout'),
        backgroundColor: Color(0xFF607D8B), 
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Workout Title',
                labelStyle: TextStyle(color: Colors.white70), 
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white)),),
              
              cursorColor: Color.fromARGB(255, 115, 136, 146), 
  style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle form submission
                _createWorkout();
              },
              child: Text(
                'Create Workout',
                style: TextStyle(color: Colors.white), 
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF607D8B), 
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to view created workouts page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewCreatedWorkoutsPage()),
                );
              },
              child: Text(
                'View Created Workouts',
                style: TextStyle(color: Colors.white), 
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF607D8B), 
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
          } else if (index == 1) {
            Navigator.pop(context);
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage(userID: 1)),
            );
          }
        },
      ),
    );
  }
}
