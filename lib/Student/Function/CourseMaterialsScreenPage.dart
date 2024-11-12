import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:intl/intl.dart';

class CourseMaterialsScreen extends StatefulWidget {
  final String studentId; // Student ID is passed here

  const CourseMaterialsScreen({required this.studentId, Key? key})
      : super(key: key);

  @override
  _CourseMaterialsScreenState createState() => _CourseMaterialsScreenState();
}

class _CourseMaterialsScreenState extends State<CourseMaterialsScreen> {
  String? intake; // This will store the intake after fetching

  @override
  void initState() {
    super.initState();

    // Fetch the intake using studentId
    getIntakeByStudentId(widget.studentId).then((value) {
      setState(() {
        intake = value; // Set the intake value
      });
    });
  }

  Future<String?> getIntakeByStudentId(String studentId) async {
    final firestore = FirebaseFirestore.instance;

    // Query the Students collection with the "Student ID" field
    final querySnapshot = await firestore
        .collection('Students')
        .where('Student ID', isEqualTo: studentId)
        .get();

    // Return the intake field if found
    if (querySnapshot.docs.isNotEmpty) {
      final data = querySnapshot.docs.first.data();
      return data['Intake'];
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchCourseMaterials() async {
    if (intake == null) {
      return [];
    }

    final firestore = FirebaseFirestore.instance;

    // Query FileUploads collection for materials with the matching intake
    final querySnapshot = await firestore
        .collection('FileUploads')
        .where('intake', isEqualTo: intake)
        .get();

    List<Map<String, dynamic>> materials = [];

    for (var doc in querySnapshot.docs) {
      final data = doc.data();

      // Fetch lecturer's name based on the `Lecturer ID` field in Lecturers collection
      final lecturerId = data['lecturerId'];
      String lecturerName = 'Unknown Lecturer';

      if (lecturerId != null && lecturerId.isNotEmpty) {
        // Query the Lecturers collection by "Lecturer ID" field
        final lecturerQuery = await firestore
            .collection('Lecturers')
            .where('Lecturer ID', isEqualTo: lecturerId)
            .get();

        if (lecturerQuery.docs.isNotEmpty) {
          lecturerName = lecturerQuery.docs.first.data()['Lecturer Name'] ??
              'Unknown Lecturer';
        } else {
          print("No lecturer found with Lecturer ID: $lecturerId");
        }
      } else {
        print("Missing lecturerId in FileUploads document.");
      }

      Timestamp timestamp = data['uploadedAt'];
      DateTime dateTime = timestamp.toDate();
      String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(dateTime);

      materials.add({
        'fileName': data['fileName'],
        'fileData': data['fileData'],
        'lecturerName': lecturerName,
        'module': data['module'],
        'uploadedAt': formattedDate,
      });
    }

    return materials;
  }

  Future<void> downloadFile(String fileData) async {
    try {
      // Get a reference to the file in Firebase Storage using the `fileData`
      final ref = FirebaseStorage.instance.refFromURL(fileData);

      // Retrieve the actual download URL
      final downloadUrl = await ref.getDownloadURL();

      // Use url_launcher to open the download URL in an external browser
      if (!await launchUrlString(downloadUrl,
          mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $downloadUrl';
      }
    } catch (e) {
      print("Error downloading file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Course Materials')),
      body: intake == null
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator until intake is fetched
          : FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchCourseMaterials(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No materials found.'));
                }

                final materials = snapshot.data!;

                return ListView.builder(
                  itemCount: materials.length,
                  itemBuilder: (context, index) {
                    final material = materials[index];
                    return ListTile(
                      title: Text(material['fileName']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Module: ${material['module']}'),
                          Text('Lecturer: ${material['lecturerName']}'),
                          Text('Uploaded At: ${material['uploadedAt']}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.download),
                        onPressed: () => downloadFile(material['fileData']),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
