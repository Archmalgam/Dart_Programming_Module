import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:convert';

class LoginSearchupService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // General method to fetch users based on collection and field names
  Future<List<Map<String, dynamic>>> fetchUsers(String collection, String idField, String passwordField, String nameField) async {
    try {
      QuerySnapshot snapshot = await _db.collection(collection).get();
      return snapshot.docs
          .map((doc) => {
                'ID': doc[idField],
                'Password': doc[passwordField],
                'Name': doc[nameField], // Add the name field here
              })
          .toList();
    } catch (e) {
      print("Error fetching users from $collection: $e");
      return []; // Return an empty list on error
    }
  }

  // Fetches administrator credentials
  Future<List<Map<String, dynamic>>> fetchAdministrators() async {
    return fetchUsers("Administrators", "Admin ID", "Admin Password", "Admin Name");
  }

  // Fetches lecturer credentials
  Future<List<Map<String, dynamic>>> fetchLecturers() async {
    return fetchUsers("Lecturers", "Lecturer ID", "Lecturer Password", "Lecturer Name");
  }

  // Fetches student credentials
  Future<List<Map<String, dynamic>>> fetchStudents() async {
    return fetchUsers("Students", "Student ID", "Student Password", "Student Name");
  }
}

class ConnectionServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetches timetable data ordered by StartDateTime
  Stream<List<Map<String, dynamic>>> fetchTimetableData() {
    return _db.collection('Timetable')
        .orderBy('StartDateTime')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'Module': doc['Module'],
          'Room': doc['Room'],
          'StartDateTime': (doc['StartDateTime'] as Timestamp).toDate(),
          'EndDateTime': (doc['EndDateTime'] as Timestamp).toDate(),
          'Topic': doc['Topic'],
          'Intake': doc['Intake'],
          'LecturerId': doc['LecturerId'],
        };
      }).toList();
    });
  }

  // Adds a new class to the timetable collection
  Future<void> addClassToTimetable({
    required String module,
    required String topic,
    required String intake,
    required String room,
    required DateTime startDateTime,
    required DateTime endDateTime,
    required String lecturerId,
  }) async {
    await _db.collection('Timetable').add({
      'Module': module,
      'Topic': topic,
      'Intake': intake,
      'Room': room,
      'StartDateTime': startDateTime,
      'EndDateTime': endDateTime,
      'LecturerId': lecturerId, 
    });
  }

  // Method to upload file data as Base64 string to Firestore
  Future<void> uploadFileToFirestore({
    required String filePath,
    required String documentId,
    required String lecturerId,
    required String module,
    required String intake,
  }) async {
    try {
      File file = File(filePath);
      List<int> fileBytes = await file.readAsBytes();
      String base64String = base64Encode(fileBytes);

      // Store Base64 string in Firestore with additional metadata
      await _db.collection('FileUploads').doc(documentId).set({
        'fileName': filePath.split('/').last,
        'fileData': base64String,
        'uploadedAt': FieldValue.serverTimestamp(),
        'lecturerId': lecturerId,
        'module': module,
        'intake': intake,
      });

      print("File uploaded successfully to Firestore with metadata");
    } catch (e) {
      print("Error uploading file to Firestore: $e");
    }
  }
}