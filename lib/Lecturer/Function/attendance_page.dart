import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TakeAttendancePage extends StatelessWidget {
  final String intake;
  final String timetableId;

  TakeAttendancePage({required this.intake, required this.timetableId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance - $intake"),
        backgroundColor: Color(0xFFd5e7ff),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Students')
            .where('Intake', isEqualTo: intake)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error loading students"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No students in this intake"));
          }

          final students = snapshot.data!.docs;

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              final studentData = student.data() as Map<String, dynamic>;
              final studentName = studentData['Student Name'] ?? 'Unknown';
              final studentId = studentData['Student ID'] ?? 'Unknown';

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Text(
                    studentName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text("ID: $studentId"),
                  trailing: AttendanceSwitch(
                    studentId: studentId,
                    timetableId: timetableId,
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

class AttendanceSwitch extends StatefulWidget {
  final String studentId;
  final String timetableId;

  AttendanceSwitch({required this.studentId, required this.timetableId});

  @override
  _AttendanceSwitchState createState() => _AttendanceSwitchState();
}

class _AttendanceSwitchState extends State<AttendanceSwitch> {
  bool isPresent = false;

  @override
  void initState() {
    super.initState();
    _initializeAttendanceRecord();
    _fetchAttendanceStatus();
  }

  // Create a document in Firestore when the page is opened
  void _initializeAttendanceRecord() async {
    final attendanceCollection = FirebaseFirestore.instance
        .collection('Timetable')
        .doc(widget.timetableId)
        .collection('Attendance');

    final docSnapshot = await attendanceCollection.doc(widget.studentId).get();

    if (!docSnapshot.exists) {
      await attendanceCollection.doc(widget.studentId).set({
        'isPresent': false,
        'timestamp': DateTime.now(),
      });
    }
  }

  // Fetch the existing attendance status
  void _fetchAttendanceStatus() async {
    final attendanceDoc = await FirebaseFirestore.instance
        .collection('Timetable')
        .doc(widget.timetableId)
        .collection('Attendance')
        .doc(widget.studentId)
        .get();

    if (attendanceDoc.exists) {
      setState(() {
        isPresent = attendanceDoc['isPresent'] ?? false;
      });
    }
  }

  // Toggle attendance status
  void markAttendance(bool value) async {
    setState(() {
      isPresent = value;
    });

    final attendanceCollection = FirebaseFirestore.instance
        .collection('Timetable')
        .doc(widget.timetableId)
        .collection('Attendance');

    await attendanceCollection.doc(widget.studentId).update({
      'isPresent': isPresent,
      'timestamp': DateTime.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isPresent,
      onChanged: (value) => markAttendance(value),
      activeColor: Colors.green,
      inactiveThumbColor: Colors.red,
    );
  }
}
