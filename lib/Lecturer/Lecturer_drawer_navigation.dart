import 'package:flutter/material.dart';
import 'Function/room_availability_page.dart';
import 'Function/eForms_page.dart';
import 'Function/student_requests_page.dart';
import '../Logout.dart';


class DrawerNavigation extends StatelessWidget {

  final String? lecturerId; // Make lecturerId optional

  DrawerNavigation({this.lecturerId});

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
              'Lecturer Features',
              style: TextStyle(color: Color(0xFF0AC5A8), fontSize: 24), // Teal for header text
            ),
          ),
          _createDrawerItem(
            icon: Icons.room,
            text: 'Check Room Availability',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RoomAvailabilityPage())),
            iconColor: Color(0xFF5E738E), // Grey Blue for icons
            textColor: Color(0xFF5E738E), // Grey Blue for text
          ),
           _createDrawerItem(
            icon: Icons.description,
            text: 'Submit eForms',
            onTap: () {
              if (lecturerId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubmitEFormPage(lecturerId: lecturerId!),
                  ),
                );
              } else {
                // Handle case where lecturerId is null, e.g., show a dialog or snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Lecturer ID is required to submit eForms.")),
                );
              }
            },
            iconColor: Color(0xFF5E738E),
            textColor: Color(0xFF5E738E),
          ),
          _createDrawerItem(
            icon: Icons.thumb_up,
            text: 'Student Requests',
            onTap: () {
              if (lecturerId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentRequestPage(lecturerId: lecturerId!),
                  ),
                );
              } else {
                // Handle case where lecturerId is null, e.g., show a dialog or snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Lecturer ID is required to view student requests.")),
                );
              }
            },
            iconColor: Color(0xFF5E738E),
            textColor: Color(0xFF5E738E),
          ),
          Divider(), // Divider between main items and profile/logout
          _createDrawerItem(
            icon: Icons.person,
            text: 'Profile',
            onTap: () {
              // Define your navigation or action for Profile
            },
            iconColor: Color(0xFF5E738E),
            textColor: Color(0xFF5E738E),
          ),
          _createDrawerItem(
            icon: Icons.logout,
            text: 'Logout',
            onTap: () => LogoutConfirmation(context),
            iconColor: Color(0xFF5E738E),
            textColor: Color(0xFF5E738E),
          ),
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
