import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../drawer_navigation.dart';
import '../../ConnectionServices.dart'; // Import ConnectionServices

class TimetablePage extends StatefulWidget {
  final String lecturerId;

  TimetablePage({required this.lecturerId});

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  final ConnectionServices _connectionServices = ConnectionServices();
  DateTime selectedDate = DateTime.now();

    // Helper to get the start of the current week (Monday)
  DateTime get startOfWeek {
    DateTime now = DateTime.now();
    return now.subtract(Duration(days: now.weekday - 1));
  }

  // Helper to get dates for the current week
  List<DateTime> get currentWeekDates {
    DateTime start = startOfWeek;
    return List.generate(7, (index) => start.add(Duration(days: index)));
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
                    lecturerId: widget.lecturerId, // Pass lecturerId
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
      drawer: DrawerNavigation(),
      body: Column(
        children: [
          // This Week Date Picker
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "This Week",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedDate = DateTime.now();
                    });
                  },
                  child: Text(
                    "Today",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF3c31c5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: currentWeekDates.length,
              itemBuilder: (context, index) {
                DateTime date = currentWeekDates[index];
                bool isSelected = date.day == selectedDate.day &&
                    date.month == selectedDate.month &&
                    date.year == selectedDate.year;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                  child: Container(
                    width: 60,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xFF3c31c5) : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat.E().format(date), // Mon, Tue, etc.
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          date.day.toString(),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                        ),
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

                // Filter the data to only show classes on the selected date
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
                    final room = classData['Room'];
                    final startDateTime = classData['StartDateTime'];
                    final timeString = "${startDateTime.hour}:${startDateTime.minute.toString().padLeft(2, '0')}";

                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$timeString - $module",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.grey, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                room,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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