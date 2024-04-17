import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditWorkoutPage extends StatefulWidget {
  final int workoutId;

  const EditWorkoutPage({required this.workoutId});

  @override
  _EditWorkoutPageState createState() => _EditWorkoutPageState();
}

class _EditWorkoutPageState extends State<EditWorkoutPage> {
  List<Map<String, dynamic>> _lifts = []; // Store lifts data here
  TextEditingController _liftTitleController = TextEditingController();
  TextEditingController _setsController = TextEditingController();
  TextEditingController _repsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchLifts();
  }

  Future<void> _fetchLifts() async {
    final response = await http.get(Uri.parse('http://localhost:3000/lifts/workout/${widget.workoutId}'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _lifts = List<Map<String, dynamic>>.from(data);
      });
    } else {
      print('Failed to fetch lifts');
    }
  }

  void _editLift(int liftId) {
    // Navigate to a page for editing the selected lift
    // You can pass the liftId to the edit page if needed
  }

  void _deleteLift(int liftId) async {
    final response = await http.delete(Uri.parse('http://localhost:3000/lifts/$liftId'));
    if (response.statusCode == 200) {
      // Lift deleted successfully, refresh the list
      _fetchLifts();
    } else {
      print('Failed to delete lift');
    }
  }

  void _addLift() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Lift'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                cursorColor: Color(0xFF37474F),
                controller: _liftTitleController,
                decoration: InputDecoration(labelText: 'Lift Title'),
              ),
              TextField(
                cursorColor: Color(0xFF37474F),
                controller: _setsController,
                decoration: InputDecoration(labelText: 'Sets'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                cursorColor: Color(0xFF37474F),
                controller: _repsController,
                decoration: InputDecoration(labelText: 'Reps'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.blue[900]),),
            ),
            TextButton(
              onPressed: () async {
                Map<String, dynamic> newLift = {
                  'liftTitle': _liftTitleController.text,
                  'workoutId': widget.workoutId,
                  'sets': int.tryParse(_setsController.text) ?? 0,
                  'reps': int.tryParse(_repsController.text) ?? 0,
                  'isCompleted': false,
                };

                final response = await http.post(
                  Uri.parse('http://localhost:3000/lifts'),
                  headers: {'Content-Type': 'application/json'},
                  body: json.encode(newLift),
                );

                if (response.statusCode == 200) {
                  // Lift added successfully
                  // Refresh the list of lifts
                  _fetchLifts();
                  Navigator.of(context).pop();
                } else {
                  // Failed to add lift
                  print('Failed to add lift: ${response.statusCode}');
                  print('Error message: ${response.body}');
                }

                _liftTitleController.clear();
                _setsController.clear();
                _repsController.clear();
              },
              child: Text('Add', style: TextStyle(color: Colors.blue[900]),),
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
        title: Text('Edit Workout'),
        backgroundColor: Color(0xFF607D8B), // Matching the color from other pages
      ),
      body: ListView.builder(
        itemCount: _lifts.length,
        itemBuilder: (context, index) {
          final lift = _lifts[index];
          return ListTile(
            title: Text(
              lift['LIFT_TITLE'],
              style: TextStyle(color: Colors.white), // Adjusted text color to be lighter
            ),
            subtitle: Text(
              'Sets: ${lift['SETS']}, Reps: ${lift['REPS']}',
              style: TextStyle(color: Colors.white), // Adjusted text color to be lighter
            ),
            onTap: () {
              _editLift(lift['ID']); // Navigate to edit lift page
            },
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red[700]),
              onPressed: () {
                _deleteLift(lift['ID']); // Delete lift on button press
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF37474F),
        onPressed: () {
          _addLift(); // Call function to add new lift
        },
        child: Icon(Icons.add, color: Colors.blue[200]),
      ),
    );
  }
}
