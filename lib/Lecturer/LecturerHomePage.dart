import 'package:flutter/material.dart';
import 'drawer_navigation.dart';

class LecturerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lecturer Dashboard',
          style: TextStyle(
            color: Color(0xFF0AC5A8), // Teal for header text
            fontSize: 24,
          ),
        ),
        backgroundColor: Color(0xFF2C3C5B), // Dark Blue for AppBar background
      ),
      drawer: DrawerNavigation(),
      body: Center(
        child: Text(
          'Welcome, Professor! Select an option from the menu.',
          style: TextStyle(
            color: Color(0xFF5E738E), // Grey Blue for body text
            fontSize: 18, // Slightly larger font for readability
          ),
          textAlign: TextAlign.center, // Center the text in the body
        ),
      ),
    );
  }
}
