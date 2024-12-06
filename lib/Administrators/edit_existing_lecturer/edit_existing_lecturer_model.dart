import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:async';
import 'edit_existing_lecturer_widget.dart' show EditExistingLecturerWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditExistingLecturerModel
    extends FlutterFlowModel<EditExistingLecturerWidget> {
  ///  State fields for stateful widgets in this page.

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
    lecturerIDFocusNode?.dispose();
    lecturerIDTextController?.dispose();

    lecturerNameFocusNode?.dispose();
    lecturerNameTextController?.dispose();

    lecturerPasswordFocusNode?.dispose();
    lecturerPasswordTextController?.dispose();
  }
}
