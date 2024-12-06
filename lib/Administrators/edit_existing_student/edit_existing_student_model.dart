import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:async';
import 'edit_existing_student_widget.dart' show EditExistingStudentWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditExistingStudentModel
    extends FlutterFlowModel<EditExistingStudentWidget> {
  ///  State fields for stateful widgets in this page.

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
  // State field(s) for IntakeDropdown widget.
  String? intakeDropdownValue;
  FormFieldController<String>? intakeDropdownValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    studentIDFocusNode?.dispose();
    studentIDTextController?.dispose();

    studentNameFocusNode?.dispose();
    studentNameTextController?.dispose();

    studentPasswordFocusNode?.dispose();
    studentPasswordTextController?.dispose();
  }
}
