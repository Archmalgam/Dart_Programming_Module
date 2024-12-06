import 'package:flutter/material.dart';
import 'StudentHomePage.dart'; // Adjust import as per your project structure
import 'Function/timetable_page.dart';

class StudentMainScreen extends StatefulWidget {
  final String StudentName;
  final String studentId;

  StudentMainScreen({required this.StudentName, required this.studentId});

  @override
  _StudentMainScreenState createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends State<StudentMainScreen> {
  int selectedIndex = 0;

  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      StudentHomePage(StudentName: widget.StudentName, studentId: widget.studentId,), // Pass name to StudentHomePage
      TimetablePage(studentId: widget.studentId),
      Scaffold(body: Center(child: Text("Calendar Page"))),
      Scaffold(body: Center(child: Text("Chat Page"))),
    ];
  }

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
        showSelectedLabels: true, // Show labels for selected items
        showUnselectedLabels: true, // Show labels for unselected items
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home", // Label for Home
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_agenda),
            label: "Timetable", // Label for Timetable
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Calendar", // Label for Calendar
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Chat", // Label for Chat
          ),
        ],
      ),
      body: pages[selectedIndex],
    );
  }
}
