import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentRequestPage extends StatefulWidget {
  final String lecturerId;

  StudentRequestPage({required this.lecturerId});

  @override
  _StudentRequestPageState createState() => _StudentRequestPageState();
}

class _StudentRequestPageState extends State<StudentRequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Requests'),
        backgroundColor: Color(0xFFd5e7ff), // Updated AppBar color
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('requests')
            .where('lecturerId', isEqualTo: widget.lecturerId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading requests.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No student requests available.'));
          }

          final requests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              final requestId = request.id;
              final requestType = request['type'] ?? 'Request';
              final message = request['message'] ?? '';
              final studentId = request['studentId'] ?? 'Unknown';
              final status = request['status'] ?? 'Pending';

              return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Students')
                    .where('Student ID', isEqualTo: studentId)
                    .get(),
                builder: (context, studentSnapshot) {
                  if (studentSnapshot.connectionState == ConnectionState.waiting) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        title: Text('Loading student data...'),
                      ),
                    );
                  }

                  if (studentSnapshot.hasError) {
                    return ListTile(
                      title: Text(requestType),
                      subtitle: Text("Error loading student information"),
                      trailing: _getStatusIcon(status),
                    );
                  }

                  String studentName = 'Unknown Student';
                  String intake = 'Unknown Intake';
                  if (studentSnapshot.hasData && studentSnapshot.data!.docs.isNotEmpty) {
                    final studentData = studentSnapshot.data!.docs.first;
                    studentName = studentData['Student Name'] ?? 'Unknown Student';
                    intake = studentData['Intake'] ?? 'Unknown Intake';
                  }

                  // Determine if the request has already been processed
                  bool isProcessed = status == "Approved" || status == "Rejected";

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 4, // Increased elevation for better visual hierarchy
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      title: Text(
                        requestType,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isProcessed ? Colors.grey : Colors.blueGrey[800],
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text(
                            "Student Name: $studentName",
                            style: TextStyle(
                              color: isProcessed ? Colors.grey : Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Intake: $intake",
                            style: TextStyle(
                              color: isProcessed ? Colors.grey : Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      trailing: _getStatusIcon(status),
                      onTap: isProcessed
                          ? null // Disable click if request is processed
                          : () {
                              _showActionDialog(
                                  context, requestId, studentName, intake, requestType, message, status);
                            },
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

  Icon _getStatusIcon(String status) {
    switch (status) {
      case 'Pending':
        return Icon(Icons.hourglass_empty, color: Colors.orange);
      case 'Approved':
        return Icon(Icons.check_circle, color: Colors.green);
      case 'Rejected':
        return Icon(Icons.cancel, color: Colors.red);
      default:
        return Icon(Icons.info_outline, color: Colors.grey);
    }
  }

  void _showActionDialog(BuildContext context, String requestId,
      String studentName, String intake, String requestType, String message, String status) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)),
          title: Text(
            "Request Details",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDialogInfo("Student Name", studentName),
              _buildDialogInfo("Intake", intake),
              _buildDialogInfo("Request Type", requestType),
              _buildDialogInfo("Message", message),
              _buildDialogInfo("Status", status),
            ],
          ),
          actions: [
            Wrap(
              spacing: 10, // Add spacing between buttons
              alignment: WrapAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    _updateRequestStatus(requestId, "Rejected");
                    Navigator.of(context).pop();
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red), // Red border color
                    padding: EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0), // Smaller padding
                    minimumSize: Size(80, 40), // Set minimum size for smaller button
                  ),
                  child: Text(
                    "Reject",
                    style: TextStyle(color: Colors.red, fontSize: 14), // Smaller text size
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    _updateRequestStatus(requestId, "Approved");
                    Navigator.of(context).pop();
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.green), // Green border color
                    padding: EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0), // Smaller padding
                    minimumSize: Size(80, 40), // Set minimum size for smaller button
                  ),
                  child: Text(
                    "Approve",
                    style: TextStyle(color: Colors.green, fontSize: 14), // Smaller text size
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildDialogInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 14, color: Colors.black87),
          children: [
            TextSpan(
              text: "$label: ",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  // Function to update the request status in Firestore
  void _updateRequestStatus(String requestId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(requestId)
          .update({
        'status': newStatus,
        'timestamp': FieldValue.serverTimestamp(), // Update the timestamp as well
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Request $newStatus successfully!'),
          backgroundColor: newStatus == "Approved" ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update request. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
