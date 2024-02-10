import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:workout_app/bottom_navbar.dart';
import 'package:workout_app/calendar_page.dart';
import 'edit_profile.dart';

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
      ),
      body: _userData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${_userData!['NAME']}'),
                  Text('Description: ${_userData!['DESCRIPTION']}'),
                  Text('Username: ${_userData!['USERNAME']}'),
                  Text('Email: ${_userData!['EMAIL']}'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfilePage( userID: widget.userID)),
                      );
                    },
                    child: Text('Edit Profile'),
                  ),
                ],
              ),
            ),
       bottomNavigationBar: BottomNavBar(
        currentIndex: 2, // Set the current index for the profile page
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/calendar'); // Navigate to the calendar page
          } else if (index == 1) {
            Navigator.pop(context); // Navigate back to the home page
          }
        },
      ),
    );
  }
}
