import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDataPage extends StatelessWidget {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firestore Data")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No data available"));
          }
          
          final docs = snapshot.data!.docs;
          
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['name']),
                subtitle: Text('Age: ${data['age']}'),
              );
            },
          );
        },
      ),
    );
  }
}
