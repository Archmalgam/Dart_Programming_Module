import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../ConnectionServices.dart'; // Import ConnectionServices
import 'upload_material.dart'; // Import the new upload_material.dart

class TimetablePage extends StatefulWidget {
  final String lecturerId;

  TimetablePage({required this.lecturerId});

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  final ConnectionServices _connectionServices = ConnectionServices();
  DateTime selectedDate = DateTime.now();
  DateTime startOfSelectedWeek =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  List<String> availableIntakes = [];
  List<String> availableRooms = [];
  DateTime? selectedClassDate;
  TimeOfDay? selectedClassTime;

  // Add this field to store room statuses
  List<Map<String, dynamic>> roomsWithStatus = [];

  @override
  void initState() {
    super.initState();
    fetchIntakes();
    fetchAvailableRooms();
    setState(() {
      startOfSelectedWeek = normalizeDate(
          DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)));
    });
  }

  // Fetch available intakes from Firestore
  void fetchIntakes() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('Students').get();

    // Extract the intakes and cast them to a List<String>
    final allIntakes = querySnapshot.docs
        .map((doc) => doc['Intake'] as String) // Casting to String here
        .toSet(); // Use toSet() to ensure unique values

    setState(() {
      availableIntakes = allIntakes.toList();
    });
  }

  void fetchAvailableRooms() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('Rooms').get();
    final now = DateTime.now();

    final allRooms = <String>[]; // Store all room names
    final roomsWithStatus = <Map<String, dynamic>>[]; // Store room names with status

    for (var doc in querySnapshot.docs) {
      String roomName = doc.id;
      QuerySnapshot bookingSnapshot =
          await doc.reference.collection('Booking detail').get();

      bool isOccupied = false;

      for (var booking in bookingSnapshot.docs) {
        DateTime? startDateTime = booking['startDateTime'] != null
            ? (booking['startDateTime'] as Timestamp).toDate()
            : null;
        DateTime? endDateTime = booking['endDateTime'] != null
            ? (booking['endDateTime'] as Timestamp).toDate()
            : null;

        if (startDateTime != null && endDateTime != null) {
          if (now.isAfter(startDateTime) && now.isBefore(endDateTime)) {
            isOccupied = true;
            break; // Stop checking once we know the room is occupied
          }
        }
      }

      // Add room name to the dropdown list
      allRooms.add(roomName);

      // Add room name and status for UI display
      roomsWithStatus.add({
        'roomName': roomName,
        'status': isOccupied ? 'occupied' : 'free',
      });
    }

    setState(() {
      availableRooms = allRooms; // Populate dropdown with all rooms
      this.roomsWithStatus = roomsWithStatus; // Populate UI with room statuses
    });
  }


  DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  List<DateTime> get weekStartDates {
    DateTime now = normalizeDate(DateTime.now());
    return [
      normalizeDate(now.subtract(
          Duration(days: now.weekday - 1))), // Start of This Week (Monday)
      normalizeDate(now
          .add(Duration(days: 7 - now.weekday))), // Start of Next Week (Monday)
      normalizeDate(now.add(Duration(
          days: 14 - now.weekday))), // Start of Two Weeks Ahead (Monday)
    ];
  }

  void _onWeekChanged(DateTime? newWeekStartDate) {
    if (newWeekStartDate != null) {
      setState(() {
        startOfSelectedWeek = newWeekStartDate;
        selectedDate =
            newWeekStartDate; // Reset selected date to match the new week start
      });
    }
  }

  void CreateClass(BuildContext context) {
  String module = "";
  String topic = "";
  String intake = "";
  String room = "";
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
      return StatefulBuilder(
        builder: (context, setState) {
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
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: "Intake"),
                    value: intake.isEmpty ? null : intake,
                    items: availableIntakes.map((String availableIntake) {
                      return DropdownMenuItem<String>(
                        value: availableIntake,
                        child: Text(availableIntake),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        intake = newValue!;
                      });
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: "Room"),
                    value: room.isEmpty ? null : room,
                    items: availableRooms.map((String availableRoom) {
                      return DropdownMenuItem<String>(
                        value: availableRoom,
                        child: Text(availableRoom),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        room = newValue!;
                      });
                    },
                  ),
                  GestureDetector(
                    onTap: () async {
                      final DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );

                      if (date != null) {
                        setState(() {
                          selectedClassDate = date;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: "Date",
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          size: 18,
                        ),
                        border: UnderlineInputBorder(),
                      ),
                      child: Text(
                        selectedClassDate != null
                            ? DateFormat('dd MMM yyyy')
                                .format(selectedClassDate!)
                            : "Select Date",
                        style: TextStyle(
                            color: selectedClassDate != null
                                ? Colors.black
                                : Colors.grey,
                            fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () async {
                      final TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (time != null) {
                        setState(() {
                          selectedClassTime = time;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: "Time",
                        suffixIcon: Icon(
                          Icons.access_time,
                          size: 18,
                        ),
                        border: UnderlineInputBorder(),
                      ),
                      child: Text(
                        selectedClassTime != null
                            ? selectedClassTime!.format(context)
                            : "Select Time",
                        style: TextStyle(
                            color: selectedClassTime != null
                                ? Colors.black
                                : Colors.grey,
                            fontSize: 16),
                      ),
                    ),
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
                  if (module.isNotEmpty &&
                      topic.isNotEmpty &&
                      intake.isNotEmpty &&
                      room.isNotEmpty &&
                      selectedClassDate != null &&
                      selectedClassTime != null &&
                      selectedDuration != null) {
                    DateTime startDateTime = DateTime(
                      selectedClassDate!.year,
                      selectedClassDate!.month,
                      selectedClassDate!.day,
                      selectedClassTime!.hour,
                      selectedClassTime!.minute,
                    );

                    DateTime endDateTime = startDateTime.add(
                      Duration(minutes: durationOptions[selectedDuration]!),
                    );

                    // Add booking to the selected room's "Booking detail" subcollection
                    await FirebaseFirestore.instance
                        .collection('Rooms')
                        .doc(room)
                        .collection('Booking detail')
                        .add({
                      'lecturerId': widget.lecturerId,
                      'lecturerName': "John", // Replace with dynamic value if available
                      'startDateTime': startDateTime,
                      'endDateTime': endDateTime,
                      'module': module,
                      'topic': topic,
                      'intake': intake,
                    });

                    // Add the same data to the "Timetable" collection
                    await FirebaseFirestore.instance
                        .collection('Timetable')
                        .add({
                      'LecturerId': widget.lecturerId,
                      'StartDateTime': startDateTime,
                      'EndDateTime': endDateTime,
                      'Module': module,
                      'Topic': topic,
                      'Intake': intake,
                      'Room': room, // Add room so that timetable also knows the location
                    });

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Class created successfully!"),
                      ),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Week",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<DateTime>(
                    value: weekStartDates.contains(startOfSelectedWeek)
                        ? startOfSelectedWeek
                        : weekStartDates.first,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
                    onChanged: _onWeekChanged,
                    items: weekStartDates.map((DateTime date) {
                      String formattedDate =
                          DateFormat('dd MMM yyyy').format(date);
                      return DropdownMenuItem<DateTime>(
                        value: date,
                        child: Text(
                          formattedDate,
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      );
                    }).toList(),
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
                            style: TextStyle(
                                color: isActive ? Colors.white : Colors.grey)),
                        SizedBox(height: 5),
                        Text(date.day.toString(),
                            style: TextStyle(
                                color: isActive ? Colors.white : Colors.black,
                                fontSize: 16)),
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
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No classes available."));
                }

                // Filter the timetable data for the given lecturerId
                final timetableData = snapshot.data!
                    .where((data) => data['LecturerId'] == widget.lecturerId)
                    .where((data) {
                  // Extract StartDateTime value and determine its type
                  var startDateTimeValue = data['StartDateTime'];
                  DateTime classDate;

                  if (startDateTimeValue is Timestamp) {
                    classDate = startDateTimeValue.toDate();
                  } else if (startDateTimeValue is DateTime) {
                    classDate = startDateTimeValue;
                  } else {
                    // If the data type is incorrect, you may want to handle this with an error or a default value
                    throw ArgumentError('StartDateTime is not a valid type');
                  }

                  // Filter based on selected date
                  return classDate.day == selectedDate.day &&
                      classDate.month == selectedDate.month &&
                      classDate.year == selectedDate.year;
                }).toList();

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

                    // Safely handle StartDateTime and EndDateTime
                    DateTime startDateTime;
                    DateTime endDateTime;

                    if (classData['StartDateTime'] is Timestamp) {
                      startDateTime =
                          (classData['StartDateTime'] as Timestamp).toDate();
                    } else if (classData['StartDateTime'] is DateTime) {
                      startDateTime = classData['StartDateTime'];
                    } else {
                      throw ArgumentError('StartDateTime is not a valid type');
                    }

                    if (classData['EndDateTime'] is Timestamp) {
                      endDateTime =
                          (classData['EndDateTime'] as Timestamp).toDate();
                    } else if (classData['EndDateTime'] is DateTime) {
                      endDateTime = classData['EndDateTime'];
                    } else {
                      throw ArgumentError('EndDateTime is not a valid type');
                    }

                    // Format the start and end times
                    final timeRange =
                        "${DateFormat.jm().format(startDateTime)} - ${DateFormat.jm().format(endDateTime)}";

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
                              timeRange, // Use the formatted string here
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black),
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
                            border:
                                Border.all(width: 1, color: Colors.grey[300]!),
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
                                    Text(module,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18)),
                                    Text(topic,
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 14)),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(Icons.school,
                                            color: Colors.grey, size: 20),
                                        const SizedBox(width: 8),
                                        Text(intake,
                                            style: TextStyle(fontSize: 14)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on,
                                            color: Colors.grey, size: 20),
                                        const SizedBox(width: 8),
                                        Text(room,
                                            style: TextStyle(fontSize: 14)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Right side with buttons in a column
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      // Call the function from the imported file
                                      await pickAndUploadFile(
                                          context, classData);
                                    },
                                    icon: Icon(Icons.upload_file,
                                        color: Colors.blue),
                                    tooltip: "Upload",
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // Logic for taking attendance goes here
                                    },
                                    icon: Icon(Icons.how_to_reg_outlined,
                                        color: Colors.green),
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
          )
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
