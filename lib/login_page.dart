import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:workout_app/home_page.dart';
import 'dart:convert';
import 'main.dart'as homeMain;

void main() {
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  int _loggedInUserID =0;

  void _navigateToHomePage(BuildContext context, int userID) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => HomePage(userID: userID)), // Pass the user ID
  );
}


  Future<void> _login(BuildContext context) async {
    final USERNAME = _usernameController.text;
    final PASSWORD = _passwordController.text;

    // Construct the URI for the profile API endpoint
    final uri = Uri.parse('http://localhost:3000/profile/$USERNAME');

    // Make the HTTP request
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      final actualPassword = userData['PASSWORD'];

      if (actualPassword == PASSWORD) {
        // Successful login
        print('Username: $USERNAME, Password: $PASSWORD');

        //save the user ID here and push it to other pages
        _loggedInUserID = userData['ID'];
                
        setState(() {
          _errorMessage = '';
        });
        
        // Navigate to the home page
        _navigateToHomePage(context, _loggedInUserID);

      } else {
        setState(() {
          _errorMessage = 'Invalid username or password';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Failed to fetch user data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _login(context),
              child: Text('Login'),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Replace MainApp with your main.dart page
class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: Center(
        child: Text('Welcome to the main page!'),
      ),
    );
  }
}
