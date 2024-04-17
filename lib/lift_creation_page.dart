import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:workout_app/view_workout_page.dart';

class LiftCreationPage extends StatefulWidget {
  final int workoutId;

  const LiftCreationPage({required this.workoutId});

  @override
  _LiftCreationPageState createState() => _LiftCreationPageState();
}

class _LiftCreationPageState extends State<LiftCreationPage> {
  List<Map<String, dynamic>> lifts = [];
  TextEditingController _nameController = TextEditingController();
  TextEditingController _setsController = TextEditingController();
  TextEditingController _repsController = TextEditingController();

  void _addLift() {
    String name = _nameController.text;
    int sets = int.tryParse(_setsController.text) ?? 0;
    int reps = int.tryParse(_repsController.text) ?? 0;

    if (name.isNotEmpty && sets > 0 && reps > 0) {
      setState(() {
        lifts.add({
          'liftTitle': name,
          'workoutId': widget.workoutId,
          'sets': sets,
          'reps': reps,
          'isCompleted': false,
        });
      });

      // Clear the text fields after adding a lift
      _nameController.clear();
      _setsController.clear();
      _repsController.clear();
    }
  }

  void _saveLifts() async {
    // Example API endpoint for creating a lift
    String apiUrl = 'http://localhost:3000/lifts';

    try {
      for (var lift in lifts) {
        // Encode the lift to JSON
        String requestBody = json.encode(lift);

        var response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json', // Set Content-Type header to application/json
          },
          body: requestBody,
        );

        if (response.statusCode == 200) {
          // Successfully saved the lift
          print('Lift saved: ${lift['liftTitle']}');
        } else {
          // Failed to save lift
          print('Failed to save lift: ${lift['liftTitle']} - ${response.statusCode} ${response.body}');
        }
      }

      // Navigate back to the previous screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ViewWorkoutPage(workoutId: widget.workoutId),
        ),
      );
    } catch (error) {
      // Handle errors from the HTTP request
      print('Error saving lifts: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Lifts'),
        backgroundColor: Color(0xFF607D8B), // Matching the color from the CreateWorkoutPage
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Lift Name',
                labelStyle: TextStyle(color: Colors.white70), // Adjusted the label color
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              cursorColor: Color(0xFF738892), // Matching the color from the CreateWorkoutPage
              style: TextStyle(color: Colors.white), // Adjusted the text color
            ),
            SizedBox(height: 10),
            TextField(
              controller: _setsController,
              decoration: InputDecoration(
                labelText: 'Sets',
                labelStyle: TextStyle(color: Colors.white70), // Adjusted the label color
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              keyboardType: TextInputType.number,
              cursorColor: Color(0xFF738892), // Matching the color from the CreateWorkoutPage
              style: TextStyle(color: Colors.white), // Adjusted the text color
            ),
            SizedBox(height: 10),
            TextField(
              controller: _repsController,
              decoration: InputDecoration(
                labelText: 'Reps',
                labelStyle: TextStyle(color: Colors.white70), // Adjusted the label color
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              keyboardType: TextInputType.number,
              cursorColor: Color(0xFF738892), // Matching the color from the CreateWorkoutPage
              style: TextStyle(color: Colors.white), // Adjusted the text color
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addLift,
              child: Text(
                'Add Lift',
                style: TextStyle(color: Colors.white), // Adjusted the text color
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF607D8B), // Matching the color from the CreateWorkoutPage
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: lifts.length,
                itemBuilder: (context, index) {
                  final lift = lifts[index];
                  return ListTile(
                    title: Text(
                      lift['liftTitle'],
                      style: TextStyle(color: Colors.white), // Adjusted the text color
                    ),
                    subtitle: Text(
                      'Sets: ${lift['sets']}, Reps: ${lift['reps']}',
                      style: TextStyle(color: Colors.white70), // Adjusted the text color
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveLifts,
              child: Text(
                'Save Workout',
                style: TextStyle(color: Colors.white), // Adjusted the text color
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF607D8B), // Matching the color from the CreateWorkoutPage
              ),
            ),
          ],
        ),
      ),
    );
  }
}
