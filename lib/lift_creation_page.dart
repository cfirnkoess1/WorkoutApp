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
    // Encode the list of lifts to JSON
    String requestBody = json.encode(lifts);
    String requestBody2 = requestBody.substring(1, requestBody.length - 1);
 print('Request Body: $requestBody2');
    // Example API endpoint for creating lifts
    String apiUrl = 'http://localhost:3000/lifts';

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json', // Set Content-Type header to application/json
        },
        
        body: requestBody2,

      );

      if (response.statusCode == 200) {
        // Successfully saved the lifts
        // Navigate back to the previous screen
        Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ViewWorkoutPage(workoutId: widget.workoutId),),);
      } else {
        // Failed to save lifts
        // Show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save lifts')),
        );
      }
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
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Lift Name'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _setsController,
              decoration: InputDecoration(labelText: 'Sets'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _repsController,
              decoration: InputDecoration(labelText: 'Reps'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addLift,
              child: Text('Add Lift'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: lifts.length,
                itemBuilder: (context, index) {
                  final lift = lifts[index];
                  return ListTile(
                    title: Text(lift['liftTitle']),
                    subtitle: Text('Sets: ${lift['sets']}, Reps: ${lift['reps']}'),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveLifts,
              child: Text('Save Lifts'),
            ),
          ],
        ),
      ),
    );
  }
}
