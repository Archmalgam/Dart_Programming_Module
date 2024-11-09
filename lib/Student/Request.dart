import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubmitRequestPage extends StatefulWidget {
  final String studentId;

  SubmitRequestPage({required this.studentId}); // Constructor with studentId

  @override
  _SubmitRequestPageState createState() => _SubmitRequestPageState();
}

class _SubmitRequestPageState extends State<SubmitRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  String _selectedRequestType = 'Appointment';
  List<Map<String, dynamic>> _requestHistory = []; // Sample request history

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
            // Form for submitting a request
            Form(
              key: _formKey,
              child: Column(
                children: [
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
            SizedBox(height: 24),
            // Display the request history
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('requests')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final requests = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final request = requests[index];
                      return Card(
                        child: ListTile(
                          title: Text(request['type']),
                          subtitle: Text(request['message']),
                          trailing: _getStatusIcon(request['status']),
                        ),
                      );
                    },
                  );
                },
              ),
            )
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

  void _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      // Create a new request object to send to Firestore
      final requestData = {
        'type': _selectedRequestType,
        'message': _messageController.text,
        'status': 'Pending', // Initially set to pending
        'timestamp': Timestamp.now(), // Store the submission time
        'studentId': widget.studentId, // Add studentId from the passed parameter
      };

      try {
        // Save request data to Firestore
        await FirebaseFirestore.instance.collection('requests').add(requestData);

        // Reset form and update UI
        setState(() {
          _messageController.clear();
          _selectedRequestType = 'Appointment';
          _requestHistory.add(requestData); // Add to local history if needed
        });

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request submitted successfully!')),
        );
      } catch (e) {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit request. Please try again.')),
        );
      }
    }
  }
}
