import 'package:flutter/material.dart';
import 'drawer_navigation.dart';

class StudentHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Student Dashboard',
          style: TextStyle(
            color: Color(0xFF0AC5A8), // Teal for header text
            fontSize: 24,
          ),
        ),
        backgroundColor: Color(0xFF2C3C5B), // Dark Blue for AppBar background
      ),
      drawer: DrawerNavigation(),
      body: Stack(
        children: [
          // Header section with date and greeting
          Container(
            color: Color(0xFF2C3C5B), // Dark Blue background for the header
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date display
                  Align(
                    alignment: Alignment.centerRight,
                    child: RichText(
                      text: TextSpan(
                        text: "Wed",
                        style: TextStyle(
                          color: Color(0xFF0AC5A8), // Teal color
                          fontWeight: FontWeight.w900,
                        ),
                        children: [
                          TextSpan(
                            text: " 10 Oct",
                            style: TextStyle(
                              color: Color(0xFF0AC5A8),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile picture
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(width: 1, color: Colors.white),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              "https://img.freepik.com/free-photo/close-up-view-strict-young-handsome-caucasian-man-wearing-glasses-standing-profile-view-isolated-crimson-wall_141793-79811.jpg",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      // Greeting and introductory text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi Professor",
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0AC5A8),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Here is a list of schedules\nyou need to check...",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              height: 1.8,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Main content area with list of classes and tasks
          Positioned(
            top: 180,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: ListView(
                children: [
                  // Today's classes section
                  buildSectionTitle("TODAY'S CLASSES", 3),
                  buildClassItem(
                    "07:00 AM",
                    "The Basics of Typography II",
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTHDRlp-KGr_M94k_oor4Odjn2UzbAS7n1YoA&s",
                    "Gabriel Sutton",
                  ),
                  buildClassItem(
                    "09:30 AM",
                    "Design Psychology: Principles of Art",
                    "https://media.istockphoto.com/id/1154642632/photo/close-up-portrait-of-brunette-woman.jpg?s=612x612&w=0&k=20&c=d8W_C2D-2rXlnkyl8EirpHGf-GpM62gBjpDoNryy98U=",
                    "Jessie Reeves",
                  ),
                  SizedBox(height: 20),
                  // Tasks section
                  buildSectionTitle("YOUR TASKS", 4),
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
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
        ),
        Text(
          "See all",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF5E738E),
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  // Helper method to build a class item
  Container buildClassItem(String time, String title, String profileUrl, String lecturerName) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                time,
                style: TextStyle(fontWeight: FontWeight.w800),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "Room C1, Faculty of Art & Design",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                lecturerName,
                style: TextStyle(fontSize: 14, color: Colors.grey),
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
          buildTaskItem(Colors.red, 3, "Typography Basics"),
          buildTaskItem(Colors.green, 10, "Design Psychology"),
          buildTaskItem(Colors.blue, 5, "Art Principles"),
        ],
      ),
    );
  }

  // Helper method to build a task item
  Container buildTaskItem(Color color, int daysLeft, String courseTitle) {
    return Container(
      margin: EdgeInsets.only(right: 15),
      padding: EdgeInsets.all(12),
      height: 170,
      width: 175,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Deadline",
            style: TextStyle(fontSize: 15, color: Colors.black26),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              CircleAvatar(radius: 4, backgroundColor: color),
              SizedBox(width: 5),
              Text(
                "$daysLeft days left",
                style: TextStyle(fontSize: 17, color: Colors.black54),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            courseTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
