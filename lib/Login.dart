import 'package:flutter/material.dart';
import 'Lecturer/Lecturer_navigation_bar.dart';
import 'Student/Student_navigation_bar.dart';
import 'ConnectionServices.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState(); // Creates a state of the login page for use through override
}

// Notification function
void showNotification(BuildContext context, String message, String Title) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(Title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

class _LoginPageState extends State<LoginPage> { // Overloading
  // Uniquely identifies the form widget  
  final _formKey = GlobalKey<FormState>(); 
  
  // Empty initial strings
  String _ID = ''; 
  String _password = '';
  
void _login() async {
  if (_formKey.currentState!.validate()) {
    String firstTwoLetters = _ID.substring(0, 2);

    LoginSearchupService userService = LoginSearchupService();
    List<Map<String, dynamic>> users;
    bool isValidUser = false;
    String? userName;
    String? lecturerId; // Declare lecturerId variable
    String? studentId;

    switch (firstTwoLetters) {
      case "AD":
        users = await userService.fetchAdministrators();
        isValidUser = users.any((user) {
          if (user['ID'] == _ID && user['Password'] == _password) {
            userName = user['Name'];
            return true;
          }
          return false;
        });
        break;
      case "ST":
        users = await userService.fetchStudents();
        isValidUser = users.any((user) {
          if (user['ID'] == _ID && user['Password'] == _password) {
            userName = user['Name'];
            studentId = user['ID']; 
            return true;
          }
          return false;
        });
        break;
      case "LC":
        users = await userService.fetchLecturers();
        isValidUser = users.any((user) {
          if (user['ID'] == _ID && user['Password'] == _password) {
            userName = user['Name'];
            lecturerId = user['ID']; // Assign lecturer ID
            return true;
          }
          return false;
        });
        break;
      default:
        showNotification(context, 'Please enter a valid ID.', 'Invalid User ID');
        return;
    }

    if (isValidUser && userName != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => resolveHomePage(firstTwoLetters, userName!, lecturerId, studentId),
        ),
      );
    } else {
      showNotification(context, 'Invalid ID or Password.', 'Login Failed');
    }
  }
}

Widget resolveHomePage(String prefix, String userName, String? lecturerId, String? studentId) {
  switch (prefix) {
    case "AD":
      return LecturerMainScreen(lecturerName: userName, lecturerId: lecturerId!); // Admin screen
    case "LC":
      return LecturerMainScreen(lecturerName: userName, lecturerId: lecturerId!); // Lecturer screen with lecturerId
    case "ST":
      return StudentMainScreen(StudentName: userName, studentId: studentId!); // Student screen
    default:
      return LoginPage();
  }
}

  // Build method is overidden...
  @override

  // ... To return a widget based on current state
  Widget build(BuildContext context) {
    // Basic structure
    return Scaffold(
      // Creates appbar at the top of the screen
      appBar: AppBar(
        title: Text('Login'),
      ),

      // Contains main content of the screen
      body: Container(
        // Set gradient background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF50C878), Color(0xFFE5E500)], // Emerald green to slightly yellowish green
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center( // **Center the content**
          child: Padding(
            // Uniform padding of 16 pixels on all sides
            padding: const EdgeInsets.all(16.0),
            // **Transparent white box with smaller size**
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 400, // Set a maximum width for the box
                maxHeight: 450, // Set a minimum height for the box
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8), // Transparent white box
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              padding: const EdgeInsets.all(16.0), // Padding inside the box
              child: Form(
                // Linking form to specially generated key earlier
                key: _formKey,
                // Arranges the list vertically...
                child: Center( // **Center the column within the box**
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Center items vertically
                    crossAxisAlignment: CrossAxisAlignment.center, // Center items horizontally
                    children: [
                      // Inserts the logo into the column
                      Image.asset('Images/Logo.png',
                      width: 200, 
                      height: 200),

                      // Creates the first text field for ID
                      TextFormField(
                        // User ID field w/ simple validation
                        decoration: InputDecoration(labelText: 'User ID'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your ID';
                          } else if (value.length <= 2) {
                            return "Please enter a valid user ID";                            
                          } return null;     
                        },
                        // Stores into email variable
                        onChanged: (value) {
                          _ID = value;
                        },
                      ),

                      // Another field: the password input
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          _password = value;
                        },
                      ),

                      // Add another space - an empty box between the textfields and button
                      SizedBox(height: 20),

                      // Button function:
                      ElevatedButton(
                        onPressed: _login,
                        child: Text('Login'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}