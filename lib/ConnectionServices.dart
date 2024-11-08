import 'package:cloud_firestore/cloud_firestore.dart';

class LoginSearchupService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // General method to fetch users based on collection and field names
  Future<List<Map<String, dynamic>>> fetchUsers(String collection, String idField, String passwordField) async {
    try {
      QuerySnapshot snapshot = await _db.collection(collection).get();
      return snapshot.docs
          .map((doc) => {
                'ID': doc[idField],
                'Password': doc[passwordField],
              })
          .toList();
    } catch (e) {
      print("Error fetching users from $collection: $e");
      return []; // Return an empty list on error
    }
  }

  // Fetches administrator credentials
  Future<List<Map<String, dynamic>>> fetchAdministrators() async {
    return fetchUsers("Administrators", "Admin ID", "Admin Password");
  }

  // Fetches lecturer credentials
  Future<List<Map<String, dynamic>>> fetchLecturers() async {
    return fetchUsers("Lecturers", "Lecturer ID", "Lecturer Password");
  }

  // Fetches student credentials
  Future<List<Map<String, dynamic>>> fetchStudents() async {
    return fetchUsers("Students", "Student ID", "Student Password");
  }
}