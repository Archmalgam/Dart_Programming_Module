import 'package:flutter/material.dart';

class LecturerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lecturer Dashboard'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome, Professor!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Your Courses:',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Assuming there are 5 courses for the example
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.book),
                    title: Text('Course ${index + 1}'),
                    subtitle: Text('Course details here...'),
                    onTap: () {
                      // Navigate to course details page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CourseDetailPage(courseId: index)),
                      );
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Logic to view all assignments
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AssignmentsPage()),
                );
              },
              child: Text('View Assignments'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Logic to manage student grades
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GradesPage()),
                );
              },
              child: Text('Manage Grades'),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder widget for course details
class CourseDetailPage extends StatelessWidget {
  final int courseId;

  CourseDetailPage({required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Details'),
      ),
      body: Center(
        child: Text('Details for Course $courseId'),
      ),
    );
  }
}

// Placeholder widget for assignments page
class AssignmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assignments'),
      ),
      body: Center(
        child: Text('List of assignments goes here'),
      ),
    );
  }
}

// Placeholder widget for grades management page
class GradesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Grades'),
      ),
      body: Center(
        child: Text('Student grades management interface goes here'),
      ),
    );
  }
}