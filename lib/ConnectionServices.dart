import 'package:cloud_firestore/cloud_firestore.dart';

// Searches database for login credentials
class LoginSearchupService {

  // Initialises database
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Searches for a user with the given username and password
  Future<List<Map<String, dynamic>>> fetchUsers(String Database) async {
    try {

      // Retrieve all documents from the 'users' collection in the database
      QuerySnapshot snapshot = await _db.collection(Database).get();
      return snapshot.docs
          .map((doc) => {
                'ID': doc['Admin ID'],
                'Password': doc['Admin Password'],
              })
          .toList();
    } catch (e) {
      print("Error fetching users: $e");
      return []; // Return an empty list on error
    }
  }
}
