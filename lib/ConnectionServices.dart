import 'package:cloud_firestore/cloud_firestore.dart';

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

  // Fetches timetable data ordered by DateTime
  Stream<List<Map<String, dynamic>>> fetchTimetableData() {
    return _db.collection('Timetable')
        .orderBy('DateTime')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'Subject': doc['Subject'],
          'Room': doc['Room'],
          'DateTime': (doc['DateTime'] as Timestamp).toDate(),
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
  }) async {
    await _db.collection('Timetable').add({
      'Module': module,
      'Topic': topic,
      'Intake': intake,
      'Room': room,
      'StartDateTime': startDateTime,
      'EndDateTime': endDateTime,
    });
  }
}
