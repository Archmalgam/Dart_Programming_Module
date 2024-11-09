import 'package:flutter/material.dart';
import 'LecturerHomePage.dart'; // Adjust import as per your project structure

class LecturerMainScreen extends StatefulWidget {
  final String lecturerName;

  const LecturerMainScreen({Key? key, required this.lecturerName}) : super(key: key);

  @override
  _LecturerMainScreenState createState() => _LecturerMainScreenState();
}

class _LecturerMainScreenState extends State<LecturerMainScreen> {
  int selectedIndex = 0;

  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      LecturerHomePage(lecturerName: widget.lecturerName), // Pass name to LecturerHomePage
      Scaffold(body: Center(child: Text("Timetable Page"))),
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
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Center(child: Icon(Icons.home)),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Center(child: Icon(Icons.view_agenda)),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Center(child: Icon(Icons.calendar_month)),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Center(child: Icon(Icons.message)),
            label: "",
          ),
        ],
      ),
      body: pages[selectedIndex],
    );
  }
}
