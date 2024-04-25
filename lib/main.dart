import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout APP',
      theme: ThemeData(
        primaryColor: Color(0xFF607D8B),  
        scaffoldBackgroundColor: Color(0xFF212121),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue[900],  
          textTheme: ButtonTextTheme.primary,
        ),
        textTheme: TextTheme(
          // Text color for various text widgets
          headline1: TextStyle(color: Color(0xFFD9D9D9)),
          headline2: TextStyle(color: Color(0xFFD9D9D9)), 
        ),
      ),
      home: LoginPage(), // Set the login page as the home page
    );
  }
}
