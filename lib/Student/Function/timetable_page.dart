import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TimetablePage extends StatefulWidget {
  final String studentId;

  TimetablePage({required this.studentId});

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  String? intake;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserIntake();
  }

  Future<void> fetchUserIntake() async {
    try {
      // Query to find the student document where Student ID matches userId
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Students')
          .where('Student ID', isEqualTo: widget.studentId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If the document is found, get the first document from the query result
        final userDoc = querySnapshot.docs.first;
        print(
            "User document data: ${userDoc.data()}"); // Print document data for debugging

        setState(() {
          intake = userDoc['Intake'];
          print("User intake found: $intake"); // Confirm that the intake is set
        });
      } else {
        print("User document does not exist.");
      }
    } catch (error) {
      print("Error fetching user intake: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Stream<List<Map<String, dynamic>>> fetchTimetable() {
    if (intake == null) return Stream.value([]);

    return FirebaseFirestore.instance
        .collection('Timetable')
        .where('Intake', isEqualTo: intake)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Map<String, dynamic>> timetableEntries = [];

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data();

        try {
          // Fetch lecturer name based on LecturerId
          if (data['LecturerId'] != null) {
            final lecturerQuery = await FirebaseFirestore.instance
                .collection('Lecturers')
                .where('Lecturer ID', isEqualTo: data['LecturerId'])
                .get();

            // Check if lecturer document exists and get the name
            if (lecturerQuery.docs.isNotEmpty) {
              data['LecturerName'] = lecturerQuery.docs.first['Lecturer Name'];
            } else {
              data['LecturerName'] = "Unknown";
            }
          } else {
            data['LecturerName'] = "Unknown";
          }

          timetableEntries.add(data);
          print(
              "Timetable entry added: ${data['Module']} with Lecturer: ${data['LecturerName']}");
        } catch (error) {
          print("Error fetching lecturer name: $error");
          data['LecturerName'] = "Unknown";
          timetableEntries.add(data);
        }
      }
      return timetableEntries;
    }).handleError((error) {
      print("Error fetching timetable: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Timetable"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : intake == null
              ? Center(child: Text("No intake found for the user."))
              : StreamBuilder<List<Map<String, dynamic>>>(
                  stream: fetchTimetable(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text("No timetable available."));
                    }

                    final timetableData = snapshot.data!;

                    return ListView.builder(
                      itemCount: timetableData.length,
                      itemBuilder: (context, index) {
                        final event = timetableData[index];

                        DateTime startTime =
                            (event['StartDateTime'] as Timestamp).toDate();
                        DateTime endTime =
                            (event['EndDateTime'] as Timestamp).toDate();

                        String formattedTime =
                            "${DateFormat.jm().format(startTime)} - ${DateFormat.jm().format(endTime)}";

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16),
                              title: Text(
                                event['Module'] ?? "Unknown Module",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Text(
                                    formattedTime,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.person,
                                          size: 16, color: Colors.grey),
                                      SizedBox(width: 4),
                                      Text(event['LecturerName'] ??
                                          "Unknown Lecturer"),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on,
                                          size: 16, color: Colors.grey),
                                      SizedBox(width: 4),
                                      Text(event['Room'] ?? "Unknown Room"),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.subject,
                                          size: 16, color: Colors.grey),
                                      SizedBox(width: 4),
                                      Text(event['Topic'] ?? "No Topic"),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
