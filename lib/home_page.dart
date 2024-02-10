import 'package:flutter/material.dart';
import 'package:workout_app/create_workout_page.dart';
import 'package:workout_app/profile_page.dart';
import 'package:workout_app/bottom_navbar.dart';
import 'package:workout_app/calendar_page.dart';

class HomePage extends StatelessWidget {
  final int userID;

  const HomePage({Key? key, required this.userID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalendarPage()),
                );              },
              child: Text('Go to Calendar Page'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateWorkoutPage(userId: userID)),);
              },
              child: Text('Create Workout'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to the user profile page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage(userID: userID)),
                );
              },
              child: Text('View User Profile'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to today's workout page
              },
              child: Text("Today's Workout"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1, // Set the current index for the home page
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CalendarPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage(userID: userID)),
            );
          }
        },
      ),
    );
  }
}
