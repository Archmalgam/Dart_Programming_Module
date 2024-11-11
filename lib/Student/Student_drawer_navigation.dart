import 'Function/submit_request.dart';
import 'package:flutter/material.dart';
import 'Function/room_availability_page.dart';
import '../Logout.dart';


class DrawerNavigation extends StatelessWidget {

  final String? studentId; // Make StudentId optional

  DrawerNavigation({this.studentId});

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
              'Student Features',
              style: TextStyle(color: Color(0xFF0AC5A8), fontSize: 24), // Teal for header text
            ),
          ),
          _createDrawerItem(
            icon: Icons.description,
            text: 'Submit Report',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SubmitRequestPage(studentId: studentId!))),
            iconColor: Color(0xFF5E738E), // Grey Blue for icons
            textColor: Color(0xFF5E738E), // Grey Blue for text
          ),
            _createDrawerItem(
            icon: Icons.room,
            text: 'Check Room Availability',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RoomAvailabilityPage())),
            iconColor: Color(0xFF5E738E), // Grey Blue for icons
            textColor: Color(0xFF5E738E), // Grey Blue for text
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
