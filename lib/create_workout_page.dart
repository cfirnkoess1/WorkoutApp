import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:workout_app/view_created_workouts.dart';

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

    // Example API endpoint for creating a workout
    String apiUrl = 'http://localhost:3000/workout';

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json', // Set Content-Type header to application/json
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Workout created successfully
        // Navigate to the home page or show a success message
        Navigator.push(
                context,
      MaterialPageRoute(builder: (context) => ViewCreatedWorkoutsPage()),
                ); // Return true to indicate success
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Workout'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Workout Title'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle form submission
                _createWorkout();
              },
              child: Text('Create Workout'),
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
              child: Text('View Created Workouts'),
            ),
          ],
        ),
      ),
    );
  }
}
