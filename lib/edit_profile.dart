import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditProfilePage extends StatefulWidget {
  final int userID;

  const EditProfilePage({required this.userID});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _profileImageController = TextEditingController();

  void _updateProfile() async {
    String newName = _nameController.text;
    String newDescription = _descriptionController.text;
    String newProfileImage = _profileImageController.text;
    String newUsername = _usernameController.text;
    String newPassword = _passwordController.text;
    String newEmail = _emailController.text;

    // Print the request body for debugging
    print('Request Body:');
    print('name: $newName');
    print('description: $newDescription');
    print('profileImage: $newProfileImage');
    print('username: $newUsername');
    print('password: $newPassword');
    print('email: $newEmail');

    // Example API endpoint for updating profile
    String apiUrl = 'http://localhost:3000/profile/${widget.userID}';

    try {
      var request = http.Request('PUT', Uri.parse(apiUrl));
      request.headers.addAll({
        'Content-Type': 'application/json',
      });
      request.body = json.encode({
        'name': newName,
        'description': newDescription,
        'profileImage': newProfileImage,
        'username': newUsername,
        'password': newPassword,
        'email': newEmail,
      });

      var response = await request.send();
      print('Request: ${request.url}');
      print('Headers: ${request.headers}');
      print('Body: ${request.body}');

      if (response.statusCode == 200) {
        // Profile updated successfully
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        // Failed to update profile
        // Show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile')),
        );
      }
    } catch (error) {
      // Handle errors from the HTTP request
      print('Error updating profile: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: Color(0xFF37474F),
            child: Text(
              'Confirm your profile details:',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Colors.white), // Set label text color
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF37474F)),
                      ),
                    ),
                    cursorColor: Colors.blue, // Set cursor color
                    style: TextStyle(color: Colors.white), // Set text color
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(color: Colors.white), // Set label text color
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF37474F)),
                      ),
                    ),
                    cursorColor: Color(0xFF37474F), // Set cursor color
                    style: TextStyle(color: Colors.white), // Set text color
                  ),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(color: Colors.white), // Set label text color
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF37474F)),
                      ),
                    ),
                    cursorColor: Color(0xFF37474F), // Set cursor color
                    style: TextStyle(color: Colors.white), // Set text color
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white), // Set label text color
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF37474F)),
                      ),
                    ),
                    cursorColor: Color(0xFF37474F), // Set cursor color
                    style: TextStyle(color: Colors.white), // Set text color
                    obscureText: true,
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white), // Set label text color
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF37474F)),
                      ),
                    ),
                    cursorColor: Color(0xFF37474F), // Set cursor color
                    style: TextStyle(color: Colors.white), // Set text color
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Handle form submission
                      _updateProfile();
                    },
                    child: Text(
                      'Save Changes',
                      style: TextStyle(color: Colors.white), // Set text color
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF37474F), // Set button background color
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
