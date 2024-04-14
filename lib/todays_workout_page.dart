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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWorkoutAndLifts();
  }

  Future<void> fetchWorkoutAndLifts() async {
    try {
      // Fetch workout information
      final workoutResponse =
          await http.get(Uri.parse('http://localhost:3000/workout/${widget.workoutId}'));
      if (workoutResponse.statusCode == 200) {
        final workoutData = json.decode(workoutResponse.body);
        workoutTitle = workoutData['TITLE'];
      } else {
        throw Exception('Failed to fetch workout information');
      }

      // Fetch lifts associated with the workout ID
      final liftsResponse =
          await http.get(Uri.parse('http://localhost:3000/lifts/workout/${widget.workoutId}'));
      if (liftsResponse.statusCode == 200) {
        final liftsData = json.decode(liftsResponse.body);
        lifts = List<Map<String, dynamic>>.from(liftsData);
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
        title: Text("Today's Workout"),
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
                          subtitle: Text('Sets: ${lift['SETS']}, Reps: ${lift['REPS']}'),
                          trailing: Checkbox(
                            value: lift['ISCOMPLETED'] == 1,
                            onChanged: (value) async {
                              try {
                                setState(() {
                                  lift['ISCOMPLETED'] = lift['ISCOMPLETED'] == 1 ? 0 : 1; // Update the local state immediately
                                });

                                // Send a request to update the completion status
                                final response = await http.put(
                                  Uri.parse('http://localhost:3000/lifts/${lift['ID']}'),
                                  body: jsonEncode({
                                    'liftTitle': lift['LIFT_TITLE'],
                                    'workoutId': widget.workoutId,
                                    'sets': lift['SETS'],
                                    'reps': lift['REPS'],
                                    'isCompleted': value,
                                  }),
                                  headers: {'Content-Type': 'application/json'},
                                );

                                if (response.statusCode != 200) {
                                  // Handle error
                                  print('Failed to update lift completion status');
                                  setState(() {
                                    // Rollback state change if update fails
                                    lift['ISCOMPLETED'] = lift['ISCOMPLETED'] == 1 ? 0 : 1;
                                  });
                                }
                              } catch (error) {
                                // Handle error
                                print('Error updating lift completion status: $error');
                                setState(() {
                                  // Rollback state change if update fails
                                  lift['ISCOMPLETED'] = lift['ISCOMPLETED'] == 1 ? 0 : 1;
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
