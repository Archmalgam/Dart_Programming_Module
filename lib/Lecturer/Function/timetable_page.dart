import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../ConnectionServices.dart'; // Import ConnectionServices
import 'package:file_picker/file_picker.dart';

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

  // Lock to prevent multiple dialog openings
  bool isPickingFile = false;

  Future<void> pickAndUploadFile(Map<String, dynamic> classData) async {
    // Check if a file picker is already active
    if (isPickingFile) return;

    isPickingFile = true; // Lock the file picker

    try {
      // Pick a file using file picker
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.single.path != null) {
        String filePath = result.files.single.path!;
        String fileName =
            result.files.single.name; // Retrieve the name of the selected file

        // Generate a unique document ID automatically using Firestore
        String documentId =
            FirebaseFirestore.instance.collection('FileUploads').doc().id;

        // Extract predefined values from classData
        String lecturerId = classData['LecturerId'];
        String module = classData['Module'];
        String intake = classData['Intake'];

        // Upload file to Firestore with additional metadata
        await FirebaseFirestore.instance
            .collection('FileUploads')
            .doc(documentId)
            .set({
          'filePath': filePath,
          'fileName': fileName, // Store the file name
          'lecturerId': lecturerId,
          'module': module,
          'intake': intake,
          'uploadedAt': Timestamp.now(),
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text("File '$fileName' uploaded successfully to Firestore!")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("No file selected")));
      }
    } catch (e) {
      print("File picking failed: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("File upload error: $e")));
    } finally {
      isPickingFile = false; // Release the lock
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
                if (module.isNotEmpty &&
                    topic.isNotEmpty &&
                    intake.isNotEmpty &&
                    room.isNotEmpty &&
                    selectedDate != null &&
                    selectedTime != null &&
                    selectedDuration != null) {
                  DateTime startDateTime = DateTime(
                    selectedDate!.year,
                    selectedDate!.month,
                    selectedDate!.day,
                    selectedTime!.hour,
                    selectedTime!.minute,
                  );

                  DateTime endDateTime = startDateTime.add(
                      Duration(minutes: durationOptions[selectedDuration]!));

                  await _connectionServices.addClassToTimetable(
                    module: module,
                    topic: topic,
                    intake: intake,
                    room: room,
                    startDateTime: startDateTime,
                    endDateTime: endDateTime,
                    lecturerId: widget.lecturerId, // Pass lecturerId
                  );
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
                    value: startOfSelectedWeek,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
                    onChanged: _onWeekChanged,
                    items: weekStartDates.map((DateTime date) {
                      String formattedDate = DateFormat('dd MMM yyyy')
                          .format(date); // Format date as "10 Nov 2024"

                      return DropdownMenuItem<DateTime>(
                        value: date,
                        child: Text(
                          formattedDate, // Display the formatted date instead of labels
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
                                    const SizedBox(height: 10),
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
                                      // Prevent double-triggering by ensuring the flag is set
                                      if (!isPickingFile) {
                                        await pickAndUploadFile(
                                            classData); // Pass the classData to upload the file with the metadata
                                      }
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
