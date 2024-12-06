import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_calendar.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/custom_code/actions/index.dart' as actions;
import 'create_new_event_widget.dart' show CreateNewEventWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreateNewEventModel extends FlutterFlowModel<CreateNewEventWidget> {
  ///  Local state fields for this page.

  DateTimeRange? startTime;

  DateTimeRange? endTime;

  ///  State fields for stateful widgets in this page.

  // State field(s) for StartCalendar widget.
  DateTimeRange? startCalendarSelectedDay;
  // State field(s) for StartHours widget.
  String? startHoursValue;
  FormFieldController<String>? startHoursValueController;
  // State field(s) for StartMins widget.
  String? startMinsValue;
  FormFieldController<String>? startMinsValueController;
  // State field(s) for StartSeconds widget.
  String? startSecondsValue;
  FormFieldController<String>? startSecondsValueController;
  // State field(s) for EndCalendar widget.
  DateTimeRange? endCalendarSelectedDay;
  // State field(s) for EndHours widget.
  String? endHoursValue;
  FormFieldController<String>? endHoursValueController;
  // State field(s) for EndMins widget.
  String? endMinsValue;
  FormFieldController<String>? endMinsValueController;
  // State field(s) for EndSecs widget.
  String? endSecsValue;
  FormFieldController<String>? endSecsValueController;
  // State field(s) for EventName widget.
  FocusNode? eventNameFocusNode;
  TextEditingController? eventNameTextController;
  String? Function(BuildContext, String?)? eventNameTextControllerValidator;
  // State field(s) for EventVenue widget.
  FocusNode? eventVenueFocusNode;
  TextEditingController? eventVenueTextController;
  String? Function(BuildContext, String?)? eventVenueTextControllerValidator;
  // State field(s) for EventDetails widget.
  FocusNode? eventDetailsFocusNode;
  TextEditingController? eventDetailsTextController;
  String? Function(BuildContext, String?)? eventDetailsTextControllerValidator;
  // Stores action output result for [Custom Action - combineDateTime] action in Container widget.
  DateTime? startDate;
  // Stores action output result for [Custom Action - combineDateTime] action in Container widget.
  DateTime? endDate;

  @override
  void initState(BuildContext context) {
    startCalendarSelectedDay = DateTimeRange(
      start: DateTime.now().startOfDay,
      end: DateTime.now().endOfDay,
    );
    endCalendarSelectedDay = DateTimeRange(
      start: DateTime.now().startOfDay,
      end: DateTime.now().endOfDay,
    );
  }

  @override
  void dispose() {
    eventNameFocusNode?.dispose();
    eventNameTextController?.dispose();

    eventVenueFocusNode?.dispose();
    eventVenueTextController?.dispose();

    eventDetailsFocusNode?.dispose();
    eventDetailsTextController?.dispose();
  }
}
