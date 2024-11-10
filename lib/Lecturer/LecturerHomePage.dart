import 'package:flutter/material.dart';
import 'drawer_navigation.dart';
import '../current_date.dart';

// Color palette
var kBackground = const Color(0xFFf9f9fc);
var textColor = const Color(0XFF263064);
var secondTextColor = const Color(0XFF3c31c5);
var kheaderColor = const Color(0xFFd5e7ff);
var kCardColor = const Color(0xFFf9f9fc);

class LecturerHomePage extends StatelessWidget {
  final String lecturerName;
  final String lecturerId;

  const LecturerHomePage({required this.lecturerName, required this.lecturerId});

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
      drawer: DrawerNavigation(lecturerId: lecturerId),
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
                      "Welcome, $lecturerName", 
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
                  buildSectionTitle("TODAY'S CLASSES", 2),
                  buildClassItem(
                    "10:00 AM",
                    "Introduction to Psychology",
                    "https://media.istockphoto.com/id/1154642632/photo/portrait-of-brunette-woman.jpg?s=612x612&w=0&k=20&c=d8W_C2D-2rXlnkyl8EirpHGf-GpM62gBjpDoNryy98U=",
                    "Room 101, Building A",
                  ),
                  buildClassItem(
                    "2:00 PM",
                    "Advanced Typography",
                    "https://img.freepik.com/free-photo/close-up-businesswoman.jpg",
                    "Room 305, Building C",
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        Text(
          "See all",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: secondTextColor,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // Helper method to build a class item
  Container buildClassItem(String time, String title, String profileUrl, String location) {
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
          CircleAvatar(
            backgroundImage: NetworkImage(profileUrl),
            radius: 18,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor),
              ),
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
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor),
              ),
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
