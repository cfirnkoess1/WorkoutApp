import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:workout_app/bottom_navbar.dart';
import 'package:workout_app/calendar_page.dart';
import 'edit_profile.dart';
import 'home_page.dart';

class ProfilePage extends StatefulWidget {
  final int userID;

  ProfilePage({required this.userID});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    fetchUserData(widget.userID);
  }

  Future<void> fetchUserData(int userID) async {
    final response = await http.get(Uri.parse('http://localhost:3000/profile/id/$userID'));
    if (response.statusCode == 200) {
      setState(() {
        _userData = json.decode(response.body);
      });
    } else {
      print('Failed to fetch user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        backgroundColor: Color(0xFF607D8B), // Matching the color from the CreateWorkoutPage
      ),
      body: _userData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Name:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), // Adjusted the text color
                  ),
                  Text(
                    '${_userData!['NAME']}',
                    style: TextStyle(fontSize: 16, color: Colors.white), // Adjusted the text color
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Description:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), // Adjusted the text color
                  ),
                  Text(
                    '${_userData!['DESCRIPTION']}',
                    style: TextStyle(fontSize: 16, color: Colors.white), // Adjusted the text color
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Username:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), // Adjusted the text color
                  ),
                  Text(
                    '${_userData!['USERNAME']}',
                    style: TextStyle(fontSize: 16, color: Colors.white), // Adjusted the text color
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Email:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), // Adjusted the text color
                  ),
                  Text(
                    '${_userData!['EMAIL']}',
                    style: TextStyle(fontSize: 16, color: Colors.white), // Adjusted the text color
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to EditProfilePage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfilePage(userID: widget.userID)),
                    ).then((result) {
                      // Update UI if result is true (indicating successful update)
                      if (result == true) {
                        // Fetch updated user data
                        fetchUserData(widget.userID);
                      }
                    });

                    },
                    child: Text('Edit Profile',
                    style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF607D8B), // Matching the color from the CreateWorkoutPage
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2, // Set the current index for the profile page
        onTap: (index) {
          if (index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CalendarPage()),); // Navigate to the calendar page
          } else if (index == 1) {
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => HomePage(userID: 1)), ); // Navigate back to the home page
          }
        },
      ),
    );
  }
}
