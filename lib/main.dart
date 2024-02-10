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
        // Theme data will go here in the future
      ),
      home: LoginPage(), // Set the login page as the home page
    );
  }
}




  
