import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Student_drawer_navigation.dart';
import '../current_date.dart';

// Color palette
var kBackground = const Color(0xFFf9f9fc);
var textColor = const Color(0XFF263064);
var kheaderColor = const Color(0xFFd5e7ff);
var kCardColor = const Color(0xFFf9f9fc);

class StudentHomePage extends StatelessWidget {
  final String StudentName;
  final String studentId;

  const StudentHomePage(
      {required this.StudentName, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kheaderColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu, color: textColor),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            CurrentDate(), // Use the CurrentDate widget
          ],
        ),
      ),
      drawer: DrawerNavigation(studentId: studentId),
      body: Column(
        children: [
          // Header section with profile and greeting
          Container(
            color: kheaderColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 1, color: Colors.white),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        "https://img.freepik.com/free-photo/successful-young-man_144627-31404.jpg",
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome, $StudentName",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Here’s a quick overview of your day",
                      style: TextStyle(
                        color: textColor.withOpacity(0.75),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Main content area with sections for Timetable, Meetings, and Tasks
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
              decoration: BoxDecoration(
                color: kBackground,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: ListView(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Timetable')
                        .where('StudentId', isEqualTo: studentId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text("Error fetching classes"));
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Column(
                          children: [
                            buildSectionTitle("TODAY'S CLASSES", 0),
                            Center(child: Text("No classes available for today.")),
                          ],
                        );
                      }

                      // Get today's date
                      DateTime today = DateTime.now();
                      List<DocumentSnapshot> todayClasses =
                          snapshot.data!.docs.where((doc) {
                        DateTime startDateTime;
                        if (doc['StartDateTime'] is Timestamp) {
                          startDateTime =
                              (doc['StartDateTime'] as Timestamp).toDate();
                        } else {
                          throw ArgumentError(
                              'StartDateTime is not a valid type');
                        }

                        // Filter for classes that are scheduled for today
                        return startDateTime.year == today.year &&
                            startDateTime.month == today.month &&
                            startDateTime.day == today.day;
                      }).toList();

                      int numberOfClasses = todayClasses.length;

                      if (numberOfClasses == 0) {
                        return Column(
                          children: [
                            buildSectionTitle("TODAY'S CLASSES", numberOfClasses),
                            Center(child: Text("No classes today.")),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          buildSectionTitle("TODAY'S CLASSES", numberOfClasses),
                          ...todayClasses.map((classData) {
                            DateTime startDateTime =
                                (classData['StartDateTime'] as Timestamp)
                                    .toDate();
                            String module = classData['Module'];
                            String room = classData['Room'];

                            // Format the time
                            String formattedTime =
                                DateFormat.jm().format(startDateTime);

                            // Use the buildClassItem method to display the class
                            return buildClassItem(
                              formattedTime,
                              module,
                              Icons.school,
                              room,
                            );
                          }).toList(),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  buildSectionTitle("UPCOMING MEETINGS", 1),
                  buildMeetingItem(
                    "3:00 PM",
                    "Faculty Meeting",
                    "Room 202, Admin Building",
                  ),
                  SizedBox(height: 20),
                  buildSectionTitle("TASKS", 3),
                  buildTaskList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build a section title
  Row buildSectionTitle(String title, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: "$title ($count)",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: textColor,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to build a class item with a border around it
  Container buildClassItem(String time, String title, IconData icon, String location) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.withOpacity(0.5), // Border color
          width: 1.5, // Width of the border
        ),
      ),
      child: Row(
        children: [
          // Start time display
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                time,
                style: TextStyle(fontWeight: FontWeight.w700, color: textColor),
              ),
            ],
          ),
          // Vertical divider to visually separate the time from the rest of the details
          VerticalDivider(color: Colors.grey.withOpacity(0.5)),
          SizedBox(width: 10),
          // Smaller icon
          Icon(
            icon,
            size: 24, // Adjusted icon size to be smaller
            color: Colors.blueAccent,
          ),
          // Increased spacing between icon and text
          SizedBox(width: 20), // Adjusted for more spacing between the icon and the text
          // Class details (module and room)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor),
              ),
              SizedBox(height: 5), // Added spacing between title and location for a cleaner look
              Text(
                location,
                style: TextStyle(fontSize: 13, color: textColor.withOpacity(0.6)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to build a meeting item
  Container buildMeetingItem(String time, String title, String location) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                time,
                style: TextStyle(fontWeight: FontWeight.w700, color: textColor),
              ),
            ],
          ),
          VerticalDivider(color: Colors.grey.withOpacity(0.5)),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textColor),
              ),
              Text(
                location,
                style:
                    TextStyle(fontSize: 13, color: textColor.withOpacity(0.6)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to build a list of task items
  SingleChildScrollView buildTaskList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          buildTaskItem(Colors.red, 2, "Prepare Lecture Materials"),
          buildTaskItem(Colors.green, 5, "Grade Assignments"),
          buildTaskItem(Colors.blue, 1, "Review Student Submissions"),
        ],
      ),
    );
  }

  // Helper method to build a task item
  Container buildTaskItem(Color color, int daysLeft, String taskTitle) {
    return Container(
      margin: EdgeInsets.only(right: 15),
      padding: EdgeInsets.all(12),
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Deadline",
            style: TextStyle(fontSize: 14, color: Colors.black26),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              CircleAvatar(radius: 4, backgroundColor: color),
              SizedBox(width: 5),
              Text(
                "$daysLeft days left",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            taskTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
