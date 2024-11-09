import 'package:flutter/material.dart';
import 'LecturerHomePage.dart'; // Adjust import as per your project structure

class LecturerMainScreen extends StatefulWidget {
  const LecturerMainScreen({super.key});

  @override
  _LecturerMainScreenState createState() => _LecturerMainScreenState();
}

class _LecturerMainScreenState extends State<LecturerMainScreen> {
  int selectedIndex = 0;

  // Define the pages to navigate to
  final List<Widget> pages = [
    LecturerHomePage(), // Home page
    Scaffold(body: Center(child: Text("Timetable Page"))), // Timetable page
    Scaffold(body: Center(child: Text("Calendar Page"))), // Calendar page
    Scaffold(body: Center(child: Text("Chat Page"))), // Chat page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: kBackground,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        showSelectedLabels: false, // Hides labels
        showUnselectedLabels: false, // Hides labels
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Center(child: Icon(Icons.home)), // Home icon
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Center(child: Icon(Icons.view_agenda)), // Timetable icon
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Center(child: Icon(Icons.calendar_month)), // Calendar icon
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Center(child: Icon(Icons.message)), // Chat icon
            label: "",
          ),
        ],
      ),
      body: pages[selectedIndex],
    );
  }
}
