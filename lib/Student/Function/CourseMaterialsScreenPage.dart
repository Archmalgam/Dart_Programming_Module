import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io'; // For File operations
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

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

      // Add the document ID from the snapshot
      final documentId = doc.id;

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
        'documentId': documentId, // Include the document ID
        'fileName': data['fileName'],
        'fileData': data['fileData'],
        'lecturerName': lecturerName,
        'module': data['module'],
        'uploadedAt': formattedDate,
      });
    }

    return materials;
  }

  Future<void> downloadAndSaveFile(String documentId) async {
    try {
      print('DEBUG: Document ID -> $documentId');

      final document = await FirebaseFirestore.instance
          .collection('FileUploads')
          .doc(documentId)
          .get();

      if (!document.exists) {
        throw 'Document with ID $documentId does not exist.';
      }

      final encodedFileData = document.data()?['fileData'] as String?;
      final fileName =
          document.data()?['fileName'] as String? ?? 'downloaded_file';

      if (encodedFileData == null) {
        throw 'File data is null.';
      }

      print('DEBUG: Retrieved fileData length: ${encodedFileData.length}');

      // Decode the Base64 fileData
      final decodedFile = base64Decode(encodedFileData);
      print('DEBUG: Decoded file size: ${decodedFile.length}');

      // Get a safe file name
      final safeFileName = fileName.replaceAll(RegExp(r'[^\w\s\.]+'), '_');

      // Get the directory to save the file
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$safeFileName';
      print('DEBUG: Saving file to: $filePath');

      // Save the file
      final file = File(filePath);
      await file.writeAsBytes(decodedFile);

      print('File saved successfully: $filePath');

      // Open the file after saving
      try {
        print('DEBUG: Attempting to open file at: $filePath');
        final result = await OpenFile.open(filePath);
        print('OpenFile result: $result');
      } catch (e) {
        print('Error opening file: $e');
      }
    } catch (e) {
      print('Error downloading or saving file: $e');
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
                    print(
                        'DEBUG: Material -> $material'); // Debug each material

                    return ListTile(
                      title: Text(material['fileName'] ??
                          'Unknown File Name'), // Default for null fileName
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Module: ${material['module'] ?? 'Unknown'}'),
                          Text(
                              'Lecturer: ${material['lecturerName'] ?? 'Unknown'}'),
                          Text(
                              'Uploaded At: ${material['uploadedAt'] ?? 'Unknown'}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.download),
                        onPressed: () {
                          if (material['documentId'] != null) {
                            downloadAndSaveFile(
                                material['documentId']); // Pass document ID
                          } else {
                            print('Document ID is null. Cannot download.');
                          }
                        },
                      ),
                      leading: material['imageUrl'] != null
                          ? Image.network(
                              material['imageUrl'],
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.broken_image,
                                    size: 50); // Handle broken images
                              },
                            )
                          : Icon(Icons.image,
                              size: 50), // Placeholder for missing imageUrl
                    );
                  },
                );
              },
            ),
    );
  }
}
