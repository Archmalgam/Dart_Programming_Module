import 'package:flutter/material.dart';
import 'Function/TimetablePage.dart';
import 'Function/RequestPage.dart';
// import 'Function/room_availability_page.dart';
// import 'Function/forms_page.dart';
// import 'Function/academic_calendar_page.dart';
// import 'Function/messaging_page.dart';
// import 'Function/attendance_page.dart';
// import 'Function/course_materials_page.dart';
// import 'Function/student_requests_page.dart';

class DrawerNavigation extends StatelessWidget {
  final String studentId; // Add studentId as a parameter

  DrawerNavigation(
      {required this.studentId}); // Constructor to accept studentId

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF2C3C5B), // Dark Blue for the header background
            ),
            child: Text(
              'Students Features',
              style: TextStyle(
                  color: Color(0xFF0AC5A8),
                  fontSize: 24), // Teal for header text
            ),
          ),
          _createDrawerItem(
            icon: Icons.schedule,
            text: 'Submit Requests to Teachers',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubmitRequestPage(
                    studentId: studentId), // Pass studentId here
              ),
            ),
            iconColor: Color(0xFF5E738E), // Grey Blue for icons
            textColor: Color(0xFF5E738E), // Grey Blue for text
          ),
          _createDrawerItem(
            icon: Icons.calendar_today,
            text: 'Timetable',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TimetablePage(studentId: studentId)), // Replace with your timetable page route
            ),
            iconColor: Color(0xFF5E738E),
            textColor: Color(0xFF5E738E),
          ),
          // _createDrawerItem(
          //   icon: Icons.description,
          //   text: 'Submit eForms',
          //   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FormsPage())),
          //   iconColor: Color(0xFF5E738E), // Grey Blue for icons
          //   textColor: Color(0xFF5E738E), // Grey Blue for text
          // ),
          // _createDrawerItem(
          //   icon: Icons.calendar_today,
          //   text: 'Academic Calendar',
          //   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AcademicCalendarPage())),
          //   iconColor: Color(0xFF5E738E), // Grey Blue for icons
          //   textColor: Color(0xFF5E738E), // Grey Blue for text
          // ),
          // _createDrawerItem(
          //   icon: Icons.message,
          //   text: 'Communicate',
          //   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MessagingPage())),
          //   iconColor: Color(0xFF5E738E), // Grey Blue for icons
          //   textColor: Color(0xFF5E738E), // Grey Blue for text
          // ),
          // _createDrawerItem(
          //   icon: Icons.access_time,
          //   text: 'Track Attendance',
          //   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AttendancePage())),
          //   iconColor: Color(0xFF5E738E), // Grey Blue for icons
          //   textColor: Color(0xFF5E738E), // Grey Blue for text
          // ),
          // _createDrawerItem(
          //   icon: Icons.folder,
          //   text: 'Course Materials',
          //   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CourseMaterialsPage())),
          //   iconColor: Color(0xFF5E738E), // Grey Blue for icons
          //   textColor: Color(0xFF5E738E), // Grey Blue for text
          // ),
          // _createDrawerItem(
          //   icon: Icons.thumb_up,
          //   text: 'Student Requests',
          //   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => StudentRequestsPage())),
          //   iconColor: Color(0xFF5E738E), // Grey Blue for icons
          //   textColor: Color(0xFF5E738E), // Grey Blue for text
          // ),
        ],
      ),
    );
  }

  Widget _createDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required Color iconColor,
    required Color textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(text, style: TextStyle(color: textColor)),
      onTap: onTap,
    );
  }
}
