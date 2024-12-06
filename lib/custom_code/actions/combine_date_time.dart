// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

DateTime combineDateTime(DateTime selectedDate, String hour, String minute,
    String seconds, String? amPm) {
  int parsedHour = int.parse(hour);
  int parsedMinute = int.parse(minute);
  int parsedSeconds = int.parse(seconds);

  // Automatically adjust AM/PM based on a 24-hour format
  if (parsedHour >= 12) {
    amPm = 'PM';
    if (parsedHour > 12) {
      parsedHour -= 12; // Convert to 12-hour clock
    }
  } else {
    amPm = 'AM';
    if (parsedHour == 0) {
      parsedHour = 12; // Convert midnight (00) to 12 AM
    }
  }

  // Create and return the combined DateTime
  return DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
    parsedHour,
    parsedMinute,
    parsedSeconds,
  );
}
