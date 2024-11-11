import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../drawer_navigation.dart';
import '../../ConnectionServices.dart'; // Import ConnectionServices

class TimetablePage extends StatefulWidget {
  final String studentId;
  // final String studentName;

  TimetablePage({required this.studentId});

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  final ConnectionServices _connectionServices = ConnectionServices();
  DateTime selectedDate = DateTime.now();
  DateTime startOfSelectedWeek = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  // Define the specific start dates for "This Week", "Next Week", and "Two Weeks Ahead"
  List<DateTime> get weekStartDates {
    DateTime now = DateTime.now();
    return [
      DateTime(now.year, now.month, now.day - (now.weekday)), // Start of This Week (Monday)
      DateTime(now.year, now.month, now.day + (7 - now.weekday)), // Start of Next Week (Monday)
      DateTime(now.year, now.month, now.day + (14 - now.weekday)), // Start of Two Weeks Ahead (Monday)
    ];
  }

  void _onWeekChanged(DateTime? newWeekStartDate) {
    if (newWeekStartDate != null) {
      setState(() {
        startOfSelectedWeek = newWeekStartDate;
        selectedDate = startOfSelectedWeek; // Reset selected date to match the new week start
      });
    }
  }

  void CreateClass(BuildContext context) {
    String module = "";
    String topic = "";
    String intake = "";
    String room = "";
    DateTime? selectedDate;
    TimeOfDay? selectedTime;
    String? selectedDuration;
    
    Map<String, int> durationOptions = {
      "30 min": 30,
      "1 hour": 60,
      "1 hour 30 min": 90,
      "2 hours": 120,
      "2 hours 30 min": 150,
      "3 hours": 180,
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Create New Class"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: "Module"),
                  onChanged: (value) => module = value,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Topic"),
                  onChanged: (value) => topic = value,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Intake"),
                  onChanged: (value) => intake = value,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Room"),
                  onChanged: (value) => room = value,
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "Duration"),
                  value: selectedDuration,
                  items: durationOptions.keys.map((String duration) {
                    return DropdownMenuItem<String>(
                      value: duration,
                      child: Text(duration),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedDuration = newValue;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );

                    if (selectedDate != null) {
                      selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                    }
                  },
                  child: Text("Select Date and Time"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (module.isNotEmpty && topic.isNotEmpty && intake.isNotEmpty && room.isNotEmpty && selectedDate != null && selectedTime != null && selectedDuration != null) {
                  DateTime startDateTime = DateTime(
                    selectedDate!.year,
                    selectedDate!.month,
                    selectedDate!.day,
                    selectedTime!.hour,
                    selectedTime!.minute,
                  );

                  DateTime endDateTime = startDateTime.add(Duration(minutes: durationOptions[selectedDuration]!));

                  await _connectionServices.addClassToTimetable(
                    module: module,
                    topic: topic,
                    intake: intake,
                    room: room,
                    startDateTime: startDateTime,
                    endDateTime: endDateTime,
                    lecturerId: widget.studentId, // Pass lecturerId
                  );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Please fill out all fields"),
                  ));
                }
              },
              child: Text("Create"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Timetable"),
        centerTitle: true,
        backgroundColor: Color(0xFFd5e7ff),
      ),
      drawer: DrawerNavigation(studentId: widget.studentId),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Week",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<DateTime>(
  value: startOfSelectedWeek,
  icon: Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
  onChanged: _onWeekChanged,
  items: weekStartDates.toSet().map((DateTime date) {
    return DropdownMenuItem<DateTime>(
      value: date,
      child: Text(
        DateFormat('dd MMM yyyy').format(date),
        style: TextStyle(color: Colors.blueAccent),
      ),
    );
  }).toList(),
)


                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                DateTime date = startOfSelectedWeek.add(Duration(days: index));
                bool isActive = date.day == selectedDate.day &&
                    date.month == selectedDate.month &&
                    date.year == selectedDate.year;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                  child: Container(
                    width: 50,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: isActive ? Colors.blue : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(DateFormat.E().format(date),
                            style: TextStyle(color: isActive ? Colors.white : Colors.grey)),
                        SizedBox(height: 5),
                        Text(date.day.toString(),
                            style: TextStyle(color: isActive ? Colors.white : Colors.black, fontSize: 16)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _connectionServices.fetchTimetableData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error fetching data"));
                }
                final timetableData = snapshot.data!
                    .where((data) {
                      DateTime classDate = data['StartDateTime'];
                      return classDate.day == selectedDate.day &&
                          classDate.month == selectedDate.month &&
                          classDate.year == selectedDate.year;
                    })
                    .toList();

                if (timetableData.isEmpty) {
                  return Center(child: Text("No classes on this day"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: timetableData.length,
                  itemBuilder: (context, index) {
                    final classData = timetableData[index];
                    final module = classData['Module'];
                    final topic = classData['Topic'];
                    final intake = classData['Intake'];
                    final room = classData['Room'];
                    final startDateTime = classData['StartDateTime'];
                    final endDateTime = classData['EndDateTime'];
                    
                    // Format the start and end times
                    final timeRange = "${DateFormat.jm().format(startDateTime)} - ${DateFormat.jm().format(endDateTime)}";

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              timeRange,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Container(
                          margin: const EdgeInsets.only(bottom: 25),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(width: 1, color: Colors.grey[300]!),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Left side with class information
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(module, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                                    Text(topic, style: TextStyle(color: Colors.grey, fontSize: 14)),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(Icons.school, color: Colors.grey, size: 20),
                                        const SizedBox(width: 8),
                                        Text(intake, style: TextStyle(fontSize: 14)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on, color: Colors.grey, size: 20),
                                        const SizedBox(width: 8),
                                        Text(room, style: TextStyle(fontSize: 14)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Right side with buttons in a column
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      // Logic for uploading goes here
                                    },
                                    icon: Icon(Icons.upload_file, color: Colors.blue),
                                    tooltip: "Upload",
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // Logic for taking attendance goes here
                                    },
                                    icon: Icon(Icons.check_circle, color: Colors.green),
                                    tooltip: "Take Attendance",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => CreateClass(context),
        backgroundColor: Color(0xFFd5e7ff),
        child: Icon(Icons.add),
      ),
    );
  }
}