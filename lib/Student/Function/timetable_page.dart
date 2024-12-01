import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'attendance_page.dart';

class TimetablePage extends StatefulWidget {
  final String studentId;

  TimetablePage({required this.studentId});

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  String? intake;
  bool isLoading = true;

  // Week Navigation and Date Selection
  final List<DateTime> weekStartDates = [
    DateTime(2024, 11, 25),
    DateTime(2024, 12, 2),
    DateTime(2024, 12, 9),
  ];
  DateTime selectedWeek = DateTime(2024, 11, 25);
  DateTime? selectedDay;

  @override
  void initState() {
    super.initState();
    fetchUserIntake();
    selectedDay = selectedWeek; // Default to the first day of the selected week
  }

  Future<void> fetchUserIntake() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Students')
          .where('Student ID', isEqualTo: widget.studentId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;

        setState(() {
          intake = userDoc['Intake'];
        });
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
    if (intake == null || selectedDay == null) return Stream.value([]);

    return FirebaseFirestore.instance
        .collection('Timetable')
        .where('Intake', isEqualTo: intake)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Map<String, dynamic>> timetableEntries = [];

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data();
        DateTime eventDate =
            (data['StartDateTime'] as Timestamp).toDate(); // Event date

        // Only include events matching the selected day
        if (eventDate.year == selectedDay!.year &&
            eventDate.month == selectedDay!.month &&
            eventDate.day == selectedDay!.day) {
          if (data['LecturerId'] != null) {
            try {
              final lecturerQuery = await FirebaseFirestore.instance
                  .collection('Lecturers')
                  .where('Lecturer ID', isEqualTo: data['LecturerId'])
                  .get();

              if (lecturerQuery.docs.isNotEmpty) {
                data['LecturerName'] = lecturerQuery.docs.first['Lecturer Name'];
              } else {
                data['LecturerName'] = "Unknown";
              }
            } catch (_) {
              data['LecturerName'] = "Unknown";
            }
          }
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
        title: const Text("Timetable"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : intake == null
              ? const Center(child: Text("No intake found for the user."))
              : Column(
                  children: [
                    // Week Navigation Dropdown
                    Container(
                      color: Colors.blue.shade100,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Week",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          DropdownButton<DateTime>(
                            value: selectedWeek,
                            underline: const SizedBox.shrink(),
                            items: weekStartDates.map((date) {
                              return DropdownMenuItem<DateTime>(
                                value: date,
                                child: Text(
                                  "${date.day.toString().padLeft(2, '0')} "
                                  "${_monthName(date.month)} ${date.year}",
                                  style: const TextStyle(color: Colors.blue),
                                ),
                              );
                            }).toList(),
                            onChanged: (newDate) {
                              setState(() {
                                selectedWeek = newDate!;
                                selectedDay = newDate; // Reset selected day
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    // Week Days Selector
                    Container(
                      color: Colors.pink.shade50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _generateWeekDays(selectedWeek),
                      ),
                    ),
                    // Timetable List
                    Expanded(
                      child: StreamBuilder<List<Map<String, dynamic>>>(
                        stream: fetchTimetable(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text("No timetable available."));
                          }

                          final timetableData = snapshot.data!;
                          return ListView.builder(
                            itemCount: timetableData.length,
                            itemBuilder: (context, index) {
                              final event = timetableData[index];

                              DateTime startTime = (event['StartDateTime']
                                      as Timestamp)
                                  .toDate();
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
                                    contentPadding: const EdgeInsets.all(16),
                                    title: Text(
                                      event['Module'] ?? "Unknown Module",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 4),
                                        Text(
                                          formattedTime,
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(Icons.person,
                                                size: 16, color: Colors.grey),
                                            const SizedBox(width: 4),
                                            Text(event['LecturerName'] ??
                                                "Unknown Lecturer"),
                                          ],
                                        ),
                                      ],
                                    ),
                                    trailing: const Icon(
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
                    ),
                  ],
                ),
    );
  }

  // Generate week days for the selected week
  List<Widget> _generateWeekDays(DateTime startDate) {
    List<Widget> weekDays = [];
    for (int i = 0; i < 7; i++) {
      DateTime currentDay = startDate.add(Duration(days: i));
      weekDays.add(GestureDetector(
        onTap: () {
          setState(() {
            selectedDay = currentDay;
          });
        },
        child: Container(
          width: 40,
          decoration: BoxDecoration(
            color: selectedDay == currentDay
                ? Colors.blue
                : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Text(
                _dayAbbreviation(currentDay.weekday),
                style: TextStyle(
                  color:
                      selectedDay == currentDay ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                currentDay.day.toString(),
                style: TextStyle(
                  color:
                      selectedDay == currentDay ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ));
    }
    return weekDays;
  }

  // Utility to get month name
  String _monthName(int month) {
    switch (month) {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "Jun";
      case 7:
        return "Jul";
      case 8:
        return "Aug";
      case 9:
        return "Sep";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";
      default:
        return "";
    }
  }

  // Utility to get day abbreviation
  String _dayAbbreviation(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return "Mon";
      case DateTime.tuesday:
        return "Tue";
      case DateTime.wednesday:
        return "Wed";
      case DateTime.thursday:
        return "Thu";
      case DateTime.friday:
        return "Fri";
      case DateTime.saturday:
        return "Sat";
      case DateTime.sunday:
        return "Sun";
      default:
        return "";
    }
  }
}
