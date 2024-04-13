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
        primaryColor: const Color.fromARGB(255, 214, 237, 255), // Soft blue background
        scaffoldBackgroundColor: const Color.fromARGB(255, 223, 241, 255), // Soft blue background for scaffolds
       buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue, // Set the default button color
          textTheme: ButtonTextTheme.primary,),
          
      ),
      home: LoginPage(), // Set the login page as the home page
    );
  }
}




  
