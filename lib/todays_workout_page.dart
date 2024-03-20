import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TodaysWorkoutPage extends StatefulWidget {
  final int workoutId;

  const TodaysWorkoutPage({Key? key, required this.workoutId}) : super(key: key);

  @override
  _TodaysWorkoutPageState createState() => _TodaysWorkoutPageState();
}

class _TodaysWorkoutPageState extends State<TodaysWorkoutPage> {
  late String workoutTitle;
  late List<Map<String, dynamic>> lifts;
  late List<bool> liftCompletionStatus; // Initialize liftCompletionStatus

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWorkoutAndLifts();
    liftCompletionStatus = []; // Initialize liftCompletionStatus here
  }

  Future<void> fetchWorkoutAndLifts() async {
    try {
      // Fetch workout information
      final workoutResponse = await http.get(Uri.parse('http://localhost:3000/workout/${widget.workoutId}'));
      if (workoutResponse.statusCode == 200) {
        final workoutData = json.decode(workoutResponse.body);
        workoutTitle = workoutData['TITLE'];
      } else {
        throw Exception('Failed to fetch workout information');
      }

      // Fetch lifts associated with the workout ID
      final liftsResponse = await http.get(Uri.parse('http://localhost:3000/lifts?Workout_ID=${widget.workoutId}'));
      if (liftsResponse.statusCode == 200) {
        final liftsData = json.decode(liftsResponse.body);
        lifts = List<Map<String, dynamic>>.from(liftsData);
        liftCompletionStatus = List.generate(lifts.length, (index) => false); // Initialize liftCompletionStatus with default values
      } else {
        throw Exception('Failed to fetch lifts');
      }

      setState(() {
        _isLoading = false; // Set loading state to false after data is fetched
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Today\'s Workout'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching data
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Workout Title: $workoutTitle',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Lifts:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: lifts.length,
                      itemBuilder: (context, index) {
                        final lift = lifts[index];
                        return ListTile(
                          title: Text(lift['LIFT_TITLE']),
                          subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sets: ${lift['SETS']}, Reps: ${lift['REPS']}'),
          Text('Completed: ${lift['ISCOMPLETED'] == 1 ? 'Yes' : 'No'}'),
        ],
      ),
                          trailing: Checkbox(
                            value: lift['ISCOMPLETED'] == 1 , // Use liftCompletionStatus to determine checkbox value
                            onChanged: (value) async {
                              setState(() {
                                liftCompletionStatus[index] = value ?? false; // Update the local state immediately
                              });
// Prepare the lift data for update
  final liftData = {
    'LIFT_TITLE': lift['LIFT_TITLE'],
    'SETS': lift['SETS'],
    'REPS': lift['REPS'],
    'ISCOMPLETED': value,
  };

    print('JSON being sent: $liftData'); // Print the JSON being sent

final String liftJson = '''
{
  "liftTitle": "Updated Bench Press",
  "sets": 4,
  "reps": 12,
  "isCompleted": $value
}
''';
                              // Send a request to your API to update the completion status
                              try {
  final response = await http.put(
    Uri.parse('http://localhost:3000/lifts/${lift['ID']}'),
    body: liftJson,
    headers: {'Content-Type': 'application/json'},
  );
  print('Response status code: ${response.statusCode}');
  print('Response body: ${response.body}');
  print(liftJson);

  if (response.statusCode != 200) {
    // Handle error
    print('Failed to update lift completion status');
    // Rollback state change if update fails
    setState(() {
      liftCompletionStatus[index] = !liftCompletionStatus[index];
    });
  }
} catch (e) {
                                // Handle error
                                print('Error updating lift completion status: $e');
                                // Rollback state change if update fails
                                setState(() {
                                  liftCompletionStatus[index] = !liftCompletionStatus[index];
                                });
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}