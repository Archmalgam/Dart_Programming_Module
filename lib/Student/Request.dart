import 'package:flutter/material.dart';

class SubmitRequestPage extends StatefulWidget {
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
                    items: ['Appointment', 'Additional Help', 'Assignment Extension']
                        .map((type) => DropdownMenuItem(value: type, child: Text(type)))
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
              child: _requestHistory.isNotEmpty
                  ? ListView.builder(
                      itemCount: _requestHistory.length,
                      itemBuilder: (context, index) {
                        final request = _requestHistory[index];
                        return Card(
                          child: ListTile(
                            title: Text(request['type']),
                            subtitle: Text(request['message']),
                            trailing: _getStatusIcon(request['status']),
                          ),
                        );
                      },
                    )
                  : Center(child: Text('No requests submitted yet')),
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

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _requestHistory.add({
          'type': _selectedRequestType,
          'message': _messageController.text,
          'status': 'Pending', // Initially set to pending
        });
      });

      // Reset form
      _messageController.clear();
      _selectedRequestType = 'Appointment';

      // In a real-world app, you would also send this request to the backend here
    }
  }
}
