import 'package:flutter/material.dart';

class NoWorkoutScheduledPage extends StatelessWidget {
  const NoWorkoutScheduledPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("No Workout Scheduled"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No workout scheduled for today",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the create workout page
                Navigator.pop(context); // Pop this page
                // You can push the CreateWorkoutPage here if needed
              },
              child: Text("Add/Create a Workout"),
            ),
          ],
        ),
      ),
    );
  }
}
