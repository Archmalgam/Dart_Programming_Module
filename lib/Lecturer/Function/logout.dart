import 'package:flutter/material.dart';
import '../../Login.dart'; // Ensure this points to the correct path of your LoginPage

void LogoutConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white, // Set the background color to white
        titlePadding: EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 8),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Warning',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 4),
            Container(
              height: 2, // Thickness of the red line
              width: double.infinity,
              color: Colors.red, // Red color for the line
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: Colors.grey[800], fontSize: 15), // Slightly darker grey for the text
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        actions: <Widget>[
          TextButton(
            child: Text(
              'CANCEL',
              style: TextStyle(color: Colors.grey), // Grey color for cancel button
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: Text(
              'LOGOUT',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold), // Red color for logout button
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()), // Redirect to LoginPage
              );
            },
          ),
        ],
      );
    },
  );
}
