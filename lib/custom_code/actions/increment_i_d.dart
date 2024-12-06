// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

String incrementID(String value) {
  // Split the prefix and numeric part
  String prefix = value.substring(0, 2);
  int number = int.parse(value.substring(2));

  // Increment and format the number with leading zeros
  String incrementedNumber =
      (number + 1).toString().padLeft(value.length - 2, '0');

  return '$prefix$incrementedNumber';
}
