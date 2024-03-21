import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:workout_app/view_workout_page.dart';

class ViewCreatedWorkoutsPage extends StatefulWidget {
  @override
  _ViewCreatedWorkoutsPageState createState() =>
      _ViewCreatedWorkoutsPageState();
}

class _ViewCreatedWorkoutsPageState extends State<ViewCreatedWorkoutsPage> {
  List<Map<String, dynamic>> _workouts = [];

  @override
  void initState() {
    super.initState();
    _fetchWorkouts();
  }

  Future<void> _fetchWorkouts() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/workout'));
    if (response.statusCode == 200) {
      setState(() {
        _workouts = List<Map<String, dynamic>>.from(
            json.decode(response.body).map((x) => x));
      });
    } else {
      print('Failed to fetch workouts');
    }
  }

  void _viewWorkout(int workoutId) {
    Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ViewWorkoutPage(workoutId: workoutId),
  ),
);

  }

  void _editWorkout(int workoutId) {
    // Implement navigation to edit workout page
  }

  void _deleteWorkout(int workoutId) async {
    final response = await http.delete(
        Uri.parse('http://localhost:3000/workout/$workoutId'));
    if (response.statusCode == 200) {
      // Workout deleted successfully, refresh the list
      _fetchWorkouts();
    } else {
      print('Failed to delete workout');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Created Workouts'),
      ),
      body: ListView.builder(
        itemCount: _workouts.length,
        itemBuilder: (context, index) {
          final workout = _workouts[index];
          return ListTile(
            title: Text(workout['TITLE']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  onPressed: () {
                    _viewWorkout(workout['ID']);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _editWorkout(workout['ID']);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteWorkout(workout['ID']);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
