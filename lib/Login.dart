import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState(); // Creates a state of the login page for use through override
}

class _LoginPageState extends State<LoginPage> { // Overloading
  // Uniquely identifies the form widget  
  final _formKey = GlobalKey<FormState>(); 
  
  // Empty initial strings
  String _email = ''; 
  String _password = '';
  
  // Login Function
  void _login() {
    if (_formKey.currentState!.validate()) {
      // Process login (call your Firebase or backend service here)
      print('Email: $_email, Password: $_password');
    }
  }

  // Build method is overidden...
  @override

  // ... To return a widger based on current state
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
                          } else {
                            return null;
                          }      
                        },
                        // Stores into email variable
                        onChanged: (value) {
                          _email = value;
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
