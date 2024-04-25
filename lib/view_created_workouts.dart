import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:workout_app/view_workout_page.dart';
import 'package:workout_app/edit_workout_page.dart';
import 'package:workout_app/profile_page.dart';
import 'package:workout_app/bottom_navbar.dart';
import 'package:workout_app/calendar_page.dart';

class ViewCreatedWorkoutsPage extends StatefulWidget {
  @override
  _ViewCreatedWorkoutsPageState createState() => _ViewCreatedWorkoutsPageState();
}

class _ViewCreatedWorkoutsPageState extends State<ViewCreatedWorkoutsPage> {
  List<Map<String, dynamic>> _workouts = [];

  @override
  void initState() {
    super.initState();
    _fetchWorkouts();
  }

  Future<void> _fetchWorkouts() async {
    final response = await http.get(Uri.parse('http://localhost:3000/workout'));
    if (response.statusCode == 200) {
      setState(() {
        _workouts = List<Map<String, dynamic>>.from(json.decode(response.body).map((x) => x));
      });
    } else {
      print('Failed to fetch workouts');
    }
  }

  void _viewWorkout(int workoutId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewWorkoutPage(workoutId: workoutId)),
    );
  }

  void _editWorkout(int workoutId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditWorkoutPage(workoutId: workoutId)),
    );
  }

  void _deleteWorkout(int workoutId) async {
    final response = await http.delete(Uri.parse('http://localhost:3000/workout/$workoutId'));
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
        backgroundColor: Color(0xFF607D8B), // Set app bar color to the first color in the palette
      ),
      body: ListView.builder(
        itemCount: _workouts.length,
        itemBuilder: (context, index) {
          final workout = _workouts[index];
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Color(0xFF212121),  
            child: ListTile(
              title: Text(
                workout['TITLE'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD9D9D9),  
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_red_eye),
                    color: Colors.grey[500],  
                    onPressed: () {
                      _viewWorkout(workout['ID']);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    color: Colors.blue[800],  
                    onPressed: () {
                      _editWorkout(workout['ID']);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.red[400],  
                    onPressed: () {
                      _deleteWorkout(workout['ID']);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CalendarPage()),
            );
          } else if(index ==1){
            Navigator.pop(context);
          }else if (index == 2) {
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
