import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:async';
import '/custom_code/actions/index.dart' as actions;
import 'creating_new_users_widget.dart' show CreatingNewUsersWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreatingNewUsersModel extends FlutterFlowModel<CreatingNewUsersWidget> {
  ///  Local state fields for this page.

  String lastStudentsID = 'Test';

  String lastLecturersID = 'Test';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in CreatingNewUsers widget.
  StudentsRecord? newStudID;
  // Stores action output result for [Firestore Query - Query a collection] action in CreatingNewUsers widget.
  LecturersRecord? newLectID;
  // Stores action output result for [Custom Action - incrementID] action in CreatingNewUsers widget.
  String? incrementedStudID;
  // Stores action output result for [Custom Action - incrementID] action in CreatingNewUsers widget.
  String? incrementedLecturerID;
  // State field(s) for StudentLecturerTab widget.
  TabController? studentLecturerTabController;
  int get studentLecturerTabCurrentIndex => studentLecturerTabController != null
      ? studentLecturerTabController!.index
      : 0;

  // State field(s) for StudentID widget.
  FocusNode? studentIDFocusNode;
  TextEditingController? studentIDTextController;
  String? Function(BuildContext, String?)? studentIDTextControllerValidator;
  // State field(s) for StudentName widget.
  FocusNode? studentNameFocusNode;
  TextEditingController? studentNameTextController;
  String? Function(BuildContext, String?)? studentNameTextControllerValidator;
  // State field(s) for StudentPassword widget.
  FocusNode? studentPasswordFocusNode;
  TextEditingController? studentPasswordTextController;
  String? Function(BuildContext, String?)?
      studentPasswordTextControllerValidator;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // State field(s) for LecturerID widget.
  FocusNode? lecturerIDFocusNode;
  TextEditingController? lecturerIDTextController;
  String? Function(BuildContext, String?)? lecturerIDTextControllerValidator;
  // State field(s) for LecturerName widget.
  FocusNode? lecturerNameFocusNode;
  TextEditingController? lecturerNameTextController;
  String? Function(BuildContext, String?)? lecturerNameTextControllerValidator;
  // State field(s) for LecturerPassword widget.
  FocusNode? lecturerPasswordFocusNode;
  TextEditingController? lecturerPasswordTextController;
  String? Function(BuildContext, String?)?
      lecturerPasswordTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    studentLecturerTabController?.dispose();
    studentIDFocusNode?.dispose();
    studentIDTextController?.dispose();

    studentNameFocusNode?.dispose();
    studentNameTextController?.dispose();

    studentPasswordFocusNode?.dispose();
    studentPasswordTextController?.dispose();

    lecturerIDFocusNode?.dispose();
    lecturerIDTextController?.dispose();

    lecturerNameFocusNode?.dispose();
    lecturerNameTextController?.dispose();

    lecturerPasswordFocusNode?.dispose();
    lecturerPasswordTextController?.dispose();
  }
}
