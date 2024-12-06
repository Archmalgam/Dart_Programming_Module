import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

class LecturerSelectionScreen extends StatelessWidget {
  final String studentId;

  LecturerSelectionScreen({required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select a Lecturer"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Lecturers').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var lecturers = snapshot.data!.docs;

          return ListView.builder(
            itemCount: lecturers.length,
            itemBuilder: (context, index) {
              var lecturer = lecturers[index];

              return ListTile(
                title: Text(lecturer['Lecturer Name']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        lecturerId: lecturer['Lecturer ID'],
                        lecturerName: lecturer['Lecturer Name'],
                        studentId: studentId,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
