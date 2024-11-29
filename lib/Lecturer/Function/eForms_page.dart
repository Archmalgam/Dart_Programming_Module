import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubmitEFormPage extends StatefulWidget {
  final String lecturerId;

  SubmitEFormPage({required this.lecturerId});

  @override
  _SubmitEFormPageState createState() => _SubmitEFormPageState();
}

class _SubmitEFormPageState extends State<SubmitEFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  String _selectedFormType = 'Leave Application';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Administrative eForm'),
        backgroundColor: Color(0xFFd5e7ff),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedFormType,
                    items: [
                      'Leave Application',
                      'Event Approval',
                      'Expense Reimbursement'
                    ]
                        .map((type) =>
                            DropdownMenuItem(value: type, child: Text(type)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedFormType = value!;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Form Type'),
                  ),
                  TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(labelText: 'Description/Reason'),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Submit Form'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('eForms')
                    .where('lecturerId', isEqualTo: widget.lecturerId)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error loading forms."));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No forms submitted yet."));
                  }

                  final forms = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: forms.length,
                    itemBuilder: (context, index) {
                      final form = forms[index];
                      return Card(
                        child: ListTile(
                          title: Text(form['type']),
                          subtitle: Text(form['description']),
                          trailing: _getStatusIcon(form['status']),
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final formData = {
        'type': _selectedFormType,
        'description': _messageController.text,
        'status': 'Pending',
        'timestamp': Timestamp.now(),
        'lecturerId': widget.lecturerId,
        'recipient': 'Admin'
      };

      try {
        await FirebaseFirestore.instance.collection('eForms').add(formData);

        setState(() {
          _messageController.clear();
          _selectedFormType = 'Leave Application';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('eForm submitted successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit eForm. Please try again.')),
        );
      }
    }
  }
}
