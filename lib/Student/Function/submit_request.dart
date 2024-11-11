import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubmitRequestPage extends StatefulWidget {
  final String studentId;

  SubmitRequestPage({required this.studentId});

  @override
  _SubmitRequestPageState createState() => _SubmitRequestPageState();
}

class _SubmitRequestPageState extends State<SubmitRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  String _selectedRequestType = 'Appointment';
  String? _selectedLecturerId; // Holds the selected lecturer's ID
  List<Map<String, String>> _lecturers = [];

  @override
  void initState() {
    super.initState();
    _fetchLecturers();
  }

  // Fetch lecturers from Firestore
  Future<void> _fetchLecturers() async {
    final lecturerDocs =
        await FirebaseFirestore.instance.collection('Lecturers').get();
    final lecturers = lecturerDocs.docs.map((doc) {
      return {
        'docId': doc.id, // Document ID as String
        'lecturerId':
            (doc['Lecturer ID'] ?? 'Unknown').toString(), // Cast to String
        'name':
            (doc['Lecturer Name'] ?? 'Unknown').toString(), // Cast to String
      };
    }).toList();

    setState(() {
      _lecturers = lecturers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Request to Teachers'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Dropdown for Lecturer selection
                  DropdownButtonFormField<String>(
                    value: _selectedLecturerId,
                    items: _lecturers.map((lecturer) {
                      return DropdownMenuItem<String>(
                        value: lecturer[
                            'lecturerId'], // Store "Lecturer ID" field as value
                        child: Text(lecturer['name'] ??
                            'Unknown'), // Display lecturer name
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedLecturerId = value;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Select Lecturer'),
                    validator: (value) =>
                        value == null ? 'Please select a lecturer' : null,
                  ),

                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedRequestType,
                    items: [
                      'Appointment',
                      'Additional Help',
                      'Assignment Extension'
                    ]
                        .map((type) =>
                            DropdownMenuItem(value: type, child: Text(type)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRequestType = value!;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Request Type'),
                  ),
                  TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(labelText: 'Message'),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a message';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _submitRequest,
                    child: Text('Submit Request'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                // Start with a basic query for debugging
                stream: FirebaseFirestore.instance
                    .collection('requests')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    print("Error loading requests: ${snapshot.error}");
                    return Center(child: Text('Error loading requests.'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No requests submitted yet.'));
                  }

                  final requests = snapshot.data!.docs;
                  print("Number of requests retrieved: ${requests.length}");

                  return ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final request = requests[index];
                      final requestType = request['type'] ?? 'Request';
                      final message = request['message'] ?? '';
                      final status = request['status'] ?? 'Pending';

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 2,
                        margin: EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 16.0),
                        child: ListTile(
                          title: Text(
                            requestType,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            message,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: _getStatusIcon(status),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
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

  // Submit the request with the selected lecturer and student details
  void _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      // Find the selected lecturer's name based on _selectedLecturerId
      final selectedLecturer = _lecturers.firstWhere(
        (lecturer) => lecturer['lecturerId'] == _selectedLecturerId,
        orElse: () => {'name': 'Unknown Lecturer'},
      );

      final lecturerName = selectedLecturer['name'] ?? 'Unknown Lecturer';

      // Prepare the request data to send to Firestore
      final requestData = {
        'type': _selectedRequestType,
        'message': _messageController.text,
        'status': 'Pending', // Initial status of the request
        'timestamp': Timestamp.now(), // Request timestamp
        'studentId': widget.studentId, // Student ID from login
        'lecturerId': _selectedLecturerId, // Selected lecturer's ID
      };

      try {
        // Save request data to Firestore
        await FirebaseFirestore.instance
            .collection('requests')
            .add(requestData);

        // Reset form and update UI
        setState(() {
          _messageController.clear();
          _selectedRequestType = 'Appointment';
          _selectedLecturerId = null; // Reset lecturer selection
        });

        // Show a success message with the lecturer's ID and Name
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Request submitted successfully to Lecturer: $lecturerName')),
        );
      } catch (e) {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to submit request. Please try again.')),
        );
      }
    }
  }
}