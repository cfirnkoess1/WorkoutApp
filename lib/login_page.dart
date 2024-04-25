import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:workout_app/home_page.dart';
import 'dart:convert';
import 'main.dart' as homeMain;

void main() {
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primaryColor: Color(0xFF607D8B),  
        scaffoldBackgroundColor: Color(0xFF212121),  
        textTheme: TextTheme(
          
          bodyText1: TextStyle(color: Color(0xFFD9D9D9)),
          bodyText2: TextStyle(color: Color(0xFFD9D9D9)),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFFADD5F7),  
          textTheme: ButtonTextTheme.primary,
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0xFFADD5F7), 
        ),
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
  int _loggedInUserID = 0;

  void _navigateToHomePage(BuildContext context, int userID) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage(userID: userID)),
    );
  }

  Future<void> _login(BuildContext context) async {
    final USERNAME = _usernameController.text;
    final PASSWORD = _passwordController.text;

     
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
              style: TextStyle(color: Color(0xFFD9D9D9)), 
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: Color(0xFFD9D9D9)),  
                focusedBorder: UnderlineInputBorder( // Remove purple underline
                  borderSide: BorderSide(color: Color(0xFFADD5F7)),  
                ),
              ),
              cursorColor: Color(0xFFADD5F7), // Set cursor color to match underline color
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              style: TextStyle(color: Color(0xFFD9D9D9)),  
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Color(0xFFD9D9D9)),  // Remove purple underline
                focusedBorder: UnderlineInputBorder( 
                  borderSide: BorderSide(color: Color(0xFFADD5F7)),  
                ),
              ),
              cursorColor: Color(0xFFADD5F7), // Set cursor color to match underline color
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _login(context),
              style: ButtonStyle(  
                foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF607D8B)),
              ),
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
