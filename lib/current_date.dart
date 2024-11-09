// current_date.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrentDate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String date = DateFormat(' d MMM y').format(DateTime.now());

    return Text(
      date,
      style: TextStyle(
        color: Color(0XFF263064),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
